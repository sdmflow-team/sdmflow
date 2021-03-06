% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/s_vif_auto.R
\name{s_vif_auto}
\alias{s_vif_auto}
\title{Automatic variance inflation factor (VIF) analysis for variable selection}
\usage{
s_vif_auto(
  training.df,
  select.cols = NULL,
  omit.cols = c("x", "y", "presence"),
  preference.order = NULL,
  biserial.cor = NULL,
  verbose = TRUE
)
}
\arguments{
\item{training.df}{A training data frame. Non-numeric columns are excluded from the analysis.}

\item{select.cols}{Character vector, names of the columns which VIF wants to be assessed. If \code{NULL}, all numeric variables but \code{presence.column} are considered. It is recommended to use the variable order of the \code{variable} column from the data frame output of \code{\link{s_biserial_cor}}.}

\item{omit.cols}{Character vector, variables to exclude from the analysis. Defaults to \code{c("x", "y", "presence")}.}

\item{preference.order}{Character vector, column names of \code{training.df} in an order of selection priority desired by the user. For example, if \code{preference.order = c("bio1", "bio2", "bio3")}, the algorithm will first compute vif for all variables in \code{training.df} not included in \code{preference.order}, and remove on each step the variable with a higher vif. Then, vif is computed iteratively on the variables in \code{preference.order}, but removing always the variable with the lowest priority (instead of the variable with the higher vif). Finally, all variables resulting from both vif analyses are grouped together, and a new vif analysis is performed, removing first the variables not in \code{preference.order}. In summary, this option will try to preserve a set of variables as long as their vif values allow it. This option is incompatible with the argument \code{biserial.cor} (see below).}

\item{biserial.cor}{List, output of the function \code{\link{s_biserial_cor}}. Its R-squared scores are used to select variables. In fact, the column "variable" of the data frame within \code{biserial.cor} is used as input for the argument \code{preference.order} explained above. This is just a convenient way to set the priority in variable selection according to the output of \code{s_biserial_cor}.}

\item{verbose}{Boolean, defaults to TRUE. Triggers messages describing what variables are being removed.}
}
\value{
An object of the class \code{s_vif_auto}. It is a list with two slots: "df" and "vars". The former contains a dataframe with the VIF values of the selected variables, while the latter contains the names of the selected variables.
}
\description{
Selects variables within a training dataframe that are not linear combinations of other variables by using the variance inflation factor (VIF) criteria implemented in the \code{\link[HH]{vif}} function (Heilberger and Holland 2004). This function has three modes:
\itemize{
\item 1. When the arguments \code{preference.order} and \code{biserial.cor} are \code{NULL}: It removes on on each iteration the variable with the highest VIF until all VIF values are lower than 5. This operation is performed by the hidden function \code{.select_by_max_vif}.
\item 2. When the argument \code{biserial.cor} is provided with an object of the class \code{s_biserial_cor} produced by the function \code{\link{s_biserial_cor}}: It adds variables one by one in the order of preference defined by the \code{s_biserial_cor} object. Any variable increasing the VIF value of any other variable beyond 5 is not added to the final variable selection. This operation is performed by the hidden function \code{.select_by_preference}. This is the most recommended option for this analysis.
\item 3. When the argument \code{preference.order} is provided: The variables in \code{preference.order} are selected as shown above in option 2, the variables not in \code{preference.order} are selected as in option 1, and finally, all variables are put together and selected again as in option 2. This method preserves the variables desired by the user as much as possible.
}
}
\examples{
\dontrun{

data(virtual.species.training)

#1. only training.df and omit.cols are provided
#variables with max vif are removed on each step

vif.auto.out <- s_vif_auto(
  training.df = virtual.species.training
)


#2. biserial.cor is provided
#variables are processed according to the
#priority established by s_biserial_cor()

biserial.cor <- s_biserial_cor(
  training.df = virtual.species.training,
  response.col = "presence",
  omit.cols = c("x", "y"),
  plot = FALSE
)

vif.auto.out <- s_vif_auto(
  training.df = virtual.species.training,
  biserial.cor = biserial.cor
)

#3, preference.order is provided
#variables in preference.order are selected by preference
#the other variables are selected by removing those with max vif

vif.auto.out <- s_vif_auto(
  training.df = virtual.species.training,
  preference.order = c("bio1", "bio5", "bio6", "bio12")
)

}

}
\references{
Heiberger, Richard M. and Holland, Burt (2004). Statistical Analysis and Data Display: An Intermediate Course with Examples in S-Plus, R, and SAS. Springer Texts in Statistics. Springer. ISBN 0-387-40270-5.
}
\author{
Blas Benito <blasbenito@gmail.com>. The function \code{\link[HH]{vif}} is authored by Richard M. Heiberger <rmh@temple.edu>.
}
