test_that("ModInputs instantiation creates valid R6 object", {
  inputs <- ModInputs$new(id = "test")
  expect_s3_class(inputs, "R6")
  expect_true(inherits(inputs, "ModInputs"))
})

test_that("ModInputs$ui() returns valid Shiny sidebar", {
  inputs <- ModInputs$new(id = "test")
  ui <- inputs$ui()

  expect_s3_class(ui, "bslib_sidebar")
  # Check for key input elements
  ui_str <- as.character(bslib::layout_sidebar(sidebar = ui))
  expect_match(ui_str, "selectize")
  expect_match(ui_str, "shiny-date-range-input")
  expect_match(ui_str, "js-range-slider")
  expect_match(ui_str, "Fetch data")
})

test_that("ModInputs$ui() uses correct namespace IDs", {
  inputs <- ModInputs$new(id = "myinputs")
  ui <- inputs$ui()
  ui_str <- as.character(bslib::layout_sidebar(sidebar = ui))

  expect_match(ui_str, "myinputs-tickers")
  expect_match(ui_str, "myinputs-dates")
  expect_match(ui_str, "myinputs-vol_window")
  expect_match(ui_str, "myinputs-fetch")
})

test_that("ModInputs$server() returns reactive list", {
  inputs <- ModInputs$new(id = "test")

  shiny::testServer(function(id) inputs$server(), {
    session$setInputs(
      tickers = "AAPL",
      dates = as.Date(c("2023-01-01", "2023-12-31")),
      vol_window = 30L,
      fetch = 0,
      format = "html"
    )

    # Verify it returns a reactive
    expect_true(shiny::is.reactive(session$returned))

    # Call the reactive and check structure
    inp_vals <- session$returned()
    expect_type(inp_vals, "list")
    expect_true("tickers" %in% names(inp_vals))
    expect_true("from" %in% names(inp_vals))
    expect_true("to" %in% names(inp_vals))
    expect_true("vol_window" %in% names(inp_vals))
    expect_true("fetch" %in% names(inp_vals))
    expect_true("format" %in% names(inp_vals))
  })
})

test_that("ModInputs reactive updates when inputs change", {
  inputs <- ModInputs$new(id = "test")

  shiny::testServer(function(id) inputs$server(), {
    # Initial state
    session$setInputs(tickers = c("AAPL", "MSFT", "GOOGL"))
    expect_equal(session$returned()$tickers, c("AAPL", "MSFT", "GOOGL"))

    # Simulate input change
    session$setInputs(tickers = c("AMZN", "TSLA"))

    # Reactive should update
    expect_equal(session$returned()$tickers, c("AMZN", "TSLA"))
  })
})

test_that("ModInputs namespace isolation prevents ID conflicts", {
  inputs1 <- ModInputs$new(id = "inputs1")
  inputs2 <- ModInputs$new(id = "inputs2")

  ui1 <- as.character(bslib::layout_sidebar(sidebar = inputs1$ui()))
  ui2 <- as.character(bslib::layout_sidebar(sidebar = inputs2$ui()))

  expect_match(ui1, "inputs1-tickers")
  expect_match(ui2, "inputs2-tickers")
  expect_no_match(ui1, "inputs2")
  expect_no_match(ui2, "inputs1")
})
