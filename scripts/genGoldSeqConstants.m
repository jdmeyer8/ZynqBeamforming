%% A script for generating files containing the VHDl description of gold sequence constants

%% File names based on what computer is running the script
if strcmp(computer, 'PCWIN64')
    fname1 = '.\data\GoldSeqConsts1.vhd';
    fname2 = '.\data\GoldSeqConsts2.vhd';
    toload = '.\data\goldSeq_4k.mat';
else
    fname1 = './data/GoldSeqConsts1.vhd';
    fname2 = './data/GoldSeqConsts2.vhd';
    toload = './data/goldSeq_4k.mat';
end

%% Load gold sequences and convert to fixed point (16 bits, 15 decimal bits)
load(toload);
gs1 = fi(real(goldSeq_4k(:,1)), 1, 16, 15);
gs2 = fi(real(goldSeq_4k(:,2)), 1, 16, 15);

%% Open files for writing
fid1 = fopen(fname1, 'w');
fid2 = fopen(fname2, 'w');

%% Loop through - write each lut_data one-by-one
fprintf(fid1, '\nGS1 i LUTs\n\n');
fprintf(fid2, '\nGS2 i LUTs\n\n');

for i = 1:64
    fprintf(fid1, ['constant lut_gs_' sprintf('%d', i) ' : vector_of_std_logic_vector16(0 to 63) := \n']);   
    fprintf(fid2, ['constant lut_gs_' sprintf('%d', i) ' : vector_of_std_logic_vector16(0 to 63) := \n']);
    for j = i:64:4096
        if (j < 65)
            fprintf(fid1, '  ("%s",\n', bin(gs1(j)));
            fprintf(fid2, '  ("%s",\n', bin(gs2(j)));
        elseif (j > 4032)
            fprintf(fid1, '   "%s");\n', bin(gs1(j)));
            fprintf(fid2, '   "%s");\n', bin(gs2(j)));
        else
            fprintf(fid1, '   "%s",\n', bin(gs1(j)));
            fprintf(fid2, '   "%s",\n', bin(gs2(j)));
        end
    end
    fprintf(fid1, '\n\n\n');
    fprintf(fid2, '\n\n\n');
end

% fprintf(fid1, '-----------------------------------------------------------------\n');
% fprintf(fid2, '-----------------------------------------------------------------\n');
% fprintf(fid1, '-----------------------------------------------------------------\n');
% fprintf(fid2, '-----------------------------------------------------------------\n');

% fprintf(fid1, '\nGS1 q LUTs\n\n');
% fprintf(fid2, '\nGS2 q LUTs\n\n');
% 
% for i = 1:64
%     fprintf(fid1, ['constant lut_gs1q_data_' sprintf('%d', i) ' : vector_of_signed16(0 to 63) := \n']);
%     fprintf(fid2, ['constant lut_gs2q_data_' sprintf('%d', i) ' : vector_of_signed16(0 to 63) := \n']);
%     for j = i:64:4096
%         if (j < 65)
%             fprintf(fid1, '   (signed("%s"),\n', bin(gs1q(j)));
%             fprintf(fid2, '   (signed("%s"),\n', bin(gs2q(j)));
%         elseif (j > 4032)
%             fprintf(fid1, '    signed("%s"));\n', bin(gs1q(j)));
%             fprintf(fid2, '    signed("%s"));\n', bin(gs2q(j)));
%         else
%             fprintf(fid1, '    signed("%s"),\n', bin(gs1q(j)));
%             fprintf(fid2, '    signed("%s"),\n', bin(gs2q(j)));
%         end
%     end
%     fprintf(fid1, '\n');
%     fprintf(fid2, '\n');
% end

fclose(fid1);
fclose(fid2);