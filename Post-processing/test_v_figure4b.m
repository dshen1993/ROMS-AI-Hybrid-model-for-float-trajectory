clear;clc;close all;
% setting data path of hf radar current vs. roms current 
data_folder='/Users/dongliangshen/Desktop/paper/github/use-public/Post-processing/data_rmse_hf_roms';

data0915=load([data_folder,'/','rmse_09_15.mat']); % Sally
data1009=load([data_folder,'/','rmse_10_09.mat']); % Delta
data1028=load([data_folder,'/','rmse_10_28.mat']); % Zeta
data1111=load([data_folder,'/','rmse_11_11.mat']); % Eta
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
rmse_u_0915=data0915.rmse_u;
rmse_v_0915=data0915.rmse_v;
max_u_0915=data0915.max_obs_u;
min_u_0915=data0915.min_obs_u;
max_v_0915=data0915.max_obs_v;
min_v_0915=data0915.min_obs_v;


rmse_u_1009=data1009.rmse_u;
rmse_v_1009=data1009.rmse_v;
max_u_1009=data1009.max_obs_u;
min_u_1009=data1009.min_obs_u;
max_v_1009=data1009.max_obs_v;
min_v_1009=data1009.min_obs_v;

rmse_u_1028=data1028.rmse_u;
rmse_v_1028=data1028.rmse_v;
max_u_1028=data1028.max_obs_u;
min_u_1028=data1028.min_obs_u;
max_v_1028=data1028.max_obs_v;
min_v_1028=data1028.min_obs_v;

rmse_u_1111=data1111.rmse_u;
rmse_v_1111=data1111.rmse_v;
max_u_1111=data1111.max_obs_u;
min_u_1111=data1111.min_obs_u;
max_v_1111=data1111.max_obs_v;
min_v_1111=data1111.min_obs_v;
clear data0915 data1009 data1028 data1111;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

rmse_u(:,1)=rmse_u_0915';
rmse_u(:,2)=rmse_u_1009';
rmse_u(:,3)=rmse_u_1028';
rmse_u(:,4)=rmse_u_1111';

rmse_v(:,1)=rmse_v_0915';
rmse_v(:,2)=rmse_v_1009';
rmse_v(:,3)=rmse_v_1028';
rmse_v(:,4)=rmse_v_1111';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
hhh=figure('visible','off');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
yyaxis left;
boxplot(rmse_v,'whisker',1.5,'boxstyle','outline','widths',0.2, ...
    'labels',{'Sally','Delta','Zeta','Eta'});
ax=gca;
ax.YAxis(1).Color='k';
h=findobj(gca,'Tag','Box');
for i=1:length(h)
    patch(get(h(i),'XData'),get(h(i),'YData'),[135,206,235]./255,'FaceAlpha',0.3);
end
set(findobj(gca,'type','line'),'linewidth',1.5);
set(findobj(gca,'Tag','Box'),'color','k');
set(gca,'ylim',[0.0,0.36]);
ylabel('RMSE (m/s)');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
yyaxis right;
max_v=[nanmean(max_v_0915(:)),nanmean(max_v_1009(:)), ...
    nanmean(max_v_1028(:)),nanmean(max_v_1111(:))];
min_v=[nanmean(min_v_0915(:)),nanmean(min_v_1009(:)), ...
    nanmean(min_v_1028(:)),nanmean(min_v_1111(:))];
plot(max_v,'*-','linewidth',1.5);
hold on;
plot(min_v,'*-','linewidth',1.5);
set(gca,'ylim',[-1.2,1.2]);
ylabel('V (m/s)');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
set(gca,'fontsize',15);
set(gca,'position',[0.15,0.25,0.7,0.65]);
set(gcf,'paperposition',[0,0,8,3]);
print(hhh,'-r600','-djpeg',['rmse_v_figure4b.jpg']);
% close;
