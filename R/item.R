# - Required Code -------------------------------------------------------------

#' @include misc.R
#' @include class_unions.R
#' @include list.R

NULL

# - Classes -------------------------------------------------------------------

#' Data Produced During Evaluation of \code{`testor`} Test
#' 
#' Kept separate from the \code{`\link{testorItem-class}`} because these
#' are the slots that get compared from the new item to the reference items
#' which means there are a whole bunch of other classes that need to have the
#' same structure as this (e.g. \code{`\link{testorItemTestsFun}`}) and by
#' definining it we let those other classes confirm they have the correct
#' structure.
#' @keywords internal

setClass(
  "testorItemData", 
  representation(
    value="ANY", 
    conditions="list", 
    output="character", 
    message="character",
    aborted="logical"      # more generally, should this be a withRestarts slot?
  ),
  validity=function(object) {
    if(any(vapply(object@conditions, function(x) !inherits(x, "condition"), logical(1L)))) 
      return("slot `conditions` may only contain \"condition\" objects")
    TRUE
} )
#' Full Representation Of an Evaluated \code{`testor`} Test
#' 
#' @slot call the call that is tested
#' @slot reference whether this is a reference or new \code{`testorItem`}
#' @slot ignore whether this test should be treated as a test or just a step
#'   towards compiling a test
#' @slot environment the environment the test was evaluated in, should contain
#'   all relevant objects
#' @slot data the container for the results of the evaluation of \code{`call`}

setClass(
  "testorItem", 
  representation(
    call="ANY",
    id="integer",
    reference="logical",
    env="environmentOrNULL",
    ignore="logical",
    ls="data.frame",
    comment="characterOrNULL",
    data="testorItemData"
  ),
  prototype(
    reference=FALSE, ignore=FALSE, id=1L, 
    ls=data.frame(names=character(), status=character())
  ),
  validity=function(object) {
    if(!identical(length(object@reference), 1L)) return("Slot `@reference` must be length 1")
    if(!identical(length(object@id), 1L) || !isTRUE(object@id > 0)) return("Slot `@id` must be length 1 and greater than zero.")
    if(!identical(names(object@ls), c("names", "status")) ||
      !identical(vapply(objecs@ls, class, ""), rep("character", 2L)))
      return("Slot `@ls` has incorrect data structure")
    TRUE
  }
)
setClassUnion("testorItemOrNULL", c("testorItem", "NULL"))
#' Initialize A \code{`\link{testorItem-class}`}
#' 
#' Makes the fact that most of the data needs to be part of a 
#' \code{`\link{testorItemData-class}`} object transparent to the user.
#' @keywords internal

setMethod("initialize", "testorItem", function(.Object, ...) {
  dots.all <- list(...)
  if(!("call" %in% names(dots.all))) stop("Argument `call` is required")
  .Object@call <- dots.all$call
  if("env" %in% names(dots.all)) .Object@env <- dots.all$env
  if(
    is.call(.Object@call) &&
    any(vapply(funs.ignore, identical, logical(1L), eval(.Object@call[[1L]], .Object@env)))
  ) {
    .Object@ignore <- TRUE
  }
  if("comment" %in% names(dots.all)) .Object@comment <- dots.all$comment
  dots <- dots.all[!(names(dots.all) %in% slotNames(.Object))]
  .Object@data <- do.call("new", c(list("testorItemData"), dots), quote=TRUE)
  .Object
} )
#' Collection of \code{`\link{testorItem-class}`} Object
#' @keywords internal

setClass("testorItems", contains="testorList", 
  representation(
    base.env="environment"    # should be enclosure of first item
  ),  
  validity=function(object) {
    if(!all(vapply(object@.items, is, logical(1L), "testorItem"))) 
      return("slot `items` may only contain objects \"testorItem\"")
    TRUE
} )
setClassUnion("testorItemsOrNULL", c("testorItems", "NULL"))

# - Single Object Methods -----------------------------------------------------

#' Display a \code{`\link{testorItem-class}`} Object
#' 
#' Highly summarized view of the testor object.

