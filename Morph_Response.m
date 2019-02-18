%% Recording Morph Response
% This is an experiment about face perception. You are going to complete
% the part of allowing participants to move and click the mouse (x
% coordinate) to control which morph face they have perceived.


clear variables;
close all;

try
    %% Load Screen
    
    Screen('Preference', 'SkipSyncTests', 1);
    RandStream.setGlobalStream(RandStream('mt19937ar','seed',sum(100*clock)));
    [window, rect] = Screen('OpenWindow', 0); % opening the screen
    Screen('BlendFunction', window, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA); % allowing transparency in the photos
    
    HideCursor();
    window_w = rect(3); % defining size of screen
    window_h = rect(4);
    
    x_2 = window_w/2;
    y_2 = window_h/2;
    
    % Navigate into the folder containing all the stimuli
    cd('Face_Stimuli');
    
    %% Start trials: loading the stimuli
    
    tid = zeros(1,147);
    for f = 1:147
        tmp_bmp = imread([num2str(f) '.PNG']); % read 147 photos
        tid(f) = Screen('MakeTexture', window, uint8(tmp_bmp));
        Screen('DrawText', window, 'Loading...', x_2, y_2-25); % Write text to confirm loading of images
        Screen('DrawText', window, [int2str(int16(f*100/147)) '%'], x_2, y_2+25); % Write text to confirm percentage complete
        Screen('Flip', window); % Display text
    end
    
    img_w = size(tmp_bmp, 2); % width of pictures
    img_h = size(tmp_bmp, 1); % height of pictures
    
    
    %% Recording responses for the morphing experiment
    
    for i = 1:5
        
        % get responses from mouse and record the x&y coordinates of mouse
        % positions and the status of clicks.
        [x,y,clicks] = GetMouse;
        
        
        % if one of the click is already down, wait for release.
        while clicks(1)==1
            [x,y,clicks] = GetMouse;
        end
        
        % Total number of faces
        face_num = 147;
        
        % add random offset to the current mouse position.
        % randomly sample integers from 1 to total number of faces,
        % representing random number of face morphs
        random_offset = randi(face_num);
        
        
        % if no click is down, keep presenting the stimuli and collecting
        % response
        while clicks(1)==0
            
            % get responses from the mouse
            [x,y,clicks] = GetMouse;
            
            % convert the x coordinate of the mouse to a particular face morph
            % in a continuous scale of face morphs.
            % remember to add random offset to the currect mouse position
            % tips: floor, mod, random_offset, face_num
            response = ceil(mod(x+random_offset,147));
%             if response == 0
%                 response=1;
%             end
            
            % present the stimulus corresponding the currect position of the
            % mouse cursor
            Screen('DrawTexture', window , tid(response) );
            
            % flip your window to show the stimulus
            Screen('Flip',window );
        end
        
        
        % Present a blank screen and wait for 0.5 second.
        Screen('Flip', window);
        WaitSecs(0.5);
        
        % Save the observers' response to a variable that is not replaced
        % everytime in the 'for' loop, otherwise it will be lost.
        All_Response(i) = response;
        
    end
    
    % Take control back of your screen
    Screen('CloseAll');
    
catch
    Screen('CloseAll');
    rethrow(lasterror);
end