\name{strtrunc}
\alias{strtrunc}
\title{Print Only First X characters}
\usage{
strtrunc(x, nchar.max = getOption("width"), ctd = "...", disambig = FALSE)
}
\arguments{
  \item{x}{string to reduce length}

  \item{nchar.max}{how many characters to reduce each
  string to}

  \item{ctd}{1 length character vector for what to use to
  indicate string truncated}

  \item{disambig}{logical 1L whether to disambiguate
  strings that end up the same after truncation (not
  currently implemented)}
}
\description{
Print Only First X characters
}
\keyword{internal}

