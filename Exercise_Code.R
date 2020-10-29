# Removing all variables
rm(list=ls())

# Install the packages
install.packages("sqldf")
install.packages("readr")
install.packages("readxl")
install.packages("plotly")

# Initialize the required libraries
library(readr)
library(sqldf)
library(readxl)
library(plotly)

# Read newsletter csv into a dataframe
nl_df <- read_csv("houzz_data_challenge_newsletters.csv")

# Subset the dataframe for all nl_ids

#test = sqldf("select distinct nl_id from nl_df")

nl_2885 = nl_df[nl_df[,2]==2885,]
nl_2912 = nl_df[nl_df[,2]==2912,]
nl_2873 = nl_df[nl_df[,2]==2873,]
nl_2853 = nl_df[nl_df[,2]==2853,]

# q1

nl_2885_cnt = sqldf("select event_Type, count(distinct user_id) from nl_2885 group by event_type")
nl_2912_cnt = sqldf("select event_Type, count(distinct user_id) from nl_2912 group by event_type")

nl_2885_open_rate = nl_2885_cnt[2,2] / nl_2885_cnt[3,2]
nl_2912_open_rate = nl_2912_cnt[2,2] / nl_2912_cnt[3,2]

# q2

nl_df_cnt = sqldf("select event_Type, nl_id, count(distinct user_id) from nl_df group by event_type, nl_id")

temp = as.Date(nl_df$dt,"%m/%d/%Y")
nl_df = cbind(nl_df,temp)

nl_usr_snt = sqldf("select nl_id, user_id, min(temp) as sent_date from nl_df where event_type = 'nlsent' 
                   group by nl_id, user_id")
nl_usr_snt[,3] = as.Date(nl_usr_snt[,3],origin = "1970-01-01")

nl_df_mrgd = sqldf("select * from nl_df left join nl_usr_snt on nl_df.nl_id = nl_usr_snt.nl_id AND 
                   nl_df.user_id = nl_usr_snt.user_id")
nl_df_mrgd[,"day_diff"] = as.numeric(nl_df_mrgd[,"temp"] - nl_df_mrgd[,"sent_date"])
nl_day_cnt = sqldf("select nl_id, day_diff, count(distinct user_id) as cnt_usr_opn from nl_df_mrgd 
                    where event_type = 'nlpv' group by nl_id, day_diff")
nl_df_opn = nl_df_cnt[nl_df_cnt[,"event_type"]=='nlpv',]
nl_df_snt = nl_df_cnt[nl_df_cnt[,"event_type"]=='nlsent',]
nl_day_cnt2 = sqldf("select * from nl_day_cnt left join nl_df_snt on nl_day_cnt.nl_id = nl_df_snt.nl_id")
nl_day_cnt2[,"perc_usr"] = round((nl_day_cnt2[,"cnt_usr_opn"] / nl_day_cnt2[,6])*100,2)
nl_day_cnt3 = nl_day_cnt2[,c(1,2,7)]
nl_day1 = sqldf("select nl_id, perc_usr as day1 from nl_day_cnt3 where day_diff = 0")
nl_day2 = sqldf("select nl_id, perc_usr as day2 from nl_day_cnt3 where day_diff = 1")
nl_day3 = sqldf("select nl_id, perc_usr as day3 from nl_day_cnt3 where day_diff = 2")
nl_day4 = sqldf("select nl_id, perc_usr as day4 from nl_day_cnt3 where day_diff = 3")
nl_day5 = sqldf("select nl_id, perc_usr as day5 from nl_day_cnt3 where day_diff = 4")
nl_day6 = sqldf("select nl_id, perc_usr as day6 from nl_day_cnt3 where day_diff = 5")
nl_day7 = sqldf("select nl_id, perc_usr as day7 from nl_day_cnt3 where day_diff = 6")
nl_opn_rt = sqldf("select * from nl_df_opn left join nl_df_snt on nl_df_opn.nl_id = nl_df_snt.nl_id")
nl_opn_rt = nl_opn_rt[,c(2,3,6)]
nl_opn_rt[,4] = round((nl_opn_rt[,2] / nl_opn_rt[,3])*100,2)
nl_opn_rt = nl_opn_rt[,c(1,4)]
colnames(nl_opn_rt)=c("nl_id","open_rate")
final_q2 = sqldf("select * from nl_day1 left join nl_day2 on nl_day1.nl_id = nl_day2.nl_id
                 left join nl_day3 on nl_day1.nl_id = nl_day3.nl_id
                 left join nl_day4 on nl_day1.nl_id = nl_day4.nl_id
                 left join nl_day5 on nl_day1.nl_id = nl_day5.nl_id
                 left join nl_day6 on nl_day1.nl_id = nl_day6.nl_id
                 left join nl_day7 on nl_day1.nl_id = nl_day7.nl_id
                 left join nl_opn_rt on nl_day1.nl_id = nl_opn_rt.nl_id")
final_q2 = final_q2[,c(1,2,4,6,8,10,12,14,16)]

# Heat map for q2

row.names(final_q2) <- final_q2$nl_id
final_q2 <- final_q2[,2:9]
final_q2_matrix <- data.matrix(final_q2)
final_q2_heatmap <- heatmap(final_q2_matrix, Rowv=NA, Colv=NA, col = heat.colors(256), scale="column", margins=c(5,10))

# q3

nl_2873_clicks = sqldf("select event_type_param, count(*) as no_clks from nl_2873 where event_type_param Like '%g%' 
                       group by event_type_param")
nl_2885_clicks = sqldf("select event_type_param, count(*) as no_clks from nl_2885 where event_type_param Like '%g%' 
                       group by event_type_param")
nl_2873_opn = sqldf("select count(*) as no_opns from nl_2873 where event_type = 'nlpv'")
nl_2885_opn = sqldf("select count(*) as no_opns from nl_2885 where event_type = 'nlpv'")
nl_2873_CTR = sqldf("select * from nl_2873_clicks left join nl_2873_opn")
nl_2885_CTR = sqldf("select * from nl_2885_clicks left join nl_2885_opn")

nl_2873_CTR[,"CTR"] = round(nl_2873_CTR[,"no_clks"] / nl_2873_CTR[,"no_opns"],3)
nl_2885_CTR[,"CTR"] = round(nl_2885_CTR[,"no_clks"] / nl_2885_CTR[,"no_opns"],3)

p1 <- plot_ly(
  x = as.vector(nl_2873_CTR[,1]),
  y = as.vector(nl_2873_CTR[,4]),
  type = "bar") %>%
layout(yaxis = list(title = 'CTR'), xaxis = list(title = 'Sale Banner'), 
         title = "CTR for news letter 2873")
p1

p2 <- plot_ly(
  x = as.vector(nl_2885_CTR[,1]),
  y = as.vector(nl_2885_CTR[,4]),
  name = "CTR for news letter 2885",
  type = "bar") %>%
layout(yaxis = list(title = 'CTR'), xaxis = list(title = 'Sale Banner'), 
         title = "CTR for news letter 2885")
p2

plotly_IMAGE(p1, format = "png", out_file = "p1.png")
plotly_IMAGE(p2, format = "png", out_file = "p2.png")
