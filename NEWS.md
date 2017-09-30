# exercism 0.1.1.9000

* Added `iteration()` and `submit()` to facilitate submit functionality

* Added tests for `iteration()`

* Updated RStudio addin to handle the submission of exercises, and improved 
UI with helper text

* Added `browse_exercise()` and `browse_solution()`, convenience functions for 
navigating to problem descriptions or solutions on http://exercism.io

* Documented new functions and added examples for all existing exported 
functions

* Replaced messages in `.onLoad()` with `packageStartupMessage()`, and made them 
more descriptive

* Re-order slug and track_id parameters in `fetch_problem()` and `skip_problem()` 
to facilitate omission of the track parameter with an unamed slug parameter

# exercism 0.1.1

* Updated README to clarify the required steps to set API key and exercism path

* Bug fix for #2

* Updated API tests to use a temporary directory & API key and cleanup 
  afterwards

* Added `force` argument to `set_api_key()` and `set_exercism_path()` to  
  facilitate when to allow overwriting of environment variables

* Added simple checks of key and path to `set_api_key()` & `set_exercism_path()` 
  repectively, with warnings when appropriate
  
* Added .onLoad() which checks if the API key & path have previously been set; 
  if not, tries to update config based on the file that is used by the exercism 
  CLI; otherwise messages with a prompt to set the API key and path


# exercism 0.1.0.9000

* Included an RStudio addin that supports the main API functionality implemented 
  in the package.

* Updated function names and documentation 


# exercism 0.1.0

* Added a `NEWS.md` file to track changes to the package
