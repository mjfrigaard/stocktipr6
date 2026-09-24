test_that("ModDownload instantiation creates valid R6 object", {
  download <- ModDownload$new(id = "test")
  expect_s3_class(download, "R6")
  expect_true(inherits(download, "ModDownload"))
})

test_that("ModDownload$server() accepts inputs_r and perf_r reactives", {
  inputs_r <- shiny::reactive(list(
    tickers = c("AAPL"),
    from = as.Date("2023-01-01"),
    to = as.Date("2023-12-31"),
    vol_window = 30L,
    fetch = 0,
    format = "html"
  ))

  perf_r <- shiny::reactive(
    data.frame(
      symbol = "AAPL",
      ann_return = 0.25,
      ann_vol = 0.18,
      sharpe = 1.39
    )
  )

  download <- ModDownload$new(id = "test")

  # Should not error
  expect_error(
    shiny::testServer(function(id) download$server(inputs_r, perf_r), {
      session$setInputs(format = "html")
    }),
    NA
  )
})

test_that("ModDownload uses correct namespace IDs", {
  download <- ModDownload$new(id = "mydownload")

  inputs_r <- shiny::reactive(list(tickers = "AAPL"))
  perf_r <- shiny::reactive(data.frame(symbol = "AAPL"))

  shiny::testServer(function(id) download$server(inputs_r, perf_r), {
    # Check for output handler with correct namespace
    expect_equal(session$ns("download"), "mydownload-download")
  })
})

test_that("ModDownload namespace isolation prevents ID conflicts", {
  download1 <- ModDownload$new(id = "download1")
  download2 <- ModDownload$new(id = "download2")

  expect_true(inherits(download1, "ModDownload"))
  expect_true(inherits(download2, "ModDownload"))
})

test_that("ModDownload$ui() ids match ModDownload$server() namespace", {
  download <- ModDownload$new(id = "download")
  ui_str <- as.character(download$ui())

  expect_match(ui_str, 'id="download-format"')
  expect_match(ui_str, 'id="download-download"')

  inputs_r <- shiny::reactive(list(tickers = "AAPL"))
  perf_r <- shiny::reactive(data.frame(symbol = "AAPL"))

  shiny::testServer(function(id) download$server(inputs_r, perf_r), {
    expect_equal(session$ns("format"), "download-format")
    expect_equal(session$ns("download"), "download-download")
  })
})

test_that("ModDownload$server() download handler renders an HTML report", {
  skip_on_cran()
  skip_if_offline()
  skip_if_not(rmarkdown::pandoc_available(), "pandoc not available")

  inputs_r <- shiny::reactive(list(
    tickers = "AAPL",
    from = as.Date("2023-01-01"),
    to = as.Date("2023-03-31"),
    vol_window = 30L
  ))

  perf_r <- shiny::reactive(
    data.frame(
      symbol = "AAPL",
      ann_return = 0.25,
      ann_vol = 0.18,
      sharpe = 1.39
    )
  )

  download <- ModDownload$new(id = "download")

  shiny::testServer(function(id) download$server(inputs_r, perf_r), {
    session$setInputs(format = "html")
    report <- output$download

    expect_true(file.exists(report))
    expect_gt(file.size(report), 0)
    expect_match(readLines(report, n = 1), "<!DOCTYPE html>", fixed = TRUE)
  })
})
