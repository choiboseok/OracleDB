/*
    
*/
SELECT department_id
    , LPAD(' ', 3*(LEVEL-1)) || department_name as �μ���
    -- ����-���μ� Ʈ�� ������ � �ܰ迡 �ִ��� ��Ÿ���� ������
    , LEVEL
    , parent_id
FROM departments
START WITH parent_id IS NULL                    -- �ش� ���� �ο���� ����
CONNECT BY PRIOR department_id = parent_id;     -- ���� ������ � ������ ����Ǵ��� 
                                                -- ���� �μ����� parent_id�� ã���� 

-- �����ڿ� ����
SELECT * FROM employees;
SELECT a.employee_id
    , a.manager_id
    , LPAD(' ', 3*(LEVEL-1)) || a. emp_name emp_nm
    , b.department_name
    , LEVEL
FROM employees a, departments b
WHERE a.department_id = b.department_id 
START WITH a.manager_id IS NULL
CONNECT BY PRIOR a.employee_id = a.manager_id; -- ������ ������ ���ǿ� ��ġ�� ���� ����� �޶���.(START WITH ��, CONNECT BY �Ʒ�)
/*
    1. ������ ������ ���� ���� ó��
    2. START WITH ���� ������ �ֻ��� ���� �ο츦 ����
    3. CONNECT BY ���� ��õ� ������ ���� ������ ���� LEVEL ����
    4. �ڽ� �ο� ã�Ⱑ ������ ���� ������ ������ �˻� ���ǿ� �����ϴ� �ο츦 �ɷ���.
*/

-- ������ ������ ���������� ������ ������ Ʈ���� ����.
-- SIBLINGS�� �־������.
SELECT department_id
    , LPAD(' ', 3*(LEVEL-1)) || department_name as �μ���
    , LEVEL
    , parent_id
FROM departments
START WITH parent_id IS NULL
CONNECT BY PRIOR department_id = parent_id
ORDER SIBLINGS BY department_name;

-- ������ �������� ����� �� �ִ� �Լ�
SELECT department_id
    , LPAD(' ', 3*(LEVEL-1)) || department_name as �μ���
    -- ��Ʈ ��忡�� ������ current row���� ���� ��ȯ
    , SYS_CONNECT_BY_PATH(department_name, '|') �μ���
    -- ������ ��� 1, �ڽ��� ������ 0
    , CONNECT_BY_ISLEAF 
    , CONNECT_BY_ROOT department_name as root_nm -- �ֻ���(ROOT�� ��)
FROM departments
START WITH parent_id IS NULL
CONNECT BY PRIOR department_id = parent_id;

-- �ű� �μ��� ������ϴ�.
-- IT �ؿ� 'SNS��'
-- IT ���� ����ũ �μ� �ؿ� '��ۺδ�'
-- �˸°� �����͸� �������ּ���
INSERT INTO departments(department_id, department_name, parent_id, manager_id) VALUES(280, 'SNS��', 60, '');
INSERT INTO departments(department_id, department_name, parent_id, manager_id) VALUES(290, '��ۺδ�', 230, '');

SELECT department_id
    , LPAD(' ', 3*(LEVEL-1)) || department_name as �μ���
    , LEVEL
FROM departments
START WITH parent_id IS NULL
CONNECT BY PRIOR department_id = parent_id;

CREATE TABLE ��(
    ���̵� NUMBER
    , �̸� VARCHAR2(100)
    , ��å VARCHAR2(100)
    , �������̵� NUMBER
);
-- ������ ���� ��µǵ��� �����͸� ���� �� ������ ������ �ۼ��Ͻÿ�
SELECT * FROM ��;
INSERT INTO ��(���̵�, �̸�, ��å, �������̵�) VALUES(1, '�̻���', '����', '');
INSERT INTO ��(���̵�, �̸�, ��å, �������̵�) VALUES(2, '�����', '����', 1);
INSERT INTO ��(���̵�, �̸�, ��å, �������̵�) VALUES(3, '������', '����', 2);
INSERT INTO ��(���̵�, �̸�, ��å, �������̵�) VALUES(4, '�����', '����', 3);
INSERT INTO ��(���̵�, �̸�, ��å, �������̵�) VALUES(5, '�ڰ���', '����', 3);
INSERT INTO ��(���̵�, �̸�, ��å, �������̵�) VALUES(6, '�̴븮', '�븮', 4);
INSERT INTO ��(���̵�, �̸�, ��å, �������̵�) VALUES(7, '��븮', '�븮', 5);
INSERT INTO ��(���̵�, �̸�, ��å, �������̵�) VALUES(8, '�ֻ��', '���', 6);
INSERT INTO ��(���̵�, �̸�, ��å, �������̵�) VALUES(9, '�����', '���', 6);
INSERT INTO ��(���̵�, �̸�, ��å, �������̵�) VALUES(10, '�ֻ��', '���', 7);
UPDATE �� SET ���̵� = 10 WHERE �̸� = '�ֻ��';

