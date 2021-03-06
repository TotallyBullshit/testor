\docType{methods}
\name{as.expression,testorList-method}
\alias{as.expression,testorList-method}
\title{Coerce to expression by returning items coerced to expressions}
\usage{
\S4method{as.expression}{testorList}(x, ...)
}
\arguments{
  \item{x}{an arbitrary \R object.}

  \item{...}{\code{expression}: \R objects, typically
  calls, symbols or constants.\cr \code{as.expression}:
  arguments to be passed to methods.}
}
\description{
Really only meaningful for classes that implement the
\code{`.items`} slot as an expression, but works for others
to the extent \code{`.items`} contents are coercible to
expressions
}
\keyword{internal}

