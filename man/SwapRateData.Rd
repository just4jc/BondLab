% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/SwapRateData.R
\name{SwapRateData}
\alias{SwapRateData}
\title{A function to read and convert a .csv data file of swap rates from the 
Federal Reseve to rates data}
\usage{
SwapRateData(datafile = "character", maturityvector = numeric())
}
\arguments{
\item{datafile}{A ccharacter vector the path to the .csv of rates data 
for see RatesData.csv in the RateData folder for the proper strucutre}

\item{maturityvector}{A numeric vector maturities corresponding to the 
tenors in RateData.csv.  Note the maturity 
vector must start with an empty space e.g. c("", 1, 2, ).  Set the working 
directory to the directory holding the 
rates data}
}
\description{
The function converts a .csv file of rates data to yield curve objects 
that can be read by the Term Structure wapper
}
\examples{
\dontrun{
SwapRateData(datafile = paste(system.file(package = "BondLab"), 
"/RatesData/20150911.csv", sep = "". header = TRUE),
maturity = c("",.0833, .25, .5, 1, 2, 3, 4, 5, 7, 10, 30))}
}

