function dataList = LoadData(pathDir, varargin)
% dataList = LoadData(pathDir)

% set the default options
defaultOptions = { ...
  'forceGetSpikes', false, ...
  'removeMemVoltage', true, ...
  'ignoreFirst_ms', 10000 ...
};
% get the options overrides from varargin
[options, ~] = GetOptions(defaultOptions, varargin);

if nargin < 1 || isempty(pathDir)
  pathDir = '/Users/Stephen/Documents/MATLAB/Stephen Recordings/CaMKII/';
end
if pathDir(end) ~= '/'
  pathDir = [pathDir, '/'];
end

dataList = getDataList(pathDir, options);

return



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function dataList = getDataList(basePath, options, highLevel)
% recursively search directory tree looking for directories with data in
% them
if nargin < 3
  % not analyzing a directory that's a subdirectory of a high-level dir
  highLevel = false;
end
isSpikeDataDir = false;
dataList = [];
subList = dir(basePath);
for dirStruct = subList'
  % Loop through all the elements of this directory. Ignore anything that
  % starts with '.' or isn't a directory
  filename = dirStruct.name;
  if filename(1) == '.'
    continue
  elseif ~dirStruct.isdir
    if length(filename) >= 4 && strcmp(filename(end-3:end), '.mat') ...
       && ~highLevel
      isSpikeDataDir = true;
    end
  end
  subPath = [basePath, filename, '/'];
  if isempty(strfind(filename, '_'))
    % this directory is a high-level directory (a year or month directory)
    dataList = [dataList, getDataList(subPath, options, true)]; %#ok<AGROW>
  elseif any(strfind(filename, 'metadata'))
    % this directory is a folder with experimental results in it
    fprintf('Loading dir: %s\n', filename)
    dataList = [dataList, loadSpikeDataDir(subPath, options)]; %#ok<AGROW>
    fprintf('  done.\n')
  else
    % this directory holds data we don't want to load at this time
    continue
  end
end

if isSpikeDataDir
  dataList = [dataList, loadSpikeDataDir(basePath, options, subList)];
end
return



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function dataList = loadSpikeDataDir(pathDir, options, dirList)
% Load spike data. If it doesn't exist, compute spike data from metadata
% file

% get the corresponding path to spike data, and ensure it exists
spikePathDir = [pathDir(1:end-9), 'spikes/'];
if ~exist(spikePathDir, 'dir')
  mkdir(spikePathDir)
end

dataList = [];
if nargin < 3
  dirList = dir(pathDir);
end
for dirStruct = dirList'
  filename = dirStruct.name;
  if length(filename) < 4 || ~strcmp(filename(end-3:end), '.mat')
    continue
  end
  fprintf('  %s ', filename)
  metaFileName = [pathDir, filename];
  spikeFileName = [spikePathDir, filename];
  
  if exist(spikeFileName, 'file') && ~options.forceGetSpikes
    % the spike information already exists, so load it
    data = load(spikeFileName);
    if ~options.removeMemVoltage
      meta = load(metaFileName, 'mem_voltage_mV');
      data.mem_voltage_mV = meta.mem_voltage_mV;
    end
  else
    % the spike information doesn't exist or forceGetSpikes has been set
    %  1. load experimental data
    data = load(metaFileName);
    %  2. compute spike information
    startInd = options.ignoreFirst_ms * data.sample_rate_kHz + 1;
    v = data.mem_voltage_mV;
    data = rmfield(data, 'mem_voltage_mV');
    data.minis = GetSpikes(data.sample_time_msec, v(startInd:end), ...
                           'findMinis', true);
    %  3. save data file name to data structure
    data.dataFileName = metaFileName;
    %  4. save spike information
    save(spikeFileName, '-struct', 'data')
    %  5. restore voltage if desired
    if ~options.removeMemVoltage
      data.mem_voltage_mV = v;
    end
  end
  dataList = [dataList, data]; %#ok<AGROW>
  fprintf(' ok\n')
end
return
