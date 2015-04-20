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

2015-04-19: Prof Brian Ripley

Hmm, we see

*checking CRAN incoming feasibility ... NOTE
Package has a VignetteBuilder field but no prebuilt vignette index.

Found the following (possibly) invalid URLs:
  URL: http://daattali.com:3838/shinyjs-demo/
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
  URL: http://daattali.com:3838/shinyjs-demo/  
  From:  
    man/runExample.Rd  
    man/shinyjs.Rd  

  Status: 404  
  Message: Not Found  

## Reviewer comments
