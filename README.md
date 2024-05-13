# Dynamic Location Quotient Analysis

## Introduction

This repository focuses on the analysis of agglomeration patterns in the early auto industry using a dynamic location quotient (DLQ). Traditional location quotients (LQ) often imply a static benchmark proportional to location size. However, we argue that a dynamic benchmark, accounting for random firm entry and industry growth, is necessary to understand agglomeration in evolving industries. This work integrates two previously separate literatures on agglomeration and random growth, applying them to the early auto industry to develop and measure a dynamic location quotient.

## Key Concepts

1. **Agglomeration Measurement:**
   - **Location Quotient (LQ):** A traditional measure suggesting localization proportional to location size.
   - **Dynamic Location Quotient (DLQ):** An improved measure based on industry random growth, considering both conventional agglomeration determinants and random entry.

2. **Random Growth Literature:**
   - **Gibrat’s Law:** Models firm growth as a random process, leading to skewed size distributions.
   - **Zipf’s Law:** Describes city growth and stable agglomerations.
   - **Industry Evolution:** New industries evolve rapidly, requiring dynamic approaches to measure localization.

## Framework

The repository provides a framework to model firm entry, location, survival, and growth as random processes. This framework serves as a benchmark to compare observed industry agglomeration against random patterns, allowing for statistical testing of agglomeration hypotheses.

1. **Firm Entry and Location:**
   - Firms enter sequentially and choose locations based on expected profits influenced by conventional agglomeration determinants (e.g., manufacturing establishments, knowledge stock, market access) or random draws.

2. **Firm Survival and Growth:**
   - Firms decide annually whether to continue or exit based on expected profits and random shocks.
   - Growth rates are drawn from a distribution conditional on firm age, reflecting industry dynamics and survival probabilities.

3. **Monte Carlo Simulations:**
   - The framework is calibrated to the early auto industry, replicating the entry, location, and survival processes for 971 firms over 1,000 simulations.
   - The simulations generate an empirical probability distribution of industry evolution, allowing for comparison with observed data.

## Application to Early Auto Industry

1. **Data Sources:**
   - **Assemblers Entry and Exit:** Derived from Smith (1969), documenting firms from 1895-1930.
   - **Conventional Agglomeration Determinants:**
     - **Manufacturing Establishments:** U.S. Censuses 1890-1930.
     - **Knowledge Stock:** USPTO patent data.
     - **Market Access:** Calculated using population, wages, and transport costs (Donaldson and Hornbeck, 2016).

2. **Analysis:**
   - Calibration of entry, location, and survival parameters to the auto industry.
   - Comparison of observed agglomeration patterns with simulated random patterns to identify deviations indicating true agglomeration.

3. **Results:**
   - DLQ and traditional LQ are compared, highlighting the differences and the importance of considering dynamic benchmarks.
   - Maps and scatterplots illustrate agglomeration evolution and entry patterns over time.

## Contributions

1. **Dynamic Location Quotient:**
   - A new measure that differentiates between random and non-random localization.
   - Provides insights into the evolution of industry market structures and agglomeration patterns.

2. **Understanding Industry Dynamics:**
   - Highlights the role of firm entry in the product life cycle and agglomeration.
   - Offers a more accurate interpretation of early industry localization and potential applications to future industry analysis.

This repository contains the code to reproduce the dynamic location quotient analysis, including simulations and visualizations. It serves as a comprehensive tool for researchers studying agglomeration and industry evolution.
