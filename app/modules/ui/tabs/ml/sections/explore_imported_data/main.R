source(path(PATH_UI_EXP_IMPORT,"tabset.R"))

# explore data main container
main <- argonColumn(
  width = 12,
  argonCard(
    width = 12, shadow = TRUE,
    tabset
  )
)
