#!usr/bin/make -f
# All commands are run as R functions rather than shell commands so that it will work easily on any Windows machine, even if the Windows machine isn't properly set up with all the right tools

all: README.md

clean:
	Rscript -e 'suppressWarnings(file.remove("README.md", "vignettes/shinyjs.md"))'

.PHONY: all clean
.DELETE_ON_ERROR:
.SECONDARY:

README.md : vignettes/shinyjs.Rmd
#	echo "Rendering the shinyjs vignette"
	Rscript -e 'rmarkdown::render("vignettes/shinyjs.Rmd", output_format = "md_document")'
#	echo "Correcting image paths"
#	sed -i -- 's,../inst,inst,g' vignettes/shinyjs.md
	Rscript -e 'file <- gsub("\\.\\./inst", "inst", readLines("vignettes/shinyjs.md")); writeLines(file, "vignettes/shinyjs.md")'
#	echo "Correcting paths to other reference vignettes"
	Rscript -e 'file <- gsub("\\((.*)\\.([rR]md)","(vignettes/\\1.\\2", readLines("vignettes/shinyjs.md")); writeLines(file, "vignettes/shinyjs.md")'
#	echo "Copying output to README.md"
#	cp vignettes/shinyjs.md README.md
	Rscript -e 'file.copy("vignettes/shinyjs.md", "README.md", overwrite = TRUE)'
	Rscript -e 'suppressWarnings(file.remove("vignettes/shinyjs.md"))'
