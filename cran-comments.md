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

2015-04-20: Prof Brian Ripley

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
