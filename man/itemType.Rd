\name{itemType}
\alias{itemType}
\alias{itemType,testorItem-method,}
\alias{itemType<-,testorItem-method,}
\alias{itemsType<-,testorItems-method}
\alias{itemsitemType,testorItems-method,}
\title{Methods to Track Whether a \code{`\link{testorItem-class}`} Object is New Or Reference}
\usage{
itemType(x, ...)
}
\description{
Necessitated due to the awkward structure around
\code{`\link{browse_testor_item}`}, where the only return
value is a \code{`\link{testorItems-class}`} object and
there is no easy way to tell which objects have been kept
from reference vs which ones are new.
}
\keyword{internal}

