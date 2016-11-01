#' Read a 30 second sensor file
#'
#' @param file Name of file to read
#' @param lanes Vector of lanes to read. Others ignored.
#' @param numlanes Total expected number of lanes in file
#' @param nrows Number of rows to read.
#' @param ... Additional parameters for read.table
#' @return data.frame
read30sec = function(file, lanes = 1:2, numlanes = 8, nrows = -1, ...)
{
    ln = data.frame(number = rep(seq.int(numlanes), each = 3))
    ln$name = paste0(rep(c("flow", "occupancy", "speed"), numlanes), ln$number)
    ln$class = rep(c("integer", "numeric", "integer"), numlanes)
    ln$keep = ln$number %in% lanes
    ln$colname = ifelse(ln$keep, ln$name, "NULL")
    ln$colclass = ifelse(ln$keep, ln$class, "NULL")

    rawdata = read.table(file, header = FALSE, sep = ",", nrows = nrows
        , col.names = c("timestamp", "station", ln$colname)
        , colClasses = c("character", "integer", ln$colclass)
        , ...)

    rawdata$timestamp = as.POSIXct(rawdata$timestamp, format = "%m/%d/%Y %H:%M:%S")

    rawdata
}
