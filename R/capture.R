#' Helper Functions to Capture and Process stdout/err Output
#' 
#' \code{`set_text_capture`} sets the sinks, while \code{`get_text_capture`}
#' retrieves the captured tests and releases the sinks with \code{`release_sinks`}.
#' \code{`get_capture`} is just a wrapper around \code{`get_text_capture`}.
#' 
#' A lot of the logic here is devoted to detecting whether users set their
#' own sinks in the course of execution.
#' 
#' @keywords internal
#' @aliases get_text_capture, get_capture, release_sinks, release_stdout_sink, release_stderr_sink

set_text_capture <- function(file.name, type) {
  if(!is.character(file.name) || !identical(length(file.name), 1L)) {
    stop("Argument `file.name` must be a 1 length character.")
  }
  if(isTRUE(getOption("testor.disable.capt"))) {
    warning(type, " capture disabled (see getOption(testor.disable.capt))")
    return(FALSE)
  }
  if(identical(type, "message")) {
    waive.capt <- !identical(sink.number(type="message"), 2L)
  } else if (identical(type, "output")) {
    waive.capt <- isTRUE(sink.number() > 0L)
  } else {
    stop("Argument `type` must be either \"message\" or \"output\"")
  }
  if(!waive.capt) {
    if(inherits(try(con <- file(file.name, "wt")), "try-error")) {
      stop(
        "Failed opening ", type, " capture buffer ", file.name, "; either you, your OS, or an admin ",
        "removed the file, changed its access, or there is a bug in the code here."
    ) }
    sink(con, type=type)
    return(con)
  }
  return(FALSE)
}
get_text_capture <- function(con, file.name, type) {
  if(
    !isTRUE(type %in% c("message", "output")) || !is.character(file.name) || length(file.name) != 1L || 
    !(inherits(con, "file") && isOpen(con) || identical(con, FALSE))
  ) {
    stop("Logic Error: invalid arguments; contact maintainer.")
  }
  if(inherits(con, "file") && isOpen(con)) {
    if(!as.character(con) %in% rownames(showConnections()) ||          
      !identical(showConnections()[as.character(con), 1], file.name)
    ) {
      stop(
        "Logic Error: ", type, " capture connection has been subverted; either ",
        "test code is manipulating connections, or there is a bug in this code."
    ) }
    if(identical(type, "message")) {
      release_stderr_sink(silent=TRUE)  # close sink since it is the same we opened
    } else if (identical(type, "output")) {
      if(isTRUE(sink.number() > 1L)) {  # test expression added a diversion
        stop(
          "Test expressions introduced additional stdout diversions, which is not supported. ",
          "If you don't believe the test expressions introduced diversions (i.e. used ",
          "`sink`), contact maintainer."
      ) }
      sink()
    }
    if(inherits(try(capture <- readLines(file.name, warn=FALSE)), "try-error")) {
      stop("Logic Error: could not read ", type, " capture buffer file ", file.name)
    }
    close(con)
    return(capture)
  } else if (!identical(con, FALSE)) {
    stop("Logic Error: argument `con` must be a file connection or FALSE")
  }
  return(character())
}
release_sinks <- function(silent=FALSE) {
  release_stdout_sink(FALSE)
  release_stderr_sink(FALSE)
  if(!isTRUE(silent)) message("All sinks released, even those established by test expressions.")
  NULL
}
release_stdout_sink <- function(silent=FALSE) {
  if(!isTRUE(silent)) message("All stdout sinks released, even those established by test expressions.")
  replicate(sink.number(), sink())  
}
release_stderr_sink <- function(silent=FALSE) {
  if(!isTRUE(silent)) message("Stderr sink released.")  
  if(!identical(sink.number(type="message"), 2L)) sink(type="message")
}
get_capture <- function(std.err.capt.con, std.err.capt, std.out.capt.con, std.out.capt) {
  tryCatch(
    {
      message <- get_text_capture(std.err.capt.con, std.err.capt, "message")  # Do message first, so we can see subsequent errors
      output <- get_text_capture(std.out.capt.con, std.out.capt, "output")
      if(isTRUE(getOption("testor.show.output"))) {
        cat(c(message, "\n"), file=stderr(), sep="\n")
        cat(c(output, "\n"), sep="\n")
      }
    },
    error=function(e) {
      release_sinks()
      if(isTRUE(is.open_con(std.err.capt.con))) close(std.err.capt.con)
      if(isTRUE(is.open_con(std.out.capt.con))) close(std.out.capt.con)
      stop(e)
  } )  
  list(output=output, message=message)
}
