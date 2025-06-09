input_path = '/Users/ally/Desktop/Lab/DevStudy_Analyses/input/'

##################
#Machine game data
##################
file_list <- list.files(paste0(input_path,"/machine_game"))

for (file in file_list){
  
  tmp <- read.csv(paste0(input_path,"machine_game/",file))
  tmp$Sub_id <- as.numeric(gsub("[^0-9]", "", file))
  tmp$Trial_number <- 1:nrow(tmp)
  
  if('X' %in% names(tmp)){
    tmp <- tmp[,-which(names(tmp) == "X")]
  }
  
  if (file == file_list[1]){
    machine_game_data = tmp
  }
  else{
    machine_game_data = rbind(machine_game_data, tmp)
  }
  rm(tmp)
}

rm(file, file_list)

#Remove subjects with incomplete data
incomplete_subs <- as.numeric(names(which(table(machine_game_data$Sub_id)!=180)))

machine_game_data_clean <- machine_game_data[machine_game_data$Sub_id %in% incomplete_subs == F,]

rm(incomplete_subs)

#Add existing behavior for sub-100110
machine_game_data_clean = machine_game_data_clean %>%
  rbind(machine_game_data %>%
  filter(Sub_id == 100110 & Trial_number < 151))

#Remove subject without imaging data sub-100109
machine_game_data_clean = machine_game_data_clean %>%
  filter(Sub_id != 100109)

#Add cols for machine properties
assign.machine.info <- function(data){
  data$facet_labels <- with(data, ifelse(Trial_type == 1, "+5,-495", ifelse(Trial_type == 2, "-5,+495", ifelse(Trial_type == 3, "-10,+100", ifelse(Trial_type == 4, "+10,-100", NA)))))
  
  data$gain_mag <- with(data, ifelse(Trial_type == 1, "5", ifelse(Trial_type == 2, "495", ifelse(Trial_type == 3, "100", ifelse(Trial_type == 4, "10", NA)))))
  
  data$loss_mag <- with(data, ifelse(Trial_type == 1, "495", ifelse(Trial_type == 2, "5", ifelse(Trial_type == 3, "10", ifelse(Trial_type == 4, "100", NA)))))
  
  data$gain_freq <- with(data, ifelse(Trial_type == 1, "90", ifelse(Trial_type == 2, "10", ifelse(Trial_type == 3, "50", ifelse(Trial_type == 4, "50", NA)))))
  
  data$loss_freq <-  with(data, ifelse(Trial_type == 1, "10", ifelse(Trial_type == 2, "90", ifelse(Trial_type == 3, "50", ifelse(Trial_type == 4, "50", NA)))))
  
  data$magnitude <- with(data, ifelse(Trial_type == 1, "large", ifelse(Trial_type == 2, "large", ifelse(Trial_type == 3, "small", ifelse(Trial_type == 4, "small", NA)))))
  
  data$variance <- with(data, ifelse(Trial_type == 1, "high", ifelse(Trial_type == 2, "high", ifelse(Trial_type == 3, "low", ifelse(Trial_type == 4, "low", NA)))))
  
  return(data)
}

machine_game_data_clean <- assign.machine.info(machine_game_data_clean)

##################
#Demographics data
##################
demog_data <- read.csv(paste0(input_path,'DevelopmentalStudy_DATA_2015-03-25_1258.csv'))

# Add age data to machine_game_data_clean
assign.age.info <- function(data){
  
  #data$age_group <- with(data, ifelse(Sub_id<200000, "kid", ifelse(Sub_id>200000 & Sub_id<300000, "teen", "adult")))
  
  data %>%
    group_by(Sub_id) %>%
    left_join(demog_data[,c('subj_id', 'calc_age')], by = c("Sub_id" = "subj_id")) %>%
    mutate(age_group = ifelse(calc_age < 13, "kid", ifelse(calc_age > 13 & calc_age < 20, "teen", ifelse(calc_age > 20, "adult", NA))),
           age_group=factor(age_group, levels=c('kid', 'teen', 'adult')))
}

machine_game_data_clean <- assign.age.info(machine_game_data_clean)

machine_game_data_clean = machine_game_data_clean  %>%
  mutate(correct1_incorrect0 = ifelse(facet_labels %in% c('-10,+100', '-5,+495') & Response ==1,1,ifelse(facet_labels %in% c('+10,-100', '+5,-495') & Response ==2,1,0)),
         Response = factor(Response, levels = c(0,1,2) ,labels=c('time-out', 'play', 'pass'))) %>%
  filter(Sub_id != "406989")
