\docType{class}
\name{testorList-class}
\alias{testorList-class}
\title{S4 Object To Implement Base List Methods}
\description{
The underlying assumption is that the `.items` slot is a
list (or an expression), and that that slot is the only
slot for which it's order and length are meaningful (i.e.
there is no other list or vector of same length as `.items`
in a different slot that is supposed to map to `.items`).
This last assumption allows us to implement the subsetting
operators in a meaninful manner.
}
\section{Slots}{

\describe{
\item{\code{.items}}{a list or expression}

\item{\code{.pointer}}{integer, used for implementing iterators}

\item{\code{.seek.fwd}}{logical used to track what direction iterators are going}
}}

