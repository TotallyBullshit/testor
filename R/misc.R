#' Deparse, But Make It Look Like It Would On Prompt
#'
#' @param expr an expression or call
#' @return character vector

deparse_prompt <- function(expr) {
  # if(!is.call(expr) || !is.expression(expr)) stop("Argument `expr` must be an expression ")
  prompt <- getOption("prompt")
  continue <- getOption("continue")
  pad.len <- max(nchar(c(prompt, continue)))
  expr.deparsed <- deparse(expr, width.cutoff=min(60L, (getOption("width") - pad.len)))
  if(length(expr.deparsed) < 1L) {
    stop("Logic Error: don't know what to do with zero length expr")
  }
  prompt.vec <- c(prompt, rep(continue, length(expr.deparsed) - 1L))
  paste0(prompt.vec, expr.deparsed)
}

# deparse_peek <- function(expr, len) {
  
#   flatten <- function(x) {
#     if(is.call(x)) {
#       if(identical(x[[1]], quote({))) {
#         return(lapply(x[[-1L]], flatten))
#       } else if (length(tail(x, 1L)) > 1L && identical(tail(x, 1L)[[1L]], quote({) {
#         return(lapply(x[[-1L]], flatten))
#       }
#     } 
#   }

#   expr.deparsed <- deparse(expr, width.cutoff=(getOption("width") - pad - 3L))
#   if(length(expr.deparsed) < 1L) {
#     stop("Logic Error: don't know what to do with zero length expr")
#   }
#   if(length(expr.deparsed) == 1L) expr.deparsed else paste0(expr.deparsed[1L], "...")
# }
#' Print Only First X characters
#' 
#' @keywords internal
#' @param x string to reduce length
#' @param nchar.max how many characters to reduce each string to
#' @param ctd 1 length character vector for what to use to indicate string truncated
#' @param disambig logical 1L whether to disambiguate strings that end up
#'   the same after truncation (not currently implemented)

strtrunc <- function(x, nchar.max=getOption("width"), ctd="...", disambig=FALSE) {
  if(!identical(disambig, FALSE)) stop("Parameter `disambig` not implemented")
  if(!is.character(x)) stop("Argument `x` must be character")
  if(!is.character(ctd) || !identical(length(ctd), 1L)) stop("Argument `ctd` must be 1 length character")
  if(!is.numeric(nchar.max) || !identical(length(nchar.max), 1L)) stop("Argument `nchar.max` must be 1 length numeric")

  len.target <- nchar.max - nchar(ctd)
  if(len.target < 1L) stop("`nchar.max` too small, make bigger or make `ctd` shorter.")
  ifelse(nchar(x) <= nchar.max, x, paste0(substr(x, 1, len.target), ctd))
}
#' Print a header
#' 
#' @aliases print.H2, print.H3, print.header
#' @param x a 1 length character vector
#' @param margin one of "both", "top", "bottom", "none", weather to add newlines at top or bottom
#' @return 1 length character vector
#' @method print H1
#' @S3method print H1

print.H1 <- function(x, ...) {
  if(!is.character(x) || length(x) != 1L) stop("Argument `x` must be a 1 length character vector")
  if((width <- getOption("width")) < 5L) return(x)
  x <- c(
    paste0(c("+", rep("-", width - 2L), "+"), collapse=""), 
    paste0(
      "| ", 
      paste0(
        text.wrapped <- text_wrap(x, width - 4L), 
        vapply((width - 4L) - nchar(text.wrapped), function(x) paste0(rep(" ", x), collapse=""), character(1L))
      ),
      " |"
    ),
    paste0(c("+", rep("-", width - 2L), "+"), collapse="")
  )
  NextMethod()
}
#' @method print H2
#' @S3method print H2

print.H2 <- function(x, ...) {
  x <- header_help(x, pad.char="=")
  NextMethod()
}

#' @method print H3
#' @S3method print H3

print.H3 <- function(x, ...) {
  x <- header_help(x, pad.char="-")
  NextMethod()
}

#' @method print header
#' @S3method print header

print.header <- function(x, margin="bottom", ...) {
  if(!is.character(x)) stop("Argument `x` must be a character vector")
  margin.legal <- c("both", "none", "top", "bottom")
  if(!is.character(margin) || !isTRUE(margin %in% margin.legal)) stop("Argument `margin` must be in ", deparse(margin.legal))
  if(isTRUE(margin %in% c("both", "top"))) x <- paste0(c("", x), collapse="\n")
  if(isTRUE(margin %in% c("both", "bottom"))) x <- paste0(c(x, ""), collapse="\n")
  x <- paste0(c(x, ""), collapse="\n")
  cat(x)
  invisible(x)
}

