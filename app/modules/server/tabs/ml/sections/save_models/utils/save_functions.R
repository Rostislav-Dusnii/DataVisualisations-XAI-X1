save_mlr_model <- function(model_obj, save_dir = "saved_models") {
  if (!dir.exists(save_dir)) dir.create(save_dir)
  file_path <- file.path(save_dir, paste0(model_obj$name, "_mlr.rds"))
  saveRDS(model_obj, file_path)
  return(file_path)
}

save_h2o_model <- function(model_obj, save_dir = "saved_models") {
  if (!dir.exists(save_dir)) dir.create(save_dir)
  # H2O models are saved differently
  file_path <- file.path(save_dir, paste0(model_obj$name, "_h2o"))
  h2o.saveModel(model_obj$fit, path = file_path, force = TRUE)
  return(file_path)
}
