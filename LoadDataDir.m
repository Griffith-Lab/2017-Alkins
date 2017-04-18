function dataList = LoadDataDir(pathDir)
% dataList = LoadDataDir(pathDir)
% Load all the matlab data files in a directory, and stores their info in
% an array
    % INPUTS to this function:
        % PATHDIR: the folder with the .m files
    % OUTPUTS to this function:
        % DATALIST: a list of fields in each of the recording files
        % of the file structure. Each file should include the following
        % fields:
            % sample_rate_kHz
            % sample_time_msec
            % length_recording_min
            % mem_voltage_mV
            % genotype
            % date of recording (day month year)
            % temperature_C
            % bridge_mOhm
            % notes
if nargin < 1
  pathDir = '/Users/Maria/Documents/Griffith Lab/Ephys/NMJ recordings/2013/July/30_metadata/';
end
dirList = dir(pathDir);

dataList = [];
for n = 1:length(dirList)
  file_n = dirList(n);
  filename = file_n.name;
  if length(filename) < 4 || ~strcmp(filename(end-3:end), '.mat')
    continue
  end
  struct_n = load([pathDir, filename]);
  dataList = [dataList, struct_n]; %#ok<AGROW>
end
return

%{
function spikesList = GetSpikesList(dataList)
% return a list of spike analysis corresponding to loaded in data structs
spikesList = [];
for dRecord = miR137Records
  spikes = GetSpikes(dRecord.sample_time_msec, dRecord.mem_voltage_mV, ...
                     'findMinis', true)]
  spikesList = [spikesList, spikes]; %#ok<AGROW>
end
return
%}            
    

% Things to add to the data structure:
% Rename files to refer to a notebook number and page and genotype:
    % 001_210813_1_52_scramble (is the first file (001) recorded on
    % August 21st, 2013 (210813) in notebook 1, page 52, scramble genotype)
% Temperature
% Bridge
% Date of recording

% 1. save MATLAB files in a named folder
% 2. save data files in different folders
% 3.