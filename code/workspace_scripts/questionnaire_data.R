input_path = '/Users/zeynepenkavi/Dropbox/PoldrackLab/DevStudy_Analyses/input/'

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
data = (data[,grep("eis", names(data))] - 2)^2

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

##################
#Select vars including IQ 
##################

q_data = data %>%
  select(id, mr_raw, vocab_raw, gender, bis, bas_drive, bas_fun_seek, bas_reward_resp, eis, care_er, care_eb)

rm(data)