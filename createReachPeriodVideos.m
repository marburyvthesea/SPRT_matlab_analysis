function createReachPeriodVideos(videoFile, target_mouse, target_day, numFramesToLoad, frames_list)
    % Create a VideoReader object
    vidObj = VideoReader(videoFile);

    % Iterate through each frame number in frames_list
    for i = 1:length(frames_list)
        reachFrame = frames_list(i);

        % Check if the frame number is within the range of the video
        if reachFrame > vidObj.NumFrames
            warning('Frame number %d exceeds the total number of frames in the video.', reachFrame);
            continue;
        end

        % Calculate the range of frames to read
        startFrame = max(1, reachFrame - numFramesToLoad);
        endFrame = min(vidObj.NumFrames, reachFrame + numFramesToLoad);

        % Preallocate cell array to hold frames
        frames = cell(endFrame - startFrame + 1, 1);

        % Read frames around reachFrame
        for j = startFrame:endFrame
            frames{j - startFrame + 1} = read(vidObj, j);
        end

        % Create and save the video file containing surrounding frames
        outputVideoFile = sprintf('mouse%d_day%d_frame%d_surrounding.avi', target_mouse, target_day, reachFrame);
        outputVidObj = VideoWriter(outputVideoFile, 'Uncompressed AVI');  % Create VideoWriter object
        open(outputVidObj);

        % Write frames to the new video file
        for k = 1:numel(frames)
            writeVideo(outputVidObj, frames{k});
        end

        % Close the VideoWriter object
        close(outputVidObj);

        % Save the specific frame as an image
        specificFrame = read(vidObj, reachFrame);
        outputImageFile = sprintf('mouse%d_day%d_frame%d.png', target_mouse, target_day, reachFrame);
        imwrite(specificFrame, outputImageFile);

        % Display the specific frame as an image
        figure;
        imshow(specificFrame);
        title(['Frame ' num2str(reachFrame)]);
    end
end
