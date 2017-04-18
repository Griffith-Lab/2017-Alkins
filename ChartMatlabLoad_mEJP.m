%Loads Matlab files from Chart recordings

clear
[filename, pathname] = uigetfile;
cd(pathname);
M = load(filename);
data_block1 = M.data_block1;
sample_time_msec = 0.1;

Volt(:,1) = data_block1(1,:);
Volt1 = Volt(:,1);
data=Volt*10^3;
data_mV=Volt1*10^3;
MaxVolt = max(Volt1);
mem_voltage_mV = data_mV;

L = length(data);
time = zeros(L,1);

%Create time vector in seconds

for i=1:L
    time(i,1) = i*10*10^-5;
end
% Plot full trace and mini-segment

figure
subplot(2,1,1)
plot(time,data)
ylim([mean(data)-7.5 mean(data)+7.5])
ylabel('mV')
subplot(2,1,2)
plot(time,data)
xlim([58,60])
xlabel('Time (S)')
ylabel('mV')

%EXAMPLE
% NMJ_minis=GetSpikes(sample_time_msec,mem_voltage_mV,'findMinis',true,'plotSubject',false,'debugPlots',false);
% genotype = 'DMEF';
