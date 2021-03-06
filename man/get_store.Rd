\name{get_store}
\alias{get_store}
\alias{set_store}
\title{Set and Retrieve Store Contents}
\usage{
get_store(store.id)

set_store(store.id, testor)
}
\arguments{
  \item{store.id}{a filesystem path to the store (an .rds
  file)}

  \item{testor}{a \code{`\link{testor-class}`} object
  containing the store data}
}
\value{
\itemize{ \item set_store TRUE if testor storing worked,
error otherwise \item get_store a
\code{`\link{testor-class}`} object, FALSE if
\code{`store.id`} doesn't exist yet , or error otherwise }
}
\description{
These functions are not used directly; rather, they are
used by \code{`\link{runtests}`} to get and set the
\code{`testor`} objects. You should only need to understand
these functions if you are looking to implement a special
storage mechanism for the \code{`testor`} objects.
}
\details{
By default, only a character method is defined, which will
interpret its inputs as a filesystem path.

You may write your own methods for special storage
situations ( e.g SQL database, ftp server, etc) with the
understanding that the getting method may only accept one
argument, the \code{`store.id`}, and the setting method
only two arguments, the \code{`store.id`} and the
\code{`testor`}.

S3 dispatch will be on \code{`store.id`}, and
\code{`store.id`} may be any R object that identifies the
testor.  For example, a potential SQL implementation where
the testors get stored in blobs may look like so:
\preformatted{ my.sql.store.id <- structure( list(
server="mytestorserver.mydomain.com:3306",
database="testors", table="project1", id="cornercasetests"
), class="sql_testor" ) get_store.sql_testor <-
function(store.id) { # FUNCTION BODY } set_store.sql_testor
<- function(store.id, testor) { # FUNCTION BODY }

runtests("testor/cornertestcases.R", my.sql.store.id) } For
inspirations for the bodies of the _store functions look at
the source code for \code{`testor:::get_store.character`}
and \code{`testor:::set_store.character`}. Expectations for
the functions are as follows.  \code{`get_store`} must
return: \itemize{ \item a \code{`\link{testor-class}`}
object if \code{`store.id`} exists and contains a valid
object \item FALSE if the object doesn't exist (e.g. first
time run-through, so reference copy doesn't exist yet)
\item \code{`\link{stop}`} on error } \code{`set_store`}
must return: \itemize{ \item TRUE on success \item
\code{`\link{stop}`} on error }
}

