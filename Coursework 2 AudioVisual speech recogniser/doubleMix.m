function doubleMix(isNoisy, startPoint, endPoint)

for number=startPoint:endPoint
    folderName = "train"+num2str(number);
    mkdir(folderName);
    eventLoop(40, isNoisy, "train", number, folderName+"\");
end

for number=startPoint:endPoint
    folderName = "thinkpad"+num2str(number);
    mkdir(folderName);
    eventLoop(10, isNoisy, "thinkpad", number, folderName+"\");
end
for number=startPoint:endPoint
    folderName = "blue"+num2str(number);
    mkdir(folderName);
    eventLoop(10, isNoisy, "blue", number, folderName+"\");
end
for number=startPoint:endPoint
    folderName = "dell"+num2str(number);
    mkdir(folderName);
    eventLoop(10, isNoisy, "dell", number, folderName+"\");
end



end