#' @include item.R
#' @include item.sub.R
#' @include testor.R

NULL

#' Add a \code{`\link{testorSection-class}`} to a \code{`\link{testor-class}`}
#' 
#' Registers the section, and the mapping of items to section.
#' 
#' @keywords internal

setMethod("+", c("testor", "testorSection"), valueClass="testor",
  function(e1, e2) {
    # the map is index (item) to value (section), id auto-increments
    # with how many sections, and start tracks how many items exist in the
    # list; if we add a section, we basically blow away the section assignment
    # for the item that became a section, and replace it with the full section

    id <- length(e1@sections) + 1L
    start <- length(e1@items.new) + 1L # because sections added before items
    if(start == 1L & length(e1@section.map) == 0L) {
      e1@section.map <- rep(id, length(e2))  
    } else {
      # If not initial section add, then must be a nested section, so have to
      # remove value

      e1@sections[[e1@section.map[start]]]@length <- e1@sections[[e1@section.map[start]]]@length - 1L # reduce length of section with nested testor section
      e1@section.map <- e1@section.map[-start]  # remove mapping for the testor section element that we are expanding
      e1@section.map <- append(e1@section.map, rep(id, length(e2)), start - 1L) # add mapping for the now expanded section
  
    }
    e1@section.parent <- c(e1@section.parent, if(isTRUE(is.na(e2@parent))) id else e2@parent)
    if(e2@title %in% (titles <- vapply(e1@sections, function(x) x@title, character(1L)))) {
      e2@title <- tail(make.unique(c(titles, e2@title)), 1L)
    } 
    e1@sections <- append(e1@sections, list(e2))
    e1
} )

#' Adds Expressions to Testor
#'
#' Expressions can be added as \code{`\link{testorTests-class}`} object
#' or a straight up expression, though in most cases it should be the
#' latter.
#' 
#' @note you can only do this once for a `testor`.

setMethod("+", c("testor", "testorTestsOrExpression"), valueClass="testor", 
  function(e1, e2) {    
    if(length(e1@sections)) 
      stop(
        "Logic Error: you are attempting to add more than one set ",
        "of tests or expressions to this `testor`"
      )
    if(is.expression(e2)) e2 <- new("testorTests") + e2
    e1 <- e1 + new("testorSection", length=length(e2))
    matched.calls <- rep(NA_integer_, length(e2))
    i <- 1L
    sect.par <- NA_integer_
    sect.end <- 0L  # Used to track if there is an active section and to manage nested sections 

    test.env <- new.env(parent=e1@items.new@base.env)
    
    repeat {
      if(done(e2 <- nextItem(e2))) break 
      
      item <- exec(getItem(e2), test.env)

      # If item is a section, added to the store and update the tests with the contents of
      # the section, and re-loop (this is how we handle nested tests), if not, store the
      # evaluated test

      if(is(item@data@value, "testorSectionExpression")) {
        if(i <= sect.end) {
          sect.end <- i + length(item@data@value) - 1L
          sect.par <- e1@section.parent[e1@section.map[[i]]]
        } else if (i > sect.end) {
          sect.end <- i + length(item@data@value) - 1L
          sect.par <- NA_integer_
        }
        e1 <- e1 + new(
          "testorSection", title=item@data@value@title, details=item@data@value@details, 
          length=length(item@data@value), parent=sect.par, compare=item@data@value@compare
        )
        e2 <- e2 + item@data@value
        next
      }
      e1 <- e1 + item  # store evaluated test and compare it to reference one
      if(!ignored(item)) test.env <- new.env(parent=test.env)  # ignored items share environment with subsequent items
      i <- i + 1L
    }
    e1
} )

#' Adds \code{`\link{testorItems-class}`} objects to Testor
#' 
#' Any added \code{`\link{testorItems-class}`} objects are treated as
#' reference items.  The only way to add new items is by adding each
#' item individually with \code{`\link{+,testor,testorItem-method}`}.

setMethod("+", c("testor", "testorItems"), valueClass="testor",
  function(e1, e2) {
    itemsType(e2) <- "reference"
    parent.env(e2@base.env) <- e1@base.env
    e1@items.ref <- e2
    if(length(e1@items.ref)) {
      e1@items.ref.calls.deparse <- vapply(as.list(e1@items.ref), function(x) paste0(deparse(x@call), collapse=""), character(1L))
      e1@items.ref.map <- rep(NA_integer_, length(e1@items.ref))
    }
    e1
  }
)
#' Adds \code{`\link{testorItem}`} to \code{`\link{testor}`}
#' 
#' All tests are run on addition, and mapping information between reference and
#' new tests is also recored.
#' 
#' @seealso \code{`\link{registerItem,testor,testorItem-method}`}
#' @keywords internal

setMethod("+", c("testor", "testorItem"),
  function(e1, e2) {
    e2 <- updateLs(e2, e1@items.new@base.env)
    e1 <- registerItem(e1, e2)
    e1 <- testItem(e1, e2)
    e1
} )
#' Add Test Errors to \code{`\link{testor-class}`}
#' @keywords internal

setMethod("+", c("testor", "testorItemTestsErrors"), 
  function(e1, e2) {
    e1@tests.errorDetails <- append(e1@tests.errorDetails, list(e2))
    e1
} )