%% Gold Sequence 1

f1 = 'gs1.txt';
gs = helperMUBeamformInitGoldSeq;
gs1 = [real(gs(1:8192,1)) imag(gs(1:8192,1))];
fid1 = fopen(f1, 'w');

nloops2 = 10;
nloops = floor(8192/nloops2);

fprintf(fid1, 'RX_I:\n');
ind = 1;
for i = 1:nloops
    for j = 1:nloops2
        fprintf(fid1, 'y(%d) = %-.5f', ind, gs1(ind,1));
        if j == nloops2
            fprintf(fid1, '; \n');
        else
            fprintf(fid1, '; ');
        end
        ind = ind + 1;
    end
end

fprintf(fid1, '\n\n');


fprintf(fid1, 'RX_Q:\n');
ind = 1;
for i = 1:nloops
    for j = 1:nloops2
        fprintf(fid1, 'y(%d) = %-.5f', ind, gs1(ind,1));
        if j == nloops2
            fprintf(fid1, '; \n');
        else
            fprintf(fid1, '; ');
        end
        ind = ind + 1;
    end
end

fclose(fid1);

%% Gold Sequence 2
f2 = 'gs2.txt';
gs = helperMUBeamformInitGoldSeq;
gs2 = [real(gs(1:8192,2)) imag(gs(1:8192,2))];
fid2 = fopen(f2, 'w');

nloops2 = 10;
nloops = floor(8192/nloops2);

fprintf(fid2, 'RX_I:\n');
ind = 1;
for i = 1:nloops
    for j = 1:nloops2
        fprintf(fid2, 'y(%d) = %-.5f', ind, gs2(ind,1));
        if j == nloops2
            fprintf(fid2, '; \n');
        else
            fprintf(fid2, '; ');
        end
        ind = ind + 1;
    end
end

fprintf(fid2, '\n\n');


fprintf(fid2, 'RX_Q:\n');
ind = 1;
for i = 1:nloops
    for j = 1:nloops2
        fprintf(fid2, 'y(%d) = %-.5f', ind, gs2(ind,1));
        if j == nloops2
            fprintf(fid2, '; \n');
        else
            fprintf(fid2, '; ');
        end
        ind = ind + 1;
    end
end

fclose(fid2);