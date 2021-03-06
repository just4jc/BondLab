  # Bond Lab is a software application for the analysis of 
  # fixed income securities it provides a suite of applications
  # mortgage backed, asset backed securities, and commerical mortgage backed 
  # securities Copyright (C) 2016  Bond Lab Technologies, Inc.
  # 
  # This program is free software: you can redistribute it and/or modify
  # it under the terms of the GNU General Public License as published by
  # the Free Software Foundation, either version 3 of the License, or
  # (at your option) any later version.
  # 
  # This program is distributed in the hope that it will be useful,
  # but WITHOUT ANY WARRANTY; without even the implied warranty of
  # MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  # GNU General Public License for more details.  
  #
  # You should have received a copy of the GNU General Public License
  # along with this program.  If not, see <http://www.gnu.org/licenses/>.

  setGeneric("BondBasisConversion", function(issue.date, 
                                             start.date, 
                                             end.date, 
                                             settlement.date,
                                             lastpmt.date,
                                             nextpmt.date)
  {standardGeneric("BondBasisConversion")})
  

  #----------------------------
  #Bond basis function This function set the interest payment day count basis 
  #----------------------------
  # Note use switch to add additional basis default will be 30/360

  #' Functions to convert bond payments to their interest payment basis
  #' 
  #' Conversion for payment date (currently 30/360 is supported)
  #' @param issue.date A character value the issue date of the security
  #' @param start.date A character value the start date for interest payment
  #'  (dated date)
  #' @param end.date A character value the final payment date
  #' @param settlement.date A character value the settlement date
  #' @param lastpmt.date  A character value the last payment date to the investor
  #' @param nextpmt.date A character value the next payment date to the investor
  #' @param type a character vector the interest basis day count type
  #' @importFrom lubridate year
  #' @importFrom lubridate month
  #' @export
  BondBasisConversion <- function(issue.date, 
                                  start.date, 
                                  end.date, 
                                  settlement.date,
                                  lastpmt.date, 
                                  nextpmt.date,
                                  type){
  # This function converts day count to bond U.S. Bond Basis 30/360 day count
  #  calculation. It returns the number of payments that will be received, 
  #  period, and n for discounting
  # issue.date is the issuance date of the bond
  # start.date is the dated date of the bond
  # end.date is the maturity date of the bond
  # settlement.date is the settlement date of the bond
  # lastpmt.date is the last coupon payment date
  # nextpmt.date is the next coupon payment date
    
  d1 <- if(settlement.date == issue.date) {day(issue.date)
    } else {day(settlement.date)}    
  m1 <- if(settlement.date == issue.date) {month(issue.date)
    } else {month(settlement.date)}
  y1 <- if(settlement.date == issue.date) {year(issue.date)
    } else {year(settlement.date)}
  d2 <- day(nextpmt.date)
  m2 <- month(nextpmt.date)
  y2 <- year(nextpmt.date)
  
  switch(type,
  "30360" = (max(0, 30 - d1) + min(30, d2) + 360*(y2-y1) + 30*(m2-m1-1))/360,
  "Actual360" = difftime(nextpmt.date, settlement.date, units = "days")/360
  ) # end of switch function
  } # end of function
