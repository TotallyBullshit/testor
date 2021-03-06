\docType{methods}
\name{ignored,testorItems-method}
\alias{ignored,testorItems-method}
\title{Determines Which Items In \code{`\link{testorItems-class}`} Are Not Full Tests}
\usage{
\S4method{ignored}{testorItems}(x, ...)
}
\description{
In order to simplify user interaction, some statements are
not considered to be tests, rather, they are set up steps
for the actual test.  At the time of this writing, top
level assignments are included in this group.
}

