%Displays first train of 40 Hz nerve stimulation matlab files from
%PowerLab

clear
[filename, pathname] = uigetfile;
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

%Peaks/Mins Assume peaks occur within .1s spaced bins
secondmin = min(avgvolt(10000:11000));
secondpeak = max(avgvolt(11000:12000));
thirdmin = min(avgvolt(11000:12000));
thirdpeak = max(avgvolt(12000:13000));
fourthmin = min(avgvolt(12000:13000));
fourthpeak = max(avgvolt(13000:14000));
fifthmin = min(avgvolt(13000:14000));
fifthpeak = max(avgvolt(14000:15000));
sixthmin = min(avgvolt(14000:15000));
sixthpeak = max(avgvolt(15000:16000));
seventhmin = min(avgvolt(15000:16000));
seventhpeak = max(avgvolt(16000:17000)); 
eighthmin = min(avgvolt(16000:17000));
eighthpeak = max(avgvolt(17000:18000));
ninthmin = min(avgvolt(17000:18000));
ninthpeak = max(avgvolt(18000:19000));
lastmin = min(avgvolt(18000:19000));
lastpeak = max(avgvolt(19000:20000));

EJPamp = maxvolt-baseline;
EJPampsecond = secondpeak-secondmin;
EJPampthird = thirdpeak-thirdmin;
EJPampfourth = fourthpeak-fourthmin;
EJPampfifth = fifthpeak-fifthmin;
EJPampsixth = sixthpeak-sixthmin;
EJPampseventh = seventhpeak-seventhmin;
EJPampeighth = eighthpeak-eighthmin;
EJPampninth = ninthpeak-ninthmin;
EJPamplast = lastpeak-lastmin;

%INDICES%
fac_depr_indexsecond = EJPampsecond/EJPamp;
fac_depr_indexthird = EJPampthird/EJPamp;
fac_depr_indexfourth = EJPampfourth/EJPamp;
fac_depr_indexfifth = EJPampfifth/EJPamp;
fac_depr_indexsixth = EJPampsixth/EJPamp;
fac_depr_indexseventh = EJPampseventh/EJPamp;
fac_depr_indexeighth = EJPampeighth/EJPamp;
fac_depr_indexninth = EJPampninth/EJPamp;
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




