
SELECT employee_id, first_name, salary
FROM emps
WHERE department_id = 30;

UPDATE emps SET salary=salary*1.3
WHERE department_id=30;

COMMIT;

-----------------------------------------

CREATE TABLE dept(
    deptno NUMBER(2),
    dname VARCHAR2(14),
    loc VARCHAR2(13)
);

CREATE TABLE dept2 AS SELECT * FROM departments;
CREATE TABLE dept3 AS SELECT * FROM departments WHERE 0=1;

DESC dept;

ALTER TABLE dept
ADD (job_ VARCHAR2(15));

ALTER TABLE dept
RENAME COLUMN job_ TO job_id;

ALTER TABLE dept
MODIFY (job_id NUMBER(5));

ALTER TABLE dept
DROP COLUMN job_id;

RENAME dept TO dept_1;

DROP TABLE dept3;

CREATE TABLE emp4(
    empno NUMBER(4) CONSTRAINT emp4_empno_pk PRIMARY KEY,
    ename VARCHAR2(30) NOT NULL,
    sal NUMBER(7,2) CONSTRAINT emp4_sal_ck CHECK(sal<=10000),
    deptno NUMBER(2) CONSTRAINT emp4_deptno_deptno_fk
                    REFERENCES departments(department_id)
);
ALTER TABLE emp4
MODIFY deptno NUMBER(3);

INSERT INTO emp4 (empno, ename, sal, deptno)
        VALUES (1000, 'qwerty', 9999, 50);
        
SELECT * FROM emp4 WHERE empno = 1000;

UPDATE emp4 SET deptno = 250 WHERE empno = 1000;

-------------------------------------

SELECT * FROM USER_ROLE_PRIVS;
SELECT * FROM USER_SYS_PRIVS;

CREATE VIEW emp_view_dept60
AS SELECT employee_id, first_name, last_name, job_id, salary
    FROM employees
    WHERE department_id = 60;
    
SELECT * FROM emp_view_dept60;

CREATE VIEW emp_view_dept60_salary
AS SELECT
    employee_id AS empno,
    first_name||' '||last_name AS name,
    salary AS monthly_salary
    FROM employees
    WHERE department_id = 60;

SELECT * FROM emp_view_dept60_salary;

CREATE OR REPLACE VIEW emp_view_dept60_salary
AS SELECT
    employee_id AS empno,
    first_name||' '||last_name AS name,
    job_id AS job,
    salary AS monthly_salary
    FROM employees
    WHERE department_id = 60;
    
CREATE VIEW emp_view
AS SELECT
    e.employee_id AS id,
    e.first_name AS name,
    d.department_name AS dept,
    j.job_title AS job
    FROM employees e
        JOIN departments d ON e.department_id = d.department_id
        JOIN jobs j ON e.job_id = j.job_id
;

SELECT * FROM emp_view WHERE dept LIKE 'Human%';

DROP VIEW emp_view_dept60_salary;

------------------------------------------

CREATE SEQUENCE depts_seq
    INCREMENT BY 1
    START WITH 91
    MAXVALUE 100
    NOCACHE
    NOCYCLE;
    
INSERT INTO dept_1 (deptno, dname, loc)
VALUES (depts_seq.NEXTVAL, 'Marketing1', 'SAN DEIGO');
INSERT INTO dept_1 (deptno, dname, loc)
VALUES (depts_seq.NEXTVAL, 'Marketing2', 'SAN DEIGO');
INSERT INTO dept_1 (deptno, dname, loc)
VALUES (depts_seq.NEXTVAL, 'Marketing3', 'SAN DEIGO');
SELECT * FROM dept_1;

ALTER SEQUENCE depts_seq
    MAXVALUE 99;
SELECT sequence_name, min_value, max_value, increment_by, last_number
FROM USER_SEQUENCES;

SELECT depts_seq.CURRVAL FROM dual;

CREATE INDEX dept_1_deptno_idx ON dept_1 (deptno);
SELECT * FROM dept_1 WHERE deptno=91;
DROP INDEX dept_1_deptno_idx;

CREATE SYNONYM emp60 FOR emp_view;
SELECT * FROM emp60;

--------------------------------------------------


