\name{set_text_capture}
\alias{get_capture,}
\alias{get_text_capture,}
\alias{release_sinks,}
\alias{release_stderr_sink}
\alias{release_stdout_sink,}
\alias{set_text_capture}
\title{Helper Functions to Capture and Process stdout/err Output}
\usage{
set_text_capture(file.name, type)
}
\description{
\code{`set_text_capture`} sets the sinks, while
\code{`get_text_capture`} retrieves the captured tests and
releases the sinks with \code{`release_sinks`}.
\code{`get_capture`} is just a wrapper around
\code{`get_text_capture`}.
}
\details{
A lot of the logic here is devoted to detecting whether
users set their own sinks in the course of execution.
}
\keyword{internal}

