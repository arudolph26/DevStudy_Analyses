library(tidyverse)
library(gridExtra)
library(GGally)
library(lme4)
library(zoo)
library(DT)
sem<-function(x)sd(x, na.rm=T)/sqrt(length(x[!is.na(x)]))
cbbPalette <- c("#E69F00", "#56B4E9", "#009E73", "#F0E442", "#0072B2", "#D55E00", "#CC79A7")
theme_set(theme_bw())
ggplot <- function(...) ggplot2::ggplot(...) + scale_fill_manual(values=cbbPalette) + scale_color_manual(values=cbbPalette)+theme(legend.position="bottom", panel.grid = element_blank())

fig_path = '/Users/zeynepenkavi/Dropbox/PoldrackLab/DevStudy_Analyses/output/figures/'

workspace_scripts = '/Users/zeynepenkavi/Dropbox/PoldrackLab/DevStudy_Analyses/code/workspace_scripts/'

source(paste0(workspace_scripts, 'machine_game_data.R'))

source(paste0(workspace_scripts, 'bart_data.R'))

source(paste0(workspace_scripts, 'questionnaire_data.R'))

source(paste0(workspace_scripts, 'rl_fits_data.R'))