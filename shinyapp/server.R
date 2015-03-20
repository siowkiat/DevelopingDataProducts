library(shiny)
library(datasets)
library(lattice)
library(ggplot2)

shinyServer(function(input, output) {
  
    mtcars$am.f <- factor(mtcars$am,levels=c(0,1), labels=c("Automatic","Manual"))
    mtcars$model <- rownames(mtcars)
    ########################################
    # base graphics
    ########################################
    observe({
    if (input$tabid == "base")
    {
    output$basePlot <- renderPlot({
        if (input$plotType == "barplot")
        {
            # base
            oldmar <- par()$mar
            par(mar=c(5.1,8,4.1,2.1))
            
            barplot(mtcars[,input$variable],
                    names.arg=mtcars$model, 
                    horiz=TRUE,
                    las=1,
                    col=input$color,
                    border=input$lineColor,
                    xlab=input$variable,
                    main=paste("Barplot:", input$variable, sep=" "),
                    cex.names = 0.8,
                    cex.lab = 1.5,
                    cex.axis = 1,
                    cex.main = 2)
            par(mar=oldmar)
    
        }
        else if(input$plotType == "boxplot")
        {
            # base
            boxplot(mtcars[,input$variable] ~ am.f,
                    data = mtcars, 
                    col=input$color,
                    border=input$lineColor,
                    xlab="Transmission", 
                    ylab=input$variable, 
                    main=paste("Boxplot:", input$variable, "vs Transmission", sep=" "),
                    cex.lab = 1.5,
                    cex.axis = 1,
                    cex.main = 2)
        }
        else if(input$plotType == "histogram")
        {
            # base
            hist(mtcars[,input$variable], 
                    xlab=input$variable,
                    col=input$color,
                    border=input$lineColor,
                    main=paste("Histogram:", input$variable, sep=" "),
                    cex.lab = 1.5,
                    cex.axis = 1,
                    cex.main = 2)
            
        }
        else if(input$plotType == "xyplot")
        {
            # base
            par(mfrow=c(1,2))
            # automatic transmission
            auto.y <- mtcars[mtcars$am==0,"mpg"]
            auto.x <- mtcars[mtcars$am==0,input$variable]
            
            plot(y=auto.y, 
                 x=auto.x, 
                   type = "p", 
                   xlab=input$variable, 
                   ylab="Miles per Gallon", 
                   col=input$color,
                   main=paste("Automatic: mpg vs", input$variable, sep = " "),
                   cex.lab = 1.5,
                   cex.axis = 1,
                   cex.main = 2)
            auto.fit <- lm (auto.y ~ auto.x)
            abline(auto.fit, lty = "dashed", col=input$lineColor)
            
            # manual transmission
            manual.y <- mtcars[mtcars$am==1,"mpg"]
            manual.x <- mtcars[mtcars$am==1,input$variable]
            
            plot(y=manual.y, 
                 x=manual.x, 
                 type = "p", 
                 xlab=input$variable, 
                 ylab="Miles per Gallon", 
                 col=input$color,
                 main=paste("Manual: mpg vs", input$variable, sep = " "),
                 cex.lab = 1.5,
                 cex.axis = 1,
                 cex.main = 2)
            manual.fit <- lm (manual.y ~ manual.x)
            abline(manual.fit, lty = "dashed", col=input$lineColor)
            par(mfrow=c(1,1))
        }
    })
    }
    
    ########################################
    # lattice plot
    ########################################
    if (input$tabid == "lattice")
    {
    output$latticePlot <- renderPlot({
        
        if (input$plotType == "barplot")
        {
            # lattice
            barchart(mtcars$model ~ mtcars[,input$variable],
                     col=input$color,
                     border=input$lineColor,
                     cex.names = 0.7,
                     main=list(paste("Barchart:", input$variable, sep=" "), cex=2),
                     xlab=list(label=input$variable, cex=1.5),
            )
        }
        else if(input$plotType == "boxplot")
        {
            # lattice
            bwplot(mtcars[,input$variable] ~ am.f,
                data = mtcars, 
                fill=input$color,
                par.settings = list( box.umbrella=list(col= c(input$lineColor)), 
                                     box.dot=list(col= c(input$lineColor)), 
                                     box.rectangle = list(col= c(input$lineColor))
                                    ),
                xlab=list(label="Transmission", cex=1.5), 
                ylab=list(label=input$variable, cex=1.5), 
                main=list(paste(input$variable, "vs Transmission", sep=" "), cex=2),
                scales=list(cex=1))
        }
        else if(input$plotType == "histogram")
        {
            # lattice
            histogram(mtcars[,input$variable], 
                      type = c("count"),
                      col=input$color,
                      border=input$lineColor,
                      xlab=list(label=input$variable, cex=1.5),
                      ylab=list(cex=1.5), 
                      main=list(paste("Histogram:", input$variable, sep=" "), cex=2),
                      )            
        }
        else if(input$plotType == "xyplot")
        {
            # lattice
            xyplot(mtcars$mpg ~ mtcars[,input$variable] | mtcars$am.f, 
                   type = c("p","r"), 
                   par.settings=simpleTheme(col=input$color, 
                                            col.line=input$lineColor), 
                   lty = "dashed",
                   layout = c(2, 1), 
                   xlab=list(label=input$variable, cex=1.5),
                   ylab=list(label="Miles per Gallon", cex=1.5),
                   main=list(paste("mpg vs", input$variable, sep = " "), cex=2),
                   )
        }
    })
    }
    
    ########################################
    # ggplot2 plot
    ########################################
    if (input$tabid == "ggplot2")
    {
    output$ggPlot <- renderPlot({
        
        if (input$plotType == "barplot")
        {
            # ggplot2
            df <- data.frame(var=mtcars[,input$variable], model=mtcars$model)
            g <- ggplot(df, aes(y=var, x=model)) +
                geom_bar(stat="identity", 
                         colour=input$lineColor, 
                         fill=input$color,
                         alpha=1/2) + 
                coord_flip() +
                theme(plot.title=element_text(size=rel(2),face="bold"), 
                      axis.text=element_text(size=rel(0.7)), 
                      axis.title=element_text(size=rel(1.5))) +
                labs(x="", y=input$variable) +
                labs(title=paste(paste("Barchart:", input$variable, sep=" ")))
            print(g)
        }
        else if(input$plotType == "boxplot")
        {
            # ggplot2
            df <- data.frame(var=mtcars[,input$variable], am.f=mtcars$am.f)
            g <- ggplot(df, aes(y=var, x=am.f)) +
                geom_boxplot(color=input$lineColor, 
                             fill=input$color, 
                             alpha=1/2, 
                             outlier.colour=input$lineColor,
                             outlier.shape = 1, 
                             outlier.size = 4) +
                theme(plot.title=element_text(size=rel(2),face="bold"), 
                      axis.text=element_text(size=rel(1)), 
                      axis.title=element_text(size=rel(1.5))) +
                labs(x="Transmission", y=input$variable) +
                labs(title=paste(input$variable, "vs Transmission", sep=" "))
            print(g)
        }
        else if(input$plotType == "histogram")
        {
            # ggplot2
            df <- data.frame(var=mtcars[,input$variable])
            binwidth <- round(max(df$var)/8, 0)
            g <- ggplot(df, aes(x=var)) +
                 geom_histogram(color=input$lineColor, 
                                fill=input$color, 
                                alpha=1/2,
                                binwidth=binwidth) +
                 theme(plot.title=element_text(size=rel(2),face="bold"), 
                       axis.text=element_text(size=rel(1)), 
                       axis.title=element_text(size=rel(1.5))) +
                 labs(x=input$variable) +
                 labs(title=paste("Histogram:", input$variable, sep=" "))
            print(g)
        }
        else if(input$plotType == "xyplot")
        {
            # ggplot2
            df <- data.frame(mpg=mtcars$mpg, var=mtcars[,input$variable], am.f=mtcars$am.f)
            g <- ggplot(df, aes(x=var, y=mpg)) +
                 geom_point(color=input$color, size = 3) + 
                 geom_smooth(method="lm", color=input$lineColor, size=1, linetype=2) +
                 facet_grid(. ~ am.f) + 
                 theme(plot.title=element_text(size=rel(2),face="bold"), 
                       strip.text=element_text(size=rel(1.2)), 
                       axis.text=element_text(size=rel(1)), 
                       axis.title=element_text(size=rel(1.5))) +
                 labs(x = input$variable) + 
                 labs(y = "Miles per Gallon") + 
                 labs(title = paste("mpg vs", input$variable, sep = " "))
            print(g)
        }
    })
    }
    })
})
