% Retrun value is...
%
%
% TODO(chanwcom) FRAME_PERIOD should be replaced by FRAME_PERIOD
% TODO(chanwcom) Make a unit test for this VAD
% VAD
%
% Return value:
function [out_speech] = vad_speech_part(in_speech)
  in_speech_org = in_speech;
  in_speech = in_speech - mean(in_speech);
  in_speech_orgStd = std(in_speech);

  % TODO(chanwcom) Make it as a constant member variable.
  PEAK   = 0.95;
  BOTTOM = 0.2;

  % This is very bad.
  % There is no gaurantee that the input sampling rate is 
  % 16 kHz.
  FRAME_PERIOD = 160.0;
  FRAME_LEN    = FRAME_PERIOD;

  iNumFrames = floor((length(in_speech) - FRAME_LEN) / FRAME_PERIOD) + 1;
  adSPL      = zeros(iNumFrames, 1);  
  
  % Compute the energy
  % TODO(chanwcom)
  % Can't we make it as a subclass of something like Process ?
  iFrameIndex = 0;
  for i = 0 : FRAME_PERIOD : length(in_speech) - 1 - FRAME_LEN
    iFrameIndex = iFrameIndex + 1;

    xFrame = in_speech(i + 1 : i + FRAME_LEN);

    % Let's calculate the sound pressure level
    % RMS power
    dRMS  = sqrt(mean(xFrame .* xFrame));
    adSPL(iFrameIndex) = 10 * log10(dRMS^2 / (2e-5)^2); 
  end

  adSortedSPL = sort(adSPL);

  aTH1 = adSortedSPL(floor(length(adSortedSPL) * PEAK));
  aTH2 = adSortedSPL(floor(length(adSortedSPL) * BOTTOM));
  dTH = (aTH1 + aTH2) / 2

  % Now, let's run the end detection algorithm
  adVAD = HangOverVAD(adSPL, dTH);
  [endResult iNumPart] =EndDetection(adVAD);
  
  iAcc = 0;
  
  for i = 1 : iNumPart,
   endResult(i, 1) = max(endResult(i, 1) - 30, 1);
   endResult(i, 2) = min(endResult(i, 2) + 30, length(adVAD));
   if i ~= iNumPart
    endResult(i, 2) = min(endResult(i, 2), endResult(i + 1, 1) - 30);
   end
   
   iStart = FRAME_PERIOD * endResult(i, 1);
   iEnd   = FRAME_PERIOD * endResult(i, 2);
   
   iLen = iEnd - iStart + 1;
   
   out_speech(iAcc + 1 : iAcc + iLen) = in_speech(iStart : iEnd);
   iAcc = iAcc + iLen;
  end
  
  if 0
      figure
      subplot(4, 1, 1)
      plot(in_speech_org)
      axis([0 length(in_speech) -max(abs(in_speech_org)) max(abs(in_speech_org))])

      subplot(4, 1, 2)
      plot(adSPL);
      axis([0 length(adSPL) min(adSPL) max(adSPL)])

      subplot(4, 1, 3)
      stem(adVAD);
      axis([0 length(adVAD) 0 1])

      subplot(4, 1, 4)
      plot((in_speech_org - mean(in_speech_org)) / 32768 + 0.5 , 'r')
      hold on

      for i = 1 : iNumPart
      plot([endResult(i, 1) * FRAME_PERIOD, endResult(i, 1) * FRAME_PERIOD], [0 1]);
      hold on
      plot([endResult(i, 2) * FRAME_PERIOD, endResult(i, 2) * FRAME_PERIOD], [0 1]);
      end
      axis([0, length(adVAD)*FRAME_PERIOD + 20, 0, 1])
  end
end

%
% Simple Hang-Over VAD
%
function [adVAD] = HangOverVAD(adSPL, dTH)

SIL    = 0;
SPEECH = 1;

bState = SIL;
bDec   = 0;

NUM_TRANS = 3;


adVAD = zeros(size(adSPL));
iToSpeech = 0;
iToSil    = 0;
    for i = 0 : length(adSPL) - 1
        
        %% Performing the decision
        if (adSPL(i + 1) > dTH)
            bDec = 1;
        else
            bDec = 0;
        end
        
        % State mach
        
        
        if (bState == SIL)
            adVAD(i + 1) = SIL;
            
            if (bDec == 1)
                iToSpeech = iToSpeech + 1;
                iToSil    = 0;
                
                if (iToSpeech == NUM_TRANS)
                    % Transition to speech occurs
                    
                    bState = SPEECH;
                    
                    for j = 0 : NUM_TRANS - 1
                        adVAD(max(i - j, 0) + 1) = SPEECH;
                    end
                  
                    
                    iToSpeech = 0;
                    iToSil    = 0;
                    
                end
            else
                
                iToSpeech = 0;
                iToSil    = 0;
            end
        end
            
        if (bState == SPEECH)
            adVAD(i + 1) = SPEECH;
                
            if (bDec == 1)
                
                iToSil    = 0;
                iToSpeech = 0;
            else
                iToSil    = iToSil + 1;
                iToSpeech = 0;
                
                if (iToSil == NUM_TRANS)
                    % Transition to speech occurs
                    
                    bState = SIL;
                    
                     for j = 0 : NUM_TRANS - 1
                        adVAD(max(i - j, 0) + 1) = SIL;
                    end
                  
                    
                    iToSpeech = 0;
                    iToSil    = 0;
                end
          
            
            end
        end
    end
end

%
% Programmed by Chanwoo Kim
function [endResult iSpeechIndex] = EndDetection(adVAD)

    iSpeechIndex = 0;
    
    OUT_SPEECH = 0;
    IN_SPEECH  = 1;
    SIL_DUR    = 30; % if the slince is longer than 2s, then it is considered to be out of the sentence
    MARGIN     = 10;
    
    bState = OUT_SPEECH;
    
    endResult = zeros(100, 2);

    for i = 0 : length(adVAD) - 1
        
        if (bState == OUT_SPEECH)
            if (adVAD(i + 1) == 1)
                iSpeechIndex = iSpeechIndex + 1;
                endResult(iSpeechIndex, 1) = i + 1;
                bState = IN_SPEECH;
                
                iCount = 0;
            end
        
        end
        
        
        if (bState == IN_SPEECH)
             if (adVAD(i + 1) == 0)
                iCount = iCount + 1;
                
                if (i      == length(adVAD) - 1)
                      endResult(iSpeechIndex, 2) = i - iCount + 1;
                      bState = OUT_SPEECH;
                      
                      iCount = 0;
                    
                end
                
                if (iCount == SIL_DUR)
                      endResult(iSpeechIndex, 2) = i - SIL_DUR + 1;
                      bState = OUT_SPEECH;
                      
                      iCount = 0;
                end
                
             else
                 iCount = 0;
             end
            
        end
        
        
    end
    
    
    %
    % Debug Chanwoo Kim
    %
    
    if (endResult(1, 2) == 0)
        endResult(1, 2) = length(adVAD);
    end
    
    endResult(iSpeechIndex + 1 : 100, :)  = [];

end
    
