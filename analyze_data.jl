#! /usr/bin/env julia

###############################################################################
# this script will plot corruption perceptions index (cpi) data for 1998-2011 
# and 2012-2015. packages and globals below. 
###############################################################################

using DataFrames
using Gadfly

filename = "data/cpi.csv"
mkpath("plots")


###############################################################################
# read in data, melt it, and split into groups for before and after 2012. 
###############################################################################

data = readtable(filename)
#data_names = convert(Array{ASCIIString, 1}, 
#                     [ string(name)[2:end] for name in names(data)[2:end] ])
#unshift!(data_names, "Jurisdiction")
#data_names = convert(Array{Symbol, 1}, data_names)
data_m = melt(data, :Jurisdiction)
data_m[:variable] = [ parse(Int, string(data_m[:variable][idx])[2:end]) 
                      for idx in 1:length(data_m[:variable]) ]

# procedure for calculating cpi changed in 2012. 
data_after = data_m[data_m[:variable] .> 2011, :]
data_before = data_m[data_m[:variable] .<= 2011, :]

# average cpi over time.
data_before_stats = by(data_before[!isna(data_before[:value]), :], :variable, 
                       df -> DataFrame(StdDev=std(df[:value]), 
                                       Mean=mean(df[:value])))

data_after_stats = by(data_after[!isna(data_after[:value]), :], :variable, 
                      df -> DataFrame(StdDev=std(df[:value]), 
                                      Mean=mean(df[:value])))


###############################################################################
# generate plots.
###############################################################################

Gadfly.push_theme(:dark)

# density plots.
p = plot(data_before[complete_cases(data_before), :], 
         x=:value, color=:variable, 
			Geom.density, 
                        Guide.xlabel("Corruption Perceptions Index"), Guide.ylabel("Density"))
draw(SVG("plots/cpi_density_before_2012.svg", 24cm, 12cm), p)

p = plot(data_after[complete_cases(data_after), :], 
         x=:value, color=:variable, 
			Geom.density,
                        Guide.xlabel("Corruption Perceptions Index"), Guide.ylabel("Density"))
draw(SVG("plots/cpi_density_after_2012.svg", 24cm, 12cm), p)

# plot average cpi +- std dev over time.
p = plot(data_before_stats, x=:variable, y=:Mean, Geom.line, Geom.point, 
         ymin=data_before_stats[:Mean] - data_before_stats[:StdDev],
         ymax=data_before_stats[:Mean] + data_before_stats[:StdDev],
         Guide.xlabel("Year"), Guide.ylabel("CPI"), 
         Guide.title("Average CPI over Time"), Geom.ribbon,
         Coord.Cartesian(xmin=minimum(data_before_stats[:variable]), 
                         xmax=maximum(data_before_stats[:variable])))
draw(SVG("plots/cpi_stats_before_2012.svg", 24cm, 12cm), p)

p = plot(data_after_stats, x=:variable, y=:Mean, Geom.line, Geom.point, 
         ymin=data_after_stats[:Mean] - data_after_stats[:StdDev],
         ymax=data_after_stats[:Mean] + data_after_stats[:StdDev],
         Guide.xlabel("Year"), Guide.ylabel("CPI"), 
         Guide.title("Average CPI over Time"), Geom.ribbon,
         Coord.Cartesian(xmin=minimum(data_after_stats[:variable]), 
                         xmax=maximum(data_after_stats[:variable])))
draw(SVG("plots/cpi_stats_after_2012.svg", 24cm, 12cm), p)


#p = plot(data_m[complete_cases(data_m), :], 
#         x=:variable, y=:value, color=:Jurisdiction, Geom.point, 
#         Guide.xlabel("Year"), Guide.ylabel("Corruption Index"), 
#         Theme(key_max_columns=7, key_position=:none ))

#p = plot(data_before[complete_cases(data_before), :], 
#         x=:variable, y=:value, color=:Jurisdiction, Geom.line, 
#         Guide.xlabel("Year"), Guide.ylabel("Corruption Index"), 
#         Theme(key_max_columns=7, key_position=:none ))

#p = plot(data_after[complete_cases(data_after), :], 
#         x=:variable, y=:value, color=:Jurisdiction, Geom.line, 
#         Guide.xlabel("Year"), Guide.ylabel("Corruption Index"), 
#         Theme(key_max_columns=7, key_position=:none ))

# heatmaps?
#p = plot(data_before[complete_cases(data_before), :], 
#         x=:variable, y=:Jurisdiction, color=:value, Geom.rectbin, 
#         Guide.xlabel("Year"), Guide.ylabel("Country") ) 

#p = plot(data_after[complete_cases(data_after), :], 
#         x=:variable, y=:Jurisdiction, color=:value, Geom.rectbin, 
#         Guide.xlabel("Year"), Guide.ylabel("Country") ) 

# histogram.
#p = plot(data_before[complete_cases(data_before), :], 
#         x=:value, color=:variable, 
#         x=:value, color=[string(var) for var in data_before[:variable]], 
#         Geom.histogram, 
#         Guide.xlabel("Corruption Perceptions Index"), Guide.ylabel("Density"))

#p = plot(data_after[complete_cases(data_after), :], 
#         x=:value, color=:variable, 
#         x=:value, color=[string(var) for var in data_after[:variable]], 
#         Geom.histogram, 
#         Guide.xlabel("Corruption Perceptions Index"), Guide.ylabel("Density"))
