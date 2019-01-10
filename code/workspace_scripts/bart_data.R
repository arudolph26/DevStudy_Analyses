##########
#Bart data
##########
file_list <- list.files("/Users/zeynepenkavi/Downloads/bart_tsv", pattern = '*.tsv')

for (file in file_list){
  
  tmp <- read.csv(paste0("/Users/zeynepenkavi/Downloads/bart_tsv/",file), sep = "\t")
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