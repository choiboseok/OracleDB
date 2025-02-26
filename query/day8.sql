/*
    �������� SQL���� �ȿ� ������ ���Ǵ� �� �ٸ� SELECT��
    ���� ������ �������� ���� 
    1. ���������� ��������, �ִ� ��������
    or ���¿� ����
    1. ��Į�� �������� SELECT��
    2. �ζ��κ� FROM��
    3. ��ø ���� WHERE��
*/
-- 1. ��Į�� �������� (���� �÷�, �������� ��ȯ), �������̺� row�� ��ŭ �����
SELECT a.emp_name
    , a.employee_id
    , a.department_id
    , (SELECT department_name FROM departments WHERE department_id = a.department_id) as dep_name
    , (SELECT job_title FROM jobs WHERE job_id = a.job_id) as job_name
FROM employees a;

-- �л�
SELECT a.�й�, a.�̸�, a.����, b.����������ȣ
    , (SELECT �����̸� FROM ���� WHERE �����ȣ = b.�����ȣ) as �����̸�
    , b.�������
FROM �л� a, �������� b -- ���̺� ��Ī ( ���̺� �̸��� �� ��� ��Ī ���)
WHERE a.�й� = b.�й�;

-- 2. �ζ��� ��(FROM ��) select ����� �ϳ��� ���̺� ó�� ���
-- ROWNUM ���̺��� ������ �ִ°�ó�� ��밡���� �÷�
SELECT *
FROM (
    SELECT ROWNUM 
        , a.*
    FROM ���� a
    )
WHERE ROWNUM BETWEEN 1 AND 10; --ROWNUM�� �ζ��� ��� ���̺� �ִ� �÷� ó�� ���

-- ������ ������ ROWNUM ������ �ٲ�.
SELECT ROWNUM 
        , a.*
FROM ���� a
ORDER BY 3;

SELECT * 
FROM (
    SELECT ROWNUM, a.* -- ROWNUM�� ������ ����ǰ��Ŀ� ������ �Űܾ� �ؼ� �ζ��κ� �ȿ� �ۼ�
    FROM (
        SELECT *
        FROM ���� 
        -- WHERE �˻�����
        ORDER BY �����̸�
        ) a
    )
WHERE ROWNUM BETWEEN 1 AND 10;

-- ����(īƮ���Ƚ��)�� �������� ������ ���� �� 2~5���� ��ȸ�Ͻÿ�
SELECT *
FROM (
    SELECT ROWNUM as rnum -- alias �ʼ�
        , t1.*  
    FROM (
        SELECT a.mem_id as ���̵�, a.mem_name as �̸� 
            , COUNT(DISTINCT b.cart_no) as īƮ���Ƚ��
            , COUNT(DISTINCT b.cart_prod) as ��ǰǰ���
            , NVL(SUM(b.cart_qty), 0) as ��ǰ���ż�
            , NVL(SUM(b.cart_qty*c.prod_price), 0) as �ѱ��űݾ�
        FROM  member a, cart b, prod c
        WHERE a.mem_id = b.cart_member(+)
        AND b.cart_prod = c.prod_id(+)
        GROUP BY a.mem_id, a.mem_name
        ORDER BY 3 DESC
        ) t1
    )
WHERE rnum BETWEEN 2 AND 5;

-- 3. ��ø����(���������� �������� ���� Ư�� ���� �ʿ��Ҷ� ���)
-- ��ü ������ ��� �޿� �̻��� ���� ��ȸ
SELECT AVG(salary)
FROM employees;
--6461.831775700934579439252336448598130841
SELECT emp_name, salary
FROM employees
WHERE salary >= AVG(salary);

SELECT emp_name, salary
FROM employees
WHERE salary >= (SELECT AVG(salary) --�ܼ� ���� �ʿ��� ��Ȳ
                FROM employees);
                
-- job_history �̷��� �ִ� ������ ��ȸ�Ͻÿ�
SELECT *
FROM employees
WHERE employee_id IN (SELECT employee_id 
                        FROM job_history);
-- ���ÿ� 2�� �̻� �÷� ���� ���� �� ��ȸ����
SELECT employee_id, emp_name, job_id
FROM employees
WHERE (employee_id, job_id) IN (SELECT employee_id, job_id 
                                FROM job_history);
