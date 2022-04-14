clear;clc; close all;

%data_folder='C:\Users\SHOU\Desktop\dissertation_research_plan\gps\model_output_new3\ai_model\test';
data_folder='/Users/dongliangshen/Desktop/paper/github/use-public/AI-Model-results';

R=6371.004;

count_06=0;
count_no_06=0;

count_12=0;
count_no_12=0;

count_18=0;
count_no_18=0;

count_24=0;
count_no_24=0;

% count_points_end=0;
% count_no_points_end=0;

bias_model_good_06=[];
bias_model_bad_06=[];
bias_ai_good_06=[];
bias_ai_bad_06=[];

bias_model_good_12=[];
bias_model_bad_12=[];
bias_ai_good_12=[];
bias_ai_bad_12=[];

bias_model_good_18=[];
bias_model_bad_18=[];
bias_ai_good_18=[];
bias_ai_bad_18=[];

bias_model_good_24=[];
bias_model_bad_24=[];
bias_ai_good_24=[];
bias_ai_bad_24=[];

count_both=0;
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
all_index=load([data_folder,'/','training_data_use_new.mat']);
train_index=all_index.train_index+1;
test_index=all_index.test_index+1;
clear all_index;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
% load loop1 data
load([data_folder,'/','data_start_info.mat']);

