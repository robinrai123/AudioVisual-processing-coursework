function mixABatch(isNoisy, numDims)
    eventLoop(40, isNoisy, "train", numDims);
    eventLoop(10, isNoisy, "thinkpad", numDims);
    eventLoop(10, isNoisy, "dell", numDims);
    eventLoop(10, isNoisy, "blue", numDims);
end