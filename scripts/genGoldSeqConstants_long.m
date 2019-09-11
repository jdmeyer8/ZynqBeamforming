%% A script for generating files containing the VHDl description of gold sequence constants

%% File names based on what computer is running the script
if strcmp(computer, 'PCWIN64')
    fname1 = '.\data\GoldSeqConsts1_long.vhd';
    fname2 = '.\data\GoldSeqConsts2_long.vhd';
    toload = '.\data\goldSeq_4k.mat';
else
    fname1 = './data/GoldSeqConsts1_long.vhd';
    fname2 = './data/GoldSeqConsts2_long.vhd';
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

fprintf(fid1, ['constant lut_gs : vector_of_std_logic_vector16(0 to 4095) := \n']);
fprintf(fid2, ['constant lut_gs : vector_of_std_logic_vector16(0 to 4095) := \n']);

for i = 1:4096
    if (i == 1)
        fprintf(fid1, '  ("%s",\n', bin(gs1(i)));
        fprintf(fid2, '  ("%s",\n', bin(gs2(i)));
    elseif (i == 4096)
        fprintf(fid1, '   "%s");\n', bin(gs1(i)));
        fprintf(fid2, '   "%s");\n', bin(gs2(i)));
    else
        fprintf(fid1, '   "%s",\n', bin(gs1(i)));
        fprintf(fid2, '   "%s",\n', bin(gs2(i)));
    end
end

fprintf(fid1, '\n\n\n');
fprintf(fid2, '\n\n\n');

fclose(fid1);
fclose(fid2);