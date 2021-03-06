\name{getItemData}
\alias{getItemData}
\title{Retrieves Additional Info About Test}
\usage{
getItemData(x, name, what, env)
}
\description{
Uses the test result to identify whether the get request
was issued on the test object or the reference test object.
The check is to ensure the user didn't modify the object
(maybe we don't need to do this?).
}
\details{
These functions rely on the \code{`ref`} and \code{`obj`}
objects being defined in their parent environment.
}
\keyword{internal}

