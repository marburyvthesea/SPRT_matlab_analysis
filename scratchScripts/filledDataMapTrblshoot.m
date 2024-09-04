for i = 1:length(frames_list)
        frameKey = frames_list(i);
        exampleSubset = filledDataMap(frameKey);
        disp(frameKey)
        disp(size(exampleSubset))
end 