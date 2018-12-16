import io
import urllib
import zipfile
from urllib.request import urlopen

import numpy as np
import pandas as pd
import requests
from PyPDF2 import PdfFileReader
from bs4 import BeautifulSoup
from dataflows import Flow, dump_to_path, printer, PackageWrapper, ResourceWrapper

first_year = 1995
last_year = 2017


def generate_data_from_excel_via_zip_url(url, excel_location, cpi_year, country_name_column, cpi_value_column, usecols,
                                         skiprows, sheet_name, divide_by_10=False):
    excel_file = io.BytesIO(zipfile.ZipFile(io.BytesIO(urllib.request.urlopen(url).read())).read(excel_location))
    return generate_from_excel(excel_file, cpi_year, country_name_column, cpi_value_column, usecols, skiprows,
                               sheet_name, divide_by_10)


def generate_data_from_excel_via_url(url, cpi_year, country_name_column, cpi_value_column, usecols, skiprows,
                                     sheet_name, divide_by_10=False):
    return generate_from_excel(urlopen(url), cpi_year, country_name_column, cpi_value_column, usecols, skiprows,
                               sheet_name, divide_by_10)


def generate_from_excel(excel_file, cpi_year, country_name_column, cpi_value_column, usecols, skiprows, sheet_name,
                        divide_by_10):
    output = {}
    df = pd.read_excel(excel_file, usecols=usecols, skiprows=skiprows, sheet_name=sheet_name)
    for index, row in df.iterrows():
        country_name = str(row[country_name_column])
        cpi_value = str(row[cpi_value_column] / 10.0 if divide_by_10 else row[cpi_value_column])
        if country_name != 'nan':
            output[country_name] = [cpi_value, cpi_year]

    return output


def generate_data_from_pdf_1995():
    with open('../archiv/1995_CPI_EN.pdf', 'rb') as f:
        table_found = 0
        list_of_countries = []
        country = []
        info_found = 0
        country_name = ''

        pdf = PdfFileReader(f)
        page_text = pdf.getPage(4).extractText()
        for word in page_text.split(' '):
            if "Country" in word:
                table_found += 1
                continue
            elif "Score" in word:
                table_found += 1
                continue
            elif "Surveys" in word:
                table_found += 1
                continue
            elif "Variance" in word:
                table_found += 1
                continue

            if table_found == 4:
                if not word.replace('.', '').isdigit():
                    if country_name:
                        country_name = country_name + ' ' + word
                    else:
                        country_name = word

                    if len(country) != 0:
                        country[0] = country_name
                    else:
                        country.append(country_name.strip())
                    info_found = 1
                else:
                    country.append(word.strip())
                    country_name = ''
                    info_found += 1

                if info_found == 4:
                    list_of_countries.append(country)
                    country = []
                    info_found = 0

        output = {}
        for name_value in list_of_countries:
            output[name_value[0]] = [name_value[1], 1995]

        return output


def generate_data_from_pdf_1996():
    with open('../archiv/1996_CPI_EN.pdf', 'rb') as f:
        pdf = PdfFileReader(f)

        table_found = False
        country_name = ''
        country = []
        list_of_countries = []
        info_found = -100
        for page_number in [0, 1]:
            page_text = pdf.getPage(page_number).extractText()
            for word in page_text.split(' '):
                if '1' == word or '17' == word:
                    table_found = True

                if table_found:
                    if not word.replace(',', '').isdigit() and word:
                        if country_name:
                            country_name = country_name + ' ' + word
                        else:
                            country_name = word

                        country = [country_name.strip()]

                        info_found = 1
                    else:
                        country.append(word.strip())
                        country_name = ''
                        info_found += 1

                    if info_found == 2:
                        list_of_countries.append(country)
                        country = []
                        info_found = -100

            table_found = False

        output = {}
        for name_value in list_of_countries:
            output[name_value[0]] = [name_value[1], 1996]

        return output


