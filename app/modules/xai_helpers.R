# Small helpers shared by modules

# Convert text to HTML with line breaks and bullets
markdownify <- function(txt) {
  txt <- gsub("\n\\- ", "<br>• ", txt)
  txt <- gsub("\n\n", "<br><br>", txt)
  txt <- gsub("\n", "<br>", txt)
  HTML(txt)
}

# Call OpenAI API for chat completion
gpt_complete <- function(system_prompt, user_prompt, model = "gpt-4o-mini", temperature = 0.7) {
  api_key <- Sys.getenv("OPENAI_API_KEY")

  if (api_key == "") {
    stop("OPENAI_API_KEY environment variable not set")
  }

  response <- httr2::request("https://api.openai.com/v1/chat/completions") |>
    httr2::req_headers(
      "Authorization" = paste("Bearer", api_key),
      "Content-Type" = "application/json"
    ) |>
    httr2::req_body_json(list(
      model = model,
      temperature = temperature,
      messages = list(
        list(role = "system", content = system_prompt),
        list(role = "user", content = user_prompt)
      )
    )) |>
    httr2::req_perform() |>
    httr2::resp_body_json()

  response$choices[[1]]$message$content
}

# Compute correlation and regression stats for x/y variables
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
