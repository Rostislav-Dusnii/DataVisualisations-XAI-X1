install:
	Rscript -e "renv::install();"

show_dependencies:
	Rscript -e "renv::dependencies();"

restore:
	Rscript -e "renv::restore();"

snapshot:
	Rscript -e "renv::snapshot();"
