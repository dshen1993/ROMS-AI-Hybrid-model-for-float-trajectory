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
train_index=all_index.train_index;
test_index=all_index.test_index;

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
    model_time=test_input(index,:,3);
    obs_lat=double(test_truth(index,:,1))+obs_lat_zero(index);
    ai_lat=double(test_output(index,:,1))+nm_lat_zero(index);

    load([data_folder,'/','test_ai_results_lon_new.mat']);
    model_lon=double(test_input(index,:,1))+nm_lon_zero(index);
    obs_lon=double(test_truth(index,:,1))+obs_lon_zero(index);
    ai_lon=double(test_output(index,:,1))+nm_lon_zero(index);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    obs_lat_12=interp1(model_time,obs_lat,0.5);
    obs_lon_12=interp1(model_time,obs_lon,0.5);
    model_lat_12=interp1(model_time,model_lat,0.5);
    model_lon_12=interp1(model_time,model_lon,0.5);
    ai_lat_12=interp1(model_time,ai_lat,0.5);
    ai_lon_12=interp1(model_time,ai_lon,0.5);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if (obs_lon(1)~=obs_lon(end))
        tmpcc_model=sind(90-model_lat_12).*sind(90-obs_lat_12).* ...
            cosd(model_lon_12-obs_lon_12)+ ...
            cosd(90-model_lat_12).*cosd(90-obs_lat_12);
        tmpbias_model=R.*acos(tmpcc_model);

        tmpcc_ai=sind(90-ai_lat_12).*sind(90-obs_lat_12).* ...
            cosd(ai_lon_12-obs_lon_12)+ ...
            cosd(90-ai_lat_12).*cosd(90-obs_lat_12);
        tmpbias_ai=R.*acos(tmpcc_ai);


        if tmpbias_ai<=tmpbias_model
            count=count+1;
            bias_model_good=[bias_model_good,tmpbias_model];
            bias_ai_good=[bias_ai_good,tmpbias_ai];
        elseif tmpbias_ai>tmpbias_model
            bias_model_bad=[bias_model_bad,tmpbias_model];
            bias_ai_bad=[bias_ai_bad,tmpbias_ai];
            count_no=count_no+1;
        end
    end
end

bias_model=[bias_model_good,bias_model_bad];
bias_ai=[bias_ai_good,bias_ai_bad];
%display(mean(bias_model));
%display(mean(bias_ai));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% good 
hhh=figure('Visible','off');
ax1 = axes('Position',[0.15 0.5 0.35 0.3]);
nbins=25;
h_model=histogram(bias_model_good,nbins);
hold on;
h_ai=histogram(bias_ai_good,nbins);
% h_model.Normalization = 'probability';
% h_ai.Normalization = 'probability';
h_model.BinWidth=1.0;
h_ai.BinWidth=1.0;
set(gca,'xlim',[0,80]);
set(gca,'ylim',[0,200]);
set(gca,'xtick',[]);
lg2=legend('ROMS','AI');
set(lg2,'box','off','fontsize',14);
ylabel('Numbers');
% xlabel('Errors (km)');
text(10,165,{'Improvement';'12-hour';'80.33% (723/900)'});
set(gca,'fontsize',16);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% bad
ax2 = axes('Position',[0.15 0.2 0.35 0.3]);
nbins=25;
h_model=histogram(bias_model_bad,nbins);
hold on;
h_ai=histogram(bias_ai_bad,nbins);
% h_model.Normalization = 'probability';
% h_ai.Normalization = 'probability';
h_model.BinWidth=1.0;
h_ai.BinWidth=1.0;
set(gca,'xlim',[0,80]);
set(gca,'ylim',[0,200]);
% lg3=legend('ROMS','AI');
% set(lg3,'box','off','fontsize',14);
ylabel('Numbers');
xlabel('Errors (km)');
text(10,165,{'Unimprovement';'12-hour';'19.67% (177/900)'});
set(gca,'fontsize',16);
print(hhh,'-r600','-djpeg',['bias_ai_roms_good_and_bad_12_figure7a.jpg']);