SELECT �̸�
    , ���̵�
    , LPAD(' ', 3*(LEVEL-1)) || ��å as ��å
    , LEVEL
FROM ��
START WITH �������̵� IS NULL
CONNECT BY PRIOR ���̵� = �������̵�;

-- (top-down) �θ𿡼� �ڽ����� Ʈ������(������)
SELECT department_id
    , LPAD(' ', 3*(LEVEL-1)) || department_name as �μ���
    , LEVEL
FROM departments
START WITH parent_id IS NULL
CONNECT BY PRIOR department_id = parent_id;

-- (bottom-up) �ڽĿ��� �θ�� (������)
SELECT department_id
    , parent_id
    , LPAD(' ', 3*(LEVEL-1)) || department_name as �μ���
    , LEVEL
FROM departments
START WITH department_id = 280
CONNECT BY PRIOR parent_id = department_id;

-- ���������� ���� CONNECT BY ���� LEVEl ��� (���� �����Ͱ� �ʿ��Ҷ�)
SELECT LEVEL
FROM dual
CONNECT BY LEVEL <= 12;

-- 1 ~ 12�� ���
SELECT TO_CHAR(sysdate, 'YYYY') || LPAD(LEVEL, 2, '0') yy
from dual
CONNECT BY LEVEL <= 12;

 -- a
SELECT '2013' || LPAD(LEVEL, 2, '0') yy
from dual
CONNECT BY LEVEL <= 12;

-- b
SELECT period
    , SUM(loan_jan_amt) �հ�
FROM kor_loan_status
WHERE period LIKE '2013%'
GROUP BY period
ORDER BY 1;
/* 
SELECT a.yy, b.�հ�
FROM () a
    , () b
WHERE a.yy = b.yy
*/
SELECT a.yy, 
    NVL(b.�հ�, 0) �հ�
FROM (SELECT '2013' || LPAD(LEVEL, 2, '0') yy
        from dual
        CONNECT BY LEVEL <= 12) a
    , (SELECT period yy
        , SUM(loan_jan_amt) �հ�
        FROM kor_loan_status
        WHERE period LIKE '2013%'
        GROUP BY period
        ORDER BY 1) b
WHERE a.yy = b.yy(+)
ORDER BY 1;

-- �������� ���ڸ� ���Ͽ� �ش� �� ��ŭ ����
SELECT TO_DATE(TO_CHAR(sysdate, 'yyyymm') || LPAD(LEVEL, 2, '0')) dates
from dual
CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(sysdate), 'dd');

-- study ����
-- reservation ���̺��� reserv_date, cancel �÷��� Ȱ���Ͽ� 
-- '��õ'���� ��� ���Ϻ� ����Ǽ��� ����Ͻÿ�(��Ұ� ����)
SELECT * FROM reservation;

SELECT LPAD(LEVEL, 1)
FROM dual
CONNECT BY LEVEL <= 7;

SELECT TO_CHAR(TO_DATE(reserv_date), 'day') ����
    , branch
    , cancel
FROM reservation
WHERE branch = '��õ';

SELECT *
FROM (
    SELECT LPAD(LEVEL, 1) ����
    FROM dual
    CONNECT BY LEVEL <= 7) a,
    (SELECT TO_CHAR(TO_DATE(reserv_date), 'day') ����
    , branch
    , cancel
    FROM reservation
    WHERE branch = '��õ') b
WHERE a.���� = b.����(+);