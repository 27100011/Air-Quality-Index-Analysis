/*
================================================================================
pakistan air quality historical data analysis (2015 - 2025)
================================================================================

introduction:
this project explores a 10-year dataset tracking air quality metrics across 10
major cities in pakistan. using mysql workbench, the analysis transitions from 
basic data cleaning and filtering to intermediate aggregates and advanced analytical 
window functions. the goal is to evaluate spatial, seasonal, and socio-economic 
trends in air pollution, including the specific impacts of population density, 
coastal geography, crop-burning periods, and global events like the 2020 lockdowns.
*/

CREATE database pakistan_air_quality;
USE pakistan_air_quality;

alter table pakistan_cities_metadata rename to cities_metadata;
alter table pakistan_air_quality_monthly_2015_2025 rename to monthly_aqi;
alter table pakistan_air_quality_annual_summary rename to annual_summary;

select * from cities_metadata limit 5;
select * from monthly_aqi;
select * from annual_summary limit 5;

select city, pm25_annual_avg, aqi_annual_avg
from annual_summary;

select year, month_name, city, pm25_ugm3, aqi_us, aqi_category 
from monthly_aqi 
limit 5;

-- listing all distinct cities
select distinct(city)
from cities_metadata;

-- counting the total distinct cities 
select count(distinct(city))
from cities_metadata;

-- finding out all unique classifications
select distinct aqi_category
from monthly_aqi;
-- finding: categories include hazardous, very unhealthy, unhealthy, unhealthy for sensitive groups, moderate, and good

--  categorized as hazardous
select month_name, city, aqi_us, aqi_category
from monthly_aqi 
where aqi_category = 'Hazardous'
order by aqi_us desc;

-- calculating the total number of hazardous monthly averages per city
select city, count(*) as hazardous_months_count
from monthly_aqi
where aqi_category = 'Hazardous'
group by city
order by hazardous_months_count desc;
-- finding: faisalabad is the only city in the dataset to cross into a hazardous monthly average

-- instances categorized as very unhealthy 
select month_name, city, aqi_us, aqi_category
from monthly_aqi 
where aqi_category = 'Very Unhealthy'
order by aqi_us desc;

-- grouping very unhealthy monthly instances by city counts
select city, count(*) as hazardous_months_count
from monthly_aqi
where aqi_category = 'Very Unhealthy'
group by city
order by hazardous_months_count desc;
-- finding: faisalabad records the highest count of very unhealthy periods, while lahore scores lower on overall monthly averages

-- highest recorded values under the sensitive group 
select month_name, city, aqi_us, aqi_category
from monthly_aqi 
where aqi_category = 'Unhealthy for Sensitive Groups'
order by aqi_us desc
limit 1;
-- finding: rawalpindi records prominent levels within this specific safety band

-- counting months marked as unsafe for sensitive populations per city
select city, count(*) as hazardous_months_count
from monthly_aqi
where aqi_category = 'Unhealthy for Sensitive Groups'
group by city
order by hazardous_months_count desc;

-- general unhealthy entries
select month_name, city, aqi_us, aqi_category
from monthly_aqi 
where aqi_category = 'Unhealthy'
order by aqi_us desc;

-- unhealthy monthly blocks per city
select city, count(*) as hazardous_months_count
from monthly_aqi
where aqi_category = 'Unhealthy'
group by city
order by hazardous_months_count desc;

-- moderate air quality 
select month_name, city, aqi_us, aqi_category
from monthly_aqi 
where aqi_category = 'Moderate'
order by aqi_us desc;

select city, count(*) as hazardous_months_count
from monthly_aqi
where aqi_category = 'Moderate'
group by city
order by hazardous_months_count desc;

-- air quality is good
select month_name, city, aqi_us, aqi_category
from monthly_aqi 
where aqi_category = 'Good'
order by aqi_us desc;

select city, count(*) as hazardous_months_count
from monthly_aqi
where aqi_category = 'Good'
group by city
order by hazardous_months_count desc;

--  locations where pollution is caused by brick or crop
select city, major_pollution_sources, province, region
from cities_metadata
where major_pollution_sources like '%brick%'  or major_pollution_sources like '%crop%';

-- pollution variance across specific yearly calendar seasons
select season, avg(pm25_ugm3) as avg_pm25, max(aqi_us) as worst_aqi_peak
from monthly_aqi
group by season
order by avg_pm25 desc;
-- finding: winter/smog season is confirmed as the worst period for air metrics nationally

-- analyzing structural differences between coastal regions and landlocked territories
select c.is_coastal, avg(m.aqi_us) as avg_aqi
from monthly_aqi m
join cities_metadata c on m.city = c.city
group by c.is_coastal;
-- finding: non-coastal baseline averages sit high at 146.96, while coastal sea breeze dynamics pull karachi down to 109.02

-- exact pollution drop observed during the 2020 health lockdowns
select covid_lockdown_period, avg(pm25_ugm3) as avg_pm25_pollution, count(*) as total_months
from monthly_aqi
where year = 2020
group by covid_lockdown_period;
-- finding: enforcement periods saw extreme drops down to 36.48 pm2.5, compared to non-lockdown baselines of 76.45

select year, city, aqi_annual_avg, rank() over (partition by year order by aqi_annual_avg desc) as pollution_rank
from annual_summary;

-- contrasting crop burning periods against normal baselines
select city, avg(case when is_crop_burning_season = 1 then pm25_ugm3 END) as crop_burning_pm25,
avg(case when is_crop_burning_season = 0 then pm25_ugm3 END) as normal_pm25,
avg(case when is_crop_burning_season = 1 then pm25_ugm3 END) - 
avg(case when is_crop_burning_season = 0 then pm25_ugm3 END) as pollution_increase
from monthly_aqi
group by city
having pollution_increase is not null
order by pollution_increase desc;
-- finding: faisalabad sustains the worst direct agricultural smoke penalty spike when crop residue burning starts

-- testing if population scale directly matches pollution trends across regions
select m.city, c.population_millions, avg(m.aqi_us) as lifetime_avg_aqi
from monthly_aqi m
join cities_metadata c on m.city = c.city
group by m.city, c.population_millions
order by c.population_millions desc;
-- finding: population scale is not the absolute factor. karachi has 16.1 million people but holds an average of 109, whereas islamabad has 2.2 million people with a close average of 105.26

-- determining long-term regional livability
select city,
       count(*) as total_recorded_months,
       sum(case when aqi_category in ('Good', 'Moderate') then 1 else 0 end) as safe_months,
       (sum(case when aqi_category in ('Good', 'Moderate') then 1 else 0 end) / count(*)) * 100 as safe_air_percentage
from monthly_aqi
group by city
order by safe_air_percentage desc;
-- finding: islamabad scores the highest consistency for providing safe, breathable air across the tracking timeline

/*
================================================================================
conclusion of findings:
1. geographic advantages: coastal cities like karachi experience high population, 
   but marine wind patterns act as a shield, lowering averages compared to the 
   landlocked industrial centers of punjab.
2. industrial & human costs: industrial setups combined with active crop burning 
   make areas like faisalabad hit extreme levels on monthly tracking metrics.
3. structural policy proof: the clear drop in numbers during the 2020 lockdowns 
   proves that cutting down vehicular and industrial operations has an immediate, 
   massive impact on lowering toxic air concentrations across pakistan.
================================================================================
*/