/*
    table ���̺�
    1. ���̺�� �÷����� �ִ� ũ��� 30byte (������ 1�� 1byte)
    2. ���̺�� �÷������� ������ ����� �� ����(select, varchar2)
    3. ���̺�� �÷������� ����, ����, _, #�� ����� �� ������
    ù ���ڴ� ���ڸ� �� �� ����.
    4. �� ���̺� ��� ������ �÷��� �ִ� 255�� 
    
    ��ɾ�� ��ҹ��ڸ� �������� ����. (����Ǵ� ���̺� ������ �빮�ڷ� �����.)
    �����ʹ� ��ҹ��ڸ� ������.
    
*/
CREATE TABLE ex1_1(
    col1 CHAR(10)
    ,col2 VARCHAR2(10) -- �÷��� ,�� ���еǸ� �ϳ��� �÷��� �ϳ��� Ÿ�԰� ����� ����.
);
-- INSERT ������ ����
INSERT INTO ex1_1(col1, col2)
VALUES ('oracle', 'oracle');
INSERT INTO ex1_1(col1, col2)
VALUES ('����Ŭ', '����Ŭ');
INSERT INTO ex1_1(col1, col2)
VALUES ('����Ŭdb', '����Ŭdb');

SELECT * FROM ex1_1;

SELECT col1 FROM ex1_1;

-- length <-- �Լ� ���ڿ� ����,  lengthb <-- ���ڿ��� ũ��(byte)
SELECT col1, col2, length(col1), length(col2), lengthb(col1), lengthb(col2) 
FROM ex1_1;

SELECT *
FROM employees; --from ���� ��ȸ�ϰ��� �ϴ� Ƽ�̺� �ۼ�.
-- ���̺� ���� ������ȸ (ORDER BY ������ ����ϴ� �Ͱ��� �ٸ�)
DESC employees;

SELECT emp_name     as nm  -- AS alias ��Ī
    , hire_date     hd  -- �޸��� �������� �÷��� ���� ���� �ܾ�� ��Ī���� �ν�
    , salary        sa_la -- ��Ī���� ����� �ȵ�.(����� ���) 
    , department_id "�μ����̵�" -- �ѱ� ��Ī�� �Ⱦ����� ������ "" �� ���
FROM employees;

-- �˻����� where
SELECT * FROM employees WHERE salary >= 20000;
SELECT * FROM employees WHERE salary >= 10000 AND 11000 > salary AND department_id = 80;

-- �������� ASC: ����, DESC: ����
SELECT * 
FROM employees 
WHERE salary >= 10000 
AND 11000 > salary 
AND department_id = 80
ORDER BY emp_name;

-- ��Ģ���� ��밡��
SELECT emp_name             AS ����
    , salary                AS ����
    , salary - salary * 0.1 AS �Ǽ��ɾ�
    , salary * 12           AS ����
    , ROUND(salary/22.5, 2) AS �ϴ�
FROM employees;

/* 
    ���� ������ Ÿ�� NUMBER 
    number(p, s) p�� �Ҽ����� �������� ��� ��ȿ���� �ڸ����� �ǹ���.
                 s�� �Ҽ����� �ڸ����� �ǹ���(����Ʈ 0)
                 s�� 2�� �Ҽ��� 2�ڸ� ���� (�������� �ݿø���.)
                 s�� �����̸� �Ҽ��� �������� ���� �ڸ���ŭ �ݿø���.
*/
CREATE TABLE ex1_2(
    col1 NUMBER(3)          -- ������ 3�ڸ�
    , col2 NUMBER(3, 2)     -- ����1, �Ҽ��� 2�ڸ�����
    , col3 NUMBER(5, -2)    -- ���� �ڸ����� �ݿø�(��7�ڸ�)
    , col4 NUMBER
);
INSERT INTO ex1_2 (col1) VALUES (0.789);
INSERT INTO ex1_2 (col1) VALUES (99.6);
INSERT INTO ex1_2 (col1) VALUES (1004); -- ���� �߻�

