################################################################################

plot.cddavardist <- function(obj = NULL, stat = "rhs",
                             ylim =  NULL, alpha = 0.05,
                             xlab = NULL, ylab = NULL, ...){
  ## ----------------------------------------------------------------------------------------------------------
  ## obj:          a cddavardist class object
  ## stat:         a character indicating the stat of statistic to be plotted
  ##               with options c("rhs", "cokurt", "rcc", "rtanh")
  ## Example:      cdda.vardist(y ~ x * mod + z, pred = "x", data = my.data) or
  ##               test <- y ~ x * mod + z
  ##               cdda.indep(test, pred = "x", mod = mod, modval = "mean", data = my.data)
  ## ---------------------------------------------------------------------------------------------------------

  ## Check for the type of object passed to the function
  if(class(obj) != "cddavardist"){
    stop("Object must be of class 'cddaindep' or 'cddavardist'.")
  }

  if(stat != "rhs" & stat != "cokurt" & stat != "rcc" & stat != "rtanh"){
    stop("stat must be one of 'rhs', 'cokurt', 'rcc', or 'rtanh'.")
  }

  ## Plot Label and Assignment ##
  mod.vals <- obj[[4]][["mod_data"]] #modvalues, raw data
  mod.levels <- x.axis.labels <- obj[[4]][["mod_levels"]] #"modval levels for pick-a-point, not raw data"
  y.title <- obj[[3]][[1]] #Test statistic CI header

  tar.model.label <- paste0(obj[[4]]["response_name"], "|", obj[[4]]["mod_name"],
                            "\u2192", obj[[4]]["pred_name"]) # y ~ x | m
  alt.model.label <- paste0(obj[[4]]["pred_name"], "|", obj[[4]]["mod_name"],
                            "\u2192", obj[[4]]["response_name"]) # x ~ y | m

  ### Limits for X-axis ####

  if(is.numeric(mod.levels)){
    x.range <- c(min(mod.levels), max(mod.levels))
    plot.axis <- mod.levels
  }
  else {x.range <- c(1, length(mod.levels))
  plot.axis <- 1:length(mod.levels)
  }

  out <- matrix(NA, length(plot.axis), 6)

  if (stat == "rhs"){
    y.title <- "RHS Differences (95% CI)"
    if(is.null(obj[[1]][[1]]$RHS)){
      stop( "mitests not found. Specify coskew = TRUE." )
      y.title <- "RHS"
    }

    for (i in 1:length(plot.axis)) {
      out[i, ] <- c(obj[[1]][[i]]$RHS, obj[[2]][[i]]$RHS)
    }
  }

  if (stat == "cokurt"){

    y.title <- "Co-Kurtosis Differences (95% CI)"
    if(is.null(obj[[1]][[1]]$cor13diff)){
      stop( "mitests not found. Specify cokurt = TRUE." )
      y.title <- "Co-Kurtosis"
    }

    for(i in 1:length(plot.axis)){
      out[i, ] <- c(obj[[1]][[i]]$cor13diff, obj[[2]][[i]]$cor13diff)
    }
  }

  if (stat == "rcc"){
    y.title <- "RCC Differences (95% CI)"
    if(is.null(obj[[1]][[1]]$RCC)){
      stop( "mitests not found. Specify cokurt = TRUE." )
      y.title <- "RCC"
    }

    for (i in 1:length(plot.axis)) {
      out[i, ] <- c(obj[[1]][[i]]$RCC, obj[[2]][[i]]$RCC)
    }
  }

  if (stat == "rtanh"){
    y.title <- "Rtanh Differences (95% CI)"
    if(is.null(obj[[1]][[1]]$Rtanh)){
      stop( "mitests not found. Specify cokurt = TRUE." )
      y.title <- "Rtanh"
    }

    for (i in 1:length(plot.axis)) {
      out[i, ] <- c(obj[[1]][[i]]$Rtanh, obj[[2]][[i]]$Rtanh)
    }
  }

  ### Vardist Plotting ################################################

  ### Matrix Creation ###

  out.tar <- data.frame(condition = plot.axis, out.mean = out[,1],
                        out.low = out[,2], out.upp = out[,3])
  out.alt <- data.frame(condition = plot.axis, out.mean = out[,4],
                        out.low = out[,5], out.upp = out[,6])

  ### Set the y-axis ###

  if(is.null(ylim)) { y.range <- c(min(c(out.tar$out.low, out.alt$out.low)) - 0.1,
                                   max(c(out.tar$out.upp, out.alt$out.upp) + 0.1) )
  } else{y.range <- ylim}

  ### Start two plots ###

  par(mfrow = c(1, 2))

  plot(plot.axis, out.tar$out.mean, type = "n",
       ylim = y.range, xlim = x.range, xaxt = "n",
       xlab = tar.model.label, ylab = y.title, main = "Target Model")
  axis(1, at = 1:length(out.tar$condition), labels = x.axis.labels)
  polygon(x = c(out.tar$condition, rev(out.tar$condition)),
          y = c(out.tar$out.low, rev(out.tar$out.upp)),
          border = FALSE, col = "lightgrey")
  points(out.tar$condition, out.tar$out.mean, type = "l")
  abline(h = 0, lty = "dashed")


  plot(plot.axis, out.alt$out.mean, type = "n",
       ylim = y.range, xlim = x.range, xaxt = "n",
       xlab = alt.model.label, ylab = y.title, main = "Alternative Model")
  axis(1, at = 1:length(out.tar$condition), labels = x.axis.labels)
  polygon(x = c(out.alt$condition, rev(out.alt$condition)),
          y = c(out.alt$out.low, rev(out.alt$out.upp)),
          border = FALSE, col = "lightgrey")
  points(out.alt$condition, out.alt$out.mean, type = "l")
  abline(h = 0, lty = "dashed")
}

par(mfrow = c(1, 1))


