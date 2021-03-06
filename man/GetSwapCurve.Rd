% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/GetSwapCurve.R
\name{GetSwapCurve}
\alias{GetSwapCurve}
\title{A function to call swap curve data from the St. Louis Federal Reserve
(FRED) database.  Full swap curve data is reported with a lag of 
approximately four days due to delayed reporting of LIBOR rates by ICE}
\usage{
GetSwapCurve(CurveDate = "character")
}
\arguments{
\item{CurveDate}{a character the swap curve date}
}
\description{
A function to call swap curve data from the St. Louis Federal Reserve
(FRED) database.  Full swap curve data is reported with a lag of 
approximately four days due to delayed reporting of LIBOR rates by ICE
}

