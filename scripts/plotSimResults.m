%% Extract data from Timeseries objects
if isa(xcorr1,'timeseries')
    t = xcorr1.Time;
    t = t*(1/61.44e6);      % convert from Simulation time to Real Time (61.44MHz clock)

    xcorr1 = xcorr1.Data;
    xcorr2 = xcorr2.Data;
    ch1_i = ch1_i.Data;
    ch1_q = ch1_q.Data;
    pd_en = pd_en.Data;
    est_en = est_en.Data;
    nr_out = nr_out.Data;
end

%% Calculate channel estimates
ch1_i = ch1_i/max(nr_out);
ch1_q = ch1_q/max(nr_out);

%% Plots
figure(20); clf;
c = get(gca,'colororder');
c1 = c(1,:);
c2 = c(2,:);
c3 = c(3,:);
c4 = c(4,:);
c5 = c(5,:);
c6 = c(6,:);

xmin = 4e-3;
% xmin = min(t);

subplot(311); hold all;
plot(t,pd_en, '.-', 'color', c1);
plot(t,est_en, '.-', 'color', c2);
set(gca, 'fontsize', 10);
title('FPGA States', 'fontweight', 'bold', 'fontsize', 16);
% ylabel('Enabled/Disabled', 'fontweight', 'bold', 'fontsize', 12);
set(gca,'ytick', [0 1]);
set(gca,'yticklabel',{'Disabled', 'Enabled'});
set(gca,'xlim', [xmin max(t)]);
leg = legend('Peak Detect', 'Estimate Channel', 'location', 'west');
leg.FontSize = 12;

subplot(312); hold all;
plot(t,xcorr1,'.-', 'color', c3);
plot(t,xcorr2,'.-', 'color', c4);
set(gca,'xlim', [xmin max(t)]);
set(gca, 'fontsize', 10);
title('Gold Sequence Cross-Correlators', 'fontweight', 'bold', 'fontsize', 16);
ylabel('Xcorr [a.u.]', 'fontweight', 'bold', 'fontsize', 16);
leg = legend('Channel 1', 'Channel 2', 'location', 'northwest');
leg.FontSize = 12;

subplot(313); hold all;
plot(t,ch1_i,'.-', 'color', c6);
plot(t,ch1_q,'.-', 'color', c5);
set(gca,'xlim', [xmin max(t)]);
set(gca, 'fontsize', 10);
title('Channel 1 CSI', 'fontweight', 'bold', 'fontsize', 16);
ylabel('CSI [a.u.]', 'fontweight', 'bold', 'fontsize', 16);
xlabel('Time [s]', 'fontweight', 'bold', 'fontsize', 16);
leg = legend('Ch1 i', 'Ch1 q', 'location', 'west');
leg.FontSize = 12;
