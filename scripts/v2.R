## ReadMe ####
# Make Over Monday 2016 Mar 28
# http://vizwiz.blogspot.com/p/makeover-monday-challenges.html

# Inspiration from 
# https://rud.is/b/2016/03/14/spinning-cycles-in-box-4-to-take-the-pies-out-of-pi-day/
# a few of things did not work, was not able to fix it

## load libraries ####
install.packages("ggplot2")
library(ggplot2)
library(grid)
library(scales)
library(dplyr)
library(stringr)

## read input file ####
# please check the file path
my.path = "/mnt/h/r.makeOver.2016Mar28/data/Sugar Tax.csv"
df.original = read.csv(file=my.path, stringsAsFactors = FALSE)

## basic manipulation ####
df.1 = df.original
df.1$Age.Group = as.factor(df.1$Age.Group)
df.1$Sugar.Source = as.factor(df.1$Sugar.Source)

df.1$Amount %>% 
  str_replace_all("\\%","") %>% # removing percentage sign 
  as.numeric() -> # convert to numeric
  df.1$Amount # assign to Amount

df.1$Amount <- df.1$Amount / 100

# We can use regular expressions to add line breaks to the factor levels by
# substituting any spaces with line breaks:
levels(df.1$Sugar.Source) <- gsub(" ", "\n", levels(df.1$Sugar.Source))

# How to order the (factor) variables in ggplot2 
# https://kohske.wordpress.com/2010/12/29/faq-how-to-order-the-factor-variables-in-ggplot2/
# re-order the levels in the order of appearance in the data.frame
# d$Team2 <- factor(d$Team1, as.character(d$Team1))
# same as mentioning them epxlicitly
# d$Team2 <- factor(d$Team1, c("Cowboys", "Giants", "Eagles", "Redskins"))
# df.1$Age.Group < factor(df.1$Age.Group, as.character(df.1$Age.Group))
# df.1$Age.Group < factor(df.1$Age.Group, levels = c("Children 1.5 - 3","Children 4 - 10","Teenagers 11 - 18","Adults 19 - 64","Adults 65+"))
levels(df.1$Age.Group)
df.1$Age.Group <- factor(df.1$Age.Group, levels(df.1$Age.Group)[c(3,4,5,1,2)])
levels(df.1$Age.Group)                      

levels(df.1$Sugar.Source)
df.1$Sugar.Source <- factor(df.1$Sugar.Source, levels(df.1$Sugar.Source)[c(2,3,5,6,4,1)])  
levels(df.1$Sugar.Source)

## basic graph ####
g1 <- ggplot(df.1, aes(x=Sugar.Source, y=Amount, fill=Sugar.Source))
g1 <- g1 + geom_bar(stat="identity", width=0.75, color="#2b2b2b", size=0.05)

# expand
# A numeric vector of length two giving multiplicative and additive expansion constants. 
# These constants ensure that the data is placed some distance away from the axes. 
# The defaults are c(0.05, 0) for continuous variables, and c(0, 0.6) for discrete variables.
#gg <- gg + scale_y_continuous(expand=c(0,0.5), labels=percent, limits=c(0, 0.5))
g2 <- g1 + scale_y_continuous(labels=percent, limits=c(0, 0.5))
#gg <- gg + scale_x_discrete(expand=c(0,1))
g3 <- g2 + scale_fill_manual(name="", values=c("#F9E559", "#218C8D", "#6CCECB", "#EF7126", "#8EDC9D", "#473E3F"))
                                               

g3 <- g3 + facet_wrap(~Age.Group, scales="free")

g3 <- g3 + labs(x=NULL, y=NULL, title="Sugar tax: How bold is it?")
g4 <- g3 + theme(panel.background=element_rect(fill="#efefef", color=NA))

g4 <- g4 + theme(strip.background=element_rect(fill="#858585", color=NA))
g4 <- g4 + theme(strip.text=element_text(family="OpenSans-CondensedBold", size=12, color="white", hjust=0.5))
g4 <- g4 + theme(panel.margin.x=unit(1, "cm"))
g4 <- g4 + theme(panel.margin.y=unit(0.5, "cm"))
g4 <- g4 + theme(legend.position="none")
g4 <- g4 + theme(panel.grid.major.y=element_line(color="#b2b2b2"))
g4 <- g4 + theme(axis.ticks = element_blank())

# Hide all the vertical gridlines
g4 <- g4 + theme(panel.grid.minor.x=element_blank(),
           panel.grid.major.x=element_blank())

g4 <- g4 + theme(panel.grid.minor.y=element_blank())

g4 <- g4 + theme(plot.title = element_text(face="bold", color = "black", size=18))

g4


