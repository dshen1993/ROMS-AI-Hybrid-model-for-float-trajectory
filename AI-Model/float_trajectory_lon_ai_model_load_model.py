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
#######################################################################
len_use=32
len_use=int(len_use)
#####################################################################
# load input data after latitude training. Then to train longitude
count=0
tmp=scipy.io.loadmat('training_data_use_new.mat')
obs_time=np.array(tmp['obs_time'])
obs_lon=np.array(tmp['obs_lon'])
obs_lat=np.array(tmp['obs_lat'])
nm_lon=np.array(tmp['nm_lon'])
nm_lat=np.array(tmp['nm_lat'])
nm_uwind=np.array(tmp['nm_uwind'])
nm_vwind=np.array(tmp['nm_vwind'])
nm_ucurrent=np.array(tmp['nm_ucurrent'])
nm_vcurrent=np.array(tmp['nm_vcurrent'])  
train_index=np.array(tmp['train_index'])
test_index=np.array(tmp['test_index'])
nm_depth=np.array(tmp['nm_depth'])

train_index=np.transpose(train_index)
test_index=np.transpose(test_index)
del(tmp)
print(obs_lat.shape)
train_index=train_index[:,0]
test_index=test_index[:,0]
print(train_index.shape)
[rr, cc]=nm_lat.shape

print('nan depth: ', np.max(nm_depth[:,:]))

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

train_input[:,:,0]=nm_lon
train_input[:,:,1]=nm_lat 
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

train_output = np.empty((rr, cc, 1), float )

train_output[:,:,0] = obs_lon

train_output_max = np.nanmax(train_output[:,:,:])
train_output_min = np.nanmin(train_output[:,:,:])

print(train_output.shape)
########################################################################
# setting ai model
aimodel_path='/Users/dongliangshen/Desktop/paper/github/use-public/AI-Model/float_model_lon.h5'
if os.path.isfile(aimodel_path):    
    float_model=load_model(aimodel_path)
else:
    acti='tanh'; depth=5; inc=2
    do=0; bn=True; mp=True; up=True; res=False
    out_dim=1; start_dim=8
    float_model=AI_Model((len_use,8),out_dim,start_dim,depth,inc,acti,do,bn,mp,up,res)
########################################################################
# running ai model
aimodel_weight_path='/Users/dongliangshen/Desktop/paper/github/use-public/AI-Model/float_model_weights_lon.h5'
if os.path.isfile(aimodel_weight_path):
    float_model.load_weights(aimodel_weight_path)
else:
    float_model.fit(train_input[train_index,:,:],train_output[train_index,:,:],
        batch_size=500, epochs=2500)
    float_model.save('float_model_lon.h5')
    float_model.save_weights('float_model_weights_lon.h5')
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
print('Test lon bias: %.4f rmse' % testscore1)


print('model-obs rmse')
testscore1=np.sqrt(mean_squared_error(test_input[:,:,0], test_truth[:,:,0]))
print('Test lon bias: %.4f rmse' % testscore1)
############################################################################
scipy.io.savemat('test_ai_results_lon_new.mat',{'test_input':test_input, 'test_truth':test_truth,
    'test_output':test_output})

