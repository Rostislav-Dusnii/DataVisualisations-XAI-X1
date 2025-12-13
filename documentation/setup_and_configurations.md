
## Makefile
We designed makefiles for Unix-based and Windows operating systems, that provide you shortcuts for every needed functionality to run the service

In order to use them you need to install "make" package. You can follow guides specific to your operating system like [Ubuntu](https://www.geeksforgeeks.org/installation-guide/how-to-install-make-on-ubuntu/) or [Windows](https://gnuwin32.sourceforge.net/packages/make.htm) 

After proper installation you will be able to run "make" commands from root of the project folder if you use Unix-based system Or from "windows_makefile" folder if you use Windows.

## Basic R

You can use the basic Rscript by simply adding ``Rscript -e "{equivalent to "make" R command}`` before every command equivalents that will be described below

Below is **end-user documentation** you can include in a `README.md` or similar. It explains each Makefile target, what it does, and how to use it—no internal Make knowledge required.

## Instructions
### Make Usage Pattern

```bash
make <target> [variable=value]
```

Some targets accept optional variables such as `name` or `script`.

---

## Available Commands

### 1. Install Dependencies

#### Install all dependencies from `renv.lock`

```bash
make install
```

* Installs **all packages** used in the project
* Equivalent to running:

  ```r
  renv::install()
  ```

#### Install a specific package

```bash
make install name=ggplot2
```

* Installs only the specified package
* Useful for adding new dependencies
* Equivalent to:

  ```r
  renv::install("ggplot2")
  ```

---

### 2. Show Project Dependencies

```bash
make show_dependencies
```

* Scans the project for used packages
* Displays detected dependencies
* Equivalent to:

  ```r
  renv::dependencies()
  ```

---

### 3. Restore Environment

```bash
make restore
```

* Restores the R environment exactly as defined in `renv.lock`
* Recommended when:

  * Cloning the project for the first time
  * Switching machines
  * Fixing dependency mismatches
* Equivalent to:

  ```r
  renv::restore()
  ```

---

### 4. Snapshot Dependencies

```bash
make snapshot
```

* Updates `renv.lock` to match currently installed packages
* Use this **after adding or upgrading packages**
* Equivalent to:

  ```r
  renv::snapshot()
  ```

---

### 5. Check Environment Status

```bash
make status
```

* Shows differences between:

  * Installed packages
  * `renv.lock`
* Helps detect out-of-sync dependencies
* Equivalent to:

  ```r
  renv::status()
  ```

---

### 6. Run an R Script

```bash
make run_script script=path/to/script.R
```

* Loads the `renv` environment
* Executes the specified R script
* Fails with a clear error if no script is provided

Example:

```bash
make run_script script=scripts/analysis.R
```

Internally runs:

```r
renv::load()
source("scripts/analysis.R")
```

---

### 7. Run a Shiny App

```bash
make run_shiny script=app.R
```

* Loads the `renv` environment
* Launches a Shiny application
* The script can be:

  * `app.R`
  * A directory containing a Shiny app

Example:

```bash
make run_shiny script=shiny_app/
```

Internally runs:

```r
renv::load()
shiny::runApp("app.R")
```