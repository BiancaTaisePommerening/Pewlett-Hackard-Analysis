
-- Total Amount of Current Employees working in the company.
SELECT 	e.emp_no,
		e.first_name,
		e.last_name,
		e.birth_date,
		de.from_date,
		de.to_date,
		t.title
INTO total_current_employees
FROM employees AS e
INNER JOIN dept_emp AS de
ON e.emp_no = de.emp_no
INNER JOIN titles AS t
ON e.emp_no = t.emp_no
WHERE de.to_date = ('9999-01-01')
ORDER BY e.emp_no ASC;
SELECT * FROM total_current_employees;

SELECT COUNT(*) AS "Amount of Current Employees"
FROM total_current_employees;

--------------------------------------------------

-- create a join of two tables into retir_titles.
SELECT  e.emp_no,
		e.first_name,
		e.last_name,
		tl.title, 
		tl.from_date,
		tl.to_date
INTO retirement_titles
FROM employees as e
INNER JOIN titles as tl
ON (e.emp_no = tl.emp_no)
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
ORDER BY emp_no ASC;

SELECT * FROM retirement_titles;

SELECT COUNT(*) AS "Retirement Titles"
FROM retirement_titles;


--------------------------------------


-- Amount of Retiring Employees.
-- Use Dictinct with Order by to remove duplicate rows
SELECT DISTINCT ON (rt.emp_no)
					rt.emp_no,
					rt.first_name,
					rt.last_name,
					rt.title
INTO unique_titles
FROM retir_titles AS rt
WHERE rt.to_date = ('9999-01-01')
ORDER BY rt.emp_no ASC;		
										
SELECT * FROM unique_titles;

SELECT COUNT(*) AS "Amount of Retiring Employees"
FROM unique_titles;

------------------------------------

-- Amount of Retiring Employees per Title.
SELECT COUNT(ut.title), 
			ut.title
INTO retiring_titles
FROM unique_titles AS ut
GROUP BY ut.title
ORDER BY ut.count DESC;

SELECT * FROM retiring_titles;


------------------------------------

-- Amount of Employees Eligible for Mentorship program.
SELECT DISTINCT ON  (e.emp_no) e.emp_no,
					 e.first_name,
					 e.last_name,
					 e.birth_date,
					 de.from_date,
					 de.to_date,
					 t.title
INTO mentorship_eligibility
FROM employees AS e
INNER JOIN dept_emp AS de
ON (e.emp_no = de.emp_no)
INNER JOIN titles AS t
ON (e.emp_no = t.emp_no)
WHERE de.to_date = ('9999-01-01')
AND (e.birth_date BETWEEN '1965-01-01' AND '1965-12-31')
ORDER BY emp_no ASC;
SELECT * FROM mentorship_eligibility;

SELECT COUNT(*) AS "Mentorship Eligibility"
FROM mentorship_eligibility;



--------------------------------------------------------------------------------


-- Amount of Employees Eligible for Mentorship Program per Title .
SELECT COUNT(me.title),
			 me.title
INTO mentor_elig_by_title
FROM mentorship_eligibility AS me
GROUP BY me.title
ORDER BY me.count DESC;

SELECT * FROM mentor_elig_by_title;

-----------------------------------------------

--- Amount of Retiring Employees per Amount of Eligible Employees by Title.
SELECT  urt.title AS "Job Title",
		met.count AS "Total Eligible p/ Title",
		urt.count AS "Total Retiring p/ Title",
		urt.count / met.count AS "Retir. p/ Elig. by Title."
INTO retir_per_elig_by_title
FROM unique_retiring_titles AS urt
FULL JOIN mentor_elig_by_title AS met
ON (urt.title = met.title)
ORDER BY urt.title ASC;
		
SELECT * FROM retir_per_elig_by_title;

--------------------------------------------------------------------

-- Checking if there are any youger employees than the ones born in 1965.

SELECT e.emp_no,
		e.birth_date,
		de.to_date
FROM employees AS e
INNER JOIN dept_emp AS de
ON e.emp_no = de.emp_no
WHERE de.to_date = ('9999-01-01')
AND e.birth_date BETWEEN '1966-01-01' AND '2004-12-31';






