---Homework. Create Tables
DROP TABLE IF EXISTS departments;
DROP TABLE IF EXISTS dept_emp;
DROP TABLE IF EXISTS dept_manager;
DROP TABLE IF EXISTS employees;
DROP TABLE IF EXISTS salaries;
DROP TABLE IF EXISTS titles;

DROP TABLE departments, dept_emp, dept_manager, employees, salaries, titles CASCADE;
select * from dept_manager

-- Exported from QuickDBD: https://www.quickdatabasediagrams.com/
-- Link to schema: https://app.quickdatabasediagrams.com/#/d/k0RcBW
-- NOTE! If you have used non-SQL datatypes in your design, you will have to change these here.

CREATE TABLE "departments" (
    "dept_no" varchar(5)   NOT NULL,
    "dept_name" varchar(30)   NOT NULL,
    CONSTRAINT "pk_departments" PRIMARY KEY (
        "dept_no"
     )
);

CREATE TABLE "dept_emp" (
    "emp_no" varchar(7)   NOT NULL,
    "dept_no" varchar(5)   NOT NULL,
    "from_date" date   NOT NULL,
    "to_date" date   NOT NULL
);

CREATE TABLE "employees" (
    "emp_no" varchar(7)   NOT NULL,
    "birth_date" date   NOT NULL,
    "first_name" varchar   NOT NULL,
    "last_name" varchar   NOT NULL,
    "gender" char(1)   NOT NULL,
    "hire_date" date   NOT NULL,
    CONSTRAINT "pk_employees" PRIMARY KEY (
        "emp_no"
     )
);

CREATE TABLE "titles" (
    "emp_no" varchar(7)   NOT NULL,
    "title" varchar(20)   NOT NULL,
    "from_date" date   NOT NULL,
    "to_date" date   NOT NULL
);

CREATE TABLE "dept_manager" (
    "dept_no" varchar(5)   NOT NULL,
    "emp_no" varchar(7)   NOT NULL,
    "from_date" date   NOT NULL,
    "to_date" date   NOT NULL
);

CREATE TABLE "salaries" (
    "emp_no" varchar(7)   NOT NULL,
    "salary" int   NOT NULL,
    "from_date" date   NOT NULL,
    "to_date" date   NOT NULL
);

ALTER TABLE "dept_emp" ADD CONSTRAINT "fk_dept_emp_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employees" ("emp_no");

ALTER TABLE "dept_emp" ADD CONSTRAINT "fk_dept_emp_dept_no" FOREIGN KEY("dept_no")
REFERENCES "departments" ("dept_no");

ALTER TABLE "titles" ADD CONSTRAINT "fk_titles_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employees" ("emp_no");

ALTER TABLE "dept_manager" ADD CONSTRAINT "fk_dept_manager_dept_no" FOREIGN KEY("dept_no")
REFERENCES "departments" ("dept_no");

ALTER TABLE "dept_manager" ADD CONSTRAINT "fk_dept_manager_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employees" ("emp_no");

ALTER TABLE "salaries" ADD CONSTRAINT "fk_salaries_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employees" ("emp_no");

--1. each employee: employee number, last name, first name, gender, and salary.

SELECT employees.emp_no,
  employees.first_name,
  employees.last_name,
  employees.gender,
  salaries.salary
FROM employees
LEFT JOIN salaries ON
employees.emp_no = salaries.emp_no;

select * from employees

--2. List employees who were hired in 1986. 36,150 rows returned
SELECT first_name, last_name, hire_date
FROM employees
WHERE hire_date BETWEEN '1986-01-01' AND '1986-12-31';

--3. List the manager of each department with the following information: 
--dept_no, dept_name, emp_no, from_date, to_date .
--(Employees) --last_name, first_name
-- Answer: 24 rows
SELECT 
	dept_manager.from_date,
	dept_manager.to_date,
	employees.first_name, 
	employees.last_name, 
	departments.dept_name
FROM dept_manager
INNER JOIN departments ON
dept_manager.dept_no = departments.dept_no
INNER JOIN employees ON
dept_manager.emp_no = employees.emp_no;

--4.List the department of each employee with the following information: 
--[Employees] emp_no, last_name, first_name, [via dept_emp.dept_no] and departments.dept_name
--Answer: 331603 rows (Explanation: Some employees have been in more than one department)
SELECT 
	employees.emp_no,
	employees.first_name, 
	employees.last_name, 
	departments.dept_name
FROM employees
LEFT JOIN dept_emp ON
employees.emp_no = dept_emp.emp_no
INNER JOIN departments ON
dept_emp.dept_no = departments.dept_no;

--5. all employees whose first name is "Hercules" and last names begin with "B."
SELECT first_name, last_name
FROM employees
WHERE first_name = 'Hercules' AND last_name LIKE 'B%';
-- Result = 20 rows

--6. all employees in the Sales department, including 
--- emp_no, last_name, first_name, dept_name
SELECT e.emp_no, e.first_name, e.last_name, s.dept_name
  -- 1. employees (alias as e)
  FROM employees AS e
  -- 2. Join to dept_emp (as d)
  INNER JOIN dept_emp AS d
    -- 3. Match on emp_no
    ON e.emp_no = d.emp_no
  -- 4. Join to departments (as s)
  INNER JOIN departments AS s
    -- 5. Match on dept_no
    ON d.dept_no = s.dept_no
	WHERE dept_name = 'Sales';
	--Answer - 52,245 rows

--7. all employees in the Sales and Development departments, 
--emp_no, last_name, first_name, dept_name
SELECT e.emp_no, e.first_name, e.last_name, s.dept_name
  -- 1. employees (alias as e)
  FROM employees AS e
  -- 2. Join to dept_emp (as d)
  INNER JOIN dept_emp AS d
    -- 3. Match on emp_no
    ON e.emp_no = d.emp_no
  -- 4. Join to departments (as s)
  INNER JOIN departments AS s
    -- 5. Match on dept_no
    ON d.dept_no = s.dept_no
	WHERE dept_name = 'Sales' OR dept_name = 'Development';
	--Answer - 137,952 rows

select * from departments

--8. descending order, list the frequency count of employee last names, 
--i.e., how many employees share each last name
SELECT COUNT(emp_no) AS Count_LastNames, last_name
    FROM employees
	GROUP BY last_name
	ORDER BY last_name;
-- Answer 1368 Unique names
