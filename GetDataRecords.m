function wantedRecords = GetDataRecords(dataRecords, fieldName, fieldValue)
% wantedRecords = GetDataRecords(dataRecords, fieldName, fieldValue)
% Get the records that correspond to a metdata field taking a desired value
%  INPUTS:
%    dataRecords: a list of structs that contain metadata for each
%      experiment
%    fieldName:   (string) the name of a field in the data struct
%    fieldValue:  the value that the desired records have for fieldName
%  OUTPUTS:
%    wantedRecords: list of structs that have desired metadata, e.g.
%        for each struct in wantedRecrods, struct.(fieldName) == fieldValue

wantedRecords = [];
if ischar(fieldValue)
  % this field takes on a string value, so test equality with strcmp
  for dStruct = dataRecords
     if strcmp(dStruct.(fieldName), fieldValue)
       wantedRecords = [wantedRecords, dStruct]; %#ok<AGROW>
     end
  end
else
  % this field is numerical, so test equality with ==
  for dStruct = dataRecords
     if dStruct.(fieldName) == fieldValue
       wantedRecords = [wantedRecords, dStruct]; %#ok<AGROW>
     end
  end  
end