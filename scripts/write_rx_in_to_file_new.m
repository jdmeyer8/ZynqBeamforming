if strcmp(computer, 'PCWIN64')
    load('.\data\goldSeq_4k.mat');
    file_i = '.\simulation\rx_test_i.txt';
    file_q = '.\simulation\rx_test_q.txt';
else
    load('./data/goldSeq_4k.mat');
    file_i = './simulation/rx_test_i.txt';
    file_q = './simulation/rx_test_q.txt';
end

%% Concatenate the gold sequences together with some fluff in the middle
rxi = [zeros(10,1); real(goldSeq_4k(:,1)); real(goldSeq_4k(1:500,3)); real(goldSeq_4k(:,1))];
rxq = [zeros(10,1); imag(goldSeq_4k(:,1)); imag(goldSeq_4k(1:500,3)); imag(goldSeq_4k(:,1))];


%% Convert to fixed point
rxi_fi = fi(rxi,1,16,15);
rxq_fi = fi(rxq,1,16,15);

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