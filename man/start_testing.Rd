% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/start_testing.R
\name{start_testing}
\alias{start_testing}
\title{Start testing your solution}
\usage{
start_testing(slug)
}
\arguments{
\item{slug}{a normalized, url-safe identifier for a problem
e.g. "hello-world"}
}
\value{
Prints test reports
}
\description{
Exercism- and R-specific wrapper for \code{\link[testthat:auto_test]{testthat::auto_test()}} that starts
testing your solution against the problem's test cases. Thus, you can improve
it iteratively, in a "\href{http://exercism.io/how-it-works/newbie}{test-driven}"
manner.
}
\examples{
\dontrun{
  start_testing("hello-world")
}
}
