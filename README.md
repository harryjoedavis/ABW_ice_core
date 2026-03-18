# ABW ice core

[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.19096564.svg)](https://doi.org/10.5281/zenodo.19096564)

This repository is associated with the manuscript ‘Assessing the potential for an ice core in the southern Antarctic
Peninsula to elucidate Holocene climate history’, submitted to The Cryosphere.

![Fig01 from manuscritpt.](https://github.com/harryjoedavis/ABW_ice_core/blob/main/README_FIG.jpg)



## ABW_ice_core/1D_ice_flow_model 

This directory contains all the scripts needed to run the forward and inverse models. To run the model open one of the scripts titled 'Main*.m' and modify input paramaters appropirately. The remaining .m files in the directory are functions that 'Main*.m' will look to call. 

- MainAgeV2_HJD.m = forward models 
- MainAgeV4_1_HJD.m = Scenarios 1-3 (transient accumulation)
- MainAgeV5.m = Scenario 4 (transient thinning)
- MainMapView1D_HJD.m = MapView simulation (fig07 in manuscript)

## ABW_ice_core/1D_steady_state_temp_model 

This directory contains all the scripts needed to run the temperature model. Again as above, MainTemperature.m is the script needed to run the model.

## ABW_ice_core/data

This directory contains all the output data files from the model. 
- MainAgeV2*.mat = forward models 
- MainAgeV4_1_output_5001.mat = Scenario 1 
- MainAgeV4_1_output_*_mmyr_5001.mat = Snenario 2 and 3
- MainAgeV5_output_5001.mat = Scenario 4
- SS_temperature*.mat = Temperature model output 
- l_curve_data_5001.mat = outputs from l-curve analyses

## ABW_ice_core/figures

This directory contains all the figures from the final manuscript.

## ABW_ice_core/plotting_code

This directory contains the code use to plot the figures in the manuscript using the output data files. 