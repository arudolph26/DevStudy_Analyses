input_path = '/Users/ally/Desktop/Lab/DevStudy_Analyses/input/'

##########
#Bart data
##########
file_list <- list.files(paste0(input_path,"bart_tsv"), pattern = '*.tsv')

for (file in file_list){
  
  tmp <- read.csv(paste0(paste0(input_path,"bart_tsv/"),file), sep = "\t")
  tmp$Sub_id <- as.numeric(strsplit(file, "_")[[1]][1])
  
  if (file == file_list[1]){
    bart_data = tmp
  }
  else{
    bart_data = rbind(bart_data, tmp)
  }
  rm(tmp)
}

rm(file, file_list)

adjusted.pumps <- function(subject_data){
  subject_data_adjusted = subject_data[subject_data$exploded == 0,]
  subject_pumps <- subject_data_adjusted %>% 
    group_by(trial.num) %>%
    summarise(total_pumps = sum(finished))
  out <- data.frame(mean_adjusted_pumps = mean(subject_pumps$total_pumps),
                    bart_mean_rt = mean(subject_data$rt, na.rm=T),
                    bart_sd_rt = sd(subject_data$rt))
  return(out)
}

bart_adjusted_pumps = bart_data %>%
  group_by(Sub_id) %>%
  do(adjusted.pumps(.)) %>%
  do(assign.age.info(.))
