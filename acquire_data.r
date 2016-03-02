#! /usr/bin/env Rscript

require("xlsx")
require("rvest")


###############################################################################
# all CPI data files will be stored in data/, and all raw xlsx files in 
# archive/.
###############################################################################

dir.create("data")
dir.create("archive")


###############################################################################
# cpi data must be downloaded individually because there is no standard api. 
###############################################################################

url2015<-"http://files.transparency.org/content/download/1950/12812/file/2015_CPI_DataMethodologyZIP.zip"
url2014<-"http://files.transparency.org/content/download/1857/12438/file/CPI2014_DataBundle.zip"
url2013<-"http://files.transparency.org/content/download/702/3015/file/CPI2013_DataBundle.zip"
url2012<-"http://files.transparency.org/content/download/533/2213/file/2012_CPI_DataPackage.zip"
url2011<-"http://files.transparency.org/content/download/313/1264/file/CPI2011_DataPackage.zip"
url2010<-"http://files.transparency.org/content/download/426/1752/CPI+2010+results_pls_standardized_data.xls"

# 2015
tryCatch({
	message("downloading and extracting cpi data 2015")
	download.file(url2015, "archive/2015_CPI_DataMethodologyZIP.zip")
	unzip("archive/2015_CPI_DataMethodologyZIP.zip", exdir="archive")
	all_data<-read.xlsx("archive/Data & methodology/Data/CPI 2015_data.xlsx", 
	                    sheetIndex = 1, stringsAsFactors=F)
	subset_data2015<-all_data[-c(1,170,171), c(3,2)]
	subset_data2015[,1]<-sub(",", "", subset_data2015[,1])
	colnames(subset_data2015)<-c("Jurisdiction","CPI")
	write.csv(subset_data2015, "archive/CPI2015.csv", quote=F, row.names=F)
	message("cpi data 2015 succesfully downloaded and saved in archive/CPI2015.csv")
}, warning = function(cond) {
	message("cpi data 2015 caused a warning:")
	message(cond)
}, error = function(cond) {
	message("cpi data 2015 caused an error:")
	message(cond)
})

# 2014
tryCatch({
	message("downloading and extracting cpi data 2014")
	download.file(url2014, "archive/CPI2014_DataBundle.zip")
	unzip("archive/CPI2014_DataBundle.zip", exdir="archive")
	all_data<-read.xlsx("archive/CPI2014_DataBundle/CPI 2014_Regional with data source scores_final.xlsx", 
	                    sheetIndex = 1, stringsAsFactors=F)
	subset_data2014<-all_data[-c(1,2), c(2,6)]
	subset_data2014[,1]<-sub(",", "", subset_data2014[,1])
	colnames(subset_data2014)<-c("Jurisdiction","CPI")
	write.csv(subset_data2014, "archive/CPI2014.csv", quote=F, row.names=F)
	message("cpi data 2014 succesfully downloaded and saved in archive/CPI2014.csv")
}, warning = function(cond) {
	message("cpi data 2014 caused a warning:")
	message(cond)
}, error = function(cond) {
	message("cpi data 2014 caused an error:")
	message(cond)
})

# 2013
tryCatch({
	message("downloading and extracting cpi data 2013")
	download.file(url2013, "archive/CPI2013_DataBundle.zip")
	unzip("archive/CPI2013_DataBundle.zip", exdir="archive")
	all_data<-read.xlsx("archive/CPI2013_DataBundle/CPI2013_GLOBAL_WithDataSourceScores.xls", 
	                    sheetIndex = 1, stringsAsFactors=F)
	subset_data2013<-all_data[-1, c(2,7)]
	subset_data2013[,1]<-sub(",", "", subset_data2013[,1])
	colnames(subset_data2013)<-c("Jurisdiction", "CPI")
	write.csv(subset_data2013, "archive/CPI2013.csv", quote=F, row.names=F)
	message("cpi data 2013 succesfully downloaded and saved in archive/CPI2013.csv")
}, warning = function(cond) {
	message("cpi data 2013 caused a warning:")
	message(cond)
}, error = function(cond) {
	message("cpi data 2013 caused an error:")
	message(cond)
})

# 2012
tryCatch({
	message("downloading and extracting cpi data 2012")
	download.file(url2012, "archive/2012_CPI_DataPackage.zip")
	unzip("archive/2012_CPI_DataPackage.zip", exdir="archive")
	all_data<-read.xlsx("archive/2012_CPI_DataPackage/CPI2012_Results.xls", 
	                    sheetIndex = 1, stringsAsFactors=F)
	subset_data2012<-all_data[-1, c(2,4)]
	subset_data2012[,1]<-sub(",", "", subset_data2012[,1])
	colnames(subset_data2012)<-c("Jurisdiction", "CPI")
	write.csv(subset_data2012, "archive/CPI2012.csv", quote=F, row.names=F)
	message("cpi data 2012 succesfully downloaded and saved in archive/CPI2012.csv")
}, warning = function(cond) {
	message("cpi data 2012 caused a warning:")
	message(cond)
}, error = function(cond) {
	message("cpi data 2012 caused an error:")
	message(cond)
})

