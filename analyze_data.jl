#! /usr/bin/env julia

###############################################################################
# this script will plot corruption perceptions index (cpi) data for 1998-2011 
# and 2012-2015. packages and globals below. 
###############################################################################

using DataFrames
using Gadfly

filename = "data/cpi.csv"


###############################################################################
# read in data, melt it, and split into groups for before and after 2012. 
###############################################################################

data = readtable(filename)
data_m = melt(data, :Jurisdiction)
data_m[:variable] = [ parse(Int, string(data_m[:variable][idx])[2:end]) for idx in 1:length(data_m[:variable]) ]

# procedure for calculating cpi changed in 2012. 
data_after = data_m[data_m[:variable] .> 2011, :]
data_before = data_m[data_m[:variable] .<= 2011, :]


###############################################################################
# generate plots.
###############################################################################

p = plot(data_m[complete_cases(data_m), :], 
         x=:variable, y=:value, color=:Jurisdiction, Geom.line, 
			Guide.xlabel("Year"), Guide.ylabel("Corruption Index"), 
			Theme(key_max_columns=7, key_position=:none ))

p = plot(data_before[complete_cases(data_before), :], 
         x=:variable, y=:value, color=:Jurisdiction, Geom.line, 
			Guide.xlabel("Year"), Guide.ylabel("Corruption Index"), 
			Theme(key_max_columns=7, key_position=:none ))

p = plot(data_after[complete_cases(data_after), :], 
         x=:variable, y=:value, color=:Jurisdiction, Geom.line, 
			Guide.xlabel("Year"), Guide.ylabel("Corruption Index"), 
			Theme(key_max_columns=7, key_position=:none ))

# heatmaps?
p = plot(data_before[complete_cases(data_before), :], 
         x=:variable, y=:Jurisdiction, color=:value, Geom.rectbin, 
			Guide.xlabel("Year"), Guide.ylabel("Country") ) 

p = plot(data_after[complete_cases(data_after), :], 
         x=:variable, y=:Jurisdiction, color=:value, Geom.rectbin, 
			Guide.xlabel("Year"), Guide.ylabel("Country") ) 

# density plots.
p = plot(data_before[complete_cases(data_before), :], 
         x=:value, color=:variable, 
#         x=:value, color=[string(var) for var in data_before[:variable]], 
			Geom.density, 
			Guide.xlabel("Corruption Perceptions Index"), Guide.ylabel("Density") ) 

p = plot(data_after[complete_cases(data_after), :], 
         x=:value, color=:variable, 
#         x=:value, color=[string(var) for var in data_after[:variable]], 
			Geom.density,
			Guide.xlabel("Corruption Perceptions Index"), Guide.ylabel("Density") ) 

# histogram.
p = plot(data_before[complete_cases(data_before), :], 
         x=:value, color=:variable, 
#         x=:value, color=[string(var) for var in data_before[:variable]], 
			Geom.histogram, 
			Guide.xlabel("Corruption Perceptions Index"), Guide.ylabel("Density") ) 

p = plot(data_after[complete_cases(data_after), :], 
         x=:value, color=:variable, 
#         x=:value, color=[string(var) for var in data_after[:variable]], 
			Geom.histogram, 
			Guide.xlabel("Corruption Perceptions Index"), Guide.ylabel("Density") ) 