INSERT INTO ex1_2 (col2) VALUES (0.7898);
INSERT INTO ex1_2 (col2) VALUES (1.7898);
INSERT INTO ex1_2 (col2) VALUES (9.9998); -- ���� 
INSERT INTO ex1_2 (col2) VALUES (10);     -- ����

INSERT INTO ex1_2 (col3) VALUES (12345.2345);
INSERT INTO ex1_2 (col3) VALUES (1234569.2345);
INSERT INTO ex1_2 (col3) VALUES (12345699.2345); -- ����

SELECT * FROM ex1_2;

/*
    ��¥ ������ Ÿ��(data ����Ͻú���, timestamp ����Ͻú���.�и���)
    sysdate ����ð�, systimstamp ����ð�.�и���
*/
CREATE TABLE ex1_3(
    date1 DATE
    , date2 TIMESTAMP
);
INSERT INTO ex1_3 VALUES(SYSDATE, SYSTIMESTAMP);
SELECT * FROM ex1_3;
--COMMIT;
--ROLLBACK

SELECT employee_id
    ,emp_name
    ,department_id
FROM employees;

SELECT *
FROM departments;

-- PK, FK�� Ȱ���Ͽ� �� ���̺��� ���踦 �ξ� �����͸� ������.
SELECT employees.employee_id        -- ���� ���̺��� PK
    ,employees.department_id        -- ���� ���̺��� FK(�μ� ���̺� ��ȣ����)
    ,employees.emp_name
    ,departments.department_id
    ,departments.department_name    -- �μ� ���̺��� PK
FROM employees
    ,departments
WHERE employees.department_id = departments.department_id;

/* ��������
    ���̺��� �����ϱ� ���� ��Ģ
    NOT NULL ���� ������� �ʰڴ�.
    UNIQUE �ߺ��� ������� �ʰڴ�
    CHECK Ư�� �����͸� �ްڴ�
    PRIMARY KEY �⺻Ű(�ϳ��� ���̺� 1���� �������� (n���� �÷��� �����ؼ� ��밡��)
                        �ϳ��� ���� �����ϴ� �ĺ��� or Ű�� or PK or �⺻Ű��� ��.
                        PK�� UNIQUE �ϸ� NOT NULL��
    FOREIGN KEY �ܷ�Ű(����Ű, FK�� ��, �ٸ� ���̺��� PK�� �����ϴ� Ű
*/
CREATE TABLE ex1_4(
    mem_id VARCHAR2(50) PRIMARY KEY     -- �⺻Ű
    ,mem_nm VARCHAR2(50) NOT NULL       -- �� ������
    ,mem_nickname VARCHAR2(100) UNIQUE  -- �ߺ� ������
    ,age NUMBER                         -- 1 ~ 150
    ,gender VARCHAR2(1)                 -- F or M
    ,create_dt DATE DEFAULT SYSDATE     -- ����Ʈ�� ����
    ,CONSTRAINT ck_ex_age CHECK(age BETWEEN 1 AND 150)
    ,CONSTRAINT ch_ex_gender CHECK(gender IN('F', 'M'))
);

INSERT INTO ex1_4 (mem_id, mem_nm, mem_nickname, age, gender)
VALUES('a001', '�ؼ�', '����', 10, 'M');

INSERT INTO ex1_4 (mem_id, mem_nm, mem_nickname, age, gender)
VALUES('a003', '����', '����', 10, 'F');

SELECT*
FROM ex1_4;

SELECT *
FROM user_constraints
WHERE table_name = 'EX1_4';

CREATE TABLE TB_INFO(
    INFO_NO NUMBER(2) PRIMARY KEY NOT NULL
    ,PC_NO VARCHAR(10) UNIQUE NOT NULL
    ,NM VARCHAR2(20) NOT NULL
    ,EN_NM VARCHAR2(50) NOT NULL
    ,EMAIL VARCHAR2(50) NOT NULL
    ,HOBBY VARCHAR2(500)
    ,CREATE_DT DATE DEFAULT SYSDATE
    ,UPDATE_DT DATE DEFAULT SYSDATE 
);

