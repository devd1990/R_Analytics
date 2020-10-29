# R_Analytics

Analytics exercise to analyze the performance of a company newsletter:

Data challenge
--------------

Company sends email newsletters to our email subscribers promoting current sales. Here is the metadata:

●	newsletters.csv
    o	ts – timestamp (epoch time in seconds)
    o	user_id – Identifier for each user
    o	nl_id – This is the id of the Company email newsletters. It is unique at the newsletter batch level, not user level. 
    o	dt – date
    o	hr – hour
    o	event_type – there are 3 types: 
      ▪	nlsent: a newsletter email was sent
      ▪	nlpv: a newsletter email was viewed
      ▪	nllc: newsletter link clicks (user clicked on clickable content in the newsletter and was directed to relevant content on the Company website)
    o	event_type_param – extra parameters for nllc/newsletter link positions. Each newsletter contains multiple sale banners.
      ▪	g0: clicks on the first sale banner in the newsletter
      ▪	g1: clicks on the the 2nd sale banner in the newsletter
      ▪	g2: clicks on the the 3rd sale banner in the newsletter
      ▪	…
      ▪	Please ignore event_type_param for nlsent/newsletter sends and nlpv/newsletter opens

Questions:
----------

●	Define open_rate as: # unique users who opened a newsletter / # unique users who received a newsletter. 
●	Define CTR as: # clicks at a position / # opens. Example:
    User 1: opened once, clicked on position 1 and 3
    User 2: opened twice, clicked once on position 1
    User 3: didn’t open
    Based on these 3 users, 
    CTR_position_1 = 2/3, CTR_position_2 = 0, CTR_position_3 = 1/3 

1.	How many newsletters were sent vs. opened for nl_id 2885 and 2912? What’s the overall open rate for each newsletter?
2.	What % of users opened the email within 1, 2, 3, 4, 5, 6, 7 days? Visualize the results for each newsletter. Which newsletter has the best open_rate?
3.	Make a graph of the CTRs by link position for nl_id 2873 and 2885. Visualize the results for each newsletter.
4.	What other metrics we can use to measure newsletter performance/quality? For each metric please state why it is important in one sentence.