# 2011
tryCatch({
	message("downloading and extracting cpi data 2011")
	download.file(url2011, "archive/CPI2011_DataPackage.zip")
	unzip("archive/CPI2011_DataPackage.zip", exdir="archive")
	# below, if sheetIndex data is used, wrong cpi data are returned. 
	# use of sheetName works. not sure why.
	all_data<-read.xlsx2("archive/CPI2011_DataPackage/CPI2011_Results.xls", 
	                     sheetName = "Global", stringsAsFactors=F)
	subset_data2011<-all_data[-1, c(2,3)]
	subset_data2011[,1]<-sub(",", "", subset_data2011[,1])
	colnames(subset_data2011)<-c("Jurisdiction","CPI")
	write.csv(subset_data2011, "archive/CPI2011.csv", quote=F, row.names=F)
	message("cpi data 2011 succesfully downloaded and saved in archive/CPI2011.csv")
}, warning = function(cond) {
	message("cpi data 2011 caused a warning:")
	message(cond)
}, error = function(cond) {
	message("cpi data 2011 caused an error:")
	message(cond)
})

# 2010
tryCatch({
	message("downloading and extracting cpi data 2010")
	download.file(url2010, "archive/CPI2010.xls")
	all_data<-read.xlsx("archive/CPI2010.xls", sheetIndex = 1, stringsAsFactors=F)
	subset_data2010<-all_data[-c(1:3), c(2,3)]
	colnames(subset_data2010)<-c("Jurisdiction","CPI")
	subset_data2010[,1]<-sub(",", "", subset_data2010[,1])
	write.csv(subset_data2010,"archive/CPI2010.csv", quote=F, row.names=F)
	message("cpi data 2010 succesfully downloaded and saved in archive/CPI2010.csv")
}, warning = function(cond) {
	message("cpi data 2010 caused a warning:")
	message(cond)
}, error = function(cond) {
	message("cpi data 2010 caused an error:")
	message(cond)
})


###############################################################################
# before 2009, html pages needs to be scraped. the base url is 
# http://www.transparency.org/research/cpi/cpi_YEAR, where YEAR is between 1998 
# and 2009. 
###############################################################################

# 1998-2009 
getCPITableFromWebPage<-function(url) {
	webpage<-read_html(url)
	# trick there as countries/cpi may be shifted by one column
	col1<-html_text(html_nodes(webpage, "td:nth-child(1)"))
	col2<-html_text(html_nodes(webpage, "td:nth-child(2)"))
	col3<-html_text(html_nodes(webpage, "td:nth-child(3)"))
	# if what we get in second column is not numeric, columns must be shifted
	countries<-col1[which(regexpr("[0-9]+", col1)== -1)]
	to_shift<-which(regexpr("[0-9\\.]+", col2)== 1)
	col3[to_shift]<-col2[to_shift]
	col2[to_shift]<-countries
	# some decimals are represented as ',' instead of '.'
	col3<-sub(",", ".", col3)
	subset_data<-cbind(col2, as.numeric(col3))
	colnames(subset_data)<-c("Jurisdiction","CPI")
	subset_data
}

for (year in 1998:2009) {
	message(paste0("downloading and extracting cpi data ", year))
	url<-paste("http://www.transparency.org/research/cpi/cpi_", year, sep="")
	filename<-paste0("archive/CPI", year, ".csv")
	data<-getCPITableFromWebPage(url)
	data[,1]<-sub(",", "", data[,1])
	write.csv(data, filename, quote=c(1), row.names=F)
	message(paste0("cpi data ", year, " succesfully downloaded and saved in data/CPI", year, ".csv"))
}


###############################################################################
# merge all tables to have the cpi for each country (rows) over the years 
# 1998-2015 (columns).
###############################################################################

listFiles<-list()

for (year in 1998:2015) {
	data<-read.csv(paste0("archive/CPI", year, ".csv"), stringsAsFactor=F, header=T)
	listFiles<-c(listFiles, list(data))
}

countries<-c()
for (i in 1:length(listFiles)) countries<-c(countries, listFiles[[i]][,1])
	countries<-sort(unique(countries))

CPI<-as.data.frame(countries)


###############################################################################
# scan each, and get the list of countries for that file. then, take all 
# unique names given to countries ver the years 1998-2015, and match cpi score 
# accordingly
###############################################################################

for (i in 1:length(listFiles)) {
	countries.i<-listFiles[[i]][,1]
	tt<-which(countries.i==7)
	if (length(tt)>0) print(i)
		match.countries<-match(countries.i,CPI[,1])
	CPI<-cbind(CPI, rep(NA, nrow(CPI)))
	CPI[match.countries,i+1]<-round(listFiles[[i]][,2], digits=2)
}


###############################################################################
# set column names and save.
###############################################################################

colnames(CPI)<-c("Jurisdiction",1998:2015)
write.csv(CPI, file="data/cpi.csv", quote=c(1), row.names=F)