# Helper function for single line headers
# 
# @param x the contents of the header
# @param ... unused, for compatibility with print generic
# @param pad.char which character to use to form the header structure

header_help <- function(x, ..., pad.char="-") {
  if(inherits(try(par.call <- sys.call(-1L), silent=TRUE), "try-error") ||
    !isTRUE(grepl("^print\\.H[1-9][0-9]*$", as.character(par.call[[1]])))
  ) {
    stop("This function may only be called from a print.H* function.")
  }
  stop2 <- function(msg) stop(simpleCondition(msg, par.call))
  if(!is.character(x) || length(x) != 1L) stop2("Argument `x` must be a 1 length character vector")
  if(!is.character(pad.char) || length(pad.char) != 1L || nchar(pad.char) != 1L) stop2("Argument `pad.char` must be a 1 length 1 character character vector.")
  if((width <- getOption("width")) < 8L) return(x)
  if(isTRUE(nchar(x) > width - 4L)) x <- paste0(substr(x, 1, width - 7L), "...")
  paste0(pad.char, " ", x, " ", paste0(rep_len(pad.char, width - 3L - nchar(x)), collapse=""), collapse="")
}
#' Create Header Objects
#' 
#' Header objects are 1 length character vectors that are printed with text 
#' formatting that highlight their "headerness". 
#' 
#' @seealso \code{`\link{print.header}`}
#' @export
#' @aliases H1, H2, H3
#' @param x 1 length character vector to turn into a header
#' @param level 1 length integer, what level to make a header 
#' @return header object

header <- function(x, level) {
  if(!is.character(x) || length(x) != 1L) stop("Argument `x` must be a one length character vector")
  levels.valid <- 1:3
  if(!identical(round(level), as.numeric(level)) || !isTRUE(level %in% levels.valid)) {
    stop("Argument `level` must be 1 length integer-like and in ", deparse(levels.valid))
  }
  structure(x, class=c(paste0("H", level), "header"))
}
#' @export

H1 <- function(x) header(x, 1L)

#' @export

H2 <- function(x) header(x, 2L)

#' @export

H3 <- function(x) header(x, 3L)

#' Wrap Text At Fixed Column Width
#' 
#' @param x character vector
#' @param width integer vector with
#' @return a list with, for each item in \code{`x`}, a character vector
#'   of the item wrapped to length \code{`width`}

text_wrap <- function(x, width) {
  if(!is.character(x) || !is.numeric(width) || any(width < 1L) || !identical(round(width), as.numeric(width))) {
    stop("Arguments `x` and `width` must be character and integer like (all values >= 1) respectively")
  }
  if(!identical((length(x) %% length(width)), 0L)) {
    stop("Argument `x` must be a multiple in length of argument `width`")
  }
  unlist(
    use.names=FALSE,
    mapply(
      x, width, SIMPLIFY=FALSE,
      FUN=function(x.sub, width.sub) {
        breaks <- ceiling(nchar(x.sub) / width.sub)
        substr(rep(x.sub, breaks), start=(1:breaks - 1) * width.sub + 1, stop=(1:breaks) * width.sub)
} ) ) }

#' Compare Lists of Conditions
#' 
#' @param target the list of conditions that we are matching against
#' @param current the list of conditions we are checking
#' @return TRUE if the lists of conditions are equivalent, an character vector explaining
#'   why they are not otherwise

compare_conditions <- function(target, current) {
  if(length(target) != length(current)) {
    return(paste0("New item has ", length(current), " conditions instead of the expected ", length(target)))
  }
  res <- mapply(function(target, current) all.equal(target, current), target, current, SIMPLIFY=FALSE)
  if(length(errs <- Filter(is.character, res))) return(unlist(errs))
  else if(all(vapply(res, isTRUE, logical(1L)))) return(TRUE)
  stop("Logic Error, unexpected return values from comparison function.")
}

#' Produces 1 Line Description of Value
#'
#' @keywords internal
#' @param val object to describe
#' @param limit max characters to display
#' @return character vector describing object

