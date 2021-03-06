\name{nextItem}
\alias{done,testorList-method}
\alias{getItem,testorList-method,}
\alias{nextItem}
\alias{nextItem,testorList-method,}
\alias{prevItem,testorList-method,}
\alias{reset,testorList-method,}
\title{Iterate through items of a \code{`\link{testorList-class}`} Object}
\usage{
nextItem(x, ...)
}
\arguments{
  \item{x}{a \code{`\link{testorList-class}`} object}
}
\value{
\code{`\link{testorList-class}`} for \code{`getItem`}, an
item from the list, which could be anything
}
\description{
Extraction process is a combination of steps: \enumerate{
\item Move Internal pointer with \code{`nextItem`} or
\code{`prevItem`} \item Retrieve item \code{`getItem`}
\item Check whether we're done iterating with \code{`done`}
} \code{`done`} will return TRUE if the pointer is on
either the first or last entry depending on what direction
you are iterating. If you wish to iterate from the last
item forward, you should either \code{`reset`} with
parameter \code{`reverse`} set to TRUE, or re-order the
items.
}
\keyword{internal}

