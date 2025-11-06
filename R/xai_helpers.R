# small helpers shared by modules
markdownify <- function(txt) {
  txt <- gsub("\n\\- ", "<br>• ", txt)
  txt <- gsub("\n\n", "<br><br>", txt)
  txt <- gsub("\n", "<br>", txt)
  HTML(txt)
}

summarize_xy <- function(d, x, y) {
  d <- stats::na.omit(d[, c(x, y), drop = FALSE])
  n <- nrow(d)
  cor_xy <- suppressWarnings(cor(d[[x]], d[[y]]))
  fit <- tryCatch(lm(stats::as.formula(paste(y, "~", x)), data = d), error = function(e) NULL)
  slope <- if (!is.null(fit)) unname(coef(fit)[2]) else NA_real_
  list(
    n = n, x = x, y = y,
    correlation = round(cor_xy, 3),
    slope = round(slope, 3),
    x_min = round(min(d[[x]]), 2), x_max = round(max(d[[x]]), 2),
    y_min = round(min(d[[y]]), 2), y_max = round(max(d[[y]]), 2)
  )
}
