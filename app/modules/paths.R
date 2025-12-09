# ============================================================
# paths.R — Centralized Project Paths (Shiny-safe)
# ============================================================

path <- function(...) {
  file.path(...)
}


# -------------------------------------------------------------------
# Core folders
# -------------------------------------------------------------------

PATH_APP        <- getwd()
PATH_MODULES    <- path("modules")
PATH_UI         <- path("modules/ui")
PATH_SERVER     <- path("modules/server")
PATH_R          <- path("modules", "R")   # your non-module R files

# -------------------------------------------------------------------
# Modules (top-level)
# -------------------------------------------------------------------

PATH_DATASET            <- path("modules/server/dataset")
PATH_DATASET_UTILS      <- path("modules/server/dataset/utils")

PATH_TABS               <- path("modules/server/tabs")
PATH_CHATBOT            <- path("modules/server/tabs/chatbot")
PATH_ML                 <- path("modules/server/tabs/ml")
PATH_XAI_SERVER         <- path("modules/server/tabs/xai")

# -------------------------------------------------------------------
# ML – Sections
# -------------------------------------------------------------------

PATH_ML_SECTIONS        <- path("modules/server/tabs/ml/sections")

# explore_imported_data
PATH_EXP_IMPORT         <- path(PATH_ML_SECTIONS, "explore_imported_data")
PATH_EXP_IMPORT_TABS    <- path(PATH_EXP_IMPORT, "tabs")

# explore_results
PATH_EXP_RESULTS        <- path(PATH_ML_SECTIONS, "explore_results")
PATH_EXP_RESULTS_TABS   <- path(PATH_EXP_RESULTS, "tabs")

# import_data
PATH_IMPORT_DATA        <- path(PATH_ML_SECTIONS, "import_data")
PATH_IMPORT_DATA_SIDEBAR <- path(PATH_IMPORT_DATA, "sidebar")
PATH_IMPORT_DATA_TABS   <- path(PATH_IMPORT_DATA, "tabs")
PATH_IMPORT_DATA_UTILS  <- path(PATH_IMPORT_DATA, "tabs/utils")

# save_models
PATH_SAVE_MODELS        <- path(PATH_ML_SECTIONS, "save_models")
PATH_SAVE_MODELS_UTILS  <- path(PATH_SAVE_MODELS, "utils")

# train_models
PATH_TRAIN_MODELS       <- path(PATH_ML_SECTIONS, "train_models")
PATH_TRAIN_ML           <- path(PATH_TRAIN_MODELS, "ml")
PATH_TRAIN_UTILS        <- path(PATH_TRAIN_ML, "utils")
PATH_TRAIN_FIT_H2O      <- path(PATH_TRAIN_UTILS, "fit/h2o")
PATH_TRAIN_FIT_MLR      <- path(PATH_TRAIN_UTILS, "fit/mlr")

# select_parameters
PATH_SELECT_PARAMS      <- path(PATH_TRAIN_MODELS, "select_parameters")

# -------------------------------------------------------------------
# UI Structure
# -------------------------------------------------------------------

PATH_UI_TABS            <- path("modules/ui/tabs")
PATH_UI_CHATBOT         <- path(PATH_UI_TABS, "chatbot")
PATH_UI_ML              <- path(PATH_UI_TABS, "ml")
PATH_UI_ML_SECTIONS     <- path(PATH_UI_ML, "sections")

# explore_imported_data (UI)
PATH_UI_EXP_IMPORT      <- path(PATH_UI_ML_SECTIONS, "explore_imported_data")
PATH_UI_EXP_IMPORT_TABS <- path(PATH_UI_EXP_IMPORT, "tabs")

# explore_results (UI)
PATH_UI_EXP_RESULTS      <- path(PATH_UI_ML_SECTIONS, "explore_results")
PATH_UI_EXP_RESULTS_TABS <- path(PATH_UI_EXP_RESULTS, "tabs")

# import_data (UI)
PATH_UI_IMPORT_DATA      <- path(PATH_UI_ML_SECTIONS, "import_data")
PATH_UI_IMPORT_TABS      <- path(PATH_UI_IMPORT_DATA, "tabs")

# save_models (UI)
PATH_UI_SAVE_MODELS      <- path(PATH_UI_ML_SECTIONS, "save_models")

# summary (UI)
PATH_UI_SUMMARY          <- path(PATH_UI_ML_SECTIONS, "summary")

# train_models (UI)
PATH_UI_TRAIN_MODELS     <- path(PATH_UI_ML_SECTIONS, "train_models")
PATH_UI_TRAIN_CARDS      <- path(PATH_UI_TRAIN_MODELS, "cards")

# XAI
PATH_UI_XAI              <- path(PATH_UI_TABS, "xai")

# -------------------------------------------------------------------
# Root-level R Files
# -------------------------------------------------------------------

PATH_HELPERS      <- path("modules/helpers.R")
PATH_SETTINGS     <- path("modules/settings.R")
PATH_UI_MAIN      <- path("modules/ui.R")
PATH_SERVER_MAIN  <- path("modules/server.R")
PATH_XAI_HELPERS  <- path("modules/xai_helpers.R")

# ============================================================
# END OF PATHS
# ============================================================
