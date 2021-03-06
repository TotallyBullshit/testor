\docType{class}
\name{testor-class}
\alias{testor-class}
\title{Contains All The Data for Our Tests!}
\description{
Generally is populated through the \code{`+`} methods, with
the exception of \code{`items.ref`}, which is added on
creation.  I guess ideally all would be done through
different \code{`+`} methods, but that would complicate the
process a bit as that would require being able to
distinguish between reference item lists and new item lists
(and the latter should never really be added as that should
happen item by item).  Maybe some day this will be cleaned
up.
}
\section{Slots}{

\describe{
\item{\code{id}}{the identifier for the testor, typically a file name, but can be anything}

\item{\code{items.new}}{a list of all the tests in the new file}

\item{\code{items.ref}}{a list of all the previously saved tests}

\item{\code{items.new.map}}{a vector that maps the entries in \code{`items.new`} to those in \code{`items.ref`},
  new items will show up as NA here}

\item{\code{items.new.calls.deparse}}{a character vector of the deparsed calls in \code{`items.new`}}

\item{\code{items.envs}}{contains the environments for each call}

\item{\code{tests.fail}}{vector highlighting which tests failed}

\item{\code{tests.new}}{vector highlighting which tests did not exist in reference}

\item{\code{test.status}}{a vector that contains the result of the test ("pass", "fail", "new", "indeterminable")
  for every item in \code{`items.new`}}

\item{\code{tests.result}}{a logical matrix with a row for each item in \code{`items.new`} where each column
  represents the result of each sub tests}

\item{\code{tests.errorDetails}}{an S4 object with a slot for each sub test, where the slot contains a
  \code{`\link{testorItemTestError-class}`} object
  either NULL or a character vector describing the test failure reason for every item in \code{`items.new`}}

\item{\code{items.ref.calls.deparse}}{like \code{`items.new.calls.deparse`}, but for the reference items}

\item{\code{items.ref.map}}{maps reference items to the new items; deleted items will show up as NA here}

\item{\code{sections}}{a list of \code{`\link{testorSections}`}}

\item{\code{section.map}}{a map of every item in \code{`items.new`} to a section}

\item{\code{changes}}{contains summary data on the test results}
}}
\keyword{internal}

