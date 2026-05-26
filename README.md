# 🌫️ Pakistan Air Quality Analytics (2015–2025)

- An in-depth historical data analysis project tracking $PM_{2.5}$ and US AQI trends across 10 major Pakistani cities over an 11-year span. This repository demonstrates database schema optimization, query performance tuning, and advanced exploratory data analysis (EDA) using MySQL.
- Dataset Link: https://www.kaggle.com/datasets/alitaqishah/pakistan-air-quality-index-10-cities-20152025/data
---

## 🗂️ Project Structure
* `pakistan_air_quality.sql`: Core analytical SQL script featuring structural optimization, indices, and analytics queries.
* `pakistan_cities_metadata.csv`: Demographic and geographic city profiles.
* `pakistan_air_quality_monthly_2015_2025.csv`: Granular time-series monthly fact logs.
* `pakistan_air_quality_annual_summary.csv`: Yearly baseline summary aggregates.

---

## 📊 Top Discoveries

* Geographic location alters base metrics more than sheer population scale. 
* Despite its size, Karachi benefits from a strong marine breeze shield, averaging **109.02 AQI** compared to inland Punjab's higher baseline of **146.96 AQI**.
* While Lahore dominates the news cycles, data shows Faisalabad is the only city to consistently sustain entire monthly averages crossing into the hazardous zone, driven by a heavy agricultural crop-burning penalty.
* Slicing the 2020 quarantine periods revealed that health lockdowns effectively cut national $PM_{2.5}$ pollution concentrations directly in half (**36.48** vs a normal baseline of **76.45**).
* Over the 11-year track, Islamabad consistently scores the highest percentage of months resting inside safe, breathable "Good" and "Moderate" air quality categories.
