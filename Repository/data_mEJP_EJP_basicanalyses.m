
% Use ChartMatlabLoad.m (modify accordingly) then save the following
% metadata code desired:

% EXAMPLE: save('W1118-1.mat', 'genotype', 'NMJ_minis', 'sample_time_msec')

% Load metadata from recordings
%***ALL CODE SHOWN COMPARING TWO GENOTYPES (MODIFY TO INCLUDE MULTIPLE)***

%CREATE DATA LIST OF mEJP RECORDINGS PER GENOTYPE
dataList_genotype_one=LoadDataDir('genotype1_dir');
genotype_one_list = GetDataRecords(dataList_genotype_one, 'genotype', 'genotype_one');

dataList_genotype_two =LoadDataDir('genotype2_dir');
genotype_two_list = GetDataRecords(dataList_genotype_two, 'genotype', 'genotype_two');

for i = 1:length(genotype_one_list)
gen_one_freq (i,1)= (genotype_one_list(i).NMJ_minis.freq);
gen_one_amplitude (i,1)= mean(genotype_one_list(i).NMJ_minis.height);
end
for i = 1:length(genotype_two_list)
gen_two_freq (i,1) = (genotype_two_list(i).NMJ_minis.freq);
gen_two_amplitude (i,1) = mean(genotype_two_list(i).NMJ_minis.height);
end

% mEJP Frequency Outliers:
Exp_low_out_freq=mean(gen_two_freq)-(3*std(gen_two_freq));
Exp_up_out_freq=mean(gen_two_freq)+(3*std(gen_two_freq));
Con_low_out_freq=mean(gen_one_freq)-(3*std(gen_one_freq));
Con_up_out_freq=mean(gen_one_freq)+(3*std(gen_one_freq));

% mEJP Amplitude Outliers:
Exp_low_out_amp=mean(gen_two_amplitude)-(3*std(gen_two_amplitude));
Exp_up_out_amp=mean(gen_two_amplitude)+(3*std(gen_two_amplitude));
Con_low_out_amp=mean(gen_one_amplitude)-(3*std(gen_one_amplitude));
Con_up_out_amp=mean(gen_one_amplitude)+(3*std(gen_one_amplitude));

% Before you plot figures, remove outliers for frequency and amplitude
% measurements

% CREATE mEJP FREQUENCY AND AMPLITUDE PLOTS (SHOWN FOR TWO GENOTYPES)

% Plot raw data points to see distribution
figure
plot(1, gen_one_amplitude, 'bx')
hold on
plot(2, gen_two_amplitude, 'rx')
hold on
set(gca,'XTick', [1 2])
set(gca,'XtickLabel',{'NRXIV', '(Set 2) miR-34 -/-', 'HTS/Adducin'})
set(gca,'XLim',[0.4 2.6])
xlabel ('Genotype')
ylabel('Amplitude (mV)')
title('mEJP Amplitude - Raw Distribution')
hold off

figure
plot(1, gen_one_freq, 'bx')
hold on
plot(2, gen_two_freq, 'rx')
hold on
set(gca,'XTick', [1 2])
set(gca,'XtickLabel',{'NRXIV', '(Set 2)miR-34 -/-', 'HTS/Adducin'})
set(gca,'XLim',[0.4 2.6])
xlabel ('Genotype')
ylabel('Frequency (Hz)')
title('mEJP Frequency - Raw Distribution')
hold off

% Plot bar graph of data

figure
bar(1,mean(gen_one_freq),'b')
hold on
bar(2,mean(gen_two_freq),'r')
plot([1 1],[mean(gen_one_freq)-(std(gen_one_freq)/sqrt(length(gen_one_freq))) mean(gen_one_freq)+(std(gen_one_freq)/sqrt(length(gen_one_freq)))],'k-');
plot([2 2],[mean(gen_two_freq)-(std(gen_two_freq)/sqrt(length(gen_two_freq)))  mean(gen_two_freq)+(std(gen_two_freq)/sqrt(length(gen_two_freq)))],'k-');
set(gca,'XTick', [1 2])
set(gca,'XtickLabel',{'gen_one', 'gen_two'})
set(gca,'XLim',[0.4 2.6])
xlabel ('Genotype')
ylabel('Frequency (Hz)')
title('mEJP Frequency')

figure
bar(1,mean(gen_one_amplitude),'b')
hold on
bar(2,mean(gen_two_amplitude),'r')
plot([1 1],[mean(gen_one_amplitude)-(std(gen_one_amplitude)/sqrt(length(gen_one_amplitude))) mean(gen_one_amplitude)+(std(gen_one_amplitude)/sqrt(length(gen_one_amplitude)))],'k-');
plot([2 2],[mean(gen_two_amplitude)-(std(gen_two_amplitude)/sqrt(length(gen_two_amplitude)))  mean(gen_two_amplitude)+(std(gen_two_amplitude)/sqrt(length(gen_two_amplitude)))],'k-');
set(gca,'XTick', [1 2])
set(gca,'XtickLabel',{'NRXIV-OK6', 'miR34 -/-'})
set(gca,'XLim',[0.4 2.6])
xlabel ('Genotype')
ylabel('Amplitude (mV)')
title('mEJP Amplitude')

