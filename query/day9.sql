/*
    ANSI(American National Standards Institute)
    ANSI ǥ���� �����ͺ��̽� �����ý��ۿ��� ����ϴ� SQL ǥ��
    INNER JOIN, LEFT OUTER JOIN RIGHT OUTER JOIN, FULL OUTER JOIN
*/
-- �Ϲ� INNER JOIN
SELECT a.employee_id, a.emp_name, a.job_id, b.department_name
FROM employees a, departments b
WHERE a.department_id = b.department_id;

-- INNER
SELECT a.employee_id, a.emp_name, a.job_id, b.department_name
FROM employees a INNER JOIN departments b
ON a.department_id = b.department_id
WHERE a.department_id = 30; -- �˻������� �ִٸ� ���α��� �Ʒ�

-- USING ���� �÷����� ������ ���
SELECT a.employee_id, a.emp_name, a.job_id, b.department_name
FROM employees a INNER JOIN departments b
USING (department_id) -- �ش� �÷��� alias ��� ����
WHERE department_id = 30; -- USING ���� ����� �÷��� ���̺�� ���� �ȵ�.

-- �Ϲ� OUTER JOIN
SELECT a.employee_id, emp_name, b.job_id -- emp_name�� ���� ���̺��� �ִ� �÷�
FROM employees a, job_history b
WHERE a.job_id = b.job_id(+)
AND a.department_id = b.department_id(+);

-- LEFT OUTER JOIN
SELECT a.employee_id, emp_name, b.job_id -- emp_name�� ���� ���̺��� �ִ� �÷�
FROM employees a LEFT JOIN job_history b -- OUTER ���� ����
ON(a.job_id = b.job_id AND a.department_id = b.department_id);

-- RIGHT OUTER JOIN (���� ������ ���)
SELECT a.employee_id, emp_name, b.job_id 
FROM job_history b RIGHT JOIN employees a 
ON(a.job_id = b.job_id AND a.department_id = b.department_id);

CREATE TABLE tb_a(
    emp_id NUMBER
);
CREATE TABLE tb_b(
    emp_id NUMBER
);
INSERT INTO tb_a VALUES(10);
INSERT INTO tb_a VALUES(20);
INSERT INTO tb_a VALUES(40);

INSERT INTO tb_b VALUES(10);
INSERT INTO tb_b VALUES(20);
INSERT INTO tb_b VALUES(30);
COMMIT;
SELECT * FROM tb_b;

-- FULL OUTER JOIN (�Ϲ� ������ ���� ����(+) �ȵ�)
SELECT a.emp_id, b.emp_id
FROM tb_a a
FULL OUTER JOIN tb_b b
ON(a.emp_id = b.emp_id);

-- �Ϲ� CROSS JOIN 
SELECT *
FROM tb_a, tb_b; -- 3 * 3 �� ���
-- 
SELECT * 
FROM tb_a CROSS JOIN tb_b;

-- �л��� ���� ������ ����Ͻÿ� LEFT JOIN ���
-- �����̸� �߰�
SELECT a.�̸�, b.���ǽ�, b.�����ȣ, c.�����̸�
FROM �л� a LEFT JOIN �������� b
ON a.�й� = b.�й�
LEFT JOIN ���� c
ON b.�����ȣ = c.�����ȣ;

-- VIEW ���� �����ʹ� �並 �����ϴ� ���̺� ��� ����.
--������ : ������ ���� ����, �����ϰ� ���ֻ���ϴ� ������ �����ϰ�.
-- VIEW���� ������ ���ٸ� 
-- DBA������ �ִ� system �������� ���� �ο�
-- GRANT CREATE VIEW TO ����;
CREATE OR REPLACE VIEW emp_dept AS 
SELECT a.employee_id, a.emp_name, b.department_id, b.department_name
FROM employees a , departments b
WHERE a.department_id = b.department_id;

-- java�������� member �������� �� ��ȸ ���� �ο�
GRANT SELECT ON emp_dept TO member;
--member���� �Ʒ�����
SELECT *
FROM java.emp_dept; -- ��Ű��.���, 
/*
    ��Ű��
    �����ͺ��̽� ������ ���� ���ǿ� ���� �������� ���� ����� ��Ÿ������ ����
    �����ͺ��̽� �𵨸� ������ ���� �ܺ�, ����, ���佺Ű���� ������
    ������ ����ڰ� ������ ��� �����ͺ��̽� ��ü���� ���ϸ�
    ����� ������ ����.java �������� java ��Ű��
*/

-- VIEW�� �ܼ���(�ϳ��� ���̺�� ����)
          -- INSERT/UPDATE/DELETE ����
--        ���պ�(������ ���̺�� ����)
          -- INSERT/UPDATE/DELETE �Ұ���
          
/*
    �ó�� SYnonym ���Ǿ�, ��ü ������ ������ �̸��� ���Ǿ ����� ��
    PUBLIC ��� ����� ���ٰ���, PRIVATE Ư������ڸ�
    �ó�� ������ default�� private�̸�
    public�� DBA������ �ִ� ����ڸ� ���� �� ���� ����
*/
GRANT CREATE SYNONYM TO java;

CREATE OR REPLACE SYNONYM emp1
FOR employees; -- private �ó��

SELECT *
FROM emp1;
GRANT SELECT ON emp1 TO member;

SELECT *
FROM java.emp1;

