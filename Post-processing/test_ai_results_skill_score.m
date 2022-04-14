clear;clc;close all;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
data_folder='/Users/dongliangshen/Desktop/paper/github/use-public/AI-Model-results';

R=6371.004;

count=0;
count_no=0;

bias_model_good=[];
bias_ai_good=[];
bias_model_bad=[];
bias_ai_bad=[];

count_total=0;
count_total_no=0;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
all_index=load([data_folder,'/','training_data_use_new.mat']);
train_index=all_index.train_index+1;
test_index=all_index.test_index+1;

sinfo=load([data_folder,'/','data_start_info.mat']);
time_zero=sinfo.data_info(test_index,2);
obs_lon_zero=sinfo.data_info(test_index,3);
obs_lat_zero=sinfo.data_info(test_index,4);
nm_lon_zero=sinfo.data_info(test_index,5);
nm_lat_zero=sinfo.data_info(test_index,6);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i=1:900
    index=i;
    load([data_folder,'/','test_ai_results_lat_new.mat']);
    model_lat=double(test_input(index,:,1))+nm_lat_zero(index);
    obs_lat=double(test_truth(index,:,1))+obs_lat_zero(index);
    ai_lat=double(test_output(index,:,1))+nm_lat_zero(index);

    load([data_folder,'/','test_ai_results_lon_new.mat']);
    model_lon=double(test_input(index,:,1))+nm_lon_zero(index);
    obs_lon=double(test_truth(index,:,1))+obs_lon_zero(index);
    ai_lon=double(test_output(index,:,1))+nm_lon_zero(index);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    tmplo=0;
    if (obs_lon(1)~=obs_lon(end))
        tmpcc_model=sind(90-model_lat).*sind(90-obs_lat).* ...
            cosd(model_lon-obs_lon)+ ...
            cosd(90-model_lat).*cosd(90-obs_lat);
        tmpbias_model=R.*acos(tmpcc_model);

        tmpcc_ai=sind(90-ai_lat).*sind(90-obs_lat).* ...
            cosd(ai_lon-obs_lon)+ ...
            cosd(90-ai_lat).*cosd(90-obs_lat);
        tmpbias_ai=R.*acos(tmpcc_ai);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        tmpcc_obs_gap=sind(90-obs_lat(2:end)).*sind(90-obs_lat(1:end-1)).* ...
            cosd(obs_lon(2:end)-obs_lon(1:end-1))+ ...
            cosd(90-obs_lat(2:end)).*cosd(90-obs_lat(1:end-1));
        tmpbias_obs_gap=R.*acos(tmpcc_obs_gap);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        for jj=1:length(tmpbias_obs_gap)
            tmplo=tmplo+sum(tmpbias_obs_gap(1:jj));
        end

        ss_model(i)=sum(tmpbias_model(2:end))/tmplo;
        if ss_model(i)>1
            ss_model_use(i)=0;
        elseif ss_model(i)<=1
            ss_model_use(i)=1-ss_model(i)/1;
        end

        ss_ai(i)=sum(tmpbias_ai(2:end))/tmplo;
        if ss_ai(i)>1
            ss_ai_use(i)=0;
        elseif ss_ai(i)<=1
            ss_ai_use(i)=1-ss_ai(i)/1;
        end




        if tmpbias_ai(end)<=tmpbias_model(end)
            count=count+1;
            bias_model_good=[bias_model_good,tmpbias_model(end)];
            bias_ai_good=[bias_ai_good,tmpbias_ai(end)];
        elseif tmpbias_ai(end)>tmpbias_model(end)
            bias_model_bad=[bias_model_bad,tmpbias_model(end)];
            bias_ai_bad=[bias_ai_bad,tmpbias_ai(end)];
            count_no=count_no+1;
        end
    end
end

display(['mean AI-Skill-Score: ', num2str(mean(ss_ai_use))]);
display(['mean ROMS-Skill-Score: ', num2str(mean(ss_model_use))]);

bias_model=[bias_model_good,bias_model_bad];
bias_ai=[bias_ai_good,bias_ai_bad];
% display(['bias model: ',num2str(mean(bias_model))]);
% display(['biad ai: ',num2str(mean(bias_ai))]);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% total
hhh1=figure('Visible','off');
nbins=25;
h_model=histogram(ss_model_use,nbins);
hold on;
h_ai=histogram(ss_ai_use,nbins);
% h_model.Normalization = 'probability';
% h_ai.Normalization = 'probability';
h_model.BinWidth=0.05;
h_ai.BinWidth=0.05;
set(gca,'xlim',[0,1]);
set(gca,'ylim',[0,250]);
lg1=legend('ROMS','AI');
set(lg1,'box','off','fontsize',14);
ylabel('Numbers');
%xlabel('Errors (km)');
% text(10,170,'24-hour');
set(gca,'fontsize',16);
set(gca,'position',[0.15,0.25,0.7,0.65]);
set(gcf,'paperposition',[0,0,8,3]);
print(hhh1,'-r600','-djpeg',['ss_total.jpg']);



