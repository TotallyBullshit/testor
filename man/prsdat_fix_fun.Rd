\name{prsdat_fix_fun}
\alias{prsdat_find_paren,}
\alias{prsdat_fix_exprlist}
\alias{prsdat_fix_for,}
\alias{prsdat_fix_fun}
\title{Functions to Adjust Parse Data To Match Expression}
\usage{
prsdat_fix_fun(parse.dat)
}
\arguments{
  \item{parse.dat}{a data frame of the type produced by
  \code{`\link{getParseData}`}}
}
\value{
\itemize{ \item for \code{`parsdat_fix*`}, a data frame of
the type produced by \code{`\link{getParseData}`} \item for
\code{`parsdat_find_paren`}, a length two integer vector
with the ids of the parens }
}
\description{
\itemize{ \item \code{`prsdat_fix_fun`} extract all
comments from formals and brings them up a level, and then
removes formals \item \code{`prsdat_fix_for`} brings
contents of `forcond` to same level as `for` to match up
with expression \item \code{`prsdat_fix_for`} extracts
expression from the condition (though apparently not from
`ifcond`) \item \code{`prsdat_fix_exprlist`} excises the
\code{`exprlist`} portions of \code{`exprlist`} as those
don't exist in the expressions proper \item
\code{`prsdat_find_paren`} returns locations of first set
of open and close parens }
}
\keyword{internal}

