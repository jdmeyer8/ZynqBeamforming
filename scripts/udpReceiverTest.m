rx = dsp.UDPReceiver;
rx.MessageDataType = 'double';
rx.MaximumMessageLength = 8e3;
rx.RemoteIPAddress = '192.168.3.2';

while 1
    rxIn = rx();
    disp(rxIn);
end