clear;clc;close all;
% load coastline datat
load('global_coast.mat');

data_folder='/Users/dongliangshen/Desktop/paper/github/use-public/AI-Model-results';
count=0;
count_no=0;

R=6371.004;

bias_model_good=[];
bias_model_bad=[];
bias_ai_good=[];
bias_ai_bad=[];

out_dir=['/Users/dongliangshen/Desktop/paper/github/use-public/Post-processing','/','figure8'];
mkdir(out_dir);
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
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
model_lon_good=[]; model_lat_good=[];
model_lon_bad=[]; model_lat_bad=[];

obs_lon_good=[]; obs_lat_good=[];
obs_lon_bad=[]; obs_lat_bad=[];

ai_lon_good=[]; ai_lat_good=[];
ai_lon_bad=[]; ai_lat_bad=[];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for i=[230, 320, 513, 713]     %1:900 
    index=i; %39 49

    load([data_folder,'/','test_ai_results_lat_new.mat']);
    model_lat=double(test_input(index,:,1))+nm_lat_zero(index);
    model_time=test_input(index,:,3)+time_zero(index);
    obs_lat=double(test_truth(index,:,1))+obs_lat_zero(index);
    ai_lat=double(test_output(index,:,1))+nm_lat_zero(index);

    load([data_folder,'/','test_ai_results_lon_new.mat']);
    model_lon=double(test_input(index,:,1))+nm_lon_zero(index);
    obs_lon=double(test_truth(index,:,1))+obs_lon_zero(index);
    ai_lon=double(test_output(index,:,1))+nm_lon_zero(index);
    %%
    if (obs_lon(1)~=obs_lon(end))
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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

            model_lon_good=[model_lon_good; model_lon];
            model_lat_good=[model_lat_good; model_lat];

            obs_lon_good=[obs_lon_good; obs_lon];
            obs_lat_good=[obs_lat_good; obs_lat];

            ai_lon_good=[ai_lon_good; ai_lon];
            ai_lat_good=[ai_lat_good; ai_lat];
        elseif tmpbias_ai>tmpbias_model
            bias_model_bad=[bias_model_bad,tmpbias_model];
            bias_ai_bad=[bias_ai_bad,tmpbias_ai];
            count_no=count_no+1;

            model_lon_bad=[model_lon_bad; model_lon];
            model_lat_bad=[model_lat_bad; model_lat];

            obs_lon_bad=[obs_lon_bad; obs_lon];
            obs_lat_bad=[obs_lat_bad; obs_lat];

            ai_lon_bad=[ai_lon_bad; ai_lon];
            ai_lat_bad=[ai_lat_bad; ai_lat];
        end
        %% plot images
        plot_image=1;
        if plot_image==1

            plon_center=(nanmin([ai_lon,model_lon,obs_lon])+ ...
                nanmax([ai_lon,model_lon,obs_lon]))./2;
            plat_center=(nanmin([ai_lat,model_lat,obs_lat])+ ...
                nanmax([ai_lat,model_lat,obs_lat]))./2;

            plon_min=plon_center-0.30;
            plon_max=plon_center+0.30;
            %plat_min=plat_center-0.32;
            %plat_max=plat_center+0.32;
            plat_min=plat_center-0.30;
            plat_max=plat_center+0.30;

            hhh=figure('visible','off');
            subplot(1,2,1);
            m_proj('mercator','lon',[plon_min,plon_max], ...
                'lat',[plat_min,plat_max]);
            h1=m_plot(obs_lon,obs_lat,'k-','linewidth',1.5);
            hold on;
            h2=m_plot(model_lon,model_lat,'b-','linewidth',1.5);
            %lg1=legend([h1,h2],{'Obs','ROMS'});
            %set(lg1,'location','southeast','box','off');

            m_plot(obs_lon(1),obs_lat(1),'ks','linewidth',1.5);
            m_plot(model_lon(1),model_lat(1),'bs','linewidth',1.5);

            m_plot(obs_lon(end),obs_lat(end),'ko','linewidth',1.5);
            m_plot(model_lon(end),model_lat(end),'bo','linewidth',1.5);

            m_plot([obs_lon(end),model_lon(end)],[obs_lat(end),model_lat(end)],'c--','linewidth',1.2);
            %set(gca,'xlim',[nanmin([tmplon_ai,tmplon_roms,tmplon_obs]),nanmax([tmplon_ai,tmplon_roms,tmplon_obs])]);
            %set(gca,'ylim',[nanmin([tmplat_ai,tmplat_roms,tmplat_obs]),nanmax([tmplat_ai,tmplat_roms,tmplat_obs])]);
            title({['Error (24 h, o-o): ',num2str(tmpbias_model,'%.2f'),' km']});
            %legend([h1(1),h2(1)],'Obs','ROMS','location','southeast');
            %set(lg1,'location','southeast','box','off');
            m_grid('box','fancy','xtick',4,'ytick',4,'tickdir','in','ticklen',0.005,'fontsize',13);
            m_patch(map_lon,map_lat,[211/255,211/255,211/255]);
            lg1=legend([h1,h2],{'Obs','ROMS'});
            %set(lg1,'location','southeast','box','off');
            set(lg1,'location','northwest','box','off');
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            subplot(1,2,2);
            m_proj('mercator','lon',[plon_min,plon_max], ...
                'lat',[plat_min,plat_max]);
            h1=m_plot(obs_lon,obs_lat,'k-','linewidth',1.5);
            hold on;
            h2=m_plot(ai_lon,ai_lat,'r-','linewidth',1.5);
            %lg1=legend([h1,h2],{'Obs','AI'});
            %set(lg1,'location','southeast','box','off');

            m_plot(obs_lon(1),obs_lat(1),'ks','linewidth',1.5);
            m_plot(ai_lon(1),ai_lat(1),'rs','linewidth',1.5);

            m_plot(obs_lon(end),obs_lat(end),'ko','linewidth',1.5);
            m_plot(ai_lon(end),ai_lat(end),'ro','linewidth',1.5);

            m_plot([obs_lon(end),ai_lon(end)],[obs_lat(end),ai_lat(end)],'c--','linewidth',1.2);
            %set(gca,'xlim',[nanmin([tmplon_ai,tmplon_roms,tmplon_obs]),nanmax([tmplon_ai,tmplon_roms,tmplon_obs])]);
            %set(gca,'ylim',[nanmin([tmplat_ai,tmplat_roms,tmplat_obs]),nanmax([tmplat_ai,tmplat_roms,tmplat_obs])]);
            title({['Error (24 h, o-o): ',num2str(tmpbias_ai,'%.2f'),' km']});
            %legend([h1(1),h2(1)],'Obs','AI','location','southeast');
            %set(lg1,'location','southeast','box','off');
            m_grid('box','fancy','xtick',4,'ytick',4,'tickdir','in','ticklen',0.005,'fontsize',13);
            m_patch(map_lon,map_lat,[211/255,211/255,211/255]);
            lg1=legend([h1,h2],{'Obs','AI'});
            %set(lg1,'location','southeast','box','off');
            set(lg1,'location','northwest','box','off');

            starttime=datestr(model_time(1),'yyyymmdd_HHMMSS');
            display(starttime);
            print(hhh,'-r600','-djpeg',[out_dir,'/','bias_',num2str(i),'_',starttime,'.jpg']);
            close;
        end

    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%