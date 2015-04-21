Corruption Perceptions Index (CPI) as issued yearly by Transparency International. 

##Data

The data is sourced from [Transparency International](http://www.transparency.org/research/cpi/overview). 

> The Corruption Perceptions Index (CPI) ranks countries/territories in terms of the degree to which corruption is perceived to exist among public officials and politicians. It draws on different assessments and business opinion surveys carried out by independent and reputable institutions. It captures information about the administrative and political aspects of corruption. Broadly speaking, the surveys and assessments used to compile the index include questions relating to bribery of public officials, kickbacks in public procurement, embezzlement of public funds, and questions that probe the strength and effectiveness of public sector anti-corruption efforts. 


Note: The scale of the CPI is 0-10 from 1998 to 2011, and 0-100 from 2012 onwards, due to an update to the methodology used to calculate the CPI in 2012. Because of the update in the methodology, CPI scores before 2012 are not comparable over time. 

More information about the index and methodology can be found [here](http://www.transparency.org/cpi2014/in_detail)

### data/allCPI.csv

CPI for each country (rows) over the years 1998-2014 (columns)

## Preparation

This package includes an R script (scripts/script.R) to download files from the Transparency International website, to convert them in CSV format, and to merge
the files in a common allCPI.csv file.

Some manual editing was finally made to merge countries whose naming is not consistent over the years (e.g., Trinidad & Tobago, Trinidad and Tobago).

## License

This Data Package is licensed by its maintainers under the [Public Domain Dedication and License (PDDL)](http://opendatacommons.org/licenses/pddl/1.0/).

Note that underlying rights, terms and conditions in the data from the source are unclear and may exist.



