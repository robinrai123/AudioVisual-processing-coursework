function [] = eventLoop(numFiles, isNoisy, fileNameStart, numChannels, outputPath)
%finds the MFCC for a bunch of files, and writes the protoFile too.

noiseFile = 0;
numChannels = numChannels * 2;

for file = 1:numFiles
    fileName = strcat(fileNameStart + num2str(file) + ".wav");
    disp(fileName);
    featureExtraction(fileName, noiseFile, isNoisy, numChannels, numChannels, outputPath, fileNameStart+ num2str(file) + ".mfc");
end