context("measure memory")

test_that("memory measurements work", {
  reg = makeRegistry(file.dir = NA, make.default = FALSE)
  ids = batchMap(function(n) { m = matrix(runif(n), nrow = 10); m %*% t(m) }, n = c(100, 1e7), reg = reg)
  submitAndWait(reg, 1:2, resources = list(measure.memory = TRUE))

  expect_true(any(stri_detect_fixed(readLog(1L, reg = reg), "Memory measurement enabled")))
  expect_numeric(reg$status$memory, any.missing = FALSE)
  expect_true(reg$status$memory[2] > reg$status$memory[1])
})
