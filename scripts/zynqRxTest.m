clear;
clc;

%%
load(fullfile('data','goldSeq_4k'));
%goldSeq_4k = helperMUBeamformInitGoldSeq;
% trainingSig = helperMUBeamformInitGoldSeq;

% gs_size = 16384;
% gs_size = 8192;
% gs_size = 4096;
% gs_size = 2048;
% gs_size = 1024;

% trainingSig = trainingSig(1:gs_size,:);

%%
receiver = sdrrx('AD936x');
receiver.BasebandSampleRate = 538e3;
receiver.EnableBurstMode = true;
receiver.SamplesPerFrame = 100e3;
receiver.CenterFrequency = 0.9e9;
receiver.OutputDataType = 'double';
%receiver.GainSource = 'AGC Slow Attack';
receiver.GainSource = 'Manual';
receiver.Gain = 70;

maxIter = 1000;

%%

for i = 1:maxIter
    rx = receiver();
    %fprintf('Iteration %d of %d.\n',i,maxIter);
    %fprintf('Iteration %d of %d.    ',i,maxIter);
    if ~isempty(rx)
        figure(1); clf; hold all;
        c = get(gca,'colororder');
        %subplot(211); 
        %plot(abs(xcorr(rx,goldSeq_4k(:,1))),'.-','color',c(1,:)); 
        %title('Correlator Ch1','fontweight','bold');
        %subplot(212); 
        %plot(abs(xcorr(rx,goldSeq_4k(:,2))),'.-','color',c(2,:)); 
        %title('Correlator Ch2','fontweight','bold');
        crossCorr = abs(xcorr(rx, goldSeq_4k(:,1)));
        plot(crossCorr, '.-');
        drawnow;
        %fprintf('Ch1 = %5.2f.    Ch2 = %5.2f.\n',(max(abs(xcorr(rx,goldSeq_4k(:,1))))),(max(abs(xcorr(rx,goldSeq_4k(:,2))))));
    end
    pause(0.5);
end

%%
release(receiver);
