%% Extract data from sim_results.txt
if strcmp(computer, 'PCWIN64')
    fname = '.\hdl_prj\vivado_ip_prj\vivado_prj.sim\sim_2\behav\xsim\sim_results.txt';
else
    fname = './hdl_prj/vivado_ip_prj/vivado_prj.sim/sim_2/behav/xsim/sim_results.txt';
end
% data_in = readResults(fname);
data_in = csvread(fname);

%% Extract variables from data and convert to fixed point and then double
corr_ch1 = 0.5*data_in(:,1)/(2^15);
corr_ch2 = 0.5*data_in(:,2)/(2^15);
state = data_in(:,3);
% ch1_i = 0.5*data_in(:,4)/(2^15);
% ch1_q = 0.5*data_in(:,5)/(2^15);
% ch1_r = 0.5*data_in(:,6)/(2^15);
ch1_i = data_in(:,4)/(2^15);
ch1_q = data_in(:,5)/(2^15);
%ch1_r = data_in(:,6)/(2^15);
ch2_i = data_in(:,6)/(2^15);
ch2_q = data_in(:,7)/(2^15);

fpga_state = zeros(size(state));
fpga_state(state == 1) = 1;
fpga_state(state == 2) = 2;
fpga_state(state == 4) = 3;
fpga_state(state == 8) = 3;

t = (1/(128*420e3))*(1:numel(state));

%% Plots
pstep = 4;

figure(20); clf;
c = get(gca,'colororder');
c1 = c(1,:);
c2 = c(2,:);
c3 = c(3,:);
c4 = c(4,:);
c5 = c(5,:);
c6 = c(6,:);
c7 = c(7,:);

% xmin = 4e-3;
xmin = min(t);

subplot(311); hold all;
plot(t(1:pstep:end),fpga_state(1:pstep:end), '-', 'color', c1);
set(gca, 'fontsize', 10);
title('FPGA State', 'fontweight', 'bold', 'fontsize', 16);
xlabel('Time [s]', 'fontsize', 14);
% ylabel('Enabled/Disabled', 'fontweight', 'bold', 'fontsize', 12);
set(gca,'ytick', [1 2 3]);
set(gca,'yticklabel',{'Peak Detect', 'Estimate Channel', 'Reset'});
set(gca,'xlim', [xmin max(t)]);
% leg = legend('Peak Detect', 'Estimate Channel', 'location', 'west');
% leg.FontSize = 12;

subplot(312); hold all;
plot(t(1:pstep:end),corr_ch1(1:pstep:end),'-', 'color', c3);
plot(t(1:pstep:end),corr_ch2(1:pstep:end),'-', 'color', c4);
set(gca,'xlim', [xmin max(t)]);
set(gca, 'fontsize', 10);
title('Gold Sequence Correlators', 'fontweight', 'bold', 'fontsize', 16);
xlabel('Time [s]', 'fontsize', 14);
ylabel('Xcorr [a.u.]', 'fontsize', 14);
leg = legend('Channel 1', 'Channel 2', 'location', 'northwest');
leg.FontSize = 12;

subplot(313); hold all;
plot(t(1:pstep:end),ch1_i(1:pstep:end),'-', 'color', c6);
plot(t(1:pstep:end),ch1_q(1:pstep:end),'--', 'color', c6);
plot(t(1:pstep:end),ch2_i(1:pstep:end),'-', 'color', c2);
plot(t(1:pstep:end),ch2_q(1:pstep:end),'--', 'color', c2);
set(gca,'xlim', [xmin max(t)]);
set(gca, 'fontsize', 10);
title('Channel 1 CSI', 'fontweight', 'bold', 'fontsize', 16);
xlabel('Time [s]', 'fontsize', 14);
ylabel('CSI [a.u.]', 'fontsize', 14);
leg = legend('Ch1 i', 'Ch1 q', 'Ch2 i', 'Ch2 q', 'location', 'west');
leg.FontSize = 12;
