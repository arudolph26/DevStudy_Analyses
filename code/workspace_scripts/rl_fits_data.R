input_dir = '/Users/zeynepenkavi/Dropbox/PoldrackLab/DevStudy_Analyses/input/rl_fits/'

process_fits = function(data){
  require(tidyverse)
  data = data %>% select(-contains("Unnamed"), -X)
  return(data)
}

source('/Users/zeynepenkavi/Dropbox/PoldrackLab/DevStudy_Analyses/code/helper_functions/rbind_all_columns.R')

fits = list.files(path=input_dir, pattern = "All")
old_fits = c('LearningParams_Fit_alpha_neg-alpha_pos-beta-exp_Fix_All.csv',
             'LearningParams_Fit_alpha_neg-alpha_pos-beta-exp_neg-exp_pos_Fix_All.csv',
             'LearningParams_Fit_alpha-beta-exp_Fix_All.csv',
             'LearningParams_Fit_alpha-beta-exp_neg-exp_pos_Fix_All.csv',
             'LearningParams_Fit_alpha-beta_Fix_exp_All.csv',
             'LearningParams_Fit_alpha_neg-alpha_pos-beta_Fix_exp_All.csv')
fits=fits[fits %in% old_fits == FALSE]

num_pars_df = data.frame(model = c('LearningParams_Fit_alpha_neg-alpha_pos-beta_Fix_exp-lossave_','LearningParams_Fit_alpha_neg-alpha_pos-beta-exp_Fix_lossave_','LearningParams_Fit_alpha_neg-alpha_pos-beta-exp_neg-exp_pos_Fix_lossave_','LearningParams_Fit_alpha_neg-alpha_pos-beta-exp_neg-exp_pos-lossave_Fix_','LearningParams_Fit_alpha_neg-alpha_pos-beta-exp-lossave_Fix_','LearningParams_Fit_alpha_neg-alpha_pos-beta-lossave_Fix_exp_','LearningParams_Fit_alpha-beta_Fix_exp-lossave_','LearningParams_Fit_alpha-beta-exp_Fix_lossave_','LearningParams_Fit_alpha-beta-exp_neg-exp_pos_Fix_lossave_','LearningParams_Fit_alpha-beta-exp_neg-exp_pos-lossave_Fix_','LearningParams_Fit_alpha-beta-exp-lossave_Fix_','LearningParams_Fit_alpha-beta-lossave_Fix_exp_'), pars = c(3,4,5,6,5,4,2,3,4,5,4,3),x_axis = c("\u03b1_gain, \u03b1_loss, \u03b2", "\u03b1_gain, \u03b1_loss, \u03b2, \u03b3", "\u03b1_gain, \u03b1_loss, \u03b2, \u03b3_gain, \u03b3_loss", "\u03b1_gain, \u03b1_loss, \u03b2, \u03b3_gain, \u03b3_loss, \u03bb", "\u03b1_gain, \u03b1_loss, \u03b2, \u03b3, \u03bb", "\u03b1_gain, \u03b1_loss, \u03b2, \u03bb", "\u03b1, \u03b2", "\u03b1, \u03b2, \u03b3", "\u03b1, \u03b2, \u03b3_gain, \u03b3_loss", "\u03b1, \u03b2, \u03b3_gain, \u03b3_loss, \u03bb", "\u03b1, \u03b2, \u03b3, \u03bb", "\u03b1, \u03b2, \u03bb"))

num_pars_df = num_pars_df %>%
  mutate(model = as.character(model),
         x_axis = as.character(x_axis))

all_sub_pars = data.frame()
best_sub_pars = data.frame()

for(f in fits){
  data = read.csv(paste0(input_dir, f))
  data = process_fits(data)
  data = data %>% 
    mutate(model = as.character(model)) %>%
    left_join(num_pars_df, by='model') %>%
    mutate(AIC = 2*neglogprob+2*pars,
           BIC = 2*neglogprob+pars*log(180))
  all_sub_pars = rbind.all.columns(all_sub_pars,data.frame(data))
  data = data %>%
    group_by(sub_id) %>%
    slice(which.min(neglogprob))
  best_sub_pars = rbind.all.columns(best_sub_pars,data.frame(data))
}

learner_info = read.csv("~/Dropbox/PoldrackLab/DevStudy_ServerScripts/nistats/level_3/learner_info.csv")
learner_info = learner_info %>%
  select(-non_learner) %>%
  rename(sub_id = Sub_id) %>%
  mutate(sub_id = as.numeric(as.character(gsub("sub-", "", sub_id))))

all_sub_pars = all_sub_pars %>%
  mutate(age_group = ifelse(sub_id<200000, "kid", ifelse(sub_id>200000 & sub_id<400000, "teen", "adult")),
         age_group = factor(age_group, levels = c("kid","teen","adult")),
         model = gsub("LearningParams_", "", model)) %>%
  left_join(learner_info, by="sub_id") %>%
  drop_na(learner_info)

best_sub_pars = best_sub_pars %>%
  mutate(age_group = ifelse(sub_id<200000, "kid", ifelse(sub_id>200000 & sub_id<400000, "teen", "adult")),
         age_group = factor(age_group, levels = c("kid","teen","adult")),
         model = gsub("LearningParams_", "", model)) %>%
  left_join(learner_info, by="sub_id") %>%
  drop_na(learner_info)


