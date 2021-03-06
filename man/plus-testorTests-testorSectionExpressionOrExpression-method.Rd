\docType{methods}
\name{+,testorTests,testorSectionExpressionOrExpression-method}
\alias{+,testorTests,testorSectionExpressionOrExpression-method}
\title{Add More Tests to \code{`\link{testorTests}`}}
\usage{
\S4method{+}{testorTests,testorSectionExpressionOrExpression}(e1, e2)
}
\value{
testorTests-class
}
\description{
Will overwrite the call at the current index with the
contents of the expression passed as the \code{`e2`}
argument, unless current index is 0L in which case will
just append the expressions.  The intended use for this is
when the evaluation of one of the tests produces a
\code{`\link{testorSectionExpression-class}`} that should
then replace the call.
}
\details{
The index of the \code{`\link{testorTests}`} object will be
set so that the next call to
\code{`\link{nextItem,testorList-method}`} will return the
first call that was added.
}
\keyword{internal}

