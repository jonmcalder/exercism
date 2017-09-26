
<!-- README.md is generated from README.Rmd. Please edit that file -->
exercism
========

[![Project Status: WIP ? Initial development is in progress, but there has not yet been a stable, usable release suitable for the public.](http://www.repostatus.org/badges/latest/wip.svg)](http://www.repostatus.org/#wip) [![Build Status](https://travis-ci.org/jonmcalder/exercism.svg?branch=master)](https://travis-ci.org/jonmcalder/exercism) [![codecov](https://codecov.io/gh/jonmcalder/exercism/branch/master/graph/badge.svg)](https://codecov.io/gh/jonmcalder/exercism)

This package is designed to make it easy for R users to work through the R track on [exercism.io](http://exercism.io).

It is not a complete replacement for the [Exercism CLI](http://exercism.io/clients/cli), but instead provides easy access to the most commonly used CLI functionality:

-   fetch problems
-   skip problems
-   submit solutions
-   check status/progress

Install
-------

    devtools::install_github("jonmcalder/exercism")
    library(exercism)

Setup
-----

There are two essential steps which must be completed before you can make use of this R package:

-   set your API key
-   set your exercism path

#### Set your API key

Go to [exercism.io -&gt; account -&gt; API key](http://exercism.io/account/key)

<img src="man/figures/api_key.png" />

Copy your API key (highlighted above in orange), and then run:

    set_api_key("<your_API_key>")
    # e.g.
    # set_api_key("1a2b3c4d5e6f7g8h1a2b3c4d5e6f7g8h")

#### Set exercism path

    set_exercism_path("<path_to_your_exercism_directory>")
    # e.g. 
    # set_exercism_path("C:/Users/Jon/exercism") # Windows example
    # set_exercism_path("~/exercism")            # Mac & Linux example
    # set_exercism_path()                        # Use default

Note that the `exercism_path` referred to here should be the root directory for exercism (i.e. not the `R` sub-directory).

By default the exercism command-line client (CLI) fetches exercises to `~/exercism`. If you have previously used the CLI and have not changed the default directory, then just run `set_exercism_path()` (i.e. with no path argument) and this will use the default exercism directory.

Once you've set your API key and exercism path these will be remembered for future R sessions.

Usage
-----

Get the next problem for the R track:

    fetch_next()

Get a specific problem for the R track (e.g. "leap"):

    fetch_problem(slug = "leap")

Skip a specific problem for the R track (e.g. "bob"):

    skip_problem(slug = "bob")

(note that you may specify a different language track via the `track_id` argument)

RStudio Addin
-------------

The core functionality mentioned above is also accessible via an RStudio Addin. You can access it via the Addins menu, or by running `exercism_addin()`.

Contribute
----------

If you encounter any problems while using this package please raise them on the [issues page](https://github.com/jonmcalder/exercism/issues). You can also use this page to offer any suggestions for improvement.
