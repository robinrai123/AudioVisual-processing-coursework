function recordscript(fileName, numFiles)
fs = 16000;
for i = 1:numFiles
    pause;
    disp('Speak now');
    r = audiorecorder(fs,16,1);
    record(r);
    pause;
    stop(r);
    disp('Finished');
    x = getaudiodata(r, 'double');
    xNorm = 0.99 * x/max(abs(x));
    fileTitle = append(fileName, string(i), '.wav');
    audiowrite(fileTitle, xNorm, fs);
end

end