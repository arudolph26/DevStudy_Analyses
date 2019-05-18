library(psych)

input_path = '/Users/zeynepenkavi/Dropbox/PoldrackLab/DevStudy_Analyses/input/'
from_gh=FALSE
source('/Users/zeynepenkavi/Dropbox/PoldrackLab/SRO_Retest_Analyses/code/helper_functions/transform_remove_skew.R')

data <- read.csv(paste0(input_path,'DevStudy_Master_Behavior.csv'))

##################
#BIS BAS
##################

# Scoring is opposite of original BUT in the original all items except 2 and 22 are reverse-scored so can keep as is and change 2 and 22 only
# 1 - strongly disagree
# 2 - disagree
# 3 - agree
# 4 - strongly agree
# 
# Original
# bis: 2 (R), 8, 13, 16, 19, 22 (R), 24
# bas drive: 3, 9, 12, 21
# bas reward responsiveness: 4, 7, 14, 18, 23
# bas fun seeking: 5, 10, 15, 20
# 
# Fillers 1, 6, 11, 17
#   
# Our version omits fillers
# bis: 1 (R), 6, 10, 13, 15, 18 (R), 20
# bas drive: 2, 7, 9, 17
# bas reward responsiveness: 3, 5, 11, 14, 19
# bas fun seeking: 4, 8, 12, 16 

data = data %>%
  mutate(bis = 4-bisbas1+bisbas6+bisbas10+bisbas13+bisbas15+4-bisbas18+bisbas20,
         bas_drive = bisbas2+bisbas7+bisbas9+bisbas17,
         bas_reward_resp = bisbas3+bisbas5+bisbas11+bisbas14+bisbas19,
         bas_fun_seek = bisbas4+bisbas8+bisbas12+bisbas16)

##################
#EIS
##################

#Convert 2's to 0's
data2 = (data[,grep("eis", names(data))] - 2)^2
data = data %>% 
  select(-contains("eis"))
data = cbind(data, data2)

data = data %>%
  mutate(eisa = eisa1 + eisa2 + eisa4 + eisa5 + eisa7 + eisa8 + eisa11 + eisa12 + eisa14 + eisa15 + eisa16 + eisa17 + eisa18 + eisa19 + eisa20 + eisa21 + eisa22 + eisa23 + eisa24 - eisa3 - eisa6 - eisa10 - eisa13 + 4,
         eisy = eisy1 + eisy2 + eisy4 + eisy5 + eisy6 + eisy7 + eisy8 + eisy9 + eisy10 + eisy12 + eisy13 + eisy14 + eisy15 + eisy16 + eisy17 + eisy18 + eisy19 + eisy20 + eisy21 + eisy22 + eisy23 - eisy3 - eisy11 + 2,
         eis = ifelse(is.na(eisa) & !is.na(eisy), eisy, ifelse(!is.na(eisa) & is.na(eisy), eisa, NA))) %>%
  select(-eisa, -eisy)

##################
#CARE - EB and ER
##################

data = data %>% 
  mutate(care_er = career1 + career2 + career3 + career4 + career5 + career6 + career7 + career8 + career9 + career10 + career11 + career12 + career13 + career14 + career15 + career16 + career17 + career18 + career19 + career20 + career21 + career22 + career23 + career24 + career25 + career26 + career27 + career28 + career29 + career30,
         care_eb = careeb1 + careeb2 + careeb3 + careeb4 + careeb5 + careeb6 + careeb7 + careeb9 + careeb10 + careeb11 + careeb12 + careeb13 + careeb14 + careeb15 + careeb16 + careeb17 + careeb18 + careeb19 + careeb20 + careeb21 + careeb22 + careeb23 + careeb24 + careeb25 + careeb26 + careeb27 + careeb28 + careeb29 + careeb30)

##################
#Drug Use Q
##################

#extract only teens and adults with the carepf and duq items
risk_data = data %>%
  filter(id > 200000 & id != 200213 & Exclude_for_age==0 & Exclude_psychopathology==0) %>%
  select(id, contains("carepf"), contains("duq")) %>%
  arrange(id)

# remove skewed variables
risk_data = transform_remove_skew(risk_data, columns=names(risk_data %>% select(-id)), drop=T, threshold=2)

#standardize
risk_data_std = risk_data %>% select(-id) %>% mutate_if(is.numeric, scale)

#median impute
risk_data_std[is.na(risk_data_std)]=0

#drop cols with no variance
risk_data_std = risk_data_std %>%
  select_if(function(col) sd(col) != 0)

#correlation matrix
cor.est = cor(risk_data_std, use="pairwise")
which((cor.est>0.9 & cor.est < 1), arr.ind=TRUE)

