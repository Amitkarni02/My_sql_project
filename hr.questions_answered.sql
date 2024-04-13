#queries to be answered based on the data available
select * from hr;
-- 1.what is gender breakdown of employees in the company--
select gender,count(*)from hr 
where age>18 and termdate='0000-00-00' group by gender;


-- 2.what is ethnicity/race of employees
select race,count(*) from hr 
where age>18 and termdate='0000-00-00' group by race 
order by count(*) desc;

-- 3.what is age distribution of emplyoees
select 
   case 
   when age>=18 and age<=24 then '18-24'
   when age>=25 and age<=34 then '25-34'
   when age>=35 and age<=44 then '35-44'
   when age>=45 and age<=54 then '45-54'
   when age>=55 and age<=64 then '55-64'
   else '65+'
   end as age_group,gender,
   count(*) as count
from hr where  age>18 and termdate='0000-00-00'
group by age_group,gender
order by age_group,gender;


#how many employees work at headquarters vs at remote
select location,count(*) as count from hr
where age>18 and termdate='0000-00-00'
group by location;



#average length of employees who have been terminated

select round(avg(datediff(termdate,hire_date))/365)
as avg_employment_length 
from hr 
where termdate<curdate() and termdate <> '0000-00-00' and age>18;



#how gender distribution varies across departments and job titles
select department,gender,count(*) 
as 'count' from hr 
where age>18 and termdate='0000-00-00'
group by department,gender order by department;


#distribution of job titles across the company
select jobtitle,count(*) 
as count from hr where age>18 and termdate='0000-00-00'
group by jobtitle order by jobtitle desc;


# which department has highest termination rate;
SELECT department, COUNT(*) as total_count, 
    SUM(CASE WHEN termdate <= CURDATE() AND termdate <> '0000-00-00' THEN 1 ELSE 0 END) as terminated_count, 
    SUM(CASE WHEN termdate = '0000-00-00' THEN 1 ELSE 0 END) as active_count,
    (SUM(CASE WHEN termdate <= CURDATE() THEN 1 ELSE 0 END) / COUNT(*)) as termination_rate
FROM hr
WHERE age >= 18
GROUP BY department
ORDER BY termination_rate DESC;


#employees and location information
SELECT location_state, COUNT(*) as count
FROM hr
WHERE age >= 18
GROUP BY location_state
ORDER BY count DESC;



#How has the company's employee count changed over time based on hire and term dates?
SELECT 
    YEAR(hire_date) AS year, 
    COUNT(*) AS hires, 
    SUM(CASE WHEN termdate <> '0000-00-00' AND termdate <= CURDATE() THEN 1 ELSE 0 END) AS terminations, 
    COUNT(*) - SUM(CASE WHEN termdate <> '0000-00-00' AND termdate <= CURDATE() THEN 1 ELSE 0 END) AS net_change,
    ROUND(((COUNT(*) - SUM(CASE WHEN termdate <> '0000-00-00' AND termdate <= CURDATE() THEN 1 ELSE 0 END)) / COUNT(*) * 100),2) AS net_change_percent
FROM 
    hr
WHERE age >= 18
GROUP BY 
    YEAR(hire_date)
ORDER BY 
    YEAR(hire_date) ASC;
    
    
    
-- What is the tenure distribution for each department?
SELECT department, ROUND(AVG(DATEDIFF(CURDATE(), termdate)/365),0) as avg_tenure
FROM hr
WHERE termdate <= CURDATE() AND termdate <> '0000-00-00' AND age >= 18
GROUP BY department



#OBSERVATIONS BASED ON DATA WRANGLING;
-- There are more male employees
-- White race is the most dominant while Native Hawaiian and American Indian are the least dominant.
-- The youngest employee is 20 years old and the oldest is 57 years old
-- 5 age groups were created (18-24, 25-34, 35-44, 45-54, 55-64)
-- A large number of employees were between 25-34 followed by 35-44 while the smallest group was 55-64.
-- A large number of employees work at the headquarters versus remotely.
-- The average length of employment for terminated employees is around 8 years.
-- The gender distribution across departments is fairly balanced but there are generally more male than female employees.
-- The Marketing department has the highest termination rate followed by Training. The least turn over rate are in the Research and development, Support and Legal departments.
-- A large number of employees come from the state of Ohio.
-- The net change in employees has increased over the years.
-- The average tenure for each department is about 8 years with Legal and Auditing having the highest and Services, Sales and Marketing having the lowest.
    

#LIMITATIONS
-- Some records had negative ages and these were excluded during querying(967 records). Ages used were 18 years and above.
-- Some termdates were far into the future and were not included in the analysis(1599 records). The only term dates used were those less than or equal to the current date.




   

