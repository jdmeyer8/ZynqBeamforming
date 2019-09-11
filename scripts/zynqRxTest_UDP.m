clear;
clc;

%%
load(fullfile('data','goldSeq_4k'));
%goldSeq_4k = helperMUBeamformInitGoldSeq;

%%
% receiver = sdrrx('AD936x');
% receiver.BasebandSampleRate = 540.54e3;
% receiver.EnableBurstMode = true;
% receiver.SamplesPerFrame = 200e3;
% receiver.CenterFrequency = 0.9e9;
% receiver.OutputDataType = 'double';
% receiver.GainSource = 'AGC Slow Attack';

receiver = dsp.UDPReceiver(...
    'RemoteIPAddress', '192.168.1.10', ...
    'LocalIPPort', 5001, ...
    'MaximumMessageLength', 2048, ...
    'MessageDataType', 'int32');


maxIter = 500e3;

%%
data = [];
rx1i = [];
rx1q = [];
rx2i = [];
rx2q = [];
rx3i = [];
rx3q = [];
rx4i = [];
rx4q = [];
rx5i = [];
rx5q = [];
rx1 = [];
rx2 = [];
rx3 = [];
rx4 = [];
rx5 = [];
t = [];
figure(1);

i = 1;
plotrange = 200;

day2sec = 24*60*60;

t_start = day2sec*now;

while (i < maxIter)
%     rx = receiver();
%     if ~isempty(rx)
%         plot(rx,'.-');
%         drawnow;
%         fprintf('Iteration %d of %d\n', i, maxIter);
%         i = i+1;
%     end
    rx = receiver()/2^16;
    if ~isempty(rx)
        xmin = i - plotrange;
        %data = [data rx'];
        t = [t (day2sec*now - t_start)];
        i_rx1i = mean(rx(1:10:end));
        i_rx1q = mean(-1*rx(2:10:end));
        i_rx2i = mean(rx(3:10:end));
        i_rx2q = mean(-1*rx(4:10:end));
        i_rx3i = mean(rx(5:10:end));
        i_rx3q = mean(-1*rx(6:10:end));
        i_rx4i = mean(rx(7:10:end));
        i_rx4q = mean(-1*rx(8:10:end));
        i_rx5i = mean(rx(9:10:end));
        i_rx5q = mean(-1*rx(10:10:end));
        
        rx1i = [rx1i i_rx1i];
        rx1q = [rx1q i_rx1q];
        rx1 = [rx1 angle(i_rx1i + 1i*i_rx1q)];
        
        rx2i = [rx2i i_rx2i];
        rx2q = [rx2q i_rx2q];
        rx2 = [rx2 angle(i_rx2i + 1i*i_rx2q)];
        
        rx3i = [rx3i i_rx3i];
        rx3q = [rx3q i_rx3q];
        rx3 = [rx3 angle(i_rx3i + 1i*i_rx3q)];
        
        rx4i = [rx4i i_rx4i];
        rx4q = [rx4q i_rx4q];
        rx4 = [rx4 angle(i_rx4i + 1i*i_rx4q)];
        
        rx5i = [rx5i i_rx5i];
        rx5q = [rx5q i_rx5q];
        rx5 = [rx5 angle(i_rx5i + 1i*i_rx5q)];
        
        clf;
        if (xmin > 0)
            inds = xmin:i;
        else
            inds = 1:i;
        end
        
        hold all;
        plot(t, rx1, '.-');
        plot(t, rx2, '.-');
        plot(t, rx3, '.-');
        plot(t, rx4, '.-');
        title('CSI Angle Estimate', 'fontsize', 16)
        xlabel('Time [s]');
        ylabel('Angle [rad]');
        legend('Ch. 1', 'Ch. 2', 'Ch. 3', 'Ch. 4', 'location', 'northeastoutside');
        
%         plot(inds, rx1i(inds), '.-');
%         plot(inds, rx1q(inds), '.-');
%         plot(inds, rx2i(inds), '.-');
%         plot(inds, rx2q(inds), '.-');
%         plot(rx1i, '.-');
%         plot(rx1q, '.-');

%         subplot(211); hold all;
%         title('Channel 1');
%         plot(t, rx1i, '.-');
%         plot(t, rx1q, '.-');
%         legend('I', 'Q', 'location', 'west');
%         
%         subplot(212); hold all;
%         title('Channel 2');
%         plot(t, rx2i, '.-');
%         plot(t, rx2q, '.-');
%         legend('I', 'Q', 'location', 'west');
        
        drawnow;
        fprintf('Iteration %d of %d\n', i, maxIter);
        i = i+1;
    end
end

%%
release(receiver);
