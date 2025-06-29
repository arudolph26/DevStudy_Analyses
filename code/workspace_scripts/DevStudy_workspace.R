library(tidyverse)
library(gridExtra)
library(GGally)
library(lme4)
library(zoo)
library(DT)

#sro_helper_functions = '/Users/ally/Dropbox/PoldrackLab/SRO_Retest_Analyses/code/helper_functions'
#source(paste0(sro_helper_functions, '/sem.R'))
#manually copied sem function from github

helper_functions = '/Users/ally/Desktop/Lab/DevStudy_Analyses/code/helper_functions'

source(paste0(helper_functions, '/ggplot_colors.R'))

fig_path = '/Users/ally/Desktop/Lab/DevStudy_Analyses/output/figures/'

workspace_scripts = '/Users/ally/Desktop/Lab/DevStudy_Analyses/code/workspace_scripts/'

source(paste0(workspace_scripts, 'machine_game_data.R'))

source(paste0(workspace_scripts, 'bart_data.R'))

source(paste0(workspace_scripts, 'questionnaire_data.R'))