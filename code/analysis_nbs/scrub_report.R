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

library(pspline)

design = read.table('~/Dropbox/PoldrackLab/DevStudy_ServerScripts/level_1/design.mat')

design = design %>%
  mutate(TR=1:n()) %>%
  rename(m1=V1, m1_td = V2, m2 = V3, m2_td = V4, m3 = V5, m3_td = V6, m4 = V7, m4_td = V8, m1_rt = V9, m1_rt_td = V10, m2_rt = V11, m2_rt_td = V12, m3_rt = V13, m3_rt_td = V14, m4_rt = V15, m4_rt_td = V16, pe_lv = V17, pe_lv_td = V18, pe_hv = V19, pe_hv_td = V20, junk = V21, junk_td = V22, scrub = V23) %>%
  gather(reg, value, -TR) %>%
  mutate(reg = factor(reg, levels = c("m1", "m1_td", "m2", "m2_td", "m3", "m3_td", "m4","m4_td", "m1_rt", "m1_rt_td", "m2_rt", "m2_rt_td", "m3_rt", "m3_rt_td", "m4_rt", "m4_rt_td", "pe_lv", "pe_lv_td", "pe_hv", "pe_hv_td", "junk", "junk_td", "scrub"), labels = c("m1", "m1_td", "m2", "m2_td", "m3", "m3_td", "m4","m4_td", "m1_rt", "m1_rt_td", "m2_rt", "m2_rt_td", "m3_rt", "m3_rt_td", "m4_rt", "m4_rt_td", "pe_lv", "pe_lv_td", "pe_hv", "pe_hv_td", "junk", "junk_td", "scrub")))


design %>%
  ggplot(aes(y=TR, x=factor(reg)))+
  geom_tile(aes(fill=value), color=NA)+
  scale_fill_gradient()+
  xlab("")+
  ylab("")+
  theme(axis.text.y = element_blank(),
        legend.position = "none",
        axis.ticks = element_blank(),
        axis.text.x = element_text(angle=90),
        panel.border = element_blank(),
        panel.grid = element_blank())

mov = read.table('~/Dropbox/PoldrackLab/DevStudy_ServerScripts/level_1/prefiltered_func_data_mcf.par')

time = c(1:216)

mov$V1_td = predict(sm.spline(time, mov$V1), time, 1)  
mov$V2_td = predict(sm.spline(time, mov$V2), time, 1)
mov$V3_td = predict(sm.spline(time, mov$V3), time, 1)  
mov$V4_td = predict(sm.spline(time, mov$V4), time, 1)
mov$V5_td = predict(sm.spline(time, mov$V5), time, 1)  
mov$V6_td = predict(sm.spline(time, mov$V6), time, 1)
mov$V1_sq = mov$V1^2
mov$V2_sq = mov$V2^2
mov$V3_sq = mov$V3^2
mov$V4_sq = mov$V4^2
mov$V5_sq = mov$V5^2
mov$V6_sq = mov$V6^2
mov$V1_sq_td = predict(sm.spline(time, mov$V1_sq), time, 1)  
mov$V2_sq_td = predict(sm.spline(time, mov$V2_sq), time, 1)
mov$V3_sq_td = predict(sm.spline(time, mov$V3_sq), time, 1)  
mov$V4_sq_td = predict(sm.spline(time, mov$V4_sq), time, 1)
mov$V5_sq_td = predict(sm.spline(time, mov$V5_sq), time, 1)  
mov$V6_sq_td = predict(sm.spline(time, mov$V6_sq), time, 1)


mov %>%
  mutate(TR=1:216) %>%
  gather(reg, value, -TR) %>%
  mutate(reg = gsub("V", "mov", reg))%>%
  rbind(design)  %>%
  mutate(reg = factor(reg, levels = c("m1", "m1_td", "m2", "m2_td", "m3", "m3_td", "m4","m4_td", "m1_rt", "m1_rt_td", "m2_rt", "m2_rt_td", "m3_rt", "m3_rt_td", "m4_rt", "m4_rt_td", "pe_lv", "pe_lv_td", "pe_hv", "pe_hv_td", "junk", "junk_td", "scrub", "mov1", "mov1_td", "mov2", "mov2_td", "mov3", "mov3_td", "mov4", "mov4_td", "mov5", "mov5_td", "mov6", "mov6_td", "mov1_sq", "mov1_sq_td", "mov2_sq", "mov2_sq_td", "mov3_sq", "mov3_sq_td", "mov4_sq", "mov4_sq_td", "mov5_sq", "mov5_sq_td", "mov6_sq", "mov6_sq_td"),
                      labels = c("m1", "m1_td", "m2", "m2_td", "m3", "m3_td", "m4","m4_td", "m1_rt", "m1_rt_td", "m2_rt", "m2_rt_td", "m3_rt", "m3_rt_td", "m4_rt", "m4_rt_td", "pe_lv", "pe_lv_td", "pe_hv", "pe_hv_td", "junk", "junk_td", "scrub", "mov1", "mov1_td", "mov2", "mov2_td", "mov3", "mov3_td", "mov4", "mov4_td", "mov5", "mov5_td", "mov6", "mov6_td", "mov1_sq", "mov1_sq_td", "mov2_sq", "mov2_sq_td", "mov3_sq", "mov3_sq_td", "mov4_sq", "mov4_sq_td", "mov5_sq", "mov5_sq_td", "mov6_sq", "mov6_sq_td"))) %>%
  ggplot(aes(y=TR, x=reg))+
  geom_tile(aes(fill=value), color=NA)+
  scale_fill_gradient()+
  xlab("")+
  ylab("")+
  theme(axis.text.y = element_blank(),
        legend.position = "none",
        axis.ticks = element_blank(),
        axis.text.x = element_text(angle=90),
        panel.border = element_blank(),
        panel.grid = element_blank())

ggsave("design_eg.jpeg", device = "jpeg", path = fig_path, width = 7, height = 5, units = "in", dpi = 450)

