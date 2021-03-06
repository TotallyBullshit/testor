\name{run_ls}
\alias{run_ls}
\title{Worker function to actually execute the `ls` work}
\usage{
run_ls(env, stop.env, all.names, pattern, store.env = NULL)
}
\arguments{
  \item{env}{the environment to start \code{`ls`}ing in}

  \item{stop.env}{the environment to stop at}

  \item{all.names,}{same as \code{`ls`}}

  \item{pattern}{same as \code{`ls`}}

  \item{store.env}{NULL or environment, if the latter will
  populate that environment with all the objects found
  between \code{`env`} and \code{`stop.env`}}
}
\value{
character or environment depending on \code{`store.env`}
}
\description{
Worker function to actually execute the `ls` work
}
\keyword{internal}