-- salary ���� ����
SELECT emp_name, salary
FROM employees
WHERE salary = (SELECT MAX(salary)
                FROM employees);
                
-- �����̷��� ���� �л� ��ȸ
SELECT *
FROM �л�
WHERE �й� NOT IN(SELECT �й� FROM ��������);

-- ��������(���ι����� ������ ����)
SELECT *
FROM �л� a
-- EXISTS �����ϴ��� üũ ���������� ������ true�� �ุ ���� ���̺��� ��ȸ
WHERE EXISTS (SELECT * FROM �������� WHERE �й� = a.�й�); -- SELECT ���� ���� * �ǹ� ���� ���� �������Ǹ� üũ

-- job_history ���̺� �����ϴ� ���� ����(�̸�, �μ�)�� ����Ͻÿ�
SELECT emp_name
    , (SELECT department_name
                FROM departments
                WHERE department_id = a.department_id) as dep_name
FROM employees a
WHERE EXISTS (SELECT * 
                FROM job_history 
                WHERE employee_id = a.employee_id );
                
-------------------------------------------------------------------------
-- ROLLUP : �κ� ���踦 �����Ͽ� ���� �հ踦 ����
SELECT department_id, job_id, SUM(salary) as tot
FROM employees
WHERE department_id IS NOT NULL
GROUP BY ROLLUP(department_id, job_id); -- N + 1 ���� ����
-- department_id, job_id -> �μ���, ������ �հ�
-- department_id, null   -> �μ��� ����
-- null null             -> ��ü �հ�

-- CUBE : ��� ������ ������ ������.(ROLLUP ���� �پ��� ����)
SELECT department_id, job_id, SUM(salary) as tot
FROM employees
WHERE department_id IS NOT NULL
GROUP BY CUBE(department_id, job_id);
-- department_id, job_id �հ�
-- department_id, null   �μ��� �հ�
-- null , job_id         ������ �հ�
-- null, null            ��ü �հ�

-- GROUPING SETS
-- ���� ���� �׷�ȭ ������ ���������� �����Ͽ� ����� ��ȯ
-- ��, ���� ���� GROUP BY ������ ������ �Ͱ� ���� ȿ��
SELECT department_id, job_id, SUM(salary) as tot
FROM employees
WHERE department_id IS NOT NULL
GROUP BY GROUPING SETS((department_id), (job_id));
-- department_id -> �μ��� ����
-- job_id ->        ������ ����
-- () ->            ��ü

-- GROUPING_ID : �� ���� � ������ �׷�ȭ���� Ȯ���Ҷ� ���
SELECT department_id, job_id, SUM(salary) as tot
    , GROUPING(department_id) as dep_gid
    , GROUPING(job_id) as job_gid
    , GROUPING_ID(department_id, job_id) as gr_id
FROM employees
WHERE department_id IS NOT NULL
GROUP BY CUBE(department_id, job_id);
-- GROUPING(department_id) 0�̸� �μ��� ����, 1�̸� �μ��� null(����)
-- GROUPING(job_id) 0�̸� ������ ����, 1�̸� ������ null (��������)
-- GROUPING_ID(department_id, job_id) GROUPING()���� �������� ��ȯ�� ��
-- 0 0 -> 0 (���α׷�)
-- 0 1 -> 1 (�μ�����)
-- 1 0 -> 2 (��������)
-- 1 1 -> 3 (��ü����)

SELECT department_id
    , DECODE(gr_id, 1, '�Ұ�', 3, '�Ѱ�', job_id) as job_id, tot
FROM (
    SELECT department_id, job_id, SUM(salary) as tot
        , GROUPING(department_id) as dep_gid
        , GROUPING(job_id) as job_gid
        , GROUPING_ID(department_id, job_id) as gr_id
    FROM employees
    WHERE department_id IS NOT NULL
    GROUP BY ROLLUP(department_id, job_id)
    );
    
-- �л����� ������ ������ ���� ���� �л��� ������ ����Ͻÿ�.
SELECT * FROM �л�;

SELECT *
FROM �л�
WHERE (����, ����) IN (SELECT ����, MAX(����)
                FROM �л�
                GROUP BY ����
                );
                
SELECT MAX(����)
FROM �л�
GROUP BY ����
ORDER BY ����;