setMethod("show", "testorItem",
  function(object) {
    cat("** ")
    if(object@reference) cat("Reference") else cat("New")
    cat(" Test **\n")
    cat("value:", paste0(desc(object@data@value, limit=getOption("width") - 7L), "\n"))
    if(out.len <- length(object@data@output)) cat("stdout:", out.len, "lines\n")
    if(err.len <- length(object@data@message)) cat("stderr:", err.len, "lines\n")
    if(cond.len <- length(object@data@conditions)) {
      cond.types <- vapply(
        object@data@conditions,
        function(x) {
          if(inherits(x, "error")) {
            "error"
          } else if (inherits(x, "warning")) {
            "warning"
          } else if (inherits(x, "message")) {
            "message"
          } else {
            "other"
        } },
        character(1L)
      )
      cond.types.summ <- Filter(
        Negate(is.na), 
        tapply(cond.types, factor(cond.types, levels=c("error", "warning", "message", "other condition")), length)
      )
      cat(
        "conditions:", 
        paste0(cond.types.summ, " ", paste0(names(cond.types.summ), ifelse(cond.types.summ > 1L, "s", ""), "\n"), collapse=", ")
      )
    }
    cat(
      paste0(
        "To retrieve detailed contents, use the `get*` methods (e.g. getOut(obj)).",
        " See documentation for `getTest` for ", 
        "details on the other accessor functions.", collapse=""
      ), fill=TRUE, sep=""
    )
} )
#' Methods to Track Whether a \code{`\link{testorItem-class}`} Object is New Or Reference
#' 
#' Necessitated due to the awkward structure around \code{`\link{browse_testor_item}`},
#' where the only return value is a \code{`\link{testorItems-class}`} object and there is
#' no easy way to tell which objects have been kept from reference vs which ones are 
#' new.
#' 
#' @keywords internal
#' @aliases itemType,testorItem-method, itemType<-,testorItem-method, itemsitemType,testorItems-method,
#'   itemsType<-,testorItems-method

setGeneric("itemType", function(x, ...) standardGeneric("itemType"))
setMethod("itemType", "testorItem", function(x) if(x@reference) "reference" else "new")
setGeneric("itemType<-", function(x, value) standardGeneric("itemType<-"))
setReplaceMethod("itemType", c("testorItem", "character"),
  function(x, value) {
    if(!(value %in% c("new", "reference"))) stop("Argument `value` must be in ", deparse(c("new", "reference")))
    x@reference <- identical(value, "reference")
    x
} )
setGeneric("itemsType", function(x, ...) standardGeneric("itemsType"))
setMethod("itemsType", "testorItems", 
  function(x) {
    vapply(as.list(x), function(y) if(y@reference) "reference" else "new", character(1L))
} )
setGeneric("itemsType<-", function(x, value) standardGeneric("itemsType<-"))
setReplaceMethod("itemsType", c("testorItems", "character"),
  function(x, value) {
    if(length(value) != 1L & !identical(length(x), length(value))) {
      stop("Argument `value` must be length 1L or have same length as argument `x`")
    }
    if(!all(value %in% c("reference", "new"))) stop("Argument `value` may only contain ", deparse(c("new", "reference")))    
    x@.items <- mapply(function(y, z) {y@reference <- identical(z, "reference"); y}, x@.items, value, SIMPLIFY=F) 
    x
} )
setGeneric("ignored", function(x, ...) standardGeneric("ignored"))

#' Determines Which Items In \code{`\link{testorItems-class}`} Are Not Full Tests
#' 
#' In order to simplify user interaction, some statements are not considered
#' to be tests, rather, they are set up steps for the actual test.  At the
#' time of this writing, top level assignments are included in this group.

setMethod("ignored", "testorItems", function(x, ...) vapply(as.list(x), function(y) y@ignore, logical(1L)))
setMethod("ignored", "testorItem", function(x, ...) x@ignore)
  
# - Multi Object Methods -------------------------------------------------------

#' Add a \code{`\link{testorItem-class}`} to a \code{`\link{testorItems-class}`}
#' @keywords internal

setMethod("+", c("testorItems", "testorItemOrNULL"), 
  function(e1, e2) {
    if(is.null(e2)) return(e1)
    e1 <- append(e1, list(e2))
    e1
} )
#' Add a \code{`\link{testorItem-class}`} to a \code{`\link{testorItems-class}`}
#' @keywords internal

setMethod("+", c("testorItems", "testorItems"), function(e1, e2) append(e1, e2))


