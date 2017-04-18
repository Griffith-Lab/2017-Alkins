function [EJPamp, fac_depr_indexfourth, fac_depr_indexseventh, fac_depr_indexlast, avgvolt] = Display40HzNerveStimcore(fullfilename, plotit);
%Displays first train of 40 Hz nerve stimulation matlab files from
%PowerLab
%INPUT PARAMETERS:
%-Files from directory of 10Hz Stimulation Recordings with .mat extension

%OUTPUT PARAMTERS:
%-Returns EJPamp: Amplitude of first spike in 10Hz train
%-Returns fac_depr_indexfourth: Index value (ratio) of 4th spike compared to first spike
%-Returns fac_depr_indexseventh: Index value (ratio) of 7th spike to first spike
%-Returns avgvolt: Average voltage of each trace (5 samples per avg. trace)

[pathname,filename] = fileparts(fullfilename);
cd(pathname);
M = load(filename);
data_block1 = M.data_block1;
data_block2 = M.data_block2;
data_block3 = M.data_block3;
data_block4 = M.data_block4;
data_block5 = M.data_block5;

Volt1(:,1) = data_block1(1,:);
Volt2(:,1) = data_block2(1,:);
Volt3(:,1) = data_block3(1,:);
Volt4(:,1) = data_block4(1,:);
Volt5(:,1) = data_block5(1,:);

Volt = [Volt1 Volt2 Volt3 Volt4 Volt5];
avgvolt =mean(Volt,2);

baseline = mean(avgvolt(1:10000));
maxvolt = max(avgvolt(1:11000));
fourthpeak = max(avgvolt(13000:14000));
fourthmin = min(avgvolt(12000:13000));
seventhpeak = max(avgvolt(16000:17000)); %Assume peaks occur within .1s spaced bins
seventhmin = min(avgvolt(15000:16000));
lastpeak = max(avgvolt(19000:20000));
lastmin = min(avgvolt(18000:19000));
EJPamp = maxvolt-baseline;
EJPampfourth = fourthpeak-fourthmin;
EJPampseventh = seventhpeak-seventhmin;
EJPamplast = lastpeak-lastmin;
fac_depr_indexfourth = EJPampfourth/EJPamp;
fac_depr_indexseventh = EJPampseventh/EJPamp;
fac_depr_indexlast = EJPamplast/EJPamp;

Stim(:,1)= data_block1(1,:);
L = length(avgvolt(:,1));
time = zeros(L,1);

%Create time vector in seconds

for i=1:L
    time(i,1) = i*1e-4;
end

%Convert Volt vector into mV units

for j=1:L
    avgvolt(j,1) = avgvolt(j,1)*1000;
end

if plotit,
    figure;
    title('10 Hz Stimuation')
    % subplot(2,1,1)
    plot(time(:,1),avgvolt);
    ylim([-70,-10]);
    xlim([0,5]);
    xlabel('Time (s)');
    ylabel('Membrane Voltage (mV)');
    % subplot(2,1,2)
    % plot(time(:,1),Stim(:,1));
    % ylim([-10,10]);
    % xlim([0,5]);
    % ylabel('Membrane Voltage (mV)');
end;



