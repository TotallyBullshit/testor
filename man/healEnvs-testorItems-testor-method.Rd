\docType{methods}
\name{healEnvs,testorItems,testor-method}
\alias{healEnvs,testorItems,testor-method}
\title{Fixes The Ancestries of our New Reference Items Object}
\usage{
\S4method{healEnvs}{testorItems,testor}(x, y, ...)
}
\arguments{
  \item{x}{\code{`\link{testorItems-class}`} object}

  \item{y}{\code{`\link{testor-class}`} object \code{`x`}
  was generated from}
}
\value{
\code{`testorItems-class`}
}
\description{
This is necessary because when we let the user pick and
chose which tests to store and which ones to reject, there
may no longer be a clear ancestry chain within the
remaining tests.
}
\details{
The healing process is somewhat complex and full of
compromises.  We are attempting to create a self consistent
set of nested parent environments for each test, but at the
same time, we don't want to store all the combinations of
reference and new objects.

We only store new objects in `testor`, with the lone
exception of objects created during a test which is then
kept as a reference test. This should be rare as most tests
are explicitly defined as calls that don't create objects,
so this will only occur if the user overrides the default
behavior.

There are two ways in which we modify the environment
ancestry. If the user decides to not store some new tests,
then the objects created in between the previous new stored
test and the next new stored test are all moved to the next
new stored test, and the previous new stored test becomes
the parent of the next new stored test.

The second way relates to when the user decides to keep a
reference test over a matching new test.  This is a lot
more complicated because we do not preserve the reference
test environment ancestry.  Effectively, we need to graft
the reference test to the new environment ancestry.

If a reference test that is being kept matches directly to
a new test, then the parent of that new test becomes the
parent of the reference test.

If there is no direct match, but there are child reference
tests that match to a new item, then the parent is the
youngest new test that is older than the new test that was
matched and is kept.  If no new tests meet this criterion,
then base.env is the parent.

If there is no direct match, and there are no child
reference tests that are being kept that do match to a kept
new item, then the parent will be the last new test that is
kept.

The main takeaway from all this is that reference tests
don't really keep their evaluation environment.  Often this
environment is similar to the new environment.  When there
are difference between the two, the output of \code{`ls`}
is customized to highlight which objects were actually
available/unmodifed at the time of the reference test
evaluation.  Object namees will have the following symbols
appended to explain the object status: \itemize{ \item ':
object exists in browsing environment, but not the same as
it was when test was evalaluated \item *: object was
present during test evaluation but is not available in
testor anymore \item **: object was not present during test
evaluation, but exists in current environment }
}
\seealso{
\code{`\link{updateLs,testorItem-method}`}
}
\keyword{internal}

