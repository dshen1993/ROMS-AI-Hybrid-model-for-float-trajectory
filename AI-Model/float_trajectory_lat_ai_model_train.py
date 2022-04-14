# import keras under tensorflow backend (version 2)
from tensorflow.keras.models import Model, Sequential
from tensorflow.keras.models import load_model
from tensorflow.keras.layers import Input, Dense, Add
from tensorflow.keras.layers import Conv2D, Conv3D, Conv1D
from tensorflow.keras.layers import BatchNormalization, Dropout
from tensorflow.keras.layers import MaxPooling1D, UpSampling1D
from tensorflow.keras.layers import concatenate
from tensorflow.keras.optimizers import Adam, Adadelta, RMSprop
from tensorflow.keras.utils import plot_model

import tensorflow as tf
# gpus=tf.config.list_physical_devices('GPU')
# print(gpus)
# tf.config.set_visible_devices([], 'GPU')

import numpy as np
import scipy.io
import os
import sys
import random

import pylab as plt

from sklearn.metrics import mean_squared_error

from float_ai_model import AI_Model
#######################################################################
# input data
# data direction
data_folder='/Users/dongliangshen/Desktop/paper/github/use-public/AI-input-data'
# data period information
case_fn='/Users/dongliangshen/Desktop/paper/github/use-public/AI-Model/case_period.txt'
fid=open(case_fn)
case_line=fid.readline()
case_name=[]
case_start=[]
case_end=[]
while case_line:
    tmp=case_line.split()
    case_name.append(tmp[0])
    case_start.append(tmp[1])
    case_end.append(tmp[2])
    case_line=fid.readline()
fid.close
del(tmp)
del(case_line)
print(len(case_name))

# initial data
len_use=32
len_use=int(len_use)
obs_time=np.empty((0, len_use), float) 
obs_lon=np.empty((0, len_use), float) 
obs_lat=np.empty((0, len_use), float)
nm_lon=np.empty((0, len_use), float)
nm_lat=np.empty((0, len_use), float)

nm_uwind=np.empty((0, len_use), float)
nm_vwind=np.empty((0, len_use), float)
nm_ucurrent=np.empty((0, len_use), float)
nm_vcurrent=np.empty((0, len_use), float)

nm_depth=np.empty((0, len_use), float)
#####################################################################
data_info=np.empty((0,6),float)
tmp_info=np.empty((1,6),float)
#####################################################################
#####################################################################