-- system �������� public �ó�� ����
CREATE OR REPLACE PUBLIC SYNONYM emp2
FOR java.employees;

SELECT *
FROM emp2; -- public�̶� ���� ����(member����)

/*
    ������ SEQUENCE �ڵ� ������ ��ȯ�ϴ� �����ͺ��̽� ��ü
    ������ ��Ģ�� ���� ������ ����
*/
CREATE SEQUENCE my_seq1
INCREMENT BY 1 -- ��������
START WITH 1   -- ���ۼ���
MINVALUE 1     -- �ּ� ����(���ۼ��ڿ� ���ƾ���)
MAXVALUE 10    -- �ִ� ����(���ۺ��� Ŀ����)
NOCYCLE        -- �ִ� or �ּ� ���޽� ���ߵ��� 
NOCACHE;       -- �޸𸮿� �̸� ���� �Ҵ����� �ʵ��� nocache�� ���ϸ� �ǳʶ�(�̸� �޸𸮿� �Ҵ�)

-- ����
SELECT my_seq1.NEXTVAL
FROM dual;
-- ����
SELECT my_seq1.CURRVAL
FROM dual;

CREATE SEQUENCE my_seq2
INCREMENT BY 100    -- ��������
START WITH 1        -- ���ۼ���
MINVALUE 1          -- �ּ� ����(���ۼ��ڿ� ���ƾ���)
MAXVALUE 1000000    -- �ִ� ����(���ۺ��� Ŀ����)
NOCYCLE             -- �ִ� or �ּ� ���޽� ���ߵ��� 
NOCACHE;            -- �޸𸮿� �̸� ���� �Ҵ����� �ʵ��� nocache�� ���ϸ� �ǳʶ�(�̸� �޸𸮿� �Ҵ�)

SELECT my_seq2.NEXTVAL
FROM dual;
SELECT my_seq2.CURRVAL
FROM dual;
INSERT INTO tb_a VALUES(my_seq2.NEXTVAL);
SELECT * FROM tb_a;

-- IDENTITY oracle 12���� �̻󿡼� ������.
CREATE TABLE my_tb(
    my_id NUMBER GENERATED ALWAYS AS IDENTITY
    , my_nm VARCHAR2(100)
    , CONSTRAINT my_pk PRIMARY KEY(my_id)
);
INSERT INTO my_tb(my_nm) VALUES('�ؼ�');
INSERT INTO my_tb(my_nm) VALUES('����');
INSERT INTO my_tb(my_nm) VALUES('����');
SELECT * FROM my_tb;

CREATE TABLE my_tb2(
    my_id NUMBER GENERATED ALWAYS AS IDENTITY(START WITH 1 INCREMENT BY 2 NOCACHE)
    , my_nm VARCHAR2(100)
    , CONSTRAINT my_pk2 PRIMARY KEY(my_id)
);
INSERT INTO my_tb2(my_nm) VALUES('�ؼ�');
INSERT INTO my_tb2(my_nm) VALUES('����');
INSERT INTO my_tb2(my_nm) VALUES('����');
SELECT * FROM my_tb2;

/*
    MERGE Ư�� ���ǿ� ���� �ٸ� ������ ������ �� ��밡��
*/
-- '����' ���̺� �ӽŷ��� ������ ������ ������  2�� ����
-- �ִٸ� ������ 3���� ������Ʈ
MERGE INTO  ���� s
USING dual -- �� ���̺� dual�� ���� ���̺��϶�
ON (s.�����̸� = '�ӽŷ���') -- ��match ����
WHEN MATCHED THEN UPDATE SET s.���� = 3
WHEN NOT MATCHED THEN INSERT (s.�����ȣ, s.�����̸�, s.����) VALUES((SELECT NVL(MAX(�����ȣ),0) + 1
FROM ����), '�ӽŷ���', 2);

SELECT * FROM ����;
SELECT NVL(MAX(�����ȣ),0) + 1
FROM ����;

/*
    2000�⵵ �Ǹ�(�ݾ�)���� ������ ����Ͻÿ�. (sales, employees)
    �ǸŰ��� �÷�(amount_sold, quantity_sold,  sales_date)
    (��Į�� ���������� �ζ��� �並 ���)
*/
SELECT * FROM employees;
SELECT * FROM sales;
SELECT a.employee_id
    , (SELECT emp_name FROM employees
        WHERE employee_id = a.employee_id) as �����̸�
    , TO_CHAR(�Ǹűݾ�, '999,999,999.99') �Ǹűݾ�
    , �Ǹż���
FROM (SELECT employee_id, SUM(amount_sold) as �Ǹűݾ�
            , SUM(quantity_sold) as �Ǹż���
        FROM sales
        WHERE TO_CHAR(sales_date, 'YYYY') = '2000'
        GROUP BY employee_id
        ORDER BY 2 DESC) a
WHERE ROWNUM <=1;

SELECT MAX(�Ǹż���), MAX(�Ǹűݾ�)
FROM employees a, (
    SELECT employee_id
        , SUM(amount_sold, '999,999,999.99') as �Ǹűݾ�
        , COUNT(quantity_sold * amount_sold) as �Ǹż���
    FROM sales 
    WHERE TO_CHAR(sales_date, 'yyyy') = 2000
    GROUP BY employee_id
    ORDER BY 2 DESC
    ) b
WHERE ROWNUM = 1;