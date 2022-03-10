---Amount of employees that were born betweenn 1952 and 1955.
SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1952-01-01' AND '1955-12-31';

---Amount of employees that were born in 1952.
SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1952-01-01' AND '1952-12-31';

---Amount of employees that were born in 1953.
SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1953-01-01' AND '1953-12-31';

---Amount of employees that were born in 1954.
SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1954-01-01' AND '1954-12-31';

---Amount of employees that were born in 1955.
SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1955-01-01' AND '1955-12-31';

-- Retirement eligibility
SELECT first_name, last_name
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31') 
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

-- Number of employees retiring
SELECT COUNT (first_name)
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31') 
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');	


-- Create new table for retiring employees
SELECT emp_no, first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');
-- Check the table
SELECT * FROM retirement_info;


-- Joining retirement_info and dept_emp tables
-- SELECT retirement_info.emp_no,
--     retirement_info.first_name,
-- 	retirement_info.last_name,
--     dept_emp.to_date
-- FROM retirement_info
-- LEFT JOIN dept_emp
-- ON retirement_info.emp_no = dept_emp.emp_no;


-- Joining retirement_info and dept_emp tables(with nicknames).
SELECT ri.emp_no,
    ri.first_name,
	ri.last_name,
    de.to_date
FROM retirement_info as ri
LEFT JOIN dept_emp as de
ON ri.emp_no = de.emp_no;


-- Joining departments and dept_manager tables
SELECT departments.dept_name,
     dept_manager.emp_no,
     dept_manager.from_date,
     dept_manager.to_date
FROM departments
INNER JOIN dept_manager
ON departments.dept_no = dept_manager.dept_no;

-- Joining departments and dept_manager tables (with nicknames).
SELECT d.dept_name,
     dm.emp_no,
     dm.from_date,
     dm.to_date
FROM departments as d
INNER JOIN dept_manager as dm
ON d.dept_no = dm.dept_no;


--- Joinning retirement_info and dept_emp tables (with nicknames).
SELECT ri.emp_no,
    ri.first_name,
    ri.last_name,
	de.to_date
--- create a new table to hold the information. Let's name it "current_emp."
INTO current_emp
--- add the code that will join these two tables.
FROM retirement_info as ri
LEFT JOIN dept_emp as de
ON ri.emp_no = de.emp_no
--- Finally, because this is a table of current employees, we need to add 
---a filter, using the WHERE keyword and the date 9999-01-01.
WHERE de.to_date = ('9999-01-01');
--- Display the new table.
SELECT * FROM current_emp;


-- Create a table Employee count by department number (emp_per_dept).
---The COUNT function was used on the employee numbers.
---Aliases were assigned to both tables.
---GROUP BY was added to the SELECT statement.
SELECT COUNT(ce.emp_no), de.dept_no
INTO emp_per_dept
FROM current_emp as ce
LEFT JOIN dept_emp as de
ON ce.emp_no = de.emp_no
GROUP BY de.dept_no
ORDER BY de.dept_no;
SELECT * FROM emp_per_dept;


-- sort to_date column in descending order.
SELECT * FROM salaries
ORDER BY to_date DESC;


-- create a list with employee information containing their unique employee number,
-- their last name, first name, gender, and salary.
--create inner join of 3 tables between employees table,
--salaries table, and dept_emp, on emp_no column.
SELECT e.emp_no,
		e.first_name, 
		e.last_name, 
		e.gender,
		s.salary,
		de.to_date
INTO emp_info
FROM employees as e
INNER JOIN salaries as s
ON (e.emp_no = s.emp_no)
INNER JOIN dept_emp as de
ON (e.emp_no = de.emp_no)
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (e.hire_date BETWEEN '1985-01-01' AND '1988-12-31')
AND (de.to_date = '9999-01-01');
--display the emp_info table.
SELECT * FROM emp_info;



-- List of management information containing managers for each department, 
-- including the department number, name, and the manager's employee number, 
-- last name, first name, and the starting and ending employment dates
-- create inner join of 3 tables between dept_manager table,
--departments table, and current_employee table, on dpet_no column, and emp_no column.
SELECT 	dm.dept_no,
		d.dept_name,
		dm.emp_no,
		ce.last_name,
		ce.first_name,
		dm.from_date,
		dm.to_date
INTO manager_info
FROM dept_manager as dm
INNER JOIN departments as d
ON (dm.dept_no = d.dept_no)
INNER JOIN current_emp as ce 
ON (dm.emp_no = ce.emp_no);
--display the manager_info table.
SELECT * FROM manager_info;



-- list of department retirees
-- An updated current_emp list that includes everything it currently has,
-- but also the employee's departments.
SELECT  ce.emp_no,
		ce.first_name,
		ce.last_name,
		d.dept_name
INTO dept_info
FROM current_emp as ce
INNER JOIN dept_emp as de
ON (ce.emp_no = de.emp_no)
INNER JOIN departments as d
ON (de.dept_no = d.dept_no);
-- display the dept_info table.
-- create inner join of 3 tables
SELECT * FROM dept_info;

-- skill drill 
-- create a table of retirees for only the sales department.
SELECT ri.emp_no,
    ri.first_name,
	ri.last_name,
    d.dept_name
INTO sales_dept_info
FROM retirement_info as ri
INNER JOIN dept_emp as de
ON ri.emp_no = de.emp_no
INNER JOIN departments as d
ON (de.dept_no = d.dept_no)
WHERE d.dept_name = ('Sales');
-- display sales info
SELECT * FROM sales_dept_info;

-- skill drill 
-- create a table of retirees of the sales and development departments.
SELECT ri.emp_no,
    ri.first_name,
	ri.last_name,
    d.dept_name
INTO sales_develp_retirees
FROM retirement_info as ri
INNER JOIN dept_emp as de
ON ri.emp_no = de.emp_no
INNER JOIN departments as d
ON (de.dept_no = d.dept_no)
WHERE d.dept_name IN ('Sales', 'Development')
ORDER BY dept_name ASC;
-- display sales and development retirees info.
SELECT * FROM sales_develp_retirees;

