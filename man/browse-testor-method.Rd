\docType{methods}
\name{browse,testor-method}
\alias{browse,testor-method}
\title{Browse testor}
\usage{
\S4method{browse}{testor}(x, ...)
}
\arguments{
  \item{x}{the object to browse}

  \item{env}{the environment to use as a parent to the
  environment to browse the tests}
}
\description{
Here we are reviewing all the tests in the testor under
three different lenses \enumerate{ \item tests that don't
match the stored reference tests \item tests that don't
exist in the reference tests \item tests that exist in the
reference tests but no the new file } Because a lot of the
logic for browsing these three types of situations is
shared, that logic has been split off into
\code{`\link{browse_testor_items}`}. The key is that that
function will return the items that are supposed to be
stored in the testor.  These items will either be new or
reference ones based on user decisions.
}
\details{
Unfortunately, in order to be able to use the same logic
for tasks that are not quite the same, a bit of contortion
was needed.  In particular, the user is always asked to
input either Y, N, or Q, but the corresponding output from
\code{`\link{browse_testor_items}`} is very different
depending on what situation we're dealing with.
}
\keyword{internal}

