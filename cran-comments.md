# Round 1

## Test environments

* Windows 7, R 3.1.3 (local)
* ubuntu 12.04, R 3.2.0 (on travis-ci)
* ubuntu 14.04, R 3.1.3 (on my DigitalOcean droplet)

## Submission comments

2015-04-18

R CMD check has no ERRORs or WARNINGs, and 1 NOTE:  

* checking CRAN incoming feasibility ... NOTE  
Maintainer: 'Dean Attali daattali@gmail.com'  
New submission  
Components with restrictions and base license permitting such:  
  MIT + file LICENSE  
File 'LICENSE':  
  YEAR: 2015  
  
  COPYRIGHT HOLDER: Dean Attali  
  

## Reviewer comments

2015-04-20 Prof Brian Ripley

Hmm, we see

*checking CRAN incoming feasibility ... NOTE
Package has a VignetteBuilder field but no prebuilt vignette index.

Found the following (possibly) invalid URLs:
  URL: http://daattali.com/shiny/shinyjs-demo/
    From: man/runExample.Rd
          man/shinyjs.Rd
    Status: 404
    Message: Not Found

The Title field should be in title case, current version then in title case:
‘Perform Common JavaScript Operations in Shiny apps using Plain R Code’
‘Perform Common JavaScript Operations in Shiny Apps using Plain R Code’

The Description field should not start with the package name,
  'This package' or similar.

so you either did not use current R or --as-cran.


# Round 2

## Test environments

* Windows 7, R 3.2.0 (local)
* ubuntu 12.04, R 3.2.0 (on travis-ci)
* ubuntu 14.04, R 3.1.3 (on my DigitalOcean droplet)

## Submission comments

2015-04-20

Addressed previous comments:  

- updated Title and Description   
- Added complete vignette  
- ran check using latest R version from last week  

One NOTE saying there is a possibly invalid URL, but the URL is valid,
I'm not sure why the check gets a 404:  

* checking CRAN incoming feasibility ... NOTE  
Maintainer: 'Dean Attali daattali@gmail.com'  
New submission  

License components with restrictions and base license permitting such:  
  MIT + file LICENSE  
File  
  'LICENSE':  
  YEAR: 2015  
  COPYRIGHT HOLDER: Dean Attali  
Found the following (possibly) invalid URLs:  
  URL: http://daattali.com/shiny/shinyjs-demo/  
  From:  
    man/runExample.Rd  
    man/shinyjs.Rd  

  Status: 404  
  Message: Not Found  

## Reviewer comments

2015-04-21 Prof Brian Ripley

Because it is not found!  See the CRAN policies.


and now

* checking re-building of vignette outputs ... NOTE
Error in re-building vignettes:
  ...
Fetching https://raw.githubusercontent.com/daattali/daattali.github.io/master/img/blog/shinyjs/basic-v1.png...
pandoc: Failed to retrieve https://raw.githubusercontent.com/daattali/daattali.github.io/master/img/blog/shinyjs/basic-v1.png
user error (https not supported)
Error: processing vignette 'overview.Rmd' failed with diagnostics:
pandoc document conversion failed with error 61




# Round 3

## Test environments

* Windows 7, R 3.2.0 (local)
* ubuntu 12.04, R 3.2.0 (on travis-ci)
* ubuntu 14.04, R 3.1.3 (on my DigitalOcean droplet)

## Submission comments

2015-04-21 

Ran check --as-cran with 0 ERROR, 0 WARNING, 1 NOTE

I apologize my previous submission resulted in multiple NOTES; I'm running 
R3.2.0 and checking --as-cran but for some reason I didn't get the same NOTES as 
my reviewer.  

Addressed previous note:

- failed processing vignette because URL was https; changed to a http URL

The other NOTE I'm getting is in regards to "potentially invalid URLs" but
these URLs are valid. http://daattali.com/shiny/shinyjs-demo/ and 
http://daattali.com/shiny/shinyjs-basic/

## Reviewer comments

2015-04-21 Uwe Ligges

Then please add the final slash:

http://daattali.com/shiny/shinyjs-demo/ rather than http://daattali.com/shiny/shinyjs-demo
etc.



# Round 4

## Test environments

* Windows 7, R 3.2.0 (local)
* ubuntu 12.04, R 3.2.0 (on travis-ci)
* ubuntu 14.04, R 3.1.3 (on my DigitalOcean droplet)

## Submission comments

2015-04-21