desc <- function(val, limit=getOption("width")) {
  if(!is.numeric(limit) | !identical(length(limit), 1L) | limit <= 4L) {
    stop("Argument `limit` must be a 1 length integer with value greater than 3")
  }
  if(is.null(val)) return("NULL")
  val.desc <- typeof(val)
  if(!is.null(class(val)) && !identical(class(val)[[1]], typeof(class(val)))) {
    val.desc <- paste(val.desc, class(val)[[1]])
  }
  first_lvl <- function(x, inc.len=TRUE) {
    class.map <- c(numeric="num", integer="int", character="chr", complex="cpx", factor="fct")
    classes <- vapply(x, function(y) class(y)[[1L]], character(1L))
    lens <- if(inc.len) {
      vapply(
        x, 
        function(y) if(length(y) > 1L) paste0("(", length(y), ")") else "",
        character(1L)
      ) 
    } else character(length(x))
    paste0(
      ifelse(nchar(nms <- names(x)), valid_names(nms), seq_along(x)), ":", 
      ifelse(is.na(new.class <- class.map[classes]), classes, new.class), 
      lens, collapse=";"
    )
  }
  if(inherits(val, "data.frame")) {
    val.desc <- paste0(val.desc, " [", nrow(val), ",{", first_lvl(val, FALSE), "}]")
  } else if(!is.null(val.dim <- dim(val))) {
    val.desc <- paste0(val.desc, paste0(" [", paste0(val.dim, collapse=",")), "]")
  } else if (is.atomic(val)) {
    val.desc <- paste0(val.desc, paste0(" [", length(val), "]"))
  } else if (is.recursive(val)) {
    count_rec <- function(x, lvl=0) {
      if(is.recursive(x) && length(x)) {
        lvl <- lvl + 1L
        res <- vapply(x, count_rec, numeric(2L), lvl=lvl)
        return(c(lvl=max(res["lvl", ]), counts=sum(res["counts",])))
      } else {
        return(c(lvl=lvl, counts=1L))
      }
    }
    val.desc <- paste(val.desc, paste0("[", paste0(c(length(val), paste0(count_rec(val), collapse=";")), collapse=","), "]"))
    val.desc <- paste0(val.desc, " {", first_lvl(val), "}")
  }
  if(nchar(val.desc) > limit - 3L) paste0(substr(val.desc, 1L, limit - 3L), "...") else val.desc
}
#' Make Valid Names
#' 
#' If names are invalid, quotes them with backtics
#' 
#' @param x character vector
#' @return character vector

valid_names <- function(x) {
  ifelse(
    grepl("^[a-zA-Z.]([_a-zA-Z.][a-zA-Z0-9._]*)?$", x),
    x,
    paste0("`", x, "`")
  )
}

#' Returns a Character Function Name From A Language Object
#' 
#' Note this doesn't really try to check too hard whether the \code{`x`} is 
#' indeed a function.
#' 
#' @keywords internal
#' @param x a call or a symbol
#' @return character 1 length, NA if \code{`x`} can't possibly be a function

deparse_fun <- function(x) {
  if(is.symbol(x)) {
    as.character(x)
  } else if (is.call(x)) {
    "<anon.FUN>"
  } else {
    NA_character_
  }
}

#' Captalizes First Letter
#' 
#' @keywords internal
#' @param x character
#' @return character

cap_first <- function(x) {
  if(!is.character(x)) stop("Argument `x` must be a character vector.")
  ifelse(
    nchar(x) > 2L, 
    paste0(substr(toupper(x), 1L, 1L), substr(x, 2L, nchar(x))),
    ifelse(identical(nchar(x), 1L), substr(toupper(x), 1L, 1L), x)
  )
}
#' Retrieves Environment Ancestry
#'
#' @keywords internal
#' @param env the environment to start with
#' @param stop.env the environment to stop with

env_ancestry <- function(env, stop.env=globalenv()) {
  if(!is.environment(env) || !is.environment(stop.env)) stop("Arguments `env` and `stop.env` must both be environments")
  out <- character(0L)
  repeat {
    out <- c(out, env_name(env))
    if(identical(env, stop.env)) break
    if(identical(env, emptyenv())) stop("Hit empty environment while traveling up environment ancestry")
    env <- parent.env(env)
  }
  out
}
#' Gets Environment Name / Memory Code
#' 
#' Captures the name that \code{`\link{print.default}`} displays when one
#' prints and environment
#' 
#' @keywords internal
#' @param env an environemnt
#' @return character 1 length

env_name <- function(env) {
  if(!is.environment(env)) stop("Argument `env` must be an environment")
  sub("<environment: (.*)>", "\\1", capture.output(print.default(env)))
}

#' Functions To Ignore
#' 
#' Ignored functions are not considered tests if they are called from
#' the top level.
#' 
#' @keywords internal

funs.ignore <- list(base::`<-`, base::library)
