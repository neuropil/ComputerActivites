library(ggplot2)
library(reshape2)
library(raster)
library(rgdal)




# Load raster
image <- stack('~/EEEI_contest/all_layers.tif')

# Load point .shp-file with classes
s_points_dFrame <- readOGR( '~/EEEI_contest',
                            layer="sampling_points",
                            p4s="+proj=utm +zone=15 +datum=NAD83 +units=m +no_defs +ellps=GRS80 +towgs84=0,0,0")
s_points <- SpatialPoints(s_points_dFrame)
dFrame <- as.data.frame(s_points_dFrame)

# Extract data at sampling points
probe <- extract(image, s_points, method='bilinear')

# Combine sampling results with original data 
sample <- cbind(dFrame, probe)

# get numbers for bands instead of names in headers of columns
for (i in c(7:ncol(sample))){
  colnames(sample)[i] <- i-6
}

# preparation for palette creation (establish wavelengths)
palette <- c()
violet <- c(380:450)
blue <- c(452:495)
green <- c(496:570)
yellow <- c(571:590)
orange <- c(591:620)
red <- c(621:750)
NIR <- c(750:1050)

# process band names (future captions) and palette
for (i in c(7:150)){
  # calculate wavelength for a given band
  wave <- (i-7)*4.685315 + 380
  wave <- round(wave, digits = 0)
  
  # rename colunms in 'sample'
  band_num <- paste('(band', i-6, sep = ' ')
  band_num <- paste(band_num, ')', sep = '')
  colnames(sample)[i] <- paste(wave, band_num, sep = ' ')
  
  # add value to palette
  if (is.element(wave, violet)) {palette <- c(palette, '#8F00FF')   
  } else if (is.element(wave, blue)) {palette <- c(palette, '#2554C7')   
  } else if (is.element(wave, green)) {palette <- c(palette, '#008000')   
  } else if (is.element(wave, yellow)) {palette <- c(palette, '#FFFF00')   
  } else if (is.element(wave, orange)) {palette <- c(palette, '#FF8040')   
  } else if (is.element(wave, red)) {palette <- c(palette, '#FF0000')   
  } else if (is.element(wave, NIR)) {palette <- c(palette, '#800000')   
  }
  
}

# Remove unneeded fields
sample <- subset(sample, select = 1:150)
sample[, 5] <- NULL
sample[, 5] <- NULL
sample <- sample[,3:148]


#
sample <- melt(sample, id = c('pattern', 'pattern_id'))
#
#


plotting <- function(data_f, plot_name){
  p <- ggplot(data_f, aes(data_f[,3], data_f[,4])) +
    geom_boxplot(aes(fill = data_f[,3]),
                 colour = palette,
                 # make outliers have the same colour as lines    
                 outlier.colour = NULL) +
    theme(axis.text.x = element_text(angle=90, hjust = 0),
          axis.title = element_text(face = 'bold', size = 14),
          title = element_text(face = 'bold', size = 16),
          legend.position = 'none') +
    labs(title = paste('Spectral response for class\n',
                       plot_name,
                       sep = ' '),
         x = 'Wavelength, nm',
         y = 'Response')+
    scale_fill_manual(values = palette)
  print(p)
}


# get unique classes

# uniue class numbers:
u <- unique(sample[,'pattern_id'])
# unique class names:
u_names <- unique(unlist(sample[,'pattern']))

for (i in u){
  # works only if class numbers (u) are consequtive integers from 1 to u
  data_f <- subset(sample, pattern_id == i)  
  plot_name <- u_names[i]
  plotting(data_f, plot_name)
}

