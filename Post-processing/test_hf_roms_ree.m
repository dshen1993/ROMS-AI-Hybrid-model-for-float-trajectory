clear; clc; close all;
% setting data path of hf radar current vs. roms current
data_folder='/Users/dongliangshen/Desktop/paper/github/use-public/Post-processing/data_rmse_hf_roms';

data0915=load([data_folder,'/','rmse_09_15.mat']); % Sally
data1009=load([data_folder,'/','rmse_10_09.mat']); % Delta
data1028=load([data_folder,'/','rmse_10_28.mat']); % Zeta
data1111=load([data_folder,'/','rmse_11_11.mat']); % Eta
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
rmse_u(:,1)=rmse_u_0915';
rmse_u(:,2)=rmse_u_1009';
rmse_u(:,3)=rmse_u_1028';
rmse_u(:,4)=rmse_u_1111';

rmse_v(:,1)=rmse_v_0915';
rmse_v(:,2)=rmse_v_1009';
rmse_v(:,3)=rmse_v_1028';
rmse_v(:,4)=rmse_v_1111';

max_u(:,1)=max_u_0915';
max_u(:,2)=max_u_1009';
max_u(:,3)=max_u_1028';
max_u(:,4)=max_u_1111';

min_u(:,1)=min_u_0915';
min_u(:,2)=min_u_1009';
min_u(:,3)=min_u_1028';
min_u(:,4)=min_u_1111';

max_v(:,1)=max_v_0915';
max_v(:,2)=max_v_1009';
max_v(:,3)=max_v_1028';
max_v(:,4)=max_v_1111';

min_v(:,1)=min_v_0915';
min_v(:,2)=min_v_1009';
min_v(:,3)=min_v_1028';
min_v(:,4)=min_v_1111';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[rr,cc]=size(rmse_u);

for i=1:rr
    for j=1:cc
        ree_u(i,j)=rmse_u(i,j)/(max_u(i,j)-min_u(i,j));
        ree_v(i,j)=rmse_v(i,j)/(max_v(i,j)-min_v(i,j));
    end
end
        
display(['mean REE of Sally: ', num2str((mean(ree_u(:,1))+mean(ree_v(:,1)))/2)]);
display(['mean REE of Delta: ', num2str((mean(ree_u(:,2))+mean(ree_v(:,2)))/2)]);
display(['mean REE of Zeta: ', num2str((mean(ree_u(:,3))+mean(ree_v(:,3)))/2)]);
display(['mean REE of Eta: ', num2str((mean(ree_u(:,4))+mean(ree_v(:,4)))/2)]);
