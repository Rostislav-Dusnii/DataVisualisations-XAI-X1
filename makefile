install:
	@if [ -z "$(name)" ]; then \
		Rscript -e "renv::install()" \
		exit 1; \
	fi
	Rscript -e "renv::install('$(name)')"

show_dependencies:
	Rscript -e "renv::dependencies()"

restore:
	Rscript -e "renv::restore()"

snapshot:
	Rscript -e "renv::snapshot()"

run:
	@if [ -z "$(script)" ]; then \
		echo "❌ Error - '$(script)': please provide a script path. Example:"; \
		echo "   make run script=path/to/script.R"; \
		exit 1; \
	fi
	Rscript -e "renv::load(); source('$(script)')"