% ANOVA Tests for significance (Run jbtest first to determine distribution)
% (for multiple genotypes use alternate program like SPSS)
h1=jbtest(gen_one_amplitude)
h2=jbtest(gen_one_freq)
h3=jbtest(gen_two_freq)
h4=jbtest(gen_two_amplitude)
allamp = [gen_one_amplitude; gen_two_amplitude];
groups = [ones(size(gen_one_amplitude));2*ones(size(gen_two_amplitude))];
[p1,anovatab,stats]=kruskalwallis(allamp,groups);
allfreq = [gen_one_freq; gen_two_freq];
groups = [ones(size(gen_one_freq));2*ones(size(gen_two_freq))];
[p2,anovatab,stats]=kruskalwallis(allfreq,groups);

%***************************************************************************************************************

%EJP AMPLITUDE STATS
%Use analyzeall.m function in correct directory CONTAINING 10Hz DATA

clear
[ejp_base_spike_CS, ejp_4th_spike_index_CS, ejp_7th_spike_index_CS, ejp_last_spike_index_CS, avgvolt_CS] = analyzeall(cd);
mean(ejp_4th_spike_index_CS)%Gives the mean of the 4th spike fac_depr index for all samples
mean(ejp_7th_spike_index_CS)%Gives the mean of the 7th spike fac_depr index for all samples
mean(ejp_last_spike_index_CS)
A=[avgvolt_CS{:}];
meanA=mean(A,2);
L=length(A(:,1));
time=zeros(L,1);
for i=1:L
time(i,1) = i*1e-4;
end
figure
title('10 Hz Stimuation')
plot(time(:,1),meanA);
ylim([-70,-10]);
xlim([0,5]);
xlabel('Time (s)');
ylabel('Membrane Voltage (mV)');

%%BE SURE TO CHANGE DIRECTORIES BEFORE COPY & PASTE%%
[ejp_base_spike_CaMKII, ejp_4th_spike_index_CaMKII, ejp_7th_spike_index_CaMKII, ejp_last_spike_index_CaMKII, avgvolt_CaMKII] = analyzeall(cd);
mean(ejp_4th_spike_index_CaMKII)
mean(ejp_7th_spike_index_CaMKII)
mean(ejp_last_spike_index_CaMKII)
B=[avgvolt_CaMKII{:}]; % [ avgvoltw1118{:} ] % Notation only works if each matrix is the same length
meanB=mean(B,2);
L=length(B(:,1));
time=zeros(L,1);
for i=1:L
time(i,1) = i*1e-4;
end
figure
title('10 Hz Stimuation')
plot(time(:,1),meanB);
ylim([-70,-10]);
xlim([0,5]);
xlabel('Time (s)');
ylabel('Membrane Voltage (mV)');

%PLOT BOTH EJP-AMPLITUDES
mean(ejp_base_spike_CS)
mean(ejp_base_spike_CaMKII)
figure
bar(1,mean(ejp_base_spike_CS),'b')
hold on
bar(2,mean(ejp_base_spike_CaMKII),'r')
plot([1 1],[mean(ejp_base_spike_CS)-(std(ejp_base_spike_CS)/sqrt(length(ejp_base_spike_CS))) mean(ejp_base_spike_CS)+(std(ejp_base_spike_CS)/sqrt(length(ejp_base_spike_CS)))],'k-');
plot([2 2],[mean(ejp_base_spike_CaMKII)-(std(ejp_base_spike_CaMKII)/sqrt(length(ejp_base_spike_CaMKII)))  mean(ejp_base_spike_CaMKII)+(std(ejp_base_spike_CaMKII)/sqrt(length(ejp_base_spike_CaMKII)))],'k-');
set(gca,'XTick', [1 2])
set(gca,'XtickLabel',{'Canton S', 'CaMKII-/-'})
set(gca,'XLim',[0.4 2.6])
xlabel ('Genotype')
ylabel('Amplitude (V)')
title('EJP Amplitude')

%INDEX TESTS FOR SIGNIFICANCE

[H_4th, P_4th]=ttest2(ejp_4th_spike_index_CS,ejp_4th_spike_index_CaMKII)
[H_7th, P_7th]=ttest2(ejp_7th_spike_index_CS,ejp_7th_spike_index_CaMKII)
[H_last, P_last]=ttest2(ejp_last_spike_index_CS,ejp_last_spike_index_CaMKII)
h1=jbtest(ejp_base_spike_CS)
h2=jbtest(ejp_base_spike_CaMKII)
% if h1=0 h2=0%
[H_base,P_base]=ttest2(ejp_base_spike_CS,ejp_base_spike_CaMKII)
% if h1=1 h2=1%
all_ejp_base_amplitudes = [ejp_base_spike_CS.'; ejp_base_spike_CaMKII.'];
ejp_groups = [ones(size(ejp_base_spike_CS.'));2*ones(size(ejp_base_spike_CaMKII.'))];
[p_base,anovatab,stats]=kruskalwallis(all_ejp_base_amplitudes,ejp_groups);