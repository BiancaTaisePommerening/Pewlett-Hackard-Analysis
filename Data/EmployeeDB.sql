-- Creating tables for PH-EmployeeDB

CREATE TABLE departments (
     dept_no VARCHAR(4) NOT NULL,
     dept_name VARCHAR(40) NOT NULL,
     PRIMARY KEY (dept_no),
     UNIQUE (dept_name)
);

CREATE TABLE employees (
	 emp_no INT NOT NULL,
     birth_date DATE NOT NULL,
     first_name VARCHAR NOT NULL,
     last_name VARCHAR NOT NULL,
     gender VARCHAR NOT NULL,
     hire_date DATE NOT NULL,
     PRIMARY KEY (emp_no)
);

CREATE TABLE dept_manager (
	dept_no VARCHAR(4) NOT NULL,
    emp_no INT NOT NULL,
    from_date DATE NOT NULL,
    to_date DATE NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
	FOREIGN KEY (dept_no) REFERENCES departments (dept_no),
	PRIMARY KEY (emp_no, dept_no)
);

CREATE TABLE salaries (
	emp_no INT NOT NULL,
	salary INT NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
	PRIMARY KEY (emp_no)
);

CREATE TABLE dept_emp (
	emp_no INT NOT NULL,
	dept_no VARCHAR NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL
	---FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
	---FOREIGN KEY (dept_no) REFERENCES departments (dept_no),
	---PRIMARY KEY (emp_no)
);
	
CREATE TABLE titles (
	emp_no INT NOT NULL,
	title VARCHAR NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL
	---FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
	---PRIMARY KEY (emp_no)
);
--- Displaying each table (each line needs to be run separately).
SELECT * FROM departments;
SELECT * FROM employees;
SELECT * FROM salaries;
SELECT * FROM dept_emp;
SELECT * FROM dept_manager;
SELECT * FROM titles;


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
SELECT retirement_info.emp_no,
    retirement_info.first_name,
	retirement_info.last_name,
    dept_emp.to_date
FROM retirement_info
LEFT JOIN dept_emp
ON retirement_info.emp_no = dept_emp.emp_no;


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


-- create a inner join of 3 tables between employees table,
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

--display the table.
SELECT * FROM emp_info;

-- List of managers per department
SELECT 	dm.dept_no,
		d.dept_name,
		dm.emp_no,
		ce.last_name,
		ce.first_name,
		dm.from_date,
		dm.to_date
--INTO manager_info
FROM dept_manager as dm
INNER JOIN departments as d
ON (dm.dept_no = d.dept_no)
INNER JOIN current_emp as ce 
ON (dm.emp_no = ce.emp_no)

