-- create a table to hold the employee number, first and last name.
SELECT emp_no, first_name, last_name
INTO emp_data
FROM employees;

-- create a table to hold the titles and dates. 
SELECT title, from_date, to_date
INTO title_data
FROM titles;


-- create a join of two tables (emp_data and title_data) into retir_titles
SELECT  e.emp_no,
		e.first_name,
		e.last_name,
		tl.title, 
		tl.from_date,
		tl.to_date
INTO retir_titles
FROM employees as e
INNER JOIN titles as tl
ON (e.emp_no = tl.emp_no)
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
ORDER BY emp_no ASC;

SELECT * FROM retir_titles;


-- create unique titles table.
-- Use Dictinct with Order by to remove duplicate rows
SELECT DISTINCT ON (rt.emp_no)
					rt.emp_no,
					rt.first_name,
					rt.last_name,
					rt.title
INTO unique_titles
FROM retir_titles as rt
WHERE rt.to_date = ('9999-01-01')
ORDER BY rt.emp_no ASC, rt.title DESC;

SELECT * FROM unique_titles;


-- create a Retiring Titles table to hold the required information.
-- retrieve the number of titles from the Unique Titles table.
-- Group the table by title, then sort the count column in descending order.
SELECT COUNT(ut.title), ut.title
INTO unique_retiring_titles
FROM unique_titles as ut
GROUP BY ut.title
ORDER BY ut.count DESC;

SELECT * FROM unique_retiring_titles;

-- create a Mentorship Eligibility table that holds the employees who are eligible
-- to participate in a mentorship program.
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