Ran check --as-cran with 0 ERROR, 0 WARNING, 1 NOTE

Addressed previous note: added final slash in URLs of web pages that were redirecting from "http://..." to "http://.../"

The only NOTE I'm getting is in regards to "potentially invalid URLs" but
these URLs are valid. http://daattali.com/shiny/shinyjs-demo/ and 
http://daattali.com/shiny/shinyjs-basic/

## Reviewer comments

2015-04-21 Prof Brian Ripley

On CRAN now

---

# Version 0.0.6.2

# Round 1

## Test environments

* Windows 7, R 3.2.0 (local)
* ubuntu 12.04, R 3.2.0 (on travis-ci)
* ubuntu 14.04, R 3.1.3 (on my DigitalOcean droplet)

## Submission comments

2015-05-25

R CMD check has no ERRORs or WARNINGs, and 2 NOTEs: one is about the license and one about potentially invalid URL (it's a valid URL).

## Reviewer comments

2015-05-25 Prof Brian Ripley

I suppose you are talking about

Found the following (possibly) invalid URLs:
  URL: http://daattali.com/shiny/shinyjs-basic/
    From: inst/doc/overview.html
          README.md
    Status: 404
    Message: Not Found
  URL: http://daattali.com/shiny/shinyjs-demo/
    From: man/runExample.Rd
          man/shinyjs.Rd
          inst/doc/overview.html
          README.md
    Status: 404
    Message: Not Found

It seems it is misconfigured site (it does not say 'invalid').  In future comply with policies when you report!

On its way to CRAN.

---

2015-05-27 Prof Brian Ripley

Actually, it also fails under Roldrelease on Windows.  
So please fix and declare version depenndencies if needed.  
http://cran.r-project.org/web/checks/check_results_shinyjs.html

# Round 2

## Test environments

* Windows 7, R 3.2.0 (local)
* ubuntu 12.04, R 3.2.0 (on travis-ci)
* ubuntu 14.04, R 3.1.3 (on my DigitalOcean droplet)

## Submission comments

2015-05-27

Package accepted 2 days ago but today I got an email
  saying that my tests failed on windows Roldrelease.
  The issue is fixed
  
## Reviewer comments

2015-05-27 Prof Brian Ripley

You also got an email about Sparc Solaris results, and that issue is not corrected:

ERROR
Running the tests in ‘tests/testthat.R’ failed.
Last 13 lines of output:
  testthat results ================================================================
  OK: 4 SKIPPED: 0 FAILED: 8
  1. Failure (at test-extendShinyjs.R#5): extendShinyjs throws error when gives a non-existent JS file
  2. Failure (at test-extendShinyjs.R#10): extendShinyjs throws error when JS file doesn't have proper shinyjs functions
  3. Failure (at test-extendShinyjs.R#15): extendShinyjs throws error when given a bad JavaScript file
  4. Error: extendShinyjs finds the correct JS functions from script file
  5. Failure (at test-extendShinyjs.R#26): extendShinyjs throws error when inline code doesn't have proper shinyjs functions
  6. Failure (at test-extendShinyjs.R#31): extendShinyjs throws error when given bad inline code
  7. Error: extendShinyjs finds the correct JS functions from inline code
  8. Error: extendShinyjs finds the correct functions when both file and text are given

  Error: testthat unit tests failed
  
## My comments

Right, you did mention that, one of my functions requires V8 which is not available on very few platforms.  Inside the function I do use the recommended check using `requireNamespace` and if the package isn't available then I throw an error. I believe that's the correct thing to do.  The tests are failing on that platform because they expect output but they get an error - and I think that's correct behaviour.   The only fix I can think of is to check for the package availability inside the test suite itself -- is that right?  I thought it'd be ok to leave it as-is since the tests that are failing are tests that should fail on that platform.

## Reviewer comments

They should not fail if they rely on things not available on the platform.

And you are *STILL* not respecting

'All correspondence with CRAN must be sent to CRAN@R-project.org (not members of the team) and be in plain text ASCII (and not HTML).'

in two ways.

---

# Version 0.0.7.0

# Round 1

## Test environments

* Windows 7, R 3.2.0 (local)
* ubuntu 12.04, R 3.2.0 (on travis-ci)
* ubuntu 14.04, R 3.1.3 (on my DigitalOcean droplet)

## Submission comments

2015-06-23

R CMD check has no ERRORs or WARNINGs, and 2 NOTEs: one is about "possibly" invalid URLs - this is because the URLs are shiny apps on a shiny server and shiny server doesn't support returning headers, the other NOTE is about having NEWS.md

## Reviewer comments

2015-06-24 Kurt Hornik

```
We get

Possibly mis-spelled words in DESCRIPTION:
  shinyjs (11:5, 12:42)

Pls use single quotes, or write "This package".

Found the following (possibly) invalid URLs:
  URL: http://daattali.com/shiny/colourInput/
    From: man/colourInput.Rd
          man/updateColourInput.Rd
          inst/doc/overview.html
    Status: 404
    Message: Not Found
  URL: http://daattali.com/shiny/shinyjs-basic/
    From: inst/doc/overview.html
    Status: 404
    Message: Not Found
  URL: http://daattali.com/shiny/shinyjs-demo/
    From: man/runExample.Rd
          man/shinyjs.Rd
          inst/doc/overview.html
    Status: 404
    Message: Not Found

Pls fix.

Best
-k
```

# Round 2

## Test environments

* Windows 7, R 3.2.0 (local)
* ubuntu 12.04, R 3.2.0 (on travis-ci)
* ubuntu 14.04, R 3.1.3 (on my DigitalOcean droplet)

## Submission comments

2015-06-24

```
Addressed previous comment: wrapped package name in single quotes in DESCRIPTION file.  
R CMD check has no ERRORs or WARNINGs, and the same 2 NOTEs: one is about having a NEWS.md file and one is about "possibly" invalid URLs. The URLs can't be fixed because they are shiny apps on a shiny server and shiny server doesn't support returning headers from curl
```

## Reviewer comments

2015-06-24 Uwe Ligges

Thanks, on CRAN now.


---

# Version 0.0.8.3

# Round 1

## Test environments

* Windows 7, R 3.2.0 (local)
* ubuntu 12.04, R 3.2.0 (on travis-ci)
* ubuntu 14.04, R 3.1.3 (on my DigitalOcean droplet)

## Submission comments

2015-07-30

R CMD check has no ERRORs or WARNINGs, and 2 NOTEs: one is about "possibly" invalid URLs - this is because the URLs are shiny apps on a shiny server and shiny server doesn't support returning headers from the curl tool, the other NOTE is about having NEWS.md as a top-level file.

## Reviewer comments

2015-07-30 Kurt Hornik

```
There's also

* checking R code for possible problems ... NOTE
formatHEXsingle: no visible global function definition for ‘colors’
formatHEXsingle: no visible binding for global variable ‘rgb’
formatHEXsingle: no visible global function definition for ‘col2rgb’
Undefined global functions or variables:
  col2rgb colors rgb
Consider adding
  importFrom("grDevices", "col2rgb", "colors", "rgb")
to your NAMESPACE.

Pls fix.

Re

Found the following (possibly) invalid URLs:
  URL: http://daattali.com/shiny/colourInput/
    From: man/colourInput.Rd
          man/updateColourInput.Rd
          inst/doc/overview.html
    Status: 404
    Message: Not Found
  URL: http://daattali.com/shiny/shinyjs-basic/
    From: inst/doc/overview.html
    Status: 404
    Message: Not Found
  URL: http://daattali.com/shiny/shinyjs-demo/
    From: man/runExample.Rd
          man/shinyjs.Rd
          inst/doc/overview.html
    Status: 404
    Message: Not Found

I thought that new versions of shiny would honor HEAD requests?  (May
stil be devel only ...)

Best
-k
```

# Round 2

## Submission comments

2015-07-30

2 comments were made on previous submission: 1. I had to namespace all non-base functions, 2. Shiny does not yet honour HEAD requests (there's an open pull request for it)

## Reviewer comments

2015-07-30 Kurt Hornik

Thanks, on CRAN now.

I'll follow up with the shiny maintainer re HEAD.

Best
-k


---

# Version 0.1.0

# Round 1

## Test environments

* Windows 7, R 3.2.1 (local)
* ubuntu 12.04, R 3.2.1 (on travis-ci)
* ubuntu 14.04, R 3.1.3 (on my DigitalOcean droplet)

## Submission comments

2015-08-12

R CMD check has no ERRORs or WARNINGs, and 2 NOTEs: one is about having NEWS.md as a top-level file and the other is the generic NOTE informing me who the maintainer of the package is.

## Reviewer comments

2015-08-13 Kurt Hornik

Thanks, on CRAN now.

---

# Version 0.2.0

# Round 1

## Test environments

* Windows 7, R 3.2.2 (local)
* ubuntu 12.04, R 3.2.2 (on travis-ci)
* ubuntu 14.04, R 3.1.3 (on my DigitalOcean droplet)

## Submission comments

2015-09-05

Tested on Windows and 7 and Ubuntu 12.04. There were no ERRORs or WARNINGs and 1 NOTE that informed me who the maintainer and what the license is.

## Reviewer comments

2015-09-06 Uwe Ligges

```
Thanks, we see:


* checking R code for possible problems ... NOTE
delay: no visible global function definition for 'runif'
oneventHelper: no visible global function definition for 'runif'
Undefined global functions or variables:
  runif
Consider adding
  importFrom("stats", "runif")
to your NAMESPACE.
* checking Rd files ... OK

Please fix.
```

# Round 2

## Test environments

* local Windows 7, R 3.2.2
* ubuntu 12.04 (on travis-ci), R 3.2.2
* ubuntu 14.04, R 3.1.3 (on my DigitalOcean droplet)

## Submission comments:

2015-09-06

addressed previous comment: namespaced stats::runif

## Reviewer comments:

2015-09-06 Uwe Ligges

Thanks, on CRAN now.


---

# Version 0.2.3

# Round 1

## Test environments

* Windows 7, R 3.2.2 (local)
* ubuntu 12.04, R 3.2.2 (on travis-ci)
* ubuntu 14.04, R 3.1.3 (on my DigitalOcean droplet)

## Submission comments

2015-11-05

Tested on Windows and 7 and Ubuntu 12.04. There were no ERRORs or WARNINGs and 1 NOTE that informed me who the maintainer is and what the license is.

## Reviewer comments

2015-11-05 Kurt Hornik

```
We get

Found the following (possibly) invalid URLs:
  URL: http://cran.r-project.org/web/packages/shinyjs/index.html
    From: inst/doc/overview.html
    Status: 200
    Message: OK
    CRAN URL not in canonical form
  The canonical URL of the CRAN page for a package is
  https://cran.r-project.org/package=pkgname

Can you pls fix?

Best
-k
```

# Round 2

## Test environments

* local Windows 7, R 3.2.2
* ubuntu 12.04 (on travis-ci), R 3.2.2
* ubuntu 14.04, R 3.1.3 (on my DigitalOcean droplet)

## Submission comments:

2015-11-05

addressed previous comment: changed URL of CRAN package to canonical form

## Reviewer comments:

2015-11-08 Kurt Hornik

Thanks, on CRAN now.

---

# Version 0.3.0

# Round 1

## Test environments

* Windows 7, R 3.2.2 (local)
* ubuntu 12.04, R 3.2.2 (on travis-ci)
* ubuntu 14.04, R 3.1.3 (on my DigitalOcean droplet)

## Submission comments

2015-12-30

Tested on Windows and 7 and Ubuntu 12.04. There were no ERRORs or WARNINGs and 1 NOTE that informed me who the maintainer is and what the license is.

## Reviewer comments

2015-12-30 Uwe Ligges

Thanks, on CRAN now.

Although, I could not check the vignettes on Windows due to missing https support in my version of pandoc.

Best,
Uwe Ligges

# Version 0.4.0

# Round 1

## Test environments

* Windows 7, R 3.2.2 (local)
* ubuntu 12.04, R 3.2.2 (on travis-ci)
* ubuntu 14.04, R 3.1.3 (on my DigitalOcean droplet)

## Submission comments

2016-01-21

There were no ERRORs or WARNINGs and 1 NOTE that informed me who the maintainer is and what the license is. I know that submitting twice within a month is frowned upon, but the previous submission was because I was told by a CRAN maintainer that I need to update my package to adhere to a new rule, and I want to have this package ready for the Shiny Conference next week

## Reviewer comments

2016-01-21 Kurt Hornik

Thanks, on CRAN now.
2016-01-21 Kurt Hornik

Thanks, on CRAN now.

# Version 0.5.0

## Round 1

### Test environments

* Windows 7, R 3.2.4 (local)
* ubuntu 12.04, R 3.2.3 (on travis-ci)
* ubuntu 14.04, R 3.1.3 (on my DigitalOcean droplet)

### Submission comments

2016-03-19

R CMD check passed with no errors/warnings/notes

### Reviewer comments

2016-03-19 Kurt Hornik

Thanks, on CRAN now.
