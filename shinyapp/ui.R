library(shiny)
library(datasets)

shinyUI(
  
    # fluid bootstrap layout
    fluidPage(    
        titlePanel("Graphics Explorer"),
        
        sidebarLayout(      
            sidebarPanel(
                selectInput("plotType", "Plot type:", 
                            choices=c("barplot", "boxplot", "histogram", "xyplot")),
              
                selectInput("variable", "Variable:", 
                            choices=c("carb","disp","drat","hp","mpg","qsec","wt")),
    
                selectInput("color", "Colour:", 
                            choices=c("blue", "green", "magenta", "orange", "red", "white")),
                
                selectInput("lineColor", "Line Colour:", 
                            choices=c("black", "blue", "green", "magenta", "orange", "red")),
                hr(),
                helpText("This Shiny application explores the graphics libraries available", 
                         "in R using the mtcars dataset. Choose the plot type, variable, colors and",
                         "graphics library to use.  A new plot will be rendered.")
            ),
          
            mainPanel(
                tabsetPanel(type="tabs", 
                            id="tabid",
                            tabPanel(title="base", value="base", plotOutput("basePlot")), 
                            tabPanel(title="lattice", value="lattice", plotOutput("latticePlot")), 
                            tabPanel(title="ggplot2", value="ggplot2", plotOutput("ggPlot"))
                )
            )
        )
    )
)