if strcmp(computer, 'PCWIN64')
    load('.\data\GenGoldSeq_4k.mat');
else
    load('./data/GenGoldSeq_4k.mat');
end

%% Arrange rx inputs
rxi = [zeros(10,1); 0];

%% File name
file_i = '.\simulation\rx_test_i.txt';
file_q = '.\simulation\rx_test_q.txt';

%% Extract rxi and rxq from .mat file data
rxi_fi = fi(rx_i_in(:,2),1,16,15);
rxq_fi = fi(rx_q_in(:,2),1,16,15);

%% Convert to binary
rxi = bin(rxi_fi);
rxq = bin(rxq_fi);

%% Loop through and write to file
nlines = numel(rxi_fi);

fidi = fopen(file_i, 'w');
fidq = fopen(file_q, 'w');

for i = 1:nlines
    fprintf(fidi,[rxi(i,:) '\n']);
    fprintf(fidq,[rxq(i,:) '\n']);
end

fclose(fidi);
fclose(fidq);