risk_data_std = risk_data_std %>%
  mutate(duq1_2 = (duq1+duq2)/2,
         duq4_18 = (duq4+duq18)/2) %>%
  select(-duq1, -duq2, -duq4, -duq18)

#new cor matrix
cor.est = cor(risk_data_std, use="pairwise")
which((cor.est>0.9 & cor.est < 1), arr.ind=TRUE)

#hclust on cor matrix
try = hclust(as.dist(1-cor.est), method="ward")
#plot(try)

#cuttree
trycut <- cutree(try, h=1.75)
trycut = data.frame(trycut)
names(trycut) = "label"
trycut$item = row.names(trycut)
row.names(trycut) = 1:nrow(trycut)
trycut = trycut %>% arrange(label)

#Figure out items for clusters
survey_questions = read.csv(paste0(input_path,"survey_questions.csv"))
# cat(trycut$item[trycut$label==1], sep = "', '")
# Label 1 = 'carepf7', 'duq11', 'duq19', 'duq27', 'duq28', 'carepf5.logTr', 'carepf9.logTr', 'duq4_18'
# View(survey_questions %>% filter(label %in% c('carepf7', 'duq11', 'duq19', 'duq27', 'duq28', 'carepf5', 'carepf9', 'duq4','duq18')))
# Alcohol

# cat(trycut$item[trycut$label==2], sep = "', '")
#Label 2= 'duq5', 'duq8', 'duq12', 'duq13', 'duq14', 'duq15', 'duq16', 'duq10.logTr', 'duq20.logTr', 'duq1_2'
# View(survey_questions %>% filter(label %in% c('duq5', 'duq8', 'duq12', 'duq13', 'duq14', 'duq15', 'duq16', 'duq10', 'duq20', 'duq1', 'duq2')))
# Smoking

# cat(trycut$item[trycut$label==3], sep = "', '")
#Label 3= 'carepf2.logTr', 'carepf6.logTr', 'carepf8.logTr', 'carepf13.logTr', 'carepf18.logTr', 'carepf20.logTr', 'carepf26.logTr'
# View(survey_questions %>% filter(label %in% c('carepf2', 'carepf6', 'carepf8', 'carepf13', 'carepf18', 'carepf20', 'carepf26')))
# Work

# cat(trycut$item[trycut$label==4], sep = "', '")
#Label 4= 'carepf15.logTr', 'carepf17.logTr', 'carepf28.logTr', 'carepf30.logTr'
# View(survey_questions %>% filter(label %in% c('carepf15', 'carepf17', 'carepf28', 'carepf30')))
# Recreational

#pca on each cluster
alcohol_pca = principal(risk_data_std %>% select('carepf7', 'duq11', 'duq19', 'duq27', 'duq28', 'carepf5.logTr', 'carepf9.logTr', 'duq4_18'), nfactors=1, rotate="none", missing=TRUE, scores=T)

smoking_pca = principal(risk_data_std %>% select('duq5', 'duq8', 'duq12', 'duq13', 'duq14', 'duq15', 'duq16', 'duq10.logTr', 'duq20.logTr', 'duq1_2'), nfactors=1, rotate="none", missing=TRUE, scores=T)

work_pca = principal(risk_data_std %>% select('carepf2.logTr', 'carepf6.logTr', 'carepf8.logTr', 'carepf13.logTr', 'carepf18.logTr', 'carepf20.logTr', 'carepf26.logTr'), nfactors=1, rotate="none", missing=TRUE, scores=T)

rec_pca = principal(risk_data_std %>% select('carepf15.logTr', 'carepf17.logTr', 'carepf28.logTr', 'carepf30.logTr'), nfactors=1, rotate="none", missing=TRUE, scores=T)

#extract scores
risk_data$alcohol_scores = alcohol_pca$scores[,1]
risk_data$smoking_scores = smoking_pca$scores[,1]
risk_data$work_scores = work_pca$scores[,1]
risk_data$rec_scores = rec_pca$scores[,1]

#merge back into data.frame
data = data %>%
  left_join(risk_data %>% select(id, alcohol_scores, smoking_scores, work_scores, rec_scores), by="id")

##################
#Select vars including IQ 
##################

q_data = data %>%
  select(id, mr_raw, vocab_raw, gender, bis, bas_drive, bas_fun_seek, bas_reward_resp, eis, care_er, care_eb, alcohol_scores, smoking_scores, work_scores, rec_scores)

rm(data, risk_data, risk_data_std, alcohol_pca, smoking_pca, work_pca, rec_pca, trycut, cor.est, data2)
