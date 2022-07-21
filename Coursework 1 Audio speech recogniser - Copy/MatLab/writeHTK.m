function [] = writeHTK(filename, vectorPeriodMS, numVectors, numDims, featureVector )
%eg speech001.mfc, 20ms, 8900, 25

parmKind = 6; %MFCC paramter type

% Open file for writing:
fid = fopen(filename, 'w', 'ieee-be');
% Write the header information% 
fwrite(fid, numVectors, 'int32'); % number of feature vectors in file (4 byte int)
fwrite(fid, (vectorPeriodMS*10000), 'int32'); % sample period in 100ns units (4 byte int)
fwrite(fid, numDims * 4, 'int16'); % number of items in each vector, number of bytes per vector (2 byte int)
fwrite(fid, parmKind, 'int16'); % code for the sample kind (2 byte int)
% Write the data: one coefficient at a time:
for i = 1: numVectors 
    for j = 1:numDims 
        fwrite(fid, featureVector(i, j), 'float32'); 
    end
end
fclose(fid);




end