\docType{data}
\name{tk.lst}
\alias{tk.lst}
\title{Listing on known tokens}
\format{\preformatted{List of 10
 $ comment       : chr "COMMENT"
 $ brac.close    : chr [1:3] "'\}'" "']'" "')'"
 $ brac.open     : chr [1:3] "'\{'" "'['" "'('"
 $ exps          : chr [1:2] "expr" "exprlist"
 $ seps          : chr [1:2] "','" "';'"
 $ non.exps      : chr [1:8] "SYMBOL" "STR_CONST" "NUM_CONST" "NULL_CONST" ...
 $ non.exps.extra: chr [1:6] "FUNCTION" "FOR" "IF" "REPEAT" ...
 $ ops           : chr [1:25] "'-'" "'+'" "'!'" "'~'" ...
 $ ops.other     : chr [1:2] "NS_GET" "NS_GET_INT"
 $ unassign      : chr [1:7] "EQ_SUB" "SYMBOL_SUB" "EQ_FORMALS" "SYMBOL_FORMALS" ...
}}
\usage{
tk.lst
}
\description{
As of this writing, the following tokens from
\file{src/main/gram.c} are not handled:
}
\details{
[,1] [,2] [,3] [,4] [1,] "'\\n'" "cr" "ifcond" "sub" [2,]
"'%'" "END_OF_INPUT" "INCOMPLETE_STRING" "sublist" [3,]
"$accept" "equal_assign" "LBB" [4,] "$end" "error"
"LINE_DIRECTIVE" "TILDE" [5,] "$undefined" "ERROR" "LOW"
"UMINUS" [6,] "COLON_ASSIGN" "expr_or_assign" "NOT" "UNOT"
[7,] "cond" "formlist" "prog" "UPLUS"

So far, we have not been able to produce
\code{`getParseData`} data frames that contain them.  It
may not be possible to do so for all of them.  For example,
\code{`INCOMPLETE_STRING`} shows up during a parse error,
so could never be part of a fully parsed expression.
}
\keyword{internal}