count=0
count2=0
for i, j in zip(case_start, case_end):
    print('Reading data from:', i,' ',j)
    tmpfn=data_folder+'/'+'out_obs_model_'+i+'_'+j+'.mat'
    
    tmp=scipy.io.loadmat(tmpfn)
    float_num=(len(tmp.keys())-3)/11
    tmpkey=tmp.keys()
    print(float_num)
    for ii in np.arange(0, float_num, 1):
        # get float id
        tmpid=np.array(tmp[list(tmpkey)[int(ii)+3]])
        tmpobs_time=np.array(tmp['float_obs_time_'+str('%15.0f' % tmpid)])
        tmplen=np.size(tmpobs_time)
        tmpobs_time2=tmpobs_time-tmpobs_time[0,0]
        tmpindex05=np.where(tmpobs_time2>=0.5)
        if (len(tmpindex05[0])>0):
            print('where >0.5: ',tmpindex05[0][0], 'and', tmpobs_time2[tmpindex05[0][0]])
            ######################################
            tmp_info[0,0]=tmpid
            tmpid=str('%15.0f' % tmpid)
            print(tmpid)
            #######################################
            # record obs time
            tmpobs_time=np.transpose(tmpobs_time)
            #######################################
            # record obs lon
            tmpobs_lon=np.array(tmp['float_obs_lon_'+tmpid])
            tmpobs_lon=np.transpose(tmpobs_lon)
            tmp_info[0,2]=tmpobs_lon[0,0]
            tmpobs_lon=tmpobs_lon-tmpobs_lon[0,0]
            #######################################
            # record obs lat
            tmpobs_lat=np.array(tmp['float_obs_lat_'+tmpid])
            tmpobs_lat=np.transpose(tmpobs_lat)
            tmp_info[0,3]=tmpobs_lat[0,0]
            tmpobs_lat=tmpobs_lat-tmpobs_lat[0,0]

            tmpnm_depth=np.array(tmp['float_model_depth_'+tmpid])
            tmpnm_depth=np.transpose(tmpnm_depth)

            tmpnm_lon=np.array(tmp['float_model_lon_'+tmpid])
            tmpnm_lon=np.transpose(tmpnm_lon)

            tmpnm_lat=np.array(tmp['float_model_lat_'+tmpid])
            tmpnm_lat=np.transpose(tmpnm_lat)

            tmpnm_ucurrent=np.array(tmp['float_model_ucurrent_'+tmpid])
            tmpnm_ucurrent=np.transpose(tmpnm_ucurrent)

            tmpnm_vcurrent=np.array(tmp['float_model_vcurrent_'+tmpid])
            tmpnm_vcurrent=np.transpose(tmpnm_vcurrent)

            if (tmpobs_lon[0,0]!=tmpobs_lon[0,-1] and tmpobs_lat[0,0]!=tmpobs_lat[0,-1] and 
                np.abs(tmpobs_lon[0,0]-tmpobs_lon[0,-1])<1 and 
                np.abs(tmpobs_lon[0,0]-tmpobs_lon[0,-1])>0.005 and
                np.max(np.abs(tmpobs_lon[0,0]-tmpobs_lon[0,:]))<1 and 
                np.abs(tmpobs_lat[0,0]-tmpobs_lat[0,-1])<1 and 
                np.abs(tmpobs_lat[0,0]-tmpobs_lat[0,-1])>0.005 and
                np.max(np.abs(tmpobs_lat[0,0]-tmpobs_lat[0,:]))<1 and 
                np.isnan(np.max(tmpnm_depth[:,:]))==False and 
                np.abs(tmpnm_lon[0,0]-tmpnm_lon[0,-1])>0.005 and
                np.max(np.abs(tmpnm_lon[0,0]-tmpnm_lon[0,:]))<1 and 
                np.abs(tmpnm_lat[0,0]-tmpnm_lat[0,-1])>0.005 and
                np.max(np.abs(tmpnm_lat[0,0]-tmpnm_lat[0,:]))<1 and 
                np.nanmax(tmpnm_ucurrent[:,:])<=3 and
                np.nanmin(tmpnm_ucurrent[:,:])>=-3 and
                np.nanmax(tmpnm_vcurrent[:,:])<=3 and
                np.nanmin(tmpnm_vcurrent[:,:])>=-3):

                count=count+1
                tmp_info[0,1]=tmpobs_time[0,0]
                tmpobs_time=tmpobs_time-tmpobs_time[0,0]
                obs_time=np.append(obs_time, tmpobs_time, axis=0)
                ##########################################################
                obs_lon=np.append(obs_lon, tmpobs_lon, axis=0)
                ##########################################################
                obs_lat=np.append(obs_lat, tmpobs_lat, axis=0)
                ##########################################################
                # record model lon
                tmpnm_lon=np.array(tmp['float_model_lon_'+tmpid])
                tmpnm_lon=np.transpose(tmpnm_lon)
                tmp_info[0,4]=tmpnm_lon[0,0]
                tmpnm_lon=tmpnm_lon-tmpnm_lon[0,0]
                nm_lon=np.append(nm_lon, tmpnm_lon, axis=0)
                ##############################
                # record model lat
                tmpnm_lat=np.array(tmp['float_model_lat_'+tmpid])
                tmpnm_lat=np.transpose(tmpnm_lat)
                tmp_info[0,5]=tmpnm_lat[0,0]
                tmpnm_lat=tmpnm_lat-tmpnm_lat[0,0]
                nm_lat=np.append(nm_lat, tmpnm_lat, axis=0)

                data_info=np.append(data_info,tmp_info,axis=0)
                #############################
                # record model uwind
                tmpnm_uwind=np.array(tmp['float_model_uwind_'+tmpid])
                tmpnm_uwind=np.transpose(tmpnm_uwind)
                nm_uwind=np.append(nm_uwind, tmpnm_uwind, axis=0)
                ###############################
                # record model vwind
                tmpnm_vwind=np.array(tmp['float_model_vwind_'+tmpid])
                tmpnm_vwind=np.transpose(tmpnm_vwind)
                nm_vwind=np.append(nm_vwind, tmpnm_vwind, axis=0)
                ##############################
                # record model ucurrent
                tmpnm_ucurrent=np.array(tmp['float_model_ucurrent_'+tmpid])
                tmpnm_ucurrent=np.transpose(tmpnm_ucurrent)
                nm_ucurrent=np.append(nm_ucurrent, tmpnm_ucurrent, axis=0)
                ##############################
                # record model vcurrent
                tmpnm_vcurrent=np.array(tmp['float_model_vcurrent_'+tmpid])
                tmpnm_vcurrent=np.transpose(tmpnm_vcurrent)
                nm_vcurrent=np.append(nm_vcurrent, tmpnm_vcurrent, axis=0)
                ###############################
                # record model water depth
                tmpnm_depth=np.array(tmp['float_model_depth_'+tmpid])
                tmpnm_depth=np.transpose(tmpnm_depth)
                nm_depth=np.append(nm_depth, tmpnm_depth, axis=0)
scipy.io.savemat('data_start_info.mat',{'data_info':data_info})
#########################################################
train_index=np.sort(random.sample(range(0,4501),3601)) # 80% for training
total_index=np.arange(0,4501)
test_index=[iii for iii in total_index if iii not in train_index] # 20% for testing
print(train_index.shape)
#########################################################
scipy.io.savemat('training_data_use_new.mat',{'obs_time':obs_time,
    'obs_lon':obs_lon, 'obs_lat':obs_lat,
    'nm_lon':nm_lon, 'nm_lat':nm_lat,
    'nm_uwind':nm_uwind, 'nm_vwind':nm_vwind,
    'nm_ucurrent':nm_ucurrent, 'nm_vcurrent':nm_vcurrent,
    'train_index':train_index,'test_index':test_index,
    'nm_depth':nm_depth})
