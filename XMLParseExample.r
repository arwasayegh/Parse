######################################################################
#Author: Arwa S
######################################################################
#Load libraries
library(XML) #for XML Parsing
library(plyr) #for Data manipulation

#Parse XML file
doc <- xmlParse("XMLParseExample.xml")
xmltop <- xmlRoot(doc)
###############################
#Example checks for parsed file
class(xmltop)
xmlName(xmltop)
xmlSize(xmltop)
xmlSize(xmltop[[2]])
xmlSApply(xmltop[[2]], xmlName)
xmlSApply(xmltop[[2]], xmlAttrs)
xmlSApply(xmltop[[2]], xmlSize)
###############################
#Get the geographic address
geo <- sapply(seq(1,xmlSize(xmltop[[2]][[6]]), by=1), function(x) 
				xmlSApply(xmltop[[2]][[6]][[x]][[3]], xmlValue))
class(geo)
geo <- as.data.frame(geo)
head(geo)

#Store size of each node
size <- xmlSApply(xmltop[[2]][[6]], xmlSize)
size <- as.vector(size)

#Get the latitude
f1 <- function(x,y) xmlSApply(xmltop[[2]][[6]][[x]][[y]][[1]][[1]], xmlValue)
lat <- mapply(f1, seq(1,xmlSize(xmltop[[2]][[6]]), by=1), size)
class(lat)
lat <- as.data.frame(lat)
head(lat)

#Get the longitude
f2 <- function(x,y) xmlSApply(xmltop[[2]][[6]][[x]][[y]][[1]][[2]], xmlValue)
long <- mapply(f2, seq(1,xmlSize(xmltop[[2]][[6]]), by=1), size)
class(long)
long <- as.data.frame(long)
head(long)

#Store as data frame for all coordinates
final_coord <- cbind(geo, lat, long)
final_coord$geo <- as.character(final_coord$geo)
final_coord$lat <- as.numeric(as.character(final_coord$lat))
final_coord$long <- as.numeric(as.character(final_coord$long))

#Save final data set in excel .csv file
write.csv(final_coord, "GeoLocations.csv", row.names = FALSE)
######################################################################