id=data_info(test_index,1);
time_zero=data_info(test_index,2);
obs_lon_zero=data_info(test_index,3);
obs_lat_zero=data_info(test_index,4);
nm_lon_zero=data_info(test_index,5);
nm_lat_zero=data_info(test_index,6);
clear data_info;
%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%out_dir='C:\Users\SHOU\Desktop\dissertation_research_plan\gps\model_output_new3\ai_model\test\images2';
for i=1:900
    index=i;
    load([data_folder,'/','test_ai_results_lat_new.mat']);
    model_lat=double(test_input(index,:,1))+nm_lat_zero(index);
    model_time=test_input(index,:,3);
    obs_lat=double(test_truth(index,:,1))+obs_lat_zero(index);
    ai_lat=double(test_output(index,:,1))+nm_lat_zero(index);

    load([data_folder,'/','test_ai_results_lon_new.mat']);
    model_lon=double(test_input(index,:,1))+nm_lon_zero(index);
    obs_lon=double(test_truth(index,:,1))+obs_lon_zero(index);
    ai_lon=double(test_output(index,:,1))+nm_lon_zero(index);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    obs_lat_06=interp1(model_time,obs_lat,0.25);
    obs_lon_06=interp1(model_time,obs_lon,0.25);
    model_lat_06=interp1(model_time,model_lat,0.25);
    model_lon_06=interp1(model_time,model_lon,0.25);
    ai_lat_06=interp1(model_time,ai_lat,0.25);
    ai_lon_06=interp1(model_time,ai_lon,0.25);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    obs_lat_12=interp1(model_time,obs_lat,0.5);
    obs_lon_12=interp1(model_time,obs_lon,0.5);
    model_lat_12=interp1(model_time,model_lat,0.5);
    model_lon_12=interp1(model_time,model_lon,0.5);
    ai_lat_12=interp1(model_time,ai_lat,0.5);
    ai_lon_12=interp1(model_time,ai_lon,0.5);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    obs_lat_18=interp1(model_time,obs_lat,0.75);
    obs_lon_18=interp1(model_time,obs_lon,0.75);
    model_lat_18=interp1(model_time,model_lat,0.75);
    model_lon_18=interp1(model_time,model_lon,0.75);
    ai_lat_18=interp1(model_time,ai_lat,0.75);
    ai_lon_18=interp1(model_time,ai_lon,0.75);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    obs_lat_24=obs_lat(end);
    obs_lon_24=obs_lon(end);
    model_lat_24=model_lat(end);
    model_lon_24=model_lon(end);
    ai_lat_24=ai_lat(end);
    ai_lon_24=ai_lon(end);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if (obs_lon(1)~=obs_lon(end))
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        tmpcc_model_06=sind(90-model_lat_06).*sind(90-obs_lat_06).* ...
            cosd(model_lon_06-obs_lon_06)+ ...
            cosd(90-model_lat_06).*cosd(90-obs_lat_06);
        tmpbias_model_06=R.*acos(tmpcc_model_06);

        tmpcc_ai_06=sind(90-ai_lat_06).*sind(90-obs_lat_06).* ...
            cosd(ai_lon_06-obs_lon_06)+ ...
            cosd(90-ai_lat_06).*cosd(90-obs_lat_06);
        tmpbias_ai_06=R.*acos(tmpcc_ai_06);


        if tmpbias_ai_06<=tmpbias_model_06
            count_06=count_06+1;
            bias_model_good_06=[bias_model_good_06,tmpbias_model_06];
            bias_ai_good_06=[bias_ai_good_06,tmpbias_ai_06];
        elseif tmpbias_ai_06>tmpbias_model_06
            bias_model_bad_06=[bias_model_bad_06,tmpbias_model_06];
            bias_ai_bad_06=[bias_ai_bad_06,tmpbias_ai_06];
            count_no_06=count_no_06+1;
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        tmpcc_model_12=sind(90-model_lat_12).*sind(90-obs_lat_12).* ...
            cosd(model_lon_12-obs_lon_12)+ ...
            cosd(90-model_lat_12).*cosd(90-obs_lat_12);
        tmpbias_model_12=R.*acos(tmpcc_model_12);

        tmpcc_ai_12=sind(90-ai_lat_12).*sind(90-obs_lat_12).* ...
            cosd(ai_lon_12-obs_lon_12)+ ...
            cosd(90-ai_lat_12).*cosd(90-obs_lat_12);
        tmpbias_ai_12=R.*acos(tmpcc_ai_12);


        if tmpbias_ai_12<=tmpbias_model_12
            count_12=count_12+1;
            bias_model_good_12=[bias_model_good_12,tmpbias_model_12];
            bias_ai_good_12=[bias_ai_good_12,tmpbias_ai_12];
        elseif tmpbias_ai_12>tmpbias_model_12
            bias_model_bad_12=[bias_model_bad_12,tmpbias_model_12];
            bias_ai_bad_12=[bias_ai_bad_12,tmpbias_ai_12];
            count_no_12=count_no_12+1;
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        tmpcc_model_18=sind(90-model_lat_18).*sind(90-obs_lat_18).* ...
            cosd(model_lon_18-obs_lon_18)+ ...
            cosd(90-model_lat_18).*cosd(90-obs_lat_18);
        tmpbias_model_18=R.*acos(tmpcc_model_18);

        tmpcc_ai_18=sind(90-ai_lat_18).*sind(90-obs_lat_18).* ...
            cosd(ai_lon_18-obs_lon_18)+ ...
            cosd(90-ai_lat_18).*cosd(90-obs_lat_18);
        tmpbias_ai_18=R.*acos(tmpcc_ai_18);


        if tmpbias_ai_18<=tmpbias_model_18
            count_18=count_18+1;
            bias_model_good_18=[bias_model_good_18,tmpbias_model_18];
            bias_ai_good_18=[bias_ai_good_18,tmpbias_ai_18];
        elseif tmpbias_ai_18>tmpbias_model_18
            bias_model_bad_18=[bias_model_bad_18,tmpbias_model_18];
            bias_ai_bad_18=[bias_ai_bad_18,tmpbias_ai_18];
            count_no_18=count_no_18+1;
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        tmpcc_model_24=sind(90-model_lat_24).*sind(90-obs_lat_24).* ...
            cosd(model_lon_24-obs_lon_24)+ ...
            cosd(90-model_lat_24).*cosd(90-obs_lat_24);
        tmpbias_model_24=R.*acos(tmpcc_model_24);

        tmpcc_ai_24=sind(90-ai_lat_24).*sind(90-obs_lat_24).* ...
            cosd(ai_lon_24-obs_lon_24)+ ...
            cosd(90-ai_lat_24).*cosd(90-obs_lat_24);
        tmpbias_ai_24=R.*acos(tmpcc_ai_24);


        if tmpbias_ai_24<=tmpbias_model_24
            count_24=count_24+1;
            bias_model_good_24=[bias_model_good_24,tmpbias_model_24];
            bias_ai_good_24=[bias_ai_good_24,tmpbias_ai_24];
        elseif tmpbias_ai_24>tmpbias_model_24
            bias_model_bad_24=[bias_model_bad_24,tmpbias_model_24];
            bias_ai_bad_24=[bias_ai_bad_24,tmpbias_ai_24];
            count_no_24=count_no_24+1;
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
hhh1=figure('visible','off');

group1=nan(900,4);
group2=nan(900,4);
group3=nan(900,4);
group4=nan(900,4);

