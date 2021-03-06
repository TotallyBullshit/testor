#' An `ls` Like Function
#' 
#' Much like `ls`, except that it will list all the objects 
#' recorded in the test items
#' 
#' @return list of object names, or a list with environments containing the objects
#' @seealso \code{`\link{print.testor_ls}`}
#' @examples
#' env1 <- new.env()
#' assign("var1", "25", env1)
#' env2 <- new.env(parent=env1)
#' assign("var2", "hello", env2)
#' env3 <- new.env(parent=env2)
#' assign("var3", 3.1415, env3)
#' 
#' ls <- testor:::make_ls(globalenv())
#' evalq(ls(), env3)
#' evalq(base::ls(), env3)
#' rm(ls)

testor_ls <- function(name, pos = -1L, envir = as.environment(pos),
   all.names = FALSE, pattern
) {
  if(!missing(pos) || !missing(name) || !missing(envir)) 
    stop(
      "You are using an overloaded version of `ls` that does not allow ",
      "using the `name`, `pos`, or `envir` arguments to `ls`; you can use standard ",
      "`ls` with `base::ls`."
    )
  new.item <- try(get(".new", parent.env(parent.env(parent.frame()))), silent=T)
  ref.item <- try(get(".ref", parent.env(parent.env(parent.frame()))), silent=T)

  ls.lst <- list()
  ls.test <- mods <- character()

  if(inherits(new.item, "try-error") && inherits(ref.item, "try-error")) {
    stop("Logic error: could not find `testorItem` objects to list contents of; contact Maintainer")
  } 
  if (!inherits(new.item, "try-error")) {
    if(nrow(new.item@ls)) ls.lst[["new"]] <- paste0(new.item@ls$names, new.item@ls$status)
    ls.lst[["tests"]] <- c(ls.lst[["tests"]], ".new")
    mods <- c(mods, Filter(nchar, unique(new.item@ls$status)))
  } 
  if (!inherits(ref.item, "try-error")) {
    if(nrow(ref.item@ls)) ls.lst[["ref"]] <- paste0(ref.item@ls$names, ref.item@ls$status)
    ls.lst[["tests"]] <- c(ls.lst[["tests"]], ".ref")
    mods <- c(mods, Filter(nchar, unique(ref.item@ls$status)))
  }
  structure(ls.lst[order(names(ls.lst))], class="testor_ls", mods=mods)  
}

#' Worker function to actually execute the `ls` work
#' 
#' @param env the environment to start \code{`ls`}ing in
#' @param stop.env the environment to stop at
#' @param all.names, same as \code{`ls`}
#' @param pattern same as \code{`ls`}
#' @param store.env NULL or environment, if the latter will populate that environment
#'   with all the objects found between \code{`env`} and \code{`stop.env`}
#' @return character or environment depending on \code{`store.env`}
#' @keywords internal

run_ls <- function(env, stop.env, all.names, pattern, store.env=NULL) {
  ls.res <- character()
  env.list <- list()
  i <- 0L
  while(!identical(env, stop.env)) {     # Get list of environments that are relevant
    env.list <- append(env.list, env)
    if(inherits(try(env <- parent.env(env)), "try-error")) stop("Specified `stop.env` does not appear to be in parent environments.")          
    if((i <- i + 1L) > 1000) stop("Logic error: not finding `stop.env` after 1000 iterations; contact package maintainer if this is an error.")
  }
  for(i in rev(seq_along(env.list))) {   # Reverse, so when we copy objects the "youngest" overwrite the "eldest"
    ls.res <- c(ls.res, ls(envir=env.list[[i]], all.names=all.names, pattern=pattern))
    if(!is.null(store.env)) {
      for(j in seq_along(ls.res)) 
        assign(ls.res[[j]], get(ls.res[[j]], envir=env.list[[i]]), store.env)
      ls.res <- character()
  } }
  if(is.null(store.env)) sort(unique(ls.res)) else store.env
}

#' @S3method print testor_ls

print.testor_ls <- function(x, ...) {
  x.copy <- x
  x <- unclass(x)
  attr(x, "mods") <- NULL
  if(length(x) == 1L) x <- unlist(x, use.names=FALSE)
  if(is.list(x)) {
    name.match <- c(
      tests="testor objects:",
      new="objects in new test env:",
      ref="objects in ref test env:" 
    )
    names(x) <- name.match[names(x)]
  }
  val <- NextMethod()
  extra <- character()
  explain <- c(
    "'"="  ':  has changed since test evaluation",
    "*"="  *:  existed during test evaluation, but doesn't anymore",
    "**"="  **: didn't exist during test evaluation"
  )
  if(all(c("new", "ref") %in% names(x.copy))) extra <- c(extra, "Use `ref(obj_name)` to access reference objects.")
  if(length(attr(x.copy, "mods"))) {
    extra <- c(extra, explain[attr(x.copy, "mods")])
  }
  if("tests" %in% names(x.copy)) extra <- c(extra, "`.new` / `.ref` for test value, `getTest(.new)` / `getTest(.ref)` for details.")
  if(length(extra)) cat(extra, sep="\n")
  invisible(val)
}