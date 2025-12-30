# OD-plot-R
# Automated Analysis of Biochemical OD Data

This repository contains an R-based workflow for processing, analyzing, and visualizing Optical Density (OD) data from protein fraction assays (indirect ELISA)

## 🔬 Scientific Context
In biochemical research, manual data processing of microplate reader outputs is time-consuming and prone to human error. This script automates the transformation of raw OD values into publication-ready visualizations. The use of jitter points is crucial for my biochemical assays to demonstrate the consistency of replicates within each protein fraction.

## 🚀 Key Features
- **Data Tidying:** Converts raw assay formats into a "long" format suitable for analysis.
- **Statistical Visualization:** Generates high-resolution boxplots and scatter plots with `ggplot2`.
- - **Advanced Jitter Plotting:** Implemented `geom_jitter()` to prevent overplotting of overlapping data points, ensuring a transparent representation of sample size (n) and distribution density.
- **Custom Aesthetics:** Optimized for scientific publications (DPI, font sizes, and color-blind friendly scales).

## 🛠 Tools Used
- **Language:** R
- **Key Libraries:** `ggplot2`, `dplyr`, `tidyr`

## 📂 Project Structure
- `plots.R`: The core script for data processing and visualization.
- `README.md`: Project documentation.

## Acknowledgements
This script was developed with the assistance of AI tools for code optimization and documentation.
