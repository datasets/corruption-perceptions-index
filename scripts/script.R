require("xlsx")
require("rvest")

dir.create("data")

#There is no consistent storage of files containing CPI data
#We need to reference them individually, for each year
#And to process them individually
#Hence the code below is somewhat repetitive, though slightly different

url2014<-"http://files.transparency.org/content/download/1857/12438/file/CPI2014_DataBundle.zip"
url2013<-"http://files.transparency.org/content/download/702/3015/file/CPI2013_DataBundle.zip"
url2012<-"http://files.transparency.org/content/download/533/2213/file/2012_CPI_DataPackage.zip"
url2011<-"http://files.transparency.org/content/download/313/1264/file/CPI2011_DataPackage.zip"
url2010<-"http://files.transparency.org/content/download/426/1752/CPI+2010+results_pls_standardized_data.xls"
#Before year 2009, HTML pages pages to be scraped
#The base url is http://www.transparency.org/research/cpi/cpi_XXXX
#where XXXX stands for the year (between 1998 and 2009)

#2014
tryCatch({
    message("Downloading and extracting CPI data 2014")
  download.file(url2014,"CPI2014_DataBundle.zip")
  unzip("CPI2014_DataBundle.zip")
  all_data<-read.xlsx("CPI2014_DataBundle/CPI 2014_Regional with data source scores_final.xlsx", sheetIndex = 1,stringsAsFactors=F)
  subset_data2014<-all_data[-c(1,2),c(2,6)]
  subset_data2014[,1]<-sub(",","",subset_data2014[,1])
  colnames(subset_data2014)<-c("Country/Territory","CPI")
  write.csv(subset_data2014,"data/CPI2014.csv",quote=F,row.names=F)
  message("CPI data 2014 succesfully downloaded and saved in data/CPI2014.csv")
}, warning = function(cond) {
    message("CPI data 2014 caused a warning:")
    message(cond)
}, error = function(cond) {
    message("CPI data 2014 caused an error:")
    message(cond)
})
#2013
tryCatch({
    message("Downloading and extracting CPI data 2013")
    download.file(url2013,"CPI2013_DataBundle.zip")
  unzip("CPI2013_DataBundle.zip")
  all_data<-read.xlsx("CPI2013_DataBundle/CPI2013_GLOBAL_WithDataSourceScores.xls", sheetIndex = 1, stringsAsFactors=F)
  subset_data2013<-all_data[-1,c(2,7)]
  subset_data2013[,1]<-sub(",","",subset_data2013[,1])
  colnames(subset_data2013)<-c("Country/Territory","CPI")
  write.csv(subset_data2013,"data/CPI2013.csv",quote=F,row.names=F)
  message("CPI data 2013 succesfully downloaded and saved in data/CPI2013.csv")
}, warning = function(cond) {
    message("CPI data 2013 caused a warning:")
    message(cond)
}, error = function(cond) {
    message("CPI data 2013 caused an error:")
    message(cond)
})
#2012
tryCatch({
    message("Downloading and extracting CPI data 2012")
    download.file(url2012,"2012_CPI_DataPackage.zip")
  unzip("2012_CPI_DataPackage.zip")
  all_data<-read.xlsx("2012_CPI_DataPackage/CPI2012_Results.xls", sheetIndex = 1, stringsAsFactors=F)
  subset_data2012<-all_data[-1,c(2,4)]
  subset_data2012[,1]<-sub(",","",subset_data2012[,1])
  colnames(subset_data2012)<-c("Country/Territory","CPI")
  write.csv(subset_data2012,"data/CPI2012.csv",quote=F,row.names=F)
  message("CPI data 2012 succesfully downloaded and saved in data/CPI2012.csv")
}, warning = function(cond) {
    message("CPI data 2012 caused a warning:")
    message(cond)
}, error = function(cond) {
    message("CPI data 2012 caused an error:")
    message(cond)
})
#2011
tryCatch({
    message("Downloading and extracting CPI data 2011")
    download.file(url2011,"CPI2011_DataPackage.zip")
  unzip("CPI2011_DataPackage.zip")
  #Below, if sheetIndex data is used, wrong CPI data are returned. Use of sheetName works. Not sure why.
  all_data<-read.xlsx2("CPI2011_DataPackage/CPI2011_Results.xls", sheetName = "Global", stringsAsFactors=F)
  subset_data2011<-all_data[-1,c(2,3)]
  subset_data2011[,1]<-sub(",","",subset_data2011[,1])
  colnames(subset_data2011)<-c("Country/Territory","CPI")
  write.csv(subset_data2011,"data/CPI2011.csv",quote=F,row.names=F)
  message("CPI data 2011 succesfully downloaded and saved in data/CPI2011.csv")
}, warning = function(cond) {
    message("CPI data 2011 caused a warning:")
    message(cond)
}, error = function(cond) {
    message("CPI data 2011 caused an error:")
    message(cond)
})
#2010
tryCatch({
    message("Downloading and extracting CPI data 2010")
    download.file(url2010,"CPI2010.xls")
  all_data<-read.xlsx("CPI2010.xls", sheetIndex = 1, stringsAsFactors=F)
  subset_data2010<-all_data[-c(1:3),c(2,3)]
  colnames(subset_data2010)<-c("Country/Territory","CPI")
  subset_data2010[,1]<-sub(",","",subset_data2010[,1])
  write.csv(subset_data2010,"data/CPI2010.csv",quote=F,row.names=F)
  message("CPI data 2010 succesfully downloaded and saved in data/CPI2010.csv")
}, warning = function(cond) {
    message("CPI data 2010 caused a warning:")
    message(cond)
}, error = function(cond) {
    message("CPI data 2010 caused an error:")
    message(cond)
})
#For 1998:2009 
#The format of each page is stable enough for a function
#to extract the table from the page url
getCPITableFromWebPage<-function(url) {
  webpage<-html(url)
  #Trick there as countries/CPI may be shifted by one column
  col1<-html_text(html_nodes(webpage, "td:nth-child(1)"))
  col2<-html_text(html_nodes(webpage, "td:nth-child(2)"))
  col3<-html_text(html_nodes(webpage, "td:nth-child(3)"))
  #If what we get in second column is not numeric, columns must be shifted
  countries<-col1[is.na(as.numeric(col1))]
  to_shift<-which(!is.na(as.numeric(col2)))
  col3[to_shift]<-col2[to_shift]
  col2[to_shift]<-countries
  subset_data<-cbind(col2,col3)
  colnames(subset_data)<-c("Country/Territory","CPI")
  subset_data
}

for (year in 1998:2009) {
    message(paste0("Downloading and extracting CPI data ",year))
        url<-paste("http://www.transparency.org/research/cpi/cpi_",year,sep="")
  filename<-paste0("data/CPI",year,".csv")
  data<-getCPITableFromWebPage(url)
  data[,1]<-sub(",","",data[,1])
  write.csv(data,filename,quote=c(1),row.names=F)
  message(paste0("CPI data ",year," succesfully downloaded and saved in data/CPI",year,".csv"))
}
