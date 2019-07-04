input_dir = '/Users/zeynepenkavi/Dropbox/PoldrackLab/DevStudy_Analyses/input/rl_preds/'

source('/Users/zeynepenkavi/Dropbox/PoldrackLab/DevStudy_Analyses/code/helper_functions/rbind_all_columns.R')

preds = list.files(path=input_dir, pattern = "All")

all_sub_preds = data.frame()
ave_sub_preds = data.frame()

for(f in preds){
  data = read.csv(paste0(input_dir, f))
  cur_m = unique(data$model)
  data = data %>% 
    select(-contains("Unnamed"), -X) %>%
    mutate(model = as.character(model))
  all_sub_preds = rbind.all.columns(all_sub_preds,data.frame(data))
  data = data %>%
    mutate(pred_choice_1_0 = ifelse(choiceprob>0.5,1,0),
           act_choice_1_0 = ifelse(Response == 1, 1, ifelse(Response == 2, 0, NA)),
           pred_correct = ifelse(pred_choice_1_0 == act_choice_1_0, 1, 0)) %>%
    group_by(sub_id) %>%
    summarise(cor_pred_prop = mean(pred_correct, na.rm=T)) %>%
    mutate(model=cur_m)
  ave_sub_preds = rbind.all.columns(ave_sub_preds,data.frame(data))
}

learner_info = read.csv("~/Dropbox/PoldrackLab/DevStudy_ServerScripts/nistats/level_3/learner_info.csv")
learner_info = learner_info %>%
  select(-non_learner) %>%
  rename(sub_id = Sub_id) %>%
  mutate(sub_id = as.numeric(as.character(gsub("sub-", "", sub_id))))

all_sub_preds = all_sub_preds %>%
  mutate(age_group = ifelse(sub_id<200000, "kid", ifelse(sub_id>200000 & sub_id<400000, "teen", "adult")),
         age_group = factor(age_group, levels = c("kid","teen","adult")),
         model = gsub("Pred_", "", model)) %>%
  left_join(learner_info, by="sub_id") %>%
  drop_na(learner)

ave_sub_preds = ave_sub_preds %>%
  mutate(age_group = ifelse(sub_id<200000, "kid", ifelse(sub_id>200000 & sub_id<400000, "teen", "adult")),
         age_group = factor(age_group, levels = c("kid","teen","adult")),
         model = gsub("Preds_", "", model)) %>%
  left_join(learner_info, by="sub_id") %>%
  drop_na(learner)

rm(data, cur_m, f, preds)

