function [] = eventLoop(numFiles, activate_spec_sub, fileNameStart, numChannels, outputPath)
%finds the MFCC for a bunch of files, and writes the protoFile too.

ibmnoisefile = "";
%factory1_16k.wav
%MachineGun_16k.wav
%babble_16k.wav
numChannels = numChannels * 2;

for file = 1:numFiles
    fileName = strcat(fileNameStart + num2str(file) + ".wav");
    disp(fileName);
    featureExtraction(fileName, ibmnoisefile, activate_spec_sub, numChannels, numChannels, outputPath, fileNameStart+ num2str(file) + ".mfc");
end