-- 1) Create a clean VIEW (adds flags + groups)

CREATE OR REPLACE VIEW vw_people AS
SELECT
  employee_id,
  age,
  gender,
  department,
  job_role,
  education,
  marital_status,
  hire_date,
  years_at_company,
  job_level,
  monthly_income,
  `salary_hike%` AS salary_hike_pct,
  overtime,
  performance_rating,
  training_times_last_year,
  work_life_balance,
  attrition,
  job_satisfaction,
  environment_satisfaction,
  promotion_last_5years,

  CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END AS attrition_flag,

  CASE
    WHEN age < 25 THEN '<25'
    WHEN age BETWEEN 25 AND 34 THEN '25-34'
    WHEN age BETWEEN 35 AND 44 THEN '35-44'
    WHEN age BETWEEN 45 AND 54 THEN '45-54'
    ELSE '55+'
  END AS age_group,

  CASE
    WHEN monthly_income < 4000 THEN '<4k'
    WHEN monthly_income BETWEEN 4000 AND 7999 THEN '4k-7.9k'
    WHEN monthly_income BETWEEN 8000 AND 11999 THEN '8k-11.9k'
    ELSE '12k+'
  END AS salary_band
FROM employees;


 -- 2) Executive KPI Cards 
-- Total Employees
SELECT 
	COUNT(*) AS total_bookings
FROM employees;


-- Attrition Count + Attrition Rate %
SELECT 
	SUM(attrition_flag) AS exited_employees,
    ROUND(100* SUM(attrition_flag) / COUNT(*),2) AS attrition_rate_pct
FROM vw_people;

-- Avg Monthly Income
SELECT
	ROUND(AVG(monthly_income),2) AS avg_monthly_income
FROM vw_people;

-- Avg Tenure (Years)
SELECT 
	ROUND(AVG(years_at_company),2) AS avg_tenure_years
FROM vw_people;
