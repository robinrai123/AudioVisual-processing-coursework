fs = 44100;
pause;
disp('Speak now');
r = audiorecorder(fs,16,1);
record(r);
pause;
stop(r);
disp('Finished');
x = getaudiodata(r, 'double');
xNorm = 0.99 * x/max(abs(x));
fileTitle = append('speech.wav');
audiowrite(fileTitle, xNorm, fs);

