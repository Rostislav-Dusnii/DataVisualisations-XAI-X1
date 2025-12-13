source(path(PATH_UI_IMPORT_DATA,"tabset.R"))

# import data main container
main <- argonColumn(
  width = 9,
  argonCard(
    width = 12, shadow = TRUE,
    tabset
  )
)