def generate_data_from_pdf_1997():
    with open('../archiv/1997_CPI_EN.pdf', 'rb') as f:
        pdf = PdfFileReader(f)

        table_found = False
        country_name = ''
        country = []
        list_of_countries = []
        info_found = -100
        for page_number in [5, 6]:
            page_text = pdf.getPage(page_number).extractText()
            for word in page_text.split(' '):
                if '1' == word or '43' == word:
                    table_found = True

                if table_found:
                    if not word.replace(',', '').isdigit() and word and word != '---':
                        if country_name:
                            country_name = country_name + ' ' + word
                        else:
                            country_name = word

                        country = [country_name.strip()]

                        info_found = 1
                    else:
                        country.append(word.strip())
                        country_name = ''
                        info_found += 1

                    if info_found == 2:
                        list_of_countries.append(country)
                        country = []
                        info_found = -100

                    if 'How' == word:
                        break

            table_found = False

        output = {}
        for name_value in list_of_countries:
            output[name_value[0]] = [name_value[1], 1997]

        return output


def scrape_website_table(url):
    page = requests.get(url)
    soup = BeautifulSoup(page.content, 'html.parser')
    headers = []
    output = {}
    cpi_year = int(url.split("/")[len(url.split("/")) - 2].split('_')[1])

    for table in soup.find_all('table'):
        if table.get('class')[0] == 'simple':
            for th in table.thead.tr.find_all('th'):
                headers.append(th.text)

            for tr in table.tbody.find_all('tr'):
                values = tr.find_all('td')
                if not values:
                    continue

                if values[0].text.strip() and values[0].text.strip().isdigit():
                    country_name = values[1].text
                    cpi_value = values[2].text

                else:
                    country_name = values[0].text
                    cpi_value = values[1].text

                if country_name.strip():
                    output[country_name] = [cpi_value, cpi_year]

    return output


