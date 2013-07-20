#install.packages("ggplot2")
library(ggplot2)
cmr <- read.table ('http://pastebin.com/raw.php?i=61J9W4Gt', header = T)
str(cmr)

#ordering factors
cmr$height <- factor(cmr$height, levels = c('h','m','l'))
cmr$Pulse <- factor (cmr$Pulse, levels = c("1LF_Low_Short",
                                           "2PF_Low_Short", "2PF_Medium_Medium",
                                           "3GF_Medium_Short","3GF_Medium_Long"))

#plot
ggplot(cmr, aes( height , variable,
                 colour = factor(pop, levels = pop[order(factor(Pulse))]),
                 fill = factor(Pulse)))+
  xlab ('Anther levels')+
  ylab ('Length (mm)')+
  scale_colour_manual( values = rep("black", 24), legend = FALSE) +
  scale_fill_manual(name = 'Flood Pulse intensity', values =
                      c("#E5E5E5", "#ACACAC", "#747474", "#3B3B3B", "#030303"))+
  geom_boxplot(mapping = NULL, data = NULL, stat = "boxplot", position =
                 "dodge", outlier.colour = "black",
               outlier.shape = 8, outlier.size = 1.5, notch = FALSE, notchwidth =
                 0.5, show_guide = TRUE)+
  theme_bw()



# Original unordered version
ggplot(InsectSprays, aes(x = spray, y = count)) + geom_boxplot()

# Ordered by median
ggplot(InsectSprays, aes(x = reorder(spray, count, FUN=median), y = count)) + geom_boxplot()