bias_model_06=[bias_model_good_06,bias_model_bad_06];
bias_ai_06=[bias_ai_good_06,bias_ai_bad_06];

bias_model_12=[bias_model_good_12,bias_model_bad_12];
bias_ai_12=[bias_ai_good_12,bias_ai_bad_12];

bias_model_18=[bias_model_good_18,bias_model_bad_18];
bias_ai_18=[bias_ai_good_18,bias_ai_bad_18];

bias_model_24=[bias_model_good_24,bias_model_bad_24];
bias_ai_24=[bias_ai_good_24,bias_ai_bad_24];


group1(1:length(bias_model_06),1)=bias_model_06';
group1(1:length(bias_ai_06),3)=bias_ai_06';

group2(1:length(bias_model_12),1)=bias_model_12';
group2(1:length(bias_ai_12),3)=bias_ai_12';

group3(1:length(bias_model_18),1)=bias_model_18';
group3(1:length(bias_ai_18),3)=bias_ai_18';

group4(1:length(bias_model_24),1)=bias_model_24';
group4(1:length(bias_ai_24),3)=bias_ai_24';

groupdata={group1 group2 group3 group4};
grouplegend={'6' '12' '18' '24'};
NN=numel(groupdata);
delta=linspace(0,20,NN);
width=1.5;
cmap=hsv(2);
legwidth=10;
hold on;
for ii=1:NN
    %boxplot(groupdata{ii},'positions',[1:NN]+delta(ii),'widths',width);%,'labels',grouplegend);
    boxplot(groupdata{ii},'positions',[1:NN]+delta(ii), ...
        'whisker',1.5,'boxstyle','outline','widths',width);
    %set(gca,'XTickLabel',grouplegend)
    %plot(nan,1);
    ax=gca;
    ax.YAxis(1).Color='k';
    h=findobj(gca,'Tag','Box');
    %for i=1:length(h)
    %    patch(get(h(i),'XData'),get(h(i),'YData'),[135,206,235]./255,'FaceAlpha',0.3);
    %end
    display(length(h));
    if length(h)==16
        % ai
        pp1=patch(get(h(2),'XData'),get(h(2),'YData'),[255,0,0]./255,'FaceAlpha',0.3);
        patch(get(h(6),'XData'),get(h(6),'YData'),[255,0,0]./255,'FaceAlpha',0.3);
        patch(get(h(10),'XData'),get(h(10),'YData'),[255,0,0]./255,'FaceAlpha',0.3);
        patch(get(h(14),'XData'),get(h(14),'YData'),[255,0,0]./255,'FaceAlpha',0.3);
        % roms
        pp2=patch(get(h(4),'XData'),get(h(4),'YData'),[135,206,235]./255,'FaceAlpha',0.3);
        patch(get(h(8),'XData'),get(h(8),'YData'),[135,206,235]./255,'FaceAlpha',0.3);
        patch(get(h(12),'XData'),get(h(12),'YData'),[135,206,235]./255,'FaceAlpha',0.3);
        patch(get(h(16),'XData'),get(h(16),'YData'),[135,206,235]./255,'FaceAlpha',0.3);
    end
    set(findobj(gca,'type','line'),'linewidth',1.5);
    set(findobj(gca,'Tag','Box'),'color','k');
end

set(gca,'XTick',[2,8.6667,15.3333,22]);
set(gca,'XTickLabel',grouplegend);
%xlim([1+2*delta(1) numel(grouplegend)+legwidth+2*delta(NN)]);

legend([pp2,pp1],{'ROMS' 'AI'},'Location','northwest','Box','off');


xlabel('Time (h)');
ylim([0,60]);
ylabel('Errors (km)');
set(gca,'fontsize',15);
set(gca,'position',[0.15,0.25,0.7,0.65]);
set(gcf,'paperposition',[0,0,8,3]);
print(hhh1,'-r600','-djpeg',['bias_ai_roms_time_series_overall_figure6.jpg']);
close;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
xxx=[1,2,3,4];
yyy_model=[mean(bias_model_06),mean(bias_model_12),mean(bias_model_18),mean(bias_model_24)];
p_model=polyfit(xxx,yyy_model,1);
f_model=polyval(p_model,xxx);

yyy_ai=[mean(bias_ai_06),mean(bias_ai_12),mean(bias_ai_18),mean(bias_ai_24)];
p_ai=polyfit(xxx,yyy_ai,1);
f_ai=polyval(p_ai,xxx);
