# Assignment B3 and B4 Apps

# B4 - Survival Plot Maker: Customizable Survival Analysis Graphs

## Description
This idea behind this Shiny app was to make survival analysis accessible to a wider audience, including users with little to no coding experience. Instead of relying on expensive software or learning statistical programming (which may be difficult for some), users can easily generate fully customizable and downloadable survival plots. This tool is particularly useful for researchers, clinicians, and students who may need quick visualizations of their data as they explore potentially interesting trends within it, or need a quick plot for a presentation or meeting.  

The app format was designed to be user-friendly. Users can simply filter specific groups within their dataset, paste the values into the app, and generate a professional-quality plot.

## Link to the app
https://aliz0124.shinyapps.io/assignment-b4/

## Instructions and Sample Data

*Instructions*
1. Use the slider to select the number of groups in your data to plot.
2. Input your group name, and paste your time-to-event and censor data directly from your data file. Please note the formatting requirements.
3. Select plot customizations and add a title
4. Press the generate plot button, and you're done!

*Below are randomly generated sample data for 3 different groups for users to demo the app*:

**Group 1 time-to-event**
```
21
33
75
72
9
74
38
17
61
31
60
57
17
38
27
44
22
64
54
9
67
16
20
18
46
```

**Group 1 censor**
```
0
0
0
0
1
1
1
0
0
0
0
1
1
0
1
1
0
0
0
1
```

**Group 2 time-to-event**
```
3
26
74
74
53
3
30
4
75
33
70
35
2
53
70
32
11
49
7
19
6
11
58
29
50
```

**Group 2 censor**
```
1
0
0
0
0
0
0
1
1
0
1
0
0
1
1
1
0
0
1
1
1
0
1
1
1
```

**Group 3 time-to-event**
```
35
65
11
67
10
40
37
73
5
28
71
12
5
67
68
51
40
71
66
68
57
65
```

**Group 3 censor**
```
1
1
1
0
0
1
0
1
1
1
1
1
0
1
1
0
1
1
1
1
0
0
```



## Features

### 1. Dynamic input fields for groups
This feature allows users to to define the number of groups they want to analyze using a slider. Based on the input, the app dynamically generates input boxes for time-to-event data, censoring data, and group names, allowing for analysis between subgroups. The number of groups were kept to a maximum of 5 based on existing Kaplan-Meier survival calculation tools and typical practice, where we only see 2-5 subgroups within a single plot. This maintains clarity and makes the plot easier to interpret.

### 2. Customize plot options
This feature allows users to fully customize their plot with features like confidence intervals, displaying a p-value using the log rank test if >1 group is inputted, and risk tables.

### 3. Downloadable survival plot
This feature lets users save their plots as PNG files for sharing results without needing additional formatting. The plot is customized based on their inputs, uses a colorblind-friendly palette and is immediately ready to share with others.


# B3 - Caffeine in Drinks Shiny App

## Link to the app
https://aliz0124.shinyapps.io/assignment-b3-aliz0124/

## Description and Source
This is an R-based Shiny app for exploring the caffeine content in various drinks. The app allows users to filter by drink type, volume and caffeine levels, or search for individual drinks. Users can also visualize the data through an interactive bubble plot.  

The dataset was sourced from [Heitor Nunez](https://www.kaggle.com/datasets/heitornunes/caffeine-content-of-drinks) on Kaggle, who extracted the data from the [Caffeine Informer Caffeine Database](https://www.caffeineinformer.com/the-caffeine-database) website, which contains information on the caffeine content of drinks.


## Features

### 1. Grouped checkbox for drink types
This feature enables users to filter the dataset by individual or multiple drink types, making it easier to compare drinks across types or assess caffeine content and other variables within specific groups.

### 2. Slider to filter based on the volume (ml) or caffeine amount (mg) 
This feature helps users filter the dataset for drinks that meet their specific preferences or needs, such as finding drinks with high caffeine content for a morning pick-me-up or within a specific volume range.

### 3. Button to download the filtered data as a CSV
This feature is useful for users who want to save their filtered data to conduct their own analysis outside of the app, or share it with others. It saves the data in CSV format making it easily accessible for analysis in R or Python.

### 4. Interactive data table 
An interactive table feature allows users to further explore their filtered data by sorting individual variables in ascending or descending order, or searching within filtered drinks for individual rows.

### 5. Interactive bubble plot (Caffeine vs Volume with bubble size = calories).
This plot provides an accessible overview of how different drinks compare in terms of caffeine amount and volume, allowing users to visually spot trends in their filtered data. Using Plotly's interactive features enables users to hover over individual points to view information, isolate specific drink types, save the plot and more.




