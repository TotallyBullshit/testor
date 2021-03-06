\docType{class}
\name{testorSection-class}
\alias{testorSection-class}
\alias{testorSectionExpression-class}
\title{Contains Representation For a Section of Tests}
\description{
\code{`testorSectionExpression-class`} contains the actual
expressions that belong to the section, whereas
\code{`testorSection-class`} only contains the meta data.
The latter objects are used within
\code{`\link{testor-class}`}, whereas the former is really
just a temporary object until we can generate the latter.
}
\section{Slots}{

\describe{
\item{\code{title}}{1 lenght character, the name of the section}

\item{\code{details}}{character vector containing additional info on the section}

\item{\code{compare}}{functions to compare the various aspects of a \code{`\link{testItem}`}}

\item{\code{length}}{tracks size of the section}
}}

