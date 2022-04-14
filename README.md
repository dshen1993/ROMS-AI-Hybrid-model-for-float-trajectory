# ROMS-AI-Hybrid-model-for-float-trajectory

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

# Post processing
###################################################################
# For Figure 1
Using "plot_obs_figure1.m"
This script will call M_Map mapping package. You can download M_Map from https://www.eoas.ubc.ca/~rich/map.html
A global coastline data will be used and called as "global_coast.mat"

You need to set "data_folder" based on your directory. The input data are from AI input data under "AI-input-data".
###################################################################
# For Figure 4
Using "test_u_figure4a.m" and "test_v_figure4a.m"

You need to set "data_folder" based on your directory. The input data are under "/Post-processing/data_rmse_hf_roms".
###################################################################
# For Figure 5
Using "test_ai_results_pdf_12_figure5a.m" and "test_ai_results_pdf_24_figure5b.m"

You need to set "data_folder" based on your directory. The input data are under "AI-Model-results".

The total mean separation error of AI and ROMS models will be printed on the screen after you run these scripts.
###################################################################
# For Figure 6
Using "test_time_series_overall_figure6.m"

You need to set "data_folder" based on your directory. The input data are under "AI-Model-results".
###################################################################
# For Figure 7
Using "test_ai_results_pdf_12_figure7a.m" and "test_ai_results_pdf_24_figure7b.m"

You need to set "data_folder" based on your directory. The input data are under "AI-Model-results".

The AI and ROMS models' performances are based on the following variables:
"bias_model_good, bias_model_bad, bias_ai_good, and bias_ai_bad"
###################################################################
# For Figure 8
Using "test_ai_results_figure8.m"
This script will call M_Map mapping package as Figure 1.

You need to set "data_folder" and "out_dir" based on your directory. The input data are under "AI-Model-results".
###################################################################
# For calculating the Skill Score of AI and ROMS models
Using "test_ai_results_skill_score.m "

You need to set "data_folder" based on your directory. The input data are under "AI-Model-results".

After runing "test_ai_results_skill_score.m", you will get "
                                                        mean AI-Skill-Score: 0.65431
                                                        mean ROMS-Skill-Score: 0.34815"
###################################################################
# For calculating relative RMS error (REE)
Using "test_hf_roms_ree.m"

You need to set "data_folder" based on your directory. The input data are under "/Post-processing/data_rmse_hf_roms"

The results will be printed on the screen after you run this script.
###################################################################
# The performances under hurricanes
You can use "test_ai_results_pdf_hurricanes.m" to get the performances under hurricanes.
###################################################################
# Figures 2 and 3 are drawn by Mircosoft PowerPoint.
