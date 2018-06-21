% ACUTE EFFECT OF FATIGUE ON THE ELECTROMECHANICAL DELAY OF THE M. BICEPS
% BRACHII AND M. BRACHIORADIALIS FOR ISOMETRIC CONTRACTIONS

% SETUP: 1 subject performed metronome-paced, isometric elbow flexion con-
% tractions with a frequency of 1Hz against a strain-gauge-based, unilate-
% ral force transducer in supination and 90 degrees of elbow flexion; the
% acute effect of fatigue on the electromechanical delay was examined with
% sEMG signals recorded from the M. biceps brachii and M. brachioradialis


clear
close all

for i=1:2
    
    if i==1
        load('/Users/ricardoknauer/Documents/DSP : MATLAB/MAT-Files/emdWithoutFatigue.mat')
        charVector = ' without fatigue';
    else
        load('/Users/ricardoknauer/Documents/DSP : MATLAB/MAT-Files/emdWithFatigue.mat')
        charVector = ' with fatigue';
        pause
    end
    
    force = double([DataMinute001(:,1);DataMinute002(:,1)]);

    % A) M. BICEPS BRACHII
    
    emgBB = double([DataMinute001(:,2);DataMinute002(:,2)]);
    
    % [pxxBB,fBB] = pwelch(emgBB-mean(emgBB),[],[],[],SamplingRate);
    % plot(fBB,pxxBB)
    % title(['power spectral density estimate: M. biceps brachii'...
    %     charVector])
    % xlabel('frequency [Hz]')
    % ylabel('PSD [mV^2/Hz]')
    % 
    % pause
    
    [B_BB,A_BB] = butter(2,[6 500]/(SamplingRate/2));
    
    % [H_BB,fr_BB] = freqz(B_BB,A_BB,200,SamplingRate);
    % figure
    % plot(fr_BB,20*log10(abs(H_BB)))
    % title(['transfer function: M. biceps brachii' charVector])
    % xlabel('frequency [Hz]')
    % ylabel('magnitude [dB]')
    %
    % pause
    
    emgFiltBB = filtfilt(B_BB,A_BB,emgBB);
    
    [B_LE_BB, A_LE_BB] = butter(2,6/(SamplingRate/2));
    linearEnvelopeBB = filtfilt(B_LE_BB,A_LE_BB,abs(emgFiltBB));
    tBB = [0:length(linearEnvelopeBB)-1]/SamplingRate;
    figure
    plot(tBB,linearEnvelopeBB)
    title(['linear envelope of the M. biceps brachii' charVector])
    xlabel('time [s]')
    ylabel('voltage [mV]')
    
    % plot([linearEnvelopeBB forceBB])
    
    [crosscorBB,lagsBB] = xcov(linearEnvelopeBB,-force,'coeff');
    tauBB = lagsBB/SamplingRate;
    [~,imaxBB] = max(crosscorBB);
    delayBB_withoutFatigue = abs(tauBB(imaxBB));
    
    pause
    
    % B) M. BRACHIORADIALIS
    
    emgBRR = double([DataMinute001(:,3);DataMinute002(:,3)]);
    
    % [pxxBRR,fBRR] = pwelch(emgBRR-mean(emgBRR),[],[],[],SamplingRate);
    % plot(fBRR,pxxBRR)
    % title(['power spectral density estimate: M. brachioradialis' ...
    %     charVector])
    % xlabel('frequency [Hz]')
    % ylabel('PSD [mV^2/Hz]')
    % 
    % pause
    
    [B_BRR,A_BRR] = butter(2,[6 500]/(SamplingRate/2));
    
    % [H_BRR,fr_BRR] = freqz(B_BRR,A_BRR,200,SamplingRate);
    % figure
    % plot(fr_BRR,20*log10(abs(H_BRR)))
    % title(['transfer function: M. brachioradialis' charVector])
    % xlabel('frequency [Hz]')
    % ylabel('magnitude [dB]')
    %
    % pause
    
    emgFiltBRR = filtfilt(B_BRR,A_BRR,emgBRR);
    
    [B_LE_BRR, A_LE_BRR] = butter(2,6/(SamplingRate/2));
    linearEnvelopeBRR = filtfilt(B_LE_BRR,A_LE_BRR,abs(emgFiltBRR));
    tBRR = [0:length(linearEnvelopeBRR)-1]/SamplingRate;
    figure
    plot(tBRR,linearEnvelopeBRR)
    title(['linear envelope of the M. brachioradialis' charVector])
    xlabel('time [s]')
    ylabel('voltage [mV]')
    
    % plot([linearEnvelopeBRR forceBRR])
    
    [crosscorBRR,lagsBRR] = xcov(linearEnvelopeBRR,-force,'coeff');
    tauBRR = lagsBRR/SamplingRate;
    [~,imaxBRR] = max(crosscorBRR);
    delayBRR_withoutFatigue = abs(tauBRR(imaxBRR));
    
    
    delayBB(1,i) = abs(tauBB(imaxBB));
    delayBRR(1,i) = abs(tauBRR(imaxBRR));

end

delayBB_withFatigue_minus_withoutFatigue = delayBB(1,2)-delayBB(1,1)
delayBRR_withFatigue_minus_withoutFatigue = delayBRR(1,2)-delayBRR(1,1)


% LIMITATIONS: experiment with only isometric elbow flexion contractions
% and 1 specific exercise protocol (unilateral biceps curls until failure),
% without variation in time between exercise and the recorded trials; only
% 2 of the 3 major elbow flexors measured