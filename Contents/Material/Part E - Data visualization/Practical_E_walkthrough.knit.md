---
title: "Practical E - solutions"
author: "Statistical Programming in R"
date: ""
output:
  html_document: 
    self_contained: false
    lib_dir: libs
  pdf_document: default
---





---

#### Exercises

---

The following packages are required for this practical:


```r
library(dplyr)
library(magrittr)
library(mice)
library(ggplot2)
library(stringr)
```

and if you'd like the same results as I have obtained, you can fix the random seed


```r
set.seed(123)
```

---

0. **Function `plot()` is the core plotting function in `R`. Find out more about `plot()`: Try both the help in the help-pane and `?plot` in the console. Look at the examples by running `example(plot)`.**

The help tells you all about a functions arguments (the input you can specify), as well as the element the function returns to the Global Environment. There are strict rules for publishing packages in R. For your packages to appear on the Comprehensive R Archive Network (CRAN), a rigorous series of checks have to be passed. As a result, all user-level components (functions, datasets, elements) that are published, have an acompanying documentation that elaborates how the function should be used, what can be expected, or what type of information a data set contains. Help files often contain example code that can be run to demonstrate the workings. 


```r
?plot
```

```
## starting httpd help server ... done
```

```r
example(plot)
```

```
## 
## plot> Speed <- cars$speed
## 
## plot> Distance <- cars$dist
## 
## plot> plot(Speed, Distance, panel.first = grid(8, 8),
## plot+      pch = 0, cex = 1.2, col = "blue")
```

<img src="Practical_E_walkthrough_files/figure-html/unnamed-chunk-4-1.png" width="672" />

```
## 
## plot> plot(Speed, Distance,
## plot+      panel.first = lines(stats::lowess(Speed, Distance), lty = "dashed"),
## plot+      pch = 0, cex = 1.2, col = "blue")
```

<img src="Practical_E_walkthrough_files/figure-html/unnamed-chunk-4-2.png" width="672" />

```
## 
## plot> ## Show the different plot types
## plot> x <- 0:12
## 
## plot> y <- sin(pi/5 * x)
## 
## plot> op <- par(mfrow = c(3,3), mar = .1+ c(2,2,3,1))
## 
## plot> for (tp in c("p","l","b",  "c","o","h",  "s","S","n")) {
## plot+    plot(y ~ x, type = tp, main = paste0("plot(*, type = \"", tp, "\")"))
## plot+    if(tp == "S") {
## plot+       lines(x, y, type = "s", col = "red", lty = 2)
## plot+       mtext("lines(*, type = \"s\", ...)", col = "red", cex = 0.8)
## plot+    }
## plot+ }
```

<img src="Practical_E_walkthrough_files/figure-html/unnamed-chunk-4-3.png" width="672" />

```
## 
## plot> par(op)
## 
## plot> ##--- Log-Log Plot  with  custom axes
## plot> lx <- seq(1, 5, length.out = 41)
## 
## plot> yl <- expression(e^{-frac(1,2) * {log[10](x)}^2})
## 
## plot> y <- exp(-.5*lx^2)
## 
## plot> op <- par(mfrow = c(2,1), mar = par("mar")-c(1,0,2,0), mgp = c(2, .7, 0))
## 
## plot> plot(10^lx, y, log = "xy", type = "l", col = "purple",
## plot+      main = "Log-Log plot", ylab = yl, xlab = "x")
```

```
## 
## plot> plot(10^lx, y, log = "xy", type = "o", pch = ".", col = "forestgreen",
## plot+      main = "Log-Log plot with custom axes", ylab = yl, xlab = "x",
## plot+      axes = FALSE, frame.plot = TRUE)
```

<img src="Practical_E_walkthrough_files/figure-html/unnamed-chunk-4-4.png" width="672" />

```
## 
## plot> my.at <- 10^(1:5)
## 
## plot> axis(1, at = my.at, labels = formatC(my.at, format = "fg"))
## 
## plot> e.y <- -5:-1 ; at.y <- 10^e.y
## 
## plot> axis(2, at = at.y, col.axis = "red", las = 1,
## plot+      labels = as.expression(lapply(e.y, function(E) bquote(10^.(E)))))
## 
## plot> par(op)
```

