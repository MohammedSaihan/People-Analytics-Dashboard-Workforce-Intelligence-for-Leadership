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

-- 3) Attrition Deep Dive (the “wow” page)

-- Attrition by Department
SELECT
  department,
  COUNT(*) AS total,
  SUM(attrition_flag) AS exited,
  ROUND(100 * SUM(attrition_flag) / COUNT(*), 2) AS attrition_rate_pct
FROM vw_people
GROUP BY department
ORDER BY attrition_rate_pct DESC;

-- Attrition by Job Role
SELECT
  job_role,
  COUNT(*) AS total,
  SUM(attrition_flag) AS exited,
  ROUND(100 * SUM(attrition_flag) / COUNT(*), 2) AS attrition_rate_pct
FROM vw_people
GROUP BY job_role
ORDER BY attrition_rate_pct DESC;

-- Attrition by Overtime
SELECT
  overtime,
  COUNT(*) AS total,
  SUM(attrition_flag) AS exited,
  ROUND(100 * SUM(attrition_flag) / COUNT(*), 2) AS attrition_rate_pct
FROM vw_people
GROUP BY overtime
ORDER BY attrition_rate_pct DESC;

-- Attrition by Age Group
SELECT
  age_group,
  COUNT(*) AS total,
  SUM(attrition_flag) AS exited,
  ROUND(100 * SUM(attrition_flag) / COUNT(*), 2) AS attrition_rate_pct
FROM vw_people
GROUP BY age_group
ORDER BY FIELD(age_group,'<25','25-34','35-44','45-54','55+');

-- Attrition by Salary Band 
SELECT
  salary_band,
  COUNT(*) AS total,
  SUM(attrition_flag) AS exited,
  ROUND(100 * SUM(attrition_flag) / COUNT(*), 2) AS attrition_rate_pct
FROM vw_people
GROUP BY salary_band
ORDER BY FIELD(salary_band,'<4k','4k-7.9k','8k-11.9k','12k+');

-- Attrition by Job Satisfaction
SELECT
  job_satisfaction,
  COUNT(*) AS total,
  SUM(attrition_flag) AS exited,
  ROUND(100 * SUM(attrition_flag) / COUNT(*), 2) AS attrition_rate_pct
FROM vw_people
GROUP BY job_satisfaction
ORDER BY job_satisfaction;

-- Attrition by Work-Life Balance
SELECT
  work_life_balance,
  COUNT(*) AS total,
  SUM(attrition_flag) AS exited,
  ROUND(100 * SUM(attrition_flag) / COUNT(*), 2) AS attrition_rate_pct
FROM vw_people
GROUP BY work_life_balance
ORDER BY work_life_balance;

-- 4) Compensation + Performance (very HR-relevant)

-- Salary by Department
SELECT
  department,
  ROUND(AVG(monthly_income), 2) AS avg_income,
  COUNT(*) AS employees
FROM vw_people
GROUP BY department
ORDER BY avg_income DESC;

-- Salary vs Performance Rating
SELECT
  performance_rating,
  ROUND(AVG(monthly_income), 2) AS avg_income,
  COUNT(*) AS employees
FROM vw_people
GROUP BY performance_rating
ORDER BY performance_rating;


-- Promotions vs Attrition
SELECT
  promotion_last_5years,
  COUNT(*) AS total,
  SUM(attrition_flag) AS exited,
  ROUND(100 * SUM(attrition_flag) / COUNT(*), 2) AS attrition_rate_pct
FROM vw_people
GROUP BY promotion_last_5years
ORDER BY promotion_last_5years;

-- Training vs Performance
SELECT
  training_times_last_year,
  ROUND(AVG(performance_rating), 2) AS avg_performance,
  COUNT(*) AS employees
FROM vw_people
GROUP BY training_times_last_year
ORDER BY training_times_last_year;


-- 5) Workforce Planning (Hiring trend)

-- Hires by Year-Month

SELECT
  DATE_FORMAT(hire_date, '%Y-%m') AS hire_month,
  COUNT(*) AS hires
FROM vw_people
GROUP BY DATE_FORMAT(hire_date, '%Y-%m')
ORDER BY hire_month;
