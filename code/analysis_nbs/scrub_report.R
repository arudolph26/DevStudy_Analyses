library(tidyverse)

subs = c("sub-100003","sub-100009","sub-100042","sub-100051","sub-100057","sub-100059","sub-100062","sub-100063","sub-100068","sub-100103","sub-100104","sub-100105","sub-100110","sub-100128","sub-100129","sub-100143","sub-100152","sub-100169","sub-100180","sub-100185","sub-100188","sub-100191","sub-100207","sub-100214","sub-100241","sub-100243","sub-100244","sub-100247","sub-100250","sub-200025","sub-200056","sub-200061","sub-200085","sub-200088","sub-200133","sub-200148","sub-200156","sub-200162","sub-200164","sub-200166","sub-200168","sub-200173","sub-200199","sub-200211","sub-200213","sub-200249","sub-306065","sub-306587","sub-310949","sub-311047","sub-311283","sub-311444","sub-311479","sub-311760","sub-400285","sub-400742","sub-402997","sub-405027","sub-406620","sub-406925","sub-406980","sub-407209","sub-407260","sub-407672","sub-408394","sub-408511","sub-408662","sub-408952","sub-408988","sub-409381","sub-409850","sub-409874","sub-411256","sub-411477")

tmp = read.csv('~/Dropbox/PoldrackLab/DevStudy_Analyses/input/scrub_fd_0.5_report.csv')

exclude_runs = tmp %>% 
  select(-X)%>%
  filter(pct_scrubbed>20) %>%
  arrange(-pct_scrubbed)

#Most of the excluded runs will be from kids
#There are 29 kids
#With the missing file exclusions we have 29*6 = 174 - 8 = 166 runs
#Excluding these runs based on scrubbing fd > 0.5 will leave 166 - 36 = 130 runs for kids
#Totals then:
#Kids - 29*6-(8+36) = 130 runs
#Teens - 17*6-(1+4+2) = 95 runs
#Adults - 28*6-(12+2) = 154 runs 
table(exclude_runs$sub_id)

########################################################################################
tmp = read.table('~/Downloads/tmp.txt')
head(tmp)

tmp = tmp %>%
  mutate(V1 = gsub("/oak/stanford/groups/russpold/data/ds000054/0.0.4/derivatives/level_2/","",V1)) %>%
  # select(V11) %>% 
  # mutate(V11 = gsub("./level1-39331547-", "", V11),
         # V11 = gsub(".err", "", V11))
separate(V1, into=c("a", "b", "c"), sep="/")
########################################################################################

design = read.csv('~/Downloads/sub-100009_run-001_level1_design_matrix.csv')

design = read.csv('~/Downloads/sub-411477_run-004_level1_design_matrix.csv')

design = read.csv('~/Downloads/sub-200061_run-002_level1_design_matrix.csv')

design %>%
  gather(reg, value, -X) %>%
  mutate(reg = gsub("_", " ", reg),
         reg = factor(reg, levels = c("m1", "m1 derivative","m2", "m2 derivative","m3", "m3 derivative", "m4", "m4 derivative", "m1 rt", "m1 rt derivative",  "m2 rt", "m2 rt derivative",  "m3 rt", "m3 rt derivative",  "m4 rt", "m4 rt derivative", "gain","gain derivative","loss", "loss derivative","junk", "junk derivative","rot x", "rot x td", "rot x sq", "rot x sq td", "rot y", "rot y td", "rot y sq", "rot y sq td", "rot z", "rot z td", "rot z sq", "rot z sq td", "trans x", "trans x td", "trans x sq", "trans x sq td", "trans y", "trans y td", "trans y sq", "trans y sq td", "trans z", "trans z td", "trans z sq", "trans z sq td", "framewise displacement", "std dvars", "scrub","drift 1", "drift 2", "constant"))) %>%
  ggplot(aes(y=X, x=factor(reg)))+
  geom_tile(aes(fill=value), color=NA)+
  scale_x_discrete(labels = function(x) str_wrap(x, width=5))+
  scale_fill_gradient()+
  xlab("")+
  ylab("")+
  theme(axis.text.y = element_blank(),
        legend.position = "none",
        axis.ticks = element_blank(),
        axis.text.x = element_text(angle=90, margin = margin(t=-18),hjust=0.95,vjust=0.2),
        panel.border = element_blank(),
        panel.grid = element_blank())