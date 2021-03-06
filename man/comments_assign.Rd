\name{comments_assign}
\alias{comments_assign}
\title{Assign Comments From Parse Data to Expression Elements}
\usage{
comments_assign(expr, comment.dat)
}
\arguments{
  \item{expr}{and expression}

  \item{comment.dat}{a data frame derived from
  \code{`\link{getParseData}`}}
}
\value{
an expression with comments attached as attributes to each
expression component
}
\description{
Based on parse data from \code{`\link{getParseData}`},
figures out what comments belong to what expression.  If a
comment is on the same line as an expression, the comment
is assigned to that expression (or whatever the nearest
expression is on that line if there is more than one).  If
a comment is on it's own line, then the match is done to
the next expression.
}
\details{
The expectation is that only "top level" expressions will
be submitted as part of `comment.dat` (i.e. they all have
the same parent, they don't strictly have to be top.level).
}
\seealso{
parse_data_assign
}