def generate_data():
    total_output = []
    total_output.append(generate_data_from_pdf_1995())
    total_output.append(generate_data_from_pdf_1996())
    total_output.append(generate_data_from_pdf_1997())
    total_output.append(scrape_website_table('https://www.transparency.org/research/cpi/cpi_1998/0'))
    total_output.append(scrape_website_table('https://www.transparency.org/research/cpi/cpi_1999/0'))
    total_output.append(scrape_website_table('https://www.transparency.org/research/cpi/cpi_2000/0'))
    total_output.append(scrape_website_table('https://www.transparency.org/research/cpi/cpi_2001/0'))
    total_output.append(scrape_website_table('https://www.transparency.org/research/cpi/cpi_2002/0'))
    total_output.append(scrape_website_table('https://www.transparency.org/research/cpi/cpi_2003/0'))
    total_output.append(scrape_website_table('https://www.transparency.org/research/cpi/cpi_2004/0'))
    total_output.append(scrape_website_table('https://www.transparency.org/research/cpi/cpi_2005/0'))
    total_output.append(scrape_website_table('https://www.transparency.org/research/cpi/cpi_2006/0'))
    total_output.append(scrape_website_table('https://www.transparency.org/research/cpi/cpi_2007/0'))
    total_output.append(scrape_website_table('https://www.transparency.org/research/cpi/cpi_2008/0'))
    total_output.append(scrape_website_table('https://www.transparency.org/research/cpi/cpi_2009/0'))
    total_output.append(generate_data_from_excel_via_url(
                        url='http://files.transparency.org/content/download/426/1752/CPI+2010'
                            '+results_pls_standardized_data.xls',
                        cpi_year=2010,
                        country_name_column='country',
                        cpi_value_column='cpi2010',
                        usecols=[1, 2],
                        skiprows=3,
                        sheet_name=0
                    ))
    total_output.append(generate_data_from_excel_via_zip_url(
            url='http://files.transparency.org/content/download/313/1264/file/CPI2011_DataPackage.zip',
            excel_location='CPI2011_DataPackage/CPI2011_Results.xls',
            cpi_year=2011,
            country_name_column='Country / Territory',
            cpi_value_column='CPI 2011 Score',
            usecols=[1, 2],
            skiprows=0,
            sheet_name='Global'
        ))
    total_output.append(generate_from_excel(
            excel_file='../archiv/CPI2012.xlsx',
            cpi_year=2012,
            country_name_column='Country / Territory',
            cpi_value_column='CPI 2012 Score',
            usecols=[1, 3],
            skiprows=0,
            sheet_name='CPI 2012',
            divide_by_10=True
        ))
    total_output.append(generate_data_from_excel_via_zip_url(
            url='http://files.transparency.org/content/download/702/3015/file/CPI2013_DataBundle.zip',
            excel_location='CPI2013_DataBundle/CPI2013_GLOBAL_WithDataSourceScores.xls',
            cpi_year=2013,
            country_name_column='Country / Territory',
            cpi_value_column='CPI 2013 Score',
            usecols=[1, 6],
            skiprows=1,
            sheet_name='CPI 2013',
            divide_by_10=True
        ))
    total_output.append(generate_data_from_excel_via_zip_url(
            url='http://files.transparency.org/content/download/1857/12438/file/CPI2014_DataBundle.zip',
            excel_location='CPI2014_DataBundle/CPI 2014_FullDataSet.xlsx',
            cpi_year=2014,
            country_name_column='Country/Territory',
            cpi_value_column='CPI 2014',
            usecols=[1, 4],
            skiprows=0,
            sheet_name='CPI 2014',
            divide_by_10=True
        ))
    total_output.append(generate_data_from_excel_via_url(
            url='http://files.transparency.org/content/download/1956/12836/file/2015_CPI_data.xlsx',
            cpi_year=2015,
            country_name_column='Country',
            cpi_value_column='CPI2015',
            usecols=[1, 2],
            skiprows=1,
            sheet_name=0,
            divide_by_10=True
        ))
    total_output.append(generate_data_from_excel_via_url(
            url='http://files.transparency.org/content/download/2155/13635/file/CPI2016_FullDataSetWithRegionalTables'
                '.xlsx',
            cpi_year=2016,
            country_name_column='Country',
            cpi_value_column='CPI2016',
            usecols=[0, 1],
            skiprows=0,
            sheet_name='CPI2016_FINAL_16Jan',
            divide_by_10=True
        ))
    total_output.append(generate_from_excel(
            excel_file='../archiv/CPI2017.xlsx',
            cpi_year=2017,
            country_name_column='Country',
            cpi_value_column='CPI Score 2017',
            usecols=[0, 3],
            skiprows=2,
            sheet_name='CPI 2017',
            divide_by_10=True
        ))

    complete_map = {}
    all_years = []
    for year in total_output:
        # print(year)
        for country in year.keys():
            if year[country][1] not in all_years:
                all_years.append(year[country][1])

            values = np.zeros(last_year - first_year + 1)
            if country not in complete_map:
                complete_map[country] = values
            # print(year)
            complete_map[country][year[country][1] - 1995] = float(year[country][0].replace(',', '.'))

    for key in sorted(complete_map.keys()):
        all_rows = {'country': key.strip()}
        for i, header_year in enumerate(range(first_year, last_year + 1)):
            all_rows[str(header_year)] = str(round(complete_map[key][i], 3))

        # print(all_rows)
        yield all_rows


def change_path(package: PackageWrapper):
    package.pkg.descriptor['resources'][0]['path'] = 'cpi.csv'
    package.pkg.descriptor['resources'][0]['name'] = 'cpi'

    yield package.pkg
    res_iter = iter(package)
    first: ResourceWrapper = next(res_iter)
    yield first.it
    yield from package


Flow(generate_data(),
     change_path,
     dump_to_path('../data'),
     printer()).process()
