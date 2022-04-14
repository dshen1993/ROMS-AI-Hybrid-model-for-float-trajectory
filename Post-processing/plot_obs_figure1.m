clear;clc;close all;
% load coastline data
load('global_coast.mat');

data_folder='/Users/dongliangshen/Desktop/paper/github/use-public/AI-input-data';
files=dir([data_folder,'/','out_obs_*.mat']);

min_lon=-98.1; max_lon=-79.8;
min_lat=18.0; max_lat=30.9;

count=0;
hhh=figure('visible','off');
m_proj('mercator','lat',[min_lat,max_lat],'lon',[min_lon,max_lon]);
hold on;
for i=1:length(files)
    tmpfn=[data_folder,'/',files(i).name];
    tmp1=load(tmpfn);
    tmp2=struct2cell(tmp1);
    
    for j=1:length(tmp2)/11
        tmpid=tmp2{j};
        eval(['tmpobs_lon=tmp1.float_obs_lon_',num2str(tmpid),';']);
        eval(['tmpobs_lat=tmp1.float_obs_lat_',num2str(tmpid),';']);
        if nanmin(tmpobs_lon)<min_lon || abs(tmpobs_lon(end)-tmpobs_lon(1))>1 ...
                || abs(tmpobs_lat(end)-tmpobs_lat(1))>1
            continue;
        else
            m_plot(tmpobs_lon,tmpobs_lat,'b-','linewidth',0.9);
            hold on;
            count=count+1;
            %display(num2str(count));
        end
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
hold on;
m_patch(map_lon,map_lat,[211/255,211/255,211/255]);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Region 1
% min_lon1=-98; max_lon1=-93.5;
min_lon1=-97.8; max_lon1=-94.1;
min_lat1=26.5; max_lat1=29.3;

% Region 2
% min_lon2=-90; max_lon2=-86.4;
% min_lat2=28.2; max_lat2=31.2;

% Region 3
min_lon3=-84.1; max_lon3=-82.2;
min_lat3=25.5; max_lat3=28.1;

hold on;
m_plot([min_lon1,max_lon1,max_lon1,min_lon1,min_lon1], ...
    [min_lat1,min_lat1,max_lat1,max_lat1,min_lat1],'r-','linewidth',1.5);

m_plot([min_lon3,max_lon3,max_lon3,min_lon3,min_lon3], ...
    [min_lat3,min_lat3,max_lat3,max_lat3,min_lat3],'r-','linewidth',1.5);

m_text(min_lon1+1.2,max_lat1+0.4,'HF1','fontsize',15,'color','r');
m_text(min_lon3+0.24,max_lat3+0.4,'HF2','fontsize',15,'color','r');
hold on;
m_grid('box','fancy','tickdir','out','xtick',4,'ytick',4,'ticklen',0.005, 'fontsize', 15);
set(gca,'FontSize',16)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
print(hhh,'-r300','-djpeg','obs_trajectories_figure1.jpg');



