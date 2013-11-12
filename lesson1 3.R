## week-1 Exc-3  
## Tewede G.HAGOS  
## date: 11-11-2013
## This documented script plots a temprature map of a country where the random sampled 
## points are visulazed on top of the raster map and labelled median value as text 
## Required input:sites to download the shape file and raster dataset of the country
## now working for kenya
## working and data directory setup below
setwd("E:/Exe lesson -3")
getwd()
datdir <- file.path("data")
datdir <- "data"
library(rasta)
## Download raster file 
rasterfile <- system.file("extdata", "anom.2000.03.tiff", package ="rasta")
temp <- raster(rasterfile)
plot(temp)
## Download and unzip shape file of kenya ( for extent)
download.file("http://rasta.r-forge.r-project.org/kenyashape.zip",
              file.path(datdir, "kenyashape.zip"))
unzip(file.path(datdir, "kenyashape.zip"), exdir= datdir)
kenya <- readOGR(dsn = datdir, layer = "kenya")
plot(kenya)
## Crop the Raster Dataset to the Extent of the Kenya Shapefile
crop <- crop(temp, kenya)
plot(crop)
plot(kenya, add=TRUE)
## Genrate random sample POINTS
RS <- sampleRandom(temp, size=30, na.rm=FALSE, ext=kenya,
                   cells=30, rowcol=TRUE, xy=TRUE, sp=TRUE, asRaster= FALSE)
plot(RS,add =TRUE,col ="blue", pch = 19, cex =0.50)
tempvalue <- extract(temp, RS, method='simple', buffer=NULL, small=FALSE, cellnumbers= FALSE, 
                     fun=NULL, na.rm=TRUE, layer, nl, df=FALSE, factors=FALSE, col = red)
## Convert random points to Spatial Points Dataframe
tempspdf<-as(RS,"SpatialPointsDataFrame")
##Drive median value of tempreature 
med <-median(tempvalue)
sd <- sd(tempvalue)
## Text leveling 
text(42.7, -3.5,paste( "Median = ",round(med, 1), "\nStd.Dev = ", round(sd, 2)),adj=c(0, 0), cex = 0.9)
label <- invisible(text(RS,labels = as.character(round(tempvalue,digits = 2), cex =0.5, col = "red", font = 0.05)))
mtext(side = 3, line = 1, "Kenya Temprature Anomaly ", cex = 1.2)
mtext(side = 2, "Latitude", line = 2.5, cex=1.1)
mtext(side = 1, "Longitude", line = 2.5, cex=1.1)
## try for other country