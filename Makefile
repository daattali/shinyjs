#!usr/bin/make -f
# All commands are run as R functions rather than shell commands so that it will work easily on any Windows machine, even if the Windows machine isn't properly set up with all the right tools

all: README.md

clean:
	Rscript -e 'suppressWarnings(file.remove("README.md", "vignettes/overview.md"))'

.PHONY: all clean
.DELETE_ON_ERROR:
.SECONDARY:

README.md : vignettes/overview.Rmd
#	echo "Rendering the overview vignette"
	Rscript -e 'rmarkdown::render("vignettes/overview.Rmd", output_format = "md_document")'
#	echo "Correcting image paths"
#	sed -i -- 's,../inst,inst,g' vignettes/overview.md
	Rscript -e 'file <- gsub("\\.\\./inst", "inst", readLines("vignettes/overview.md")); writeLines(file, "vignettes/overview.md")'
#	echo "Copying output to README.md"
#	cp vignettes/overview.md README.md
	Rscript -e 'file.copy("vignettes/overview.md", "README.md", overwrite = TRUE)'
	Rscript -e 'suppressWarnings(file.remove("vignettes/overview.md"))'
