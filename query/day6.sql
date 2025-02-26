-- 17002 lsnrctl status ����Ŭ ���� �۵����ΰ� Ȯ���ϴ� ��ɾ� (����Ȯ��)
-- ���������� lsnrctl start (����)
/*
    �����Լ��� �׷����
    �����Լ� ��� �����Ϳ� ���� ����, ���, �ִ�, �ּڰ� ���� ���ϴ� �Լ�
*/
SELECT COUNT(*)                   -- null ����
    , COUNT(department_id)          -- default all
    , COUNT(ALL department_id)      -- �ߺ� o, null x
    , COUNT(DISTINCT department_id) -- �ߺ� x, null x
    , COUNT(employee_id)
FROM employees; 

SELECT SUM(salary) as �հ�
    , MAX(salary) as �ִ�
    , MIN(salary) as �ּ�
    , ROUND(AVG(salary), 2) as ���
FROM employees;

SELECT department_id
    , SUM(salary) as �հ�
    , MAX(salary) as �ִ�
    , MIN(salary) as �ּ�
    , ROUND(AVG(salary), 2) as ���
    , COUNT(employee_id) as ������
FROM employees
WHERE department_id IS NOT NULL
AND department_id IN(30, 60, 90)
GROUP BY department_id
ORDER BY 1;

-- �μ���, ������ ����
SELECT department_id
    , job_id
    , SUM(salary) as �հ�
    , MAX(salary) as �ִ�
    , MIN(salary) as �ּ�
    , ROUND(AVG(salary), 2) as ���
    , COUNT(employee_id) as ������
FROM employees
WHERE department_id IS NOT NULL
AND department_id IN(30, 60, 90)
GROUP BY department_id, job_id
ORDER BY 1;

-- member�� ȸ������ ���ϸ����� �հ�, ����� ����Ͻÿ�
SELECT * FROM member;
SELECT COUNT(mem_id) as ȸ���� -- COUNT(*)
    , SUM(mem_mileage) as ���ϸ���
    , ROUND(AVG(mem_mileage), 2) as ���
FROM member;

-- ������, ȸ����, ���ϸ��� �հ�, ��� (���ϸ��� ��� ��������)
SELECT mem_job  
    , COUNT(mem_id) as ȸ���� -- COUNT(*)
    , SUM(mem_mileage) as ���ϸ���
    , ROUND(AVG(mem_mileage), 2) as ���
FROM member
GROUP BY mem_job
ORDER BY ��� DESC;

-- ������ ���ϸ��� ����� 3000 �̻��� ȸ���� ������ ȸ������ ���
SELECT mem_job  
    , COUNT(mem_id) as ȸ���� -- COUNT(*)
    , SUM(mem_mileage) as ���ϸ���
    , ROUND(AVG(mem_mileage), 2) as ���
FROM member
GROUP BY mem_job
HAVING AVG(mem_mileage) >= 3000 -- �������� ���ؼ� �˻����� �߰��Ҷ� ���
ORDER BY ��� DESC;

-- kor_loan_status (java ����) ���̺��� 2013�⵵ �Ⱓ��, ������ �� ����ܾ��� ����Ͻÿ�.
SELECT * FROM kor_loan_status;
SELECT SUBSTR(period,1, 4) as �⵵
    , region as ����
    , SUM(loan_jan_amt) as ������
FROM kor_loan_status
WHERE SUBSTR(period,1, 4) = '2013'
GROUP BY SUBSTR(period,1, 4), region -- �����Լ��� ������ �÷����� GROUP BY�� �ۼ��ؾ� �Ѵ�.
ORDER BY ����;

-- ������ �����ܾ��հ谡 200000 �̻��� ������ ����Ͻÿ�
SELECT region as ����
    , SUM(loan_jan_amt) as ������
FROM kor_loan_status
GROUP BY region -- �����Լ��� ������ �÷����� GROUP BY�� �ۼ��ؾ� �Ѵ�.
HAVING SUM(loan_jan_amt) >= 300000
ORDER BY ������ DESC;

-- ����, ����, �λ��� �⵵�� ���� �հ迡�� ������ ���� 60000�Ѵ� ����� ����Ͻÿ�.
-- ���� : ���� ��������, ������ ��������

SELECT SUBSTR(period,1, 4) as �⵵
    , region as ����
    , SUM(loan_jan_amt) as �����հ�
FROM kor_loan_status
WHERE region IN ('����', '����', '�λ�')
GROUP BY SUBSTR(period,1, 4), region
HAVING SUM(loan_jan_amt) >= 60000
ORDER BY ����, �����հ� DESC;

SELECT NVL(region, '�հ�')
    , SUM(loan_jan_amt) as �հ�
FROM kor_loan_status
GROUP BY ROLLUP(region);

-- �⵵�� ������ �հ�� �Ѱ�
SELECT SUBSTR(period,1, 4) as �⵵
    , SUM(loan_jan_amt) as ������
FROM kor_loan_status
GROUP BY ROLLUP(SUBSTR(period,1, 4));

-- employees �������� �Ի�⵵�� �������� ����Ͻÿ� (���� �Ի�⵵ ��������)
SELECT * FROM employees;
SELECT TO_CHAR(HIRE_DATE, 'YYYY') as �⵵
    , COUNT(*)
FROM employees
GROUP BY TO_CHAR(HIRE_DATE, 'YYYY')
ORDER BY 1;

-- employees �������� ������ڸ� Ȱ�� �Ի��� ���� ������ �������� ���
SELECT TO_CHAR(HIRE_DATE, 'day') as ����
    , COUNT(*)
FROM employees
GROUP BY TO_CHAR(HIRE_DATE, 'day'), TO_CHAR(HIRE_DATE, 'd') -- ���(SELECT)�� ���� �ʾƵ� ���Ŀ� ����ϱ� ���ؼ� �׷���̿� �߰�
ORDER BY TO_CHAR(HIRE_DATE, 'd');

-- customers ȸ���� ��ü ȸ����, ���� ȸ����, ���� ȸ������ ����Ͻÿ�
-- ����, ���ڶ�� �÷��� ����
-- customers ���̺��� �÷��� Ȱ���ؼ� ��������.
SELECT * FROM customers;
SELECT COUNT(DECODE(cust_gender, 'F', cust_gender)) as ����
    , COUNT(DECODE(cust_gender, 'M', cust_gender)) as ����
    , COUNT(cust_gender) as  ��ü
--    ,COUNT(DECODE(cust_gender, 'F', '����') as ����
--    ,COUNT(DECODE(cust_gender, 'F', '����') as ����
FROM customers;