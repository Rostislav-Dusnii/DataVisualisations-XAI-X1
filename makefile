install:
	@if [ -z "$(name)" ]; then \
		Rscript -e "renv::install()"; \
	else \
		Rscript -e "renv::install('$(name)')"; \
	fi

show_dependencies:
	Rscript -e "renv::dependencies()"

restore:
	Rscript -e "renv::restore()"

snapshot:
	Rscript -e "renv::snapshot()"

status:
	Rscript -e "renv::status()"

run_script:
	@if [ -z "$(script)" ]; then \
		echo "❌ Error - please provide a script path. Example:"; \
		echo "   make run script=path/to/script.R"; \
		exit 1; \
	fi; \
	Rscript -e "renv::load(); source('$(script)')"

run_shiny:
	@if [ -z "$(script)" ]; then \
		echo "❌ Error - please provide a script path. Example:"; \
		echo "   make run script=app.R"; \
		exit 1; \
	fi; \
	Rscript -e "renv::load(); shiny::runApp('$(script)', port=8000)"