There are many more functions that can plot specific types of plots. For example, function `hist()` plots histograms, but falls back on the basic `plot()` function. Packages `lattice` and `ggplot2` are excellent packages to use for complex plots. Pretty much any type of plot can be made in R. A good reference for packages `lattice` that provides all `R`-code can be found at [http://lmdvr.r-forge.r-project.org/figures/figures.html](http://lmdvr.r-forge.r-project.org/figures/figures.html). Alternatively, all ggplot2 documentation can be found at [http://docs.ggplot2.org/current/](http://docs.ggplot2.org/current/)

---

1. **Create a scatterplot between `age` and `bmi` in the `mice::boys` data set.**

With the standard plotting device in `R`:


```r
plot( boys$bmi ~ boys$age )
```

<img src="Practical_E_walkthrough_files/figure-html/unnamed-chunk-5-1.png" width="672" />
---

2. **Now recreate the plot with the following specifications:**

- If `bmi < 18.5` use `color = "light blue"`
- If `bmi > 18.5 & bmi < 25` use `color = "light green"`
- If `bmi > 25 & bmi < 30` use `color = "orange"`
- If `bmi > 30` use `color = "red"`

Hint: it may help to expand the data set with a new variable. 

It may be easier to create a new variable that creates the specified categories. We can use the `cut()` function to do this quickly


```r
boys2 <- 
  boys %>%
  mutate(class = cut(bmi, c(0, 18.5, 25, 30, Inf),
                    labels = c("underweight",
                               "healthy",
                               "overweight",
                               "obese")))
```

by specifying the boundaries of the intervals. In this case we obtain 4 intervals: `0-18.5`, `18.5-25`, `25-30` and `30-Inf`. We used the `%>%` pipe to work with `bmi` directly. Alternatively, we could have done this without a pipe:


```r
boys3 <- boys
boys3$class <- cut(boys$bmi, c(0, 18.5, 25, 30, Inf), 
                   labels = c("underweight",
                              "healthy",
                              "overweight",
                              "obese"))
```

to obtain the same result. 

With the standard plotting device in `R` we can now specify:


```r
plot(bmi ~ age, subset = class == "underweight", col = "light blue", data = boys2, 
     ylim = c(10, 35), xlim = c(0, 25))
points(bmi ~ age, subset = class == "healthy", col = "light green", data = boys2)
points(bmi ~ age, subset = class == "overweight", col = "orange", data = boys2)
points(bmi ~ age, subset = class == "obese", col = "red", data = boys2)
```

<img src="Practical_E_walkthrough_files/figure-html/unnamed-chunk-8-1.png" width="672" />
---

3. **Create a histogram for `age` in the `boys` data set.**

With the standard plotting device in `R`:


```r
hist(boys$age, breaks = 50)
```

<img src="Practical_E_walkthrough_files/figure-html/unnamed-chunk-9-1.png" width="672" />

The `breaks = 50` overrides the default breaks between the bars. By default the plot would be


```r
hist(boys$age)
```

<img src="Practical_E_walkthrough_files/figure-html/unnamed-chunk-10-1.png" width="672" />

The title and axis label need to be fixed: 


```r
hist(boys$age, breaks = 50, xlab = "Age", main = "Histogram")
```

<img src="Practical_E_walkthrough_files/figure-html/unnamed-chunk-11-1.png" width="672" />

---

4. **Create a bar chart for `reg` in the boys data set.**

With a standard plotting device in `R`:


```r
boys %$%
  table(reg) %>%
  barplot()
```

<img src="Practical_E_walkthrough_files/figure-html/unnamed-chunk-12-1.png" width="672" />

---

5. **Create a box plot for `hgt` with different boxes for `reg` in the `boys` data set.**

With a standard plotting device in `R`:


```r
boys %$%
  boxplot(hgt ~ reg)
```

<img src="Practical_E_walkthrough_files/figure-html/unnamed-chunk-13-1.png" width="672" />


---

6. **Create a density plot for `age` with different curves for boys from the `city` and boys from rural areas (`!city`).**

With a standard plotting device in `R`:


```r
d1 <- boys %>%
  subset(reg == "city") %$%
  density(age)
d2 <- boys %>%
  subset(reg != "city") %$%
  density(age)

plot(d1, col = "red", ylim = c(0, .08))
lines(d2, col = "blue")
```

<img src="Practical_E_walkthrough_files/figure-html/unnamed-chunk-14-1.png" width="672" />

The above plot can also be generated without pipes, but results in an *ugly* main title. You may edit the title via the `main` argument in the `plot()` function.


```r
plot(density(boys$age[!is.na(boys$reg) & boys$reg == "city"]),
     col = "red",
     ylim = c(0, .08))
lines(density(boys$age[!is.na(boys$reg) & boys$reg != "city"]),
      col = "blue")
```

<img src="Practical_E_walkthrough_files/figure-html/unnamed-chunk-15-1.png" width="672" />

<!-- With `ggplot2` everything looks much nicer: -->

<!-- ```{r cache=TRUE} -->
<!-- boys %>% -->
<!--   mutate(area = ifelse(reg == "city", "city", "rural")) %>% -->
<!--   filter(!is.na(area)) %>% -->
<!--   ggplot(aes(age, fill = area)) + -->
<!--   geom_density(alpha = .3) # some transparency -->
<!-- ``` -->

---

7. **Create a diverging bar chart for `hgt` in the `boys` data set, that displays for every `age` year that year's mean height in deviations from the overall average `hgt`.**

Let's not make things too complicated and just focus on `ggplot2`:


```r
boys %>%
  mutate(Hgt = hgt - mean(hgt, na.rm = TRUE),
         Age = cut(age, 0:22, labels = 0:21)) %>%
  group_by(Age) %>%
  summarize(Hgt = mean(Hgt, na.rm = TRUE)) %>% 
  mutate(Diff = cut(Hgt, c(-Inf, 0, Inf),
                    labels = c("Below Average", "Above Average"))) %>%
  ggplot(aes(x = Age, y = Hgt, fill = Diff)) + 
  geom_bar(stat = "identity") +
  coord_flip()
```

<img src="Practical_E_walkthrough_files/figure-html/unnamed-chunk-16-1.png" width="672" />

We can clearly see that the average height in the group is reached just before age 7. 

The `group_by()` and `summarize()` function are advanced `dplyr` functions used to return the `mean()` of deviation `Hgt` for every group in `Age`. For example, if we would like the mean and sd of height `hgt` for every region `reg` in the `boys` data, we could call:


```r
boys %>%
  group_by(reg) %>% 
  summarize(mean_hgt = mean(hgt, na.rm = TRUE), 
            sd_hgt   = sd(hgt, na.rm = TRUE))
```

```
## # A tibble: 6 × 3
##   reg   mean_hgt sd_hgt
##   <fct>    <dbl>  <dbl>
## 1 north    152.    43.8
## 2 east     134.    43.2
## 3 west     130.    48.0
## 4 south    128.    46.3
## 5 city     126.    46.9
## 6 <NA>      73.0   29.3
```

The `na.rm` argument ensures that the mean and sd of only the observed values in each category are used.


---

8. **Read in the `sf` package, and open the shapefiles on the Danish municipalities from the course homepage. Plot the `REGIONNAVN` variable to see the Danish regions. Plot the municipal-level population.**

With the standard plotting device in `R`:



```r
library(sf)
```

```
## Linking to GEOS 3.9.1, GDAL 3.4.3, PROJ 7.2.1; sf_use_s2() is TRUE
```

```r
denmark <- st_read("DK_map.shp")
```

```
## Reading layer `DK_map' from data source 
##   `C:\Mikkel\Dropbox\Work\RWORK\DSTStuff\Ghana\RGhana\Contents\Material\Part E - Data visualization\DK_map.shp' 
##   using driver `ESRI Shapefile'
## Simple feature collection with 306 features and 6 fields
## Geometry type: POLYGON
## Dimension:     XY
## Bounding box:  xmin: 441524.8 ymin: 6049785 xmax: 892800.8 ymax: 6402308
## CRS:           NA
```

```r
class(denmark)
```

```
## [1] "sf"         "data.frame"
```

The default plot for an object of class `sf` is a multi-plot of all attributes, up to a reasonable maximum:

```r
plot(denmark)
```

<img src="Practical_E_walkthrough_files/figure-html/unnamed-chunk-19-1.png" width="672" />

If we want to view the shapes themselves without the attributes, we can plot the `st_geometry`

```r
plot(st_geometry(denmark))
```

<img src="Practical_E_walkthrough_files/figure-html/unnamed-chunk-20-1.png" width="672" />


Say we want to colour the maps by the administrative regions coded in the `REGIONNAVN` variable:

```r
denmark <- denmark %>% mutate( REGIONNAVN = word( REGIONNAVN , 2))
plot(denmark["REGIONNAVN"], key.pos = 1, key.length = 1)
```

<img src="Practical_E_walkthrough_files/figure-html/unnamed-chunk-21-1.png" width="672" />

The legend is being bothersome here, though. The `ggplot` default is prettier.

We plot the municipal-level population


```r
denmark <- denmark %>% mutate( population = population/1000) 

plot(denmark["population"], main = "Population,\nthousands")
```

<img src="Practical_E_walkthrough_files/figure-html/unnamed-chunk-22-1.png" width="672" />

But perhaps population per square kilometer might be more informative than just population

```r
denmark$area <- st_area(denmark)/(1000^2)

denmark1 <- denmark %>% 
  group_by(KOMKODE) %>% 
  summarise( total.area = sum( as.numeric( area ) ), 
             population = first( population )) %>% 
  mutate( pop.area = population/total.area)

plot(denmark1["pop.area"], main = "Population per square kilometer")
```

<img src="Practical_E_walkthrough_files/figure-html/unnamed-chunk-23-1.png" width="672" />

Our `sf` object contains more than one feature for some of the municipalities. The population number given is for the total municipality, so we need to compute the total area for each municipality. 

---

End of Practical

---


