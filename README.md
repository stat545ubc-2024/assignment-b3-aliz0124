# Caffeine in Drinks Shiny App

## Link to the app
https://aliz0124.shinyapps.io/assignment-b3-aliz0124/

## Description and Source
This is an R-based Shiny app for exploring the caffeine content in various drinks. The app allows users to filter by drink type, volume and caffeine levels, or search for individual drinks. Users can also visualize the data through an interactive bubble plot.  

The dataset was sourced from [Heitor Nunez](https://www.kaggle.com/datasets/heitornunes/caffeine-content-of-drinks) on Kaggle, who extracted the data from the [Caffeine Informer Caffeine Database](https://www.caffeineinformer.com/the-caffeine-database) website, which contains information on the caffeine content of drinks.


## Features

### 1. Grouped checkbox for drink types
This feature enables users to filter the dataset by drink type, making it easier to compare drinks across different types or analyze caffeine content and other variables within specific groups.

### 2. Slider to filter based on the volume (ml) or caffeine amount (mg) 
This feature helps users filter the dataset for drinks that meet their specific preferences or needs, such as finding drinks with high caffeine content or within a specific volume range.

### 3. Button to download the filtered data as a CSV
This feature is useful for users who want to save their filtered data for further analysis outside of the app, or share it with others.

### 4. Interactive data table 
An interactive table feature allows users to further explore their filtered data by sorting individual variables in ascending or descending order, or searching within filtered drinks.

### 5. Interactive bubble plot (Caffeine vs Volume with bubble size = calories).
This plot provides an accessible overview of how different drinks compare in terms of caffeine amount and volume, allowing users to visually spot trends in their filtered data. Using Plotly's interactive features enables users to hover over individual points to view information, isolate specific drink types, save the plot and more.




