  
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


  # The following script analyzes a pass-through security.  
  # To create the script the standard procedure is followed set class, 
  # set generics, set methods, functions the generics and methods are getters 
  # for the class MortgageCashFlow and the initialize method for the class.  
  # This class is a subclass of the following: (document the superclasses)
  # for the most part this script is requiring only modest changes.
  
  #' @include MBSDetails.R PriceTypes.R CouponTypes.R GWacTypes.R
  #' @include ServicingFeeTypes.R
  NULL
  
  #' An S4 class PassThroughScenarios
  #' 
  #' @slot PrepaymentType A character the prepayment type (i.e. "CPR", "MODEL")
  #' @slot PrepaymentScenario A character prepayment value (i.e. "25", "D25s")
  #' @exportClass PriceYieldScenarioSet
  setClass("PriceYieldScenarioSet",
           representation(
             PrepaymentType = "list",
             PrepaymentScenario = "list"
           ))
  
  setGeneric("PriceYieldScenarioSet", function(PrepaymentType = list(),
                                               PrepaymentScenario = list())
    {standardGeneric("PriceYieldScenarioSet")})
  
  #' A generic functon to access the slot PrepaymentType
  #' 
  #' @param object an S4 class object
  #' @export PrepaymentType
  setGeneric("PrepaymentType", function(object)
    {standardGeneric("PrepaymentType")})
  
  #' A generic function to access the slot PrepaymentScenario
  #' 
  #' @param object an S4 class object
  #' @export PrepaymentScenario
  setGeneric("PrepaymentScenario", function(object)
    {standardGeneric("PrepaymentScenario")})
  
  #' generic function to access both slots of PrepaymentScenario
  #' 
  #' @param object an S4 class object
  #' @param ... optional arguments
  #' @export PriceYieldScenario
  setGeneric("PriceYieldScenario", function(object,...)
    {standardGeneric("PriceYieldScenario")})
  
  setMethod("initialize",
            signature("PriceYieldScenarioSet"),
            function(.Object,
                     PrepaymentType = "list",
                     PrepaymentScenario = "list",
                     ...){
              callNextMethod(.Object,
                             PrepaymentType = PrepaymentType,
                             PrepaymentScenario = PrepaymentScenario,
                             ...)
            }
  )
  
  #' A method to extract the PrepaymentType from class PriceYieldScenarioSet
  #' 
  #' @param object an S4 object of the typre PriceYieldScenarioSet
  #' @exportMethod PrepaymentType
  setMethod("PrepaymentType", signature("PriceYieldScenarioSet"),
            function(object){
              object@PrepaymentType
            })
  
  #' A method to extract the PrepaymentScenario from class PriceYieldScenarioSet
  #'
  #'@param object an S4 object of the type PriceYieldScenarioSet
  #'@exportMethod PrepaymentScenario
  setMethod("PrepaymentScenario", signature("PriceYieldScenarioSet"),
            function(object){
              object@PrepaymentScenario
            })
  
  #' A method to extract a Price/Yield Scenario Pair
  #' 
  #' @param object an S4 object of type PriceYieldScenarioSet
  #' @param scenario an numeric value the location of the scenario
  #' @exportMethod PriceYieldScenario
  setMethod("PriceYieldScenario", signature("PriceYieldScenarioSet"),
            function(object, scenario = numeric()){
              c(object@PrepaymentType[scenario],
                object@PrepaymentScenario[scenario])
            })
  
  #' A function to convert Price Yield data to class PriceYieldScenarioSet
  #' 
  #' @param PrepaymentType a list of the prepayment type
  #' @param PrepaymentScenario a list of the prepayment scenario corresponding
  #' to the prepayment type
  #' @export
  PriceYieldScenarioSet <- function(PrepaymentType = "list",
                                    PrepaymentScenario = "list"){
    new("PriceYieldScenarioSet",
        PrepaymentType = PrepaymentType,
        PrepaymentScenario = PrepaymentScenario)
  }
  
  #' A function to test the validity of PriceYieldScenarioSet object
  #' 
  #' Validity test of the PriceYieldScenarioSet object test if the length
  #' of the PrepaymentType and the PrepaymentScenario are equal
  #' @param object an S4 object of type PriceYieldScenarioSet
  #' @export ValidPriceYieldScenarioSet
  ValidPriceYieldScenarioSet <- function(object){
    if(length(object@PrepaymentType) == length(object@PrepaymentScenario))
       TRUE
       else
      paste("Lengths of PrepaymentType(", length(object@PrepaymentType), ")",
          "and PrepaymentScenario (", length(object@PrepaymentScenario), ")",
          "should be equal", sep = " ")
    }
  
  #' An S4 class MortgageCashFlow containing cashflow data 
  #' for a mortgage pass-through security
  #' 
  #' @slot Price A numeric value the price of the pass-through.
  #' @slot Accrued A numeric value the accrued interest as of settlement date.
  #' @slot YieldToMaturity A numeric value the yield to maturity.
  #' @slot WAL A numeric value the weighted average life of the pass-thorough.
  #' @slot ModDuration A numeric value the Modified Duration pass-through.
  #' @slot Convexity A numeric value the Convexity of the pass-through.
  #' @slot Period A numeric value the period in which the cash-flow is received.
  #' @slot PmtDate A character the date in which the cash-flow is received.
  #' @slot TimePeriod A numeric value the time weight applied to 
  #' the principal cash-flow and discount factors.
  #' @slot BeginningBal A numeric value the Beginning Balance in the period.
  #' @slot MonthlyPmt A numeric value the borrower's monthly payment.
  #' @slot MonthlyInterest A numeric value the borrower's monthly interest.
  #' @slot PassThroughInterest A numeric value the pass-through interest paid
  #' to the investor in the pool.
  #' @slot ScheduledPrin A numeric value scheduled principal due in the period.
  #' @slot PrepaidPrin A numeric value the prepaid principal in the period.
  #' @slot DefaultedPrin A numeric value the default principal in the period.
  #' @slot LossAmount A numeric value the loss amount in the period.
  #' @slot RecoveredAmount A numeric value the recovered amount in the period.
  #' @slot EndingBal A numeric value the ending balance in the period.
  #' @slot ServicingIncome A numeric value the servicing recevied in the period.
  #' @slot PMIPremium A numeric value the PMI paid in the period.
  #' @slot GFeePremium A numeric value the GFee paid in the period.
  #' @slot TotalCashFlow A numeric value the total cashflow paid in the period. 
  #' @exportClass MortgageCashFlow
  setClass("MortgageCashFlow",
         representation(
           Price = "numeric",
           Accrued = "numeric",
           YieldToMaturity = "numeric",
           WAL = "numeric",
           ModDuration = "numeric",
           Convexity = "numeric",
           Period = "numeric",
           PmtDate = "character",
           TimePeriod = "numeric",
           BeginningBal = "numeric",
           MonthlyPmt = "numeric",
           MonthlyInterest = "numeric",
           PassThroughInterest = "numeric",
           ScheduledPrin = "numeric",
           PrepaidPrin = "numeric",
           DefaultedPrin = "numeric",
           LossAmount = "numeric",
           RecoveredAmount = "numeric",
           EndingBal = "numeric",
           ServicingIncome = "numeric",
           PMIPremium = "numeric",
           GFeePremium = "numeric",  
           TotalCashFlow = "numeric"))
  
  setGeneric("MortgageCashFlow", function(bond.id = "character", 
                                        original.bal = numeric(), 
                                        settlement.date = "character", 
                                        price = numeric(), 
                                        PrepaymentAssumption = "character") 
  {standardGeneric("MortgageCashFlow")})

  #' A standard generic function to access the slot Price
  #' @param object an S4 class object
  #' @export
  setGeneric("Price", function(object)
  {standardGeneric("Price")})
  
  #' A standard generic function to access the slot Accrued
  #' @param object an S4 class object
  #' @export
  setGeneric("Accrued", function(object)
  {standardGeneric("Accrued")})
  
  #' A standard generic function to access the slot YieldToMaturity
  #' @param  object an S4 class object
  #' @export
  setGeneric("YieldToMaturity", function(object)
  {standardGeneric("YieldToMaturity")})
  
  #' A standard generic function to access the slot WAL
  #' @param object an S4 class object
  #' @export
  setGeneric("WAL", function(object)
  {standardGeneric("WAL")})
  
  #' A standard generic function to access the slot ModDuration
  #' @param object an S4 class object of type MortgageCashFlow
  #' @export
  setGeneric("ModDuration", function(object)
    {standardGeneric("ModDuration")})
  
  #' A standard generic function to access the slot Convexity
  #' @param object an S4 class object of type MortgageCashFlow
  #' @export
  setGeneric("Convexity", function(object)
    {standardGeneric("Convexity")})
  
  #' A standard generic function to access the slot Period
  #' @param object an S4 class object
  #' @export
  setGeneric("Period", function(object)
    {standardGeneric("Period")})
  
  #' A standard generic function to access the slot PmtDate
  #' @param object an S4 class object of type MortgageCashFlow 
  #' @export
  setGeneric("PmtDate", function(object)
    {standardGeneric("PmtDate")})
  
  #' A standard generic function to access the slot PmtDate
  #' @param object an S4 class object of type MortgageCashFlow 
  #' @export
  setGeneric("TimePeriod", function(object)
  {standardGeneric("TimePeriod")})
  
  #' A standard generic function to access the slot BeginningBal
  #' @param object an S4 class object of type MortgageCashFlow
  #' @export
  setGeneric("BeginningBal", function(object)
    {standardGeneric})
  
  #' A standard generic function to access the slot MonthlyPmt
  #' @param object an S4 class object of type MortgageCashFlow
  #' @export
  setGeneric("MonthlyPmt", function(object)
    {standardGeneric})
  
  #' A generic function to access the slot MonthlyInterest
  #' @param object an S4 class object of type MortgageCashFlow
  #' @export
  setGeneric("MonthlyInterest", function(object)
    {standardGeneric})
  
  #' A generic function to access the slot PassThroughInterest
  #' @param object an S4 class object of the type MortgageCashFlow
  #' @export
  setGeneric("PassThroughInterest", function(object)
    {standardGeneric})
  
  #' A generic function to access the slot ScheduledPrin
  #' @param object an S4 class object of the type MortgageCashFlow
  #' @export
  setGeneric("ScheduledPrin", function(object)
    {standardGeneric("ScheduledPrin")})
  
  #' A generic function to access to the slot PrepaidPrin
  #' @param object an S4 class object of the type MortgageCashFlow
  #' @export
  setGeneric("PrepaidPrin", function(object)
    {standardGeneric("PrepaidPrin")})
    
  #' A standard generic function to access the slot DefaultedPrin
  #' @param object an S4 class object of type MortgageCashFlow
  #' @export
  setGeneric("DefaultedPrin", function(object)
  {standardGeneric("DefaultedPrin")})
  
  #' A standard generic function to access the slot LossAmount
  #' @param object an S4 class object of the type MortgageCashFlow
  #' @export
  setGeneric("LossAmount", function(object)
    {standardGeneric("LossAmount")})
  
  #' A standard generic function to access the slot RecoveredAmount
  #' @param object an S4 class object of the type MortgageCashFlow
  #' @export
  setGeneric("RecoveredAmount", function(object)
    {standardGeneric("RecoveredAmount")})
  
  #' A standard generic function to access the slot EndingBalance
  #' @param object an S4 class object of the type MortgageCashFlow
  #' @export
  setGeneric("EndingBalance", function(object)
    {standardGeneric("EndingBalance")})
  
  #' A standard generic function to access the slot of ServicingIncome
  #' @param object an S4 class object of the type MortgageCashFlow
  #' @export
  setGeneric("ServicingIncome", function(object)
    {standardGeneric("ServicingIncome")})
  
  #' A standard generic function to access the slot of PMIPremium
  #' @param object an S4 class object of the type MortgageCashFlow
  #' @export
  setGeneric("PMIPremium", function(object)
    {standardGeneric("PMIPremium")})
  
  #Note: generic function GFeePremium is defined in PassThroughConstructor.R
  
  #' A standard generic function to access the slot of TotalCashFlow
  #' @param object an S4 class object of the type MortgageCashFlow
  #' @export
  setGeneric("TotalCashFlow", function(object)
    {standardGeneric("TotalCashFlow")})
  
  # Note: generic for FirstPrinPaymentDate is 
  # defined in PassThroughConstructor.R
  
  setMethod("initialize",
          signature("MortgageCashFlow"),
          function(.Object,       
                   Price = numeric(),
                   Accrued = numeric(),
                   YieldToMaturity = numeric(),
                   WAL = numeric(),
                   ModDuration = numeric(),
                   Convexity = numeric(),
                   Period = numeric(),
                   PmtDate = "character",
                   TimePeriod = numeric(),
                   BeginningBal = numeric(),
                   MonthlyPmt = numeric(),
                   MonthlyInterest = numeric(),
                   PassThroughInterest = numeric(),
                   ScheduledPrin = numeric(),
                   PrepaidPrin = numeric(),
                   DefaultedPrin = numeric(),
                   LossAmount = numeric(),
                   RecoveredAmount = numeric(),
                   EndingBal = numeric(),
                   ServicingIncome = numeric(),
                   PMIPremium = numeric(),
                   GFeePremium = numeric(),  
                   TotalCashFlow = numeric(),
                   ...){
            callNextMethod(.Object,
                           Price = Price,
                           Accrued = Accrued,
                           YieldToMaturity = YieldToMaturity,
                           WAL = WAL,
                           ModDuration = ModDuration,
                           Convexity = Convexity,
                           Period = Period,
                           PmtDate = PmtDate,
                           TimePeriod = TimePeriod,
                           BeginningBal = BeginningBal,
                           MonthlyPmt = MonthlyPmt,
                           MonthlyInterest = MonthlyInterest,
                           PassThroughInterest = PassThroughInterest,
                           ScheduledPrin = ScheduledPrin,
                           PrepaidPrin = PrepaidPrin,
                           DefaultedPrin = DefaultedPrin,
                           LossAmount = LossAmount,
                           RecoveredAmount = RecoveredAmount,
                           EndingBal = EndingBal,
                           ServicingIncome = ServicingIncome,
                           PMIPremium = PMIPremium,
                           GFeePremium = GFeePremium,
                           TotalCashFlow = TotalCashFlow,
                           ...)
          })

  #' Method to extract Price from S4 class MortgageCashFlow
  #' @param object the name of the S4 object
  #' @exportMethod Price
  setMethod("Price", signature("MortgageCashFlow"),
            function(object){object@Price})
  
  #' Method to extract Accrued from S4 class MortgageCashFlow
  #' @param object the nameof the S4 object
  #' @exportMethod Accrued
  setMethod("Accrued", signature = ("MortgageCashFlow"),
            function(object){object@Accrued})
  
  #' Method to extract YieldToMaturity from S4 class MortgageCashFlow
  #' @param object the name of the S4 object
  #' @exportMethod YieldToMaturity
  setMethod("YieldToMaturity", signature = ("MortgageCashFlow"),
            function(object){object@YieldToMaturity})
  
  #' Method to extract WAL from S4 class MortgageCashFlow
  #' @param object the name of the S4 object
  #' @exportMethod WAL
  setMethod("WAL", signature = ("MortgageCashFlow"),
            function(object){object@WAL})
  
  #' Method to extract Modified Duration from S4 class MortgageCashFlow
  #' @param object the name of the S4 object
  #' @exportMethod ModDuration
  setMethod("ModDuration", signature = ("MortgageCashFlow"),
            function(object){object@ModDuration})
  
  #' Method to extract Convexity from S4 class MortgageCashFlow
  #' @param object the name of the S4 object
  #' @exportMethod Convexity
  setMethod("Convexity", signature("MortgageCashFlow"),
            function(object){object@Convexity})
  
  #' Method to extract Period from S4 class MortgageCashFlow
  #' @param object the name of the S4 object
  #' @exportMethod Period
  setMethod("Period", signature("MortgageCashFlow"),
            function(object){object@Period})
  
  #' Method to extract PmtDate from S4 class MortgageCashFlow
  #' @param object the name of the S4 object
  #' @exportMethod PmtDate
  setMethod("PmtDate", signature = ("MortgageCashFlow"),
            function(object){object@PmtDate})
  
  #' Method to extract the TimePeriod from class MortgageCashFlow
  #' @param object the name of the object of type MortgageCashFlow
  #' @exportMethod TimePeriod
  setMethod("TimePeriod", signature = ("MortgageCashFlow"),
            function(object){object@TimePeriod})
  
  #' Method to extract the PrepaidPrin from class MortgageCashFlow
  #' @param object the name of the object of type MortgageCashFlow
  #' @exportMethod BeginningBal
  setMethod("BeginningBal", signature = ("MortgageCashFlow"),
            function(object){object@BeginningBal})
  
  #' Method to extract the MonthlyPmt from class MortgageCashFlow
  #' @param object the name of the object of type MortgageCashFlow
  #' @exportMethod MonthlyPmt
  setMethod("MonthlyPmt", signature = ("MortgageCashFlow"),
            function(object){object@MonthlyPmt})
  
  #' Method to extract the MonthlyInterest from class MortgageCashFlow
  #' @param object the name of the object of type MortgageCashFlow
  #' @exportMethod MonthlyInterest
  setMethod("MonthlyInterest", signature = ("MortgageCashFlow"),
            function(object){object@MonthlyInterest})
  
  #' Method to extract the PassThroughInterest from class MortgageCashFlow
  #' @param object the name of the object of type MortgageCashFlow
  #' @exportMethod PassThroughInterest
  setMethod("PassThroughInterest", signature("MortgageCashFlow"),
            function(object){object@PassThroughInterest})
  
  #' Method to extract the ScheduledPrin from class MortgageCashFlow
  #' @param object the name of the object of type MortgageCashFlow
  #' @exportMethod ScheduledPrin
  setMethod("ScheduledPrin", signature("MortgageCashFlow"),
             function(object){object@ScheduledPrin})
  
  #' Method to extract Prepaid Principal from class MortgageCashFlow
  #' @param object the name of the object of type MortgageCashFlow
  #' @exportMethod PrepaidPrin
  setMethod("PrepaidPrin", signature("MortgageCashFlow"),
            function(object){object@PrepaidPrin})
  
  #' Method to extract the Defaulted Principal from class MortgageCashFlow
  #' @param object the name of the object of type MortgageCashFlow
  #' @exportMethod DefaultedPrin
  setMethod("DefaultedPrin", signature("MortgageCashFlow"),
            function(object){object@DefaultedPrin})
  
  #' Method to extract the Defaulted Principal from class MortgageCashFlow
  #' @param object the name of the object of type MortgageCashFlow
  #' @exportMethod LossAmount
  setMethod("LossAmount", signature("MortgageCashFlow"),
            function(object){object@LossAmount})
  
  #' Method to extract the Recovered Amount from class MortgageCashFlow
  #' @param object the name of the object of type MortgageCashFlow
  #' @exportMethod RecoveredAmount
  setMethod("RecoveredAmount", signature("MortgageCashFlow"),
            function(object){object@RecoveredAmount})
  
  #' Method to extract the Ending Balance from class MortgageCashFlow
  #' @param object the name of the object of type MortgageCashFlow
  #' @exportMethod EndingBalance
  setMethod("EndingBalance", signature("MortgageCashFlow"),
            function(object){object@EndingBal})
  
  #' Method to extract the Servicing Income from the class MortgageCashFlow
  #' @param object the name of the object of type MortgageCashFlow
  #' @exportMethod ServicingIncome
  setMethod("ServicingIncome", signature("MortgageCashFlow"),
            function(object){object@ServicingIncome})
  
  #' Method to extract the PMIPremium from the class MortgageCashFlow
  #' @param object the name of the object of type MortgageCashFlow
  #' @exportMethod PMIPremium
  setMethod("PMIPremium", signature("MortgageCashFlow"),
            function(object){object@PMIPremium})
  
  #' Method to extract the GFeePremium from the class MortgageCashFlow
  #' @param object the name of the object of type MortgageCashFlow
  #' @exportMethod GFeePremium
  setMethod("GFeePremium", signature("MortgageCashFlow"),
            function(object){object@GFeePremium})
  
  #' Method to extract the TotalCashFlow from the class MortgageCashFlow
  #' @param object the name of the object of type MortgageCashFlow
  #' @exportMethod TotalCashFlow
  setMethod("TotalCashFlow", signature("MortgageCashFlow"),
            function(object){object@TotalCashFlow})

  
  #'  A function to compute the cash flow of a pool of securitized mortgages
  #' 
  #' This is a generic function used to construct the class 
  #' object MortgageCashFlow. For this function to work properly the classes 
  #' MBSDetails and PrepaymentAssumption. must be present and loaded into 
  #' the local environment.
  #' @param bond.id A character string referencing the object MBSDetails.
  #' @param original.bal The original balance of the MBS pool.
  #' @param settlement.date The settlment date of the MBS trade.
  #' For example $102 is input as 102.00 not 1.02.
  #' @param price A numeric value the price traded.  Price is input as a 
  #' whole number.
  #' @param PrepaymentAssumption A character string referencing the 
  #' class PrepaymentModel
  #' @examples
  #' \dontrun{
  #' MortgageCashFlow(bond.id = "bondlabMBS4", 
  #' original.bal = 1000000000,
  #' settlement.date = "01-13-2013", 
  #' price = 104.00, 
  #' PrepaymentAssumption = "Prepayment")}
  #' @export MortgageCashFlow
  MortgageCashFlow <- function(bond.id = "character", 
                             original.bal = numeric(), 
                             settlement.date = "character",
                             price = "character",
                             PrepaymentAssumption = "character"){
  
  #This function error traps mortgage bond inputs
  ErrorTrap(bond.id = bond.id, 
            principal = original.bal, 
            settlement.date = settlement.date, 
            price = price)
    
  Price <- PriceTypes(Price = price)
  
  issue.date = as.Date(IssueDate(bond.id), "%m-%d-%Y")
  start.date = as.Date(DatedDate(bond.id), "%m-%d-%Y")
  end.date = as.Date(Maturity(bond.id), "%m-%d-%Y")
  lastpmt.date = as.Date(LastPmtDate(bond.id), "%m-%d-%Y")
  nextpmt.date = as.Date(NextPmtDate(bond.id), "%m-%d-%Y")
  coupon = Coupon(bond.id)
  frequency = Frequency(bond.id)
  delay = PaymentDelay(bond.id)
  settlement.date = as.Date(c(settlement.date), "%m-%d-%Y")
  bondbasis = BondBasis(bond.id)
  note.rate = GWac(bond.id)
  WAM = WAM(bond.id)
  
  
  # calculate beginning balance (principal) from the MBS pool factor
  # accrued interest is calculated using the current factor
  factor = MBSFactor(bond.id)
  principal = original.bal * factor
  
  # The factor must be adjusted by the prepayment assumption so the 
  # investor estimated cashflow is accurately projected following
  # TBA settlement
  
  SchedPrin = Sched.Prin(balance = principal, 
                        note.rate = note.rate,
                        term.mos = WAM,
                        period =1)
  
  if(PrepaymentAssumption(PrepaymentAssumption) == "CPR"){
    paydown = (principal - SchedPrin) * SMM(PrepaymentAssumption)[1]
    AdjFactor = (principal - SchedPrin - paydown)/OriginalBal(bond.id)
  } else {AdjFactor = factor}
  
  AdjPrincipal = original.bal * AdjFactor
  
  MBS.CF.Table = CashFlowEngine(bond.id = bond.id,
                                settlement.date = settlement.date,
                                principal = principal,
                                PrepaymentAssumption = PrepaymentAssumption)


  #step5 calculate accrued interest for the period
  days.to.nextpmt = (BondBasisConversion(issue.date = issue.date, 
                                         start.date = start.date, 
                                         end.date = end.date, 
                                         settlement.date = settlement.date,
                                         lastpmt.date = lastpmt.date,
                                         nextpmt.date = nextpmt.date,
                                         type = bondbasis)) * days.in.year.360
  
  days.between.pmtdate = 
    ((months.in.year/frequency)/months.in.year) * days.in.year.360
  days.of.accrued = (days.between.pmtdate - days.to.nextpmt) 
  accrued.interest = (days.of.accrued/days.between.pmtdate) * 
  ((coupon/yield.basis)/frequency) * principal
 
  # Step6 solve for yield to maturity given the price of the bond.  
  # irr is an internal function used to solve for yield to maturity
  # it is internal so that the bond's yield to maturity is not passed to a 
  # global variable that may inadvertantly use the value

  irr <- function(rate, 
                  time.period, 
                  cashflow, 
                  principal, 
                  price, 
                  accrued.interest){
  #pv = cashflow * exp(rate * -time.period)
  pv = cashflow * 1/(1+rate) ^ time.period
  proceeds = principal * PriceBasis(Price)
  sum(pv) - (proceeds + accrued.interest)}
  
  
  # note: create an XIRR type function to replace uniroot
  ytm = try(
    uniroot(irr,
          interval = c(lower = -.75, upper = .75),
          tol = tolerance, 
          time.period = round(as.numeric(MBS.CF.Table[,"Time"]),12), 
          cashflow = round(as.numeric(MBS.CF.Table[,"Investor CashFlow"]),12), 
          principal = principal, 
          price = PriceBasis(Price), 
          accrued.interest = accrued.interest)$root)
    
  # Convert to semi-bond equivalent
  Yield.To.Maturity = ((((1 + ytm) ^ (1/2)) -1) * 2) * yield.basis

  # Pass Yield.To.Maturity to YieldTypes class to handle the conversion to 
  # YieldBasis, YieldDecimal, and YieldDecimalString
  Yield <- YieldTypes(yield = Yield.To.Maturity)
  
  #Step7 Present value of the cash flows Present Value Factors
  MBS.CF.Table[,"Present Value Factor"] = 
    round((1/((1+(YieldBasis(Yield)/frequency))^(MBS.CF.Table[,"Time"] * 
                                                   frequency))),12)
  
  #Present Value of the cash flows
  MBS.CF.Table[,"Present Value"] = 
    round(MBS.CF.Table[,"Investor CashFlow"] * 
    MBS.CF.Table[,"Present Value Factor"],12)
  
  #Step8 Risk measures Duration Factors
  MBS.CF.Table[,"Duration"] = 
    MBS.CF.Table[,"Time"] * 
    (MBS.CF.Table[,"Present Value"]/
       ((principal * PriceBasis(Price)) + accrued.interest))
  
  # Weighted Average Life 
  WAL = 
    sum(((
      MBS.CF.Table[,"Scheduled Prin"] + MBS.CF.Table[,"Prepaid Prin"] + 
        MBS.CF.Table[,"Recovered Amount"]) * MBS.CF.Table[,"Time"])/ 
        sum(MBS.CF.Table[,"Scheduled Prin"] + MBS.CF.Table[,"Prepaid Prin"] + 
              MBS.CF.Table[,"Recovered Amount"]))
  
  #Convexity Factors
  MBS.CF.Table[,"Convexity Time"] = 
    MBS.CF.Table[,"Time"] *(MBS.CF.Table[,"Time"] + 1)
  
  MBS.CF.Table[,"CashFlow Convexity"] = 
  (MBS.CF.Table[,"Investor CashFlow"]/((1 + ((YieldBasis(Yield))/frequency)) ^ 
    ((MBS.CF.Table[,"Time"] + 2) * frequency)))/ 
    ((principal * PriceBasis(Price)) + accrued.interest)
  
  MBS.CF.Table[,"Convexity"] = 
    MBS.CF.Table[,"Convexity Time"] * MBS.CF.Table[,"CashFlow Convexity"] 
  
  #Duration and Convexity
  Duration = apply(MBS.CF.Table, 2, sum)["Duration"]
  Modified.Duration = Duration/(1 + (YieldBasis(Yield)/frequency))
  Convexity = apply(MBS.CF.Table, 2, sum)["Convexity"] * .5
  
  #Create Class Mortgage Loan Cashflows
  new("MortgageCashFlow",
      Price = PriceDecimal(Price),
      Accrued = accrued.interest,
      YieldToMaturity = YieldDecimal(Yield),
      WAL = WAL,
      ModDuration = unname(Modified.Duration),
      Convexity = unname(Convexity),
      Period = unname(MBS.CF.Table[,"Period"]),
      PmtDate = unname(as.character(as.Date(MBS.CF.Table[,"Date"], 
                                     origin = "1970-01-01"))),
      TimePeriod = unname(MBS.CF.Table[,"Time"]),
      BeginningBal = unname(MBS.CF.Table[,"Begin Bal"]),
      MonthlyPmt = unname(MBS.CF.Table[,"Monthly Pmt"]),
      MonthlyInterest = unname(MBS.CF.Table[,"Scheduled Int"]),
      PassThroughInterest = unname(MBS.CF.Table[,"Pass Through Interest"]),
      ScheduledPrin = unname(MBS.CF.Table[,"Scheduled Prin"]),
      PrepaidPrin = unname(MBS.CF.Table[,"Prepaid Prin"]),
      DefaultedPrin = unname(MBS.CF.Table[,"Defaulted Prin"]),
      LossAmount = unname(MBS.CF.Table[,"Loss Amount"]),
      RecoveredAmount = unname(MBS.CF.Table[,"Recovered Amount"]),
      EndingBal = unname(MBS.CF.Table[,"Ending Bal"]),
      ServicingIncome = unname(MBS.CF.Table[,"Servicing"]),
      PMIPremium = unname(MBS.CF.Table[,"PMI"]),    
      GFeePremium = unname(MBS.CF.Table[,"GFee"]),
      TotalCashFlow = unname(MBS.CF.Table[,"Investor CashFlow"])
  )}
