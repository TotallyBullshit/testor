\name{testor_sect}
\alias{testor_sect}
\title{Define a \code{`testor`} Section}
\usage{
testor_sect(title = NULL, expr = expression(), details = character(),
  compare = new("testorItemTestsFuns"))
}
\arguments{
  \item{title}{character 1 length title for the section,
  can be omitted though if you do omit it you will have to
  refer to the subsequent arguments by name (i.e.
  `\code{`testor_sect(expr=...)`})}

  \item{test}{expression(s), most commonly a call to
  \code{`{`} with several calls (see examples)}

  \item{details}{character more detailed description of
  what the purpose of the section is}

  \item{compare}{a function or a
  \code{`\link{testorItemTestsFuns-class}`} object}
}
\description{
The purpose of \code{`testor`} sections is to allow the
user to tag a group of test expressions with meta
information as well as to modify the comparison functions
used when determining whether the newly evaluated values
match the reference values.
}
\details{
\code{`testor`} will compare values as well as some side
effects from the test expression evaluation.  If you wish
to modify the comparison function for the value of the test
expressions then all you need to do is pass your comparison
function as the \code{`compare`} argument.

If you wish to modify the comparison functions for the side
effects (e.g. screen output or conditions), then you need
to pass a \code{`\link{testorItemTestsFuns-class}`} object
intialized with the appropriate functions (see example).
}
\note{
if you want to modify the functions used to compare
conditions, keep in mind that the conditions are stored in
lists, so your function must loop through the lists and
compare conditions pairwise (i.e. you can't just use
\code{`\link{all.equal}`} or \code{`\link{identical}`} as
you can when comparing the values or other side effects).

currently sections have no impact whatsoever on reference
expressions. The only thing that matters is what section
the new expressions are in. New expressions are matched to
reference expressions based purely on the deparsed calls
irrespective of what section the reference expressions were
in.
}
\examples{
testor_sect("Custom Tests", {
  my_fun("a", FALSE)
  my_fun(845, TRUE)
})
testor_sect("Compare With Identical",
  {
    my_exact_fun(6L)
    my_exact_fun("hello")
  },
  compare=identical
)
testor_sect("Compare With Identical",
  {
    my_exact_fun(6L)
    my_exact_fun("hello")
  },
  compare=identical
)
testor_sect("Compare With Identical For Screen Output",
  {
    my_exact_fun(6L)
    my_exact_fun("hello")
  },
  compare=new("testorItemTestsFuns", value=identical, output=identical)
)
}

