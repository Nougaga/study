-- 작업물 스위치들 --
DESC departments;
ROLLBACK;
COMMIT;
DELETE FROM departments WHERE department_name = 'BigDada Analytics';
DELETE FROM emps;
DELETE FROM managers;
-- 신중하게 누를 것 --


INSERT INTO departments (department_id, department_name, manager_id, location_id)
    VALUES (300, 'BigDada Analytics', null, 1700);
INSERT INTO departments VALUES (300, 'BigDada Analytics', null, 1700);
SELECT * FROM departments WHERE department_id = 300;
--COMMIT;
ROLLBACK;

CREATE TABLE managers AS
SELECT employee_id, first_name, job_id, salary, hire_date
FROM employees
WHERE 1=2   -- Null

INSERT INTO managers (employee_id, first_name, job_id, salary, hire_date)
SELECT employee_id, first_name, job_id, salary, hire_date
FROM employees
WHERE job_id LIKE '%MAN';

SELECT * FROM managers;

CREATE TABLE emps AS SELECT * FROM employees;

SELECT employee_id, first_name, salary
FROM emps
WHERE employee_id = 103;

UPDATE emps
SET salary = salary * 1.1
WHERE employee_id = 103;

UPDATE emps
SET (job_id, salary, manager_id) =
    (SELECT job_id, salary, manager_id
    FROM emps
    WHERE employee_id = 108)
WHERE employee_id = 109;

DELETE FROM emps
WHERE employee_id = 109;

DELETE FROM emps WHERE department_id = 20;
SAVEPOINT delete_20;
DELETE FROM emps WHERE department_id = 30;
ROLLBACK TO SAVEPOINT delete_20;