del(tmp_info)        
del(tmp); del(tmpfn); del(tmpkey); del(tmpid); del(tmpobs_time)
del(tmpobs_lon); del(tmpobs_lat); del(tmpnm_lat); del(tmpnm_lon)
del(tmpnm_uwind); del(tmpnm_vwind); del(tmpnm_ucurrent); del(tmpnm_vcurrent)
del(tmpnm_depth)
print(obs_lat.shape)
[rr, cc]=nm_lat.shape
print(count)      

print('nan depth max: ', np.max(nm_depth[:,:]))
print('ucurrent max: ', np.max(nm_ucurrent[:,:]))
print('ucurrent min: ', np.min(nm_ucurrent[:,:]))
print('vcurrent max: ', np.max(nm_vcurrent[:,:]))
print('vcurrent min: ', np.min(nm_vcurrent[:,:]))
print('uwind max: ', np.max(nm_uwind[:,:]))
print('uwind min: ', np.min(nm_uwind[:,:]))
print('vwind max: ', np.max(nm_vwind[:,:]))
print('vwind min: ', np.min(nm_vwind[:,:]))

tmpbias_total=np.sqrt((nm_lon-obs_lon)**2+(nm_lat-obs_lon)**2)*100
print(np.mean(tmpbias_total[:,:]))
######################################################
nm_lat_max=np.nanmax(nm_lat[:,:])
nm_lat_min=np.nanmin(nm_lat[:,:])
nm_lon_max=np.nanmax(nm_lon[:,:])
nm_lon_min=np.nanmin(nm_lon[:,:])
obs_time_max=np.nanmax(obs_time[:,:])
obs_time_min=np.nanmin(obs_time[:,:])

nm_uwind_max=50
nm_uwind_min=-50
nm_vwind_max=50
nm_vwind_min=-50
nm_ucurrent_max=3
nm_ucurrent_min=-3
nm_vcurrent_max=3
nm_vcurrent_min=-3

nm_depth_max=4000
nm_depth_min=0.1
#######################################################
train_input=np.empty((rr, cc, 8), float)

train_input[:,:,0]=nm_lat
train_input[:,:,1]=nm_lon
train_input[:,:,2]=obs_time
train_input[:,:,3]=(nm_uwind)/nm_uwind_max   # normalize
train_input[:,:,4]=(nm_vwind)/nm_vwind_max   # normalize
train_input[:,:,5]=(nm_ucurrent)/nm_ucurrent_max   # normalize
train_input[:,:,6]=(nm_vcurrent)/nm_vcurrent_max   # normalize
train_input[:,:,7]=(nm_depth)/(nm_depth_max)  # normalize
#########################################################
obs_lat_max=np.nanmax(obs_lat[:,:])
obs_lat_min=np.nanmin(obs_lat[:,:])
obs_lon_max=np.nanmax(obs_lon[:,:])
obs_lon_min=np.nanmin(obs_lon[:,:])

train_output=np.empty((rr, cc, 1), float)

train_output[:,:,0]=obs_lat

print(train_output.shape)
########################################################################
# todo: setting ai model
aimodel_path=''
if os.path.isfile(aimodel_path):    
    float_model=load_model(aimodel_path)
else:
    acti='tanh'; depth=5; inc=2
    do=0; bn=True; mp=True; up=True; res=False
    out_dim=1; start_dim=8
    float_model=AI_Model((len_use,8),out_dim,start_dim,depth,inc,acti,do,bn,mp,up,res)
########################################################################
# running ai model
aimodel_weight_path=''
if os.path.isfile(aimodel_weight_path):
    float_model.load_weights(aimodel_weight_path)
else:
    float_model.fit(train_input[train_index,:,:],train_output[train_index,:,:],
        batch_size=500, epochs=2500)  
    float_model.save('float_model_lat.h5')
    float_model.save_weights('float_model_weights_lat.h5')
############################################################################
# testing ai model
test_input=train_input[test_index,:,:]
test_truth=train_output[test_index,:,:]

test_output=float_model.predict(test_input[:,:,:])

test_input[:,:,3]=test_input[:,:,3]*(nm_uwind_max)
test_input[:,:,4]=test_input[:,:,4]*(nm_vwind_max)
test_input[:,:,5]=test_input[:,:,5]*(nm_ucurrent_max)
test_input[:,:,6]=test_input[:,:,6]*(nm_vcurrent_max)
test_input[:,:,7]=test_input[:,:,7]*(nm_depth_max)
############################################################################
print('ai-obs rmse')
testscore1=np.sqrt(mean_squared_error(test_output[:,:,0], test_truth[:,:,0]))
print('Test lat bias: %.4f rmse' % testscore1)

print('model-obs rmse')
testscore1=np.sqrt(mean_squared_error(test_input[:,:,0], test_truth[:,:,0]))
print('Test lat bias: %.4f rmse' % testscore1)
############################################################################
scipy.io.savemat('test_ai_results_lat_new.mat',{'test_input':test_input, 'test_truth':test_truth,
    'test_output':test_output})