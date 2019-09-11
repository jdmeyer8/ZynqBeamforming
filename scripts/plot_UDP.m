clear;
clc;

%% Load file
load(fullfile('data','ch_est_data.mat'));

%% Plot data
figure(103); clf;

subplot(211); hold all;
plot(t, rx1i);
plot(t, rx1q);
title('Channel 1 Estimation', 'fontsize', 16);
xlabel('Time [s]', 'fontweight', 'bold');
ylabel('CSI Magnitude [a.u.]', 'fontweight', 'bold');
legend('I', 'Q', 'location', 'southwest');
set(gca,'xlim',[0 400]);

subplot(212); hold all;
plot(t, rx2i);
plot(t, rx2q);
title('Channel 2 Estimation', 'fontsize', 16);
xlabel('Time [s]', 'fontweight', 'bold');
ylabel('CSI Magnitude [a.u.]', 'fontweight', 'bold');
legend('I', 'Q', 'location', 'southwest');
set(gca,'xlim',[0 400]);