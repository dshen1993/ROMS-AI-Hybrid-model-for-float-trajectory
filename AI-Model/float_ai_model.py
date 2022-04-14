# import keras under tensorflow backend (version 2)
from tensorflow.keras.utils import plot_model
from tensorflow.keras.models import Model
from tensorflow.keras.layers import Input, Dense, GRU, LSTM
from tensorflow.keras.layers import Conv2D, MaxPooling2D, Flatten
from tensorflow.keras.layers import Conv2DTranspose
from tensorflow.keras.layers import UpSampling2D, Dropout, BatchNormalization
from tensorflow.keras.layers import Concatenate
from tensorflow.keras.layers import Conv3D, Conv3DTranspose, MaxPooling3D
from tensorflow.keras.layers import UpSampling3D
###################################################################
from tensorflow.keras.layers import Conv1D, MaxPooling1D, UpSampling1D
###################################################################
from tensorflow.keras.optimizers import Adam, RMSprop, Ftrl, Nadam

import tensorflow as tf

import os
####################################################################
# acti=activation, do=dropout, res=residual, mp=maxpool, up=upconv, bn=batchnorm
def conv_block(m, dim, acti, bn, res, do): 
	n=Conv1D(dim, 3, activation=acti, padding='same')(m)
	n=BatchNormalization()(n) if bn else n
	n=Dropout(do)(n) if do else n
	n=Conv1D(dim, 3, activation=acti, padding='same')(n)
	n=BatchNormalization()(n) if bn else n
	return Concatenate()([m, n]) if res else n

def level_block(m, dim, depth, inc, acti, do, bn, mp, up, res):
	if depth>0:
		n=conv_block(m, dim, acti, bn, res, do)
		m=MaxPooling1D()(n) if mp else Conv1D(dim, 3, strides=2, padding='same')(n)
		m=level_block(m, int(inc*dim), depth-1, inc, acti, do, bn, mp, up, res)
		if up:
			m=UpSampling1D()(m)
			m=Conv1D(dim, 2, activation=acti, padding='same')(m)
	
		n=Concatenate()([n, m])
		
		m=conv_block(n, dim, acti, bn, res, do)
	else:
		m=conv_block(m, dim, acti, bn, res, do)

	return m

def AI_Model(input_shape, out_ch, start_ch, depth, inc_rate, activation, dropout, batchnorm, maxpool, upconv, residual):
	i=Input(shape=input_shape)
	# UNet Part
	o1=level_block(i, start_ch, depth, inc_rate, activation, dropout, batchnorm, maxpool, upconv, residual)
	# GRU part
	o2=GRU(units=16, activation='tanh', return_sequences=True)(i)
	o2=GRU(units=32, activation='tanh', return_sequences=True)(o2)
	o2=GRU(units=64, activation='tanh', return_sequences=True)(o2)
	o2=GRU(units=32, activation='tanh', return_sequences=True)(o2)
	o2=GRU(units=16, activation='tanh', return_sequences=True)(o2)
	# concatenate UNet and GRU
	o=Concatenate()([o1,o2])
	##################################
	o=Dense(64, activation='tanh')(o)
	o=Dense(32, activation='tanh')(o)
	o=Dense(out_ch, activation='linear')(o) # last layer
	
	float_model=Model(inputs=i, outputs=o)
	
	print(float_model.summary())

	#plot_model(model_unet, to_file='ai_model_test.png', show_shapes='True')
	
	optimizer=RMSprop(learning_rate=0.0008)

	float_model.compile(optimizer=optimizer, loss='mse', metrics=['mse'])

	return float_model
