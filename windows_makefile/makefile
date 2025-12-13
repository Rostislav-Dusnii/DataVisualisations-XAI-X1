# Windows-friendly Makefile matching team behaviour

RSCRIPT = "C:\Program Files\R\R-4.5.2\bin\x64\Rscript.exe"

# ---- install ----
install:
ifndef name
	$(RSCRIPT) -e "renv::install()"
else
	$(RSCRIPT) -e "renv::install('$(name)')"
endif

show_dependencies:
	$(RSCRIPT) -e "renv::dependencies()"

restore:
	$(RSCRIPT) -e "renv::restore()"

snapshot:
	$(RSCRIPT) -e "renv::snapshot()"

status:
	$(RSCRIPT) -e "renv::status()"


# ---- run an arbitrary R script ----
run_script:
ifndef script
	@echo ERROR - please provide a script path. Example:
	@echo    make run_script script=path/to/script.R
	@exit 1
else
	$(RSCRIPT) -e "renv::load(); source('$(script)')"
endif


# ---- run a Shiny app ----
run_shiny:
ifndef script
	@echo ERROR - please provide a script path. Example:
	@echo    make run_shiny script=app.R
	@exit 1
else
	$(RSCRIPT) -e "renv::load(); shiny::runApp('$(script)', port=8000)"
endif