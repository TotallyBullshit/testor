\name{is.valid_con}
\alias{is.open_con}
\alias{is.valid_con}
\title{Check Whether File Connection Are Valid}
\usage{
is.valid_con(x, file.name = NULL)
}
\arguments{
  \item{x}{object to test}

  \item{file.name}{1 length character the name of the file
  that \code{`x`} must point to}
}
\value{
TRUE if valid, 1 length character vector if not explaining
why it's not
}
\description{
Use \code{`is.open_con`} to verify that a connection is
open in addition to being valid
}

