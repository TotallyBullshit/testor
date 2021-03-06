\docType{class}
\name{testorItemTestsFuns-class}
\alias{testorItemTestsFuns-class}
\title{Store Functions for New vs. Reference Test Comparisons}
\description{
\code{`testorItemTestsFuns`} contains the functions used to
compare the results and side effects of running test
expresssions.
}
\details{
By default, the comparison for each of the
\code{`testorItem-class`} elements are carried out as
follows (i.e. this is what the default
\code{`testorItemTestsFuns-class`} is populated with)
\itemize{ \item value: compared using
\code{`\link{all.equal}`} \item conditions: each item in
this list is compared to the corresponding item in the
reference list with \code{`\link{all.equal}`} \item output:
not compared (too variable, e.g. screen widths, etc.)
\item message: not compared (note this is presumably
included in \code{`conditions`}) }
}
\examples{
new("testorItemTestsFuns", value=identical)  # use `identical` instead of `all.equal` to compare values
}
\seealso{
\code{`\link{testorTest-class}`}
}

