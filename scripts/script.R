require("xlsx")
require("dpmr")

download.file("http://data.okfn.org/data/core/country-codes/r/country-codes.csv","country_codes.csv")
country_code<-read.csv("country_codes.csv")

url<-"http://files.transparency.org/content/download/1900/12610/file/CPI2014_ResultsSpreadsheet.xlsx"
if(url.exists(url)) {
  download.file(url,"CPI.xlsx")
  all_data<-read.xlsx("CPI.xlsx", sheetIndex = 1)
  subset_data<-all_data[-c(1,2),c(2,3)]
  colnames(subset_data)<-c("Country/Territory","CPI 2014")
}

meta<-list(
    name="corruption-perceptions-index",
    title="Corruption Perceptions Index (CPI)",
    description="Corruption Perceptions Index (CPI), as reported by Transparency International, since 2001.",
    license=list(
        "type"= "odc-pddl",
        "url"= "http://opendatacommons.org/licenses/pddl/"),
    version="1.0-beta.10",
    last_updated="2015-02-21",
    sources=list(
        "name"= "World Bank and OECD",
        "web"="http://www.transparency.org/cpi2014/"
      ),
    keywords=list("CPI","Transparency International", "Corruption Perceptions Index")
  )

datapackage_init(subset_data,"corruption-perceptions-index",meta,"script.R")


#http://www.transparency.org/cpi2014/results#myAnchor1

#http://files.transparency.org/content/download/1900/12610/file/CPI2014_ResultsSpreadsheet.xlsx

http://files.transparency.org/content/download/1857/12438/file/CPI2014_DataBundle.zip
http://files.transparency.org/content/download/702/3015/file/CPI2013_DataBundle.zip
http://files.transparency.org/content/download/533/2213/file/2012_CPI_DataPackage.zip
http://files.transparency.org/content/download/313/1264/file/CPI2011_DataPackage.zip
http://files.transparency.org/content/download/426/1752/CPI+2010+results_pls_standardized_data.xls
http://www.transparency.org/files/content/tool/2009_CPI_SourcesByCountry.xls
http://www.transparency.org/files/content/tool/2008_CPI_SourcesByCountry.xls



