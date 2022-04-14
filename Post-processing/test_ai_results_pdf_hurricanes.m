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
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
time_0915=datenum('2020_09_15','yyyy_mm_dd');
time_1009=datenum('2020_10_09','yyyy_mm_dd');
time_1028=datenum('2020_10_28','yyyy_mm_dd');
time_1111=datenum('2020_11_11','yyyy_mm_dd');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i=1:900
    index=i;
    load([data_folder,'/','test_ai_results_lat_new.mat']);
    model_lat=double(test_input(index,:,1))+nm_lat_zero(index);
    model_time=test_input(index,:,3)+time_zero(index);
    obs_lat=double(test_truth(index,:,1))+obs_lat_zero(index);
    ai_lat=double(test_output(index,:,1))+nm_lat_zero(index);

    load([data_folder,'/','test_ai_results_lon_new.mat']);
    model_lon=double(test_input(index,:,1))+nm_lon_zero(index);
    obs_lon=double(test_truth(index,:,1))+obs_lon_zero(index);
    ai_lon=double(test_output(index,:,1))+nm_lon_zero(index);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if (obs_lon(1)~=obs_lon(end) && model_time(1)>=time_0915-1 && model_time(1)<=time_0915+1 || ...
            model_time(1)>=time_1009-1 && model_time(1)<=time_1009+1 || ...
            model_time(1)>=time_1028-1 && model_time(1)<=time_1028+1 || ...
            model_time(1)>=time_1111-1 && model_time(1)<=time_1111+1)
        tmpcc_model=sind(90-model_lat(end)).*sind(90-obs_lat(end)).* ...
            cosd(model_lon(end)-obs_lon(end))+ ...
            cosd(90-model_lat(end)).*cosd(90-obs_lat(end));
        tmpbias_model=R.*acos(tmpcc_model);

        tmpcc_ai=sind(90-ai_lat(end)).*sind(90-obs_lat(end)).* ...
            cosd(ai_lon(end)-obs_lon(end))+ ...
            cosd(90-ai_lat(end)).*cosd(90-obs_lat(end));
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
display(['ROMS mean error under hurricanes: ',num2str(mean(bias_model))]);
display(['AI mean error under hurricanes: ', num2str(mean(bias_ai))]);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



