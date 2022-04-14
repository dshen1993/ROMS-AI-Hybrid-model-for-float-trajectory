#####################################################################
# Latitude and longitude will be trained separately.

# Train latitude AI model first. 
Using "float_trajectory_lat_ai_model_train.py"

You need to set "data_folder" and "case_fn" based on your directory. 
(The cases periods are in "case_period.txt")
The input data for training are under "AI-input-data".
(including lat, lon, time, wind in x component, wind in y component, 
current in x component, current in y component, and water depth.)

After you train latitude AI model, you will get AI model parameters and saved as 
"float_model_lat.h5" and "float_model_weights_lat.h5".

Then, the test results (will be used for analysis) of latitudes will be calculated and saved as 
"test_ai_results_lat_new.mat". You can find the AI test results in "AI-Model-results".
####################################################################
After you run latitude AI model. you will also get "data_start_info.mat" and "training_data_use_new.mat", 
which include the float information and input data for training.

We use "training_data_use_new.mat" to train longitude AI model, which means you must run latitude AI model first.

# Train longitude AI model secondly.
Using "float_trajectory_lon_ai_model_train.py"

After you train longitude AI model, you will get AI model parameters and saved as 
"float_model_lon.h5" and "float_model_weights_lon.h5".

The test results of longitude will be calculated and saved as "test_ai_results_lon_new.mat" after you run this python script.
######################################################################
If you want to load AI model without training to get the test results, 
you can use the following python scripts: "float_trajectory_lat_ai_model_load_model.py" and "float_trajectory_lon_ai_model_load_model.py"

You need to set "aimodel_path" and "aimodel_weight_path" based on your directory.
#######################################################################