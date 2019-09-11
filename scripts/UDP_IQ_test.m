clear;
clc;

%% Load GS file
load(fullfile('data','goldSeq_4k'));
gs = goldSeq_4k;

%% UDP receiver
receiver = dsp.UDPReceiver(...
    'RemoteIPAddress', '192.168.1.10', ...
    'LocalIPPort', 5001, ...
    'MaximumMessageLength', 16350, ...
    'MessageDataType', 'int32');


% maxIter = 500e3;

%% Loop
figure(401);
i = 0;

while true
    rx = receiver();
    if ~isempty(rx)
        data = zeros(numel(rx),1);
        for i = 1:numel(data)
            data(i) = bin2dec(dec2bin(bitget(rx(i),32:-1:17))') + 1i*bin2dec(dec2bin(bitget(rx(i),16:-1:1))');
        end
        data = data/2^16;
        xc = xcorr(data,gs(:,1));
        plot(abs(xc), '.-');
%         plot(rx, '.-');
        set(gca,'ylim',[0 600]);
        drawnow;
%         i = i+1;
    end
end