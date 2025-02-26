/*
    ������ ���۾� DML
    ���̺� ������ �˻�, ����, ����, ������ ���
    SELECT, UPDATE, INSERT, DELETE, MERGE
*/
-- �� ������ >, <, >=, <=, =, <>, !=, ^=
SELECT * FROM employees WHERE salary = 2600;
SELECT * FROM employees WHERE salary <> 2600;
SELECT * FROM employees WHERE salary != 2600;
SELECT * FROM employees WHERE salary ^= 2600;
SELECT * FROM employees WHERE salary < 2600;
SELECT * FROM employees WHERE salary > 2600;
SELECT * FROM employees WHERE salary <= 2600;
SELECT * FROM employees WHERE salary >= 2600;

-- �� �����ڸ� ����Ͽ� PRODUCTS ���̺��� 
-- ��ǰ �����ݾ�(prod_min_price) �� 30 '�̻�' 50 '�̸�'�� '��ǰ��'�� ��ȸ�Ͻÿ�
SELECT * FROM products ;

--SELECT prod_name, prod_min_price FROM products WHERE prod_min_price >= 30 AND prod_min_price <=50 ORDER BY prod_min_price, prod_name;

-- ���� ī�װ��� 'CD-ROM'
SELECT prod_name, prod_min_price FROM products WHERE prod_min_price >= 30 AND prod_min_price <=50 AND prod_subcategory = 'CD-ROM' 
ORDER BY prod_min_price, prod_name;

-- ���� �� 10, 20�� �μ��� ������ ��ȸ�Ͻÿ� (�̸�, �μ���ȣ, ����)
SELECT emp_name, department_id, salary FROM employees WHERE department_id=10 OR department_id=20;

-- ǥ���� CASE ��
-- table�� ���� Ư�� ���ǿ� ���� �ٸ��� ǥ���ϰ� ������ ���
-- salary�� 5000 ���� C���, 5000�ʰ� 15000���� B���, 15000�ʰ� A���

SELECT emp_name, salary 
    ,CASE WHEN salary<=5000 THEN 'C���' 
          WHEN salary >5000 AND salary <=15000 THEN 'B���'
          ELSE 'A���'
    END AS salary_grade
FROM employees
ORDER BY salary DESC;

-- �� ���ǽ� AND OR NOT
SELECT emp_name, salary FROM employees WHERE NOT(salary >= 2500);

-- IN ����(or�� ������)
SELECT * FROM employees WHERE department_id IN (10, 20, 30, 40);
SELECT * FROM employees WHERE department_id NOT IN (10, 20, 30, 40);

-- BETWEEN a AND b ���ǽ�
SELECT emp_name, salary FROM employees WHERE salary BETWEEN 2000 AND 2500;

-- LIKE ���ǽ�
SELECT emp_name FROM employees WHERE emp_name LIKE 'A%';
SELECT emp_name FROM employees WHERE emp_name LIKE '%a';
SELECT emp_name FROM employees WHERE emp_name LIKE '%a%';

CREATE TABLE ex2_1(
    nm VARCHAR2(30)
);

INSERT INTO ex2_1 VALUES('���ؼ�');
INSERT INTO ex2_1 VALUES('�ؼ�');
INSERT INTO ex2_1 VALUES('�ؼ���');
INSERT INTO ex2_1 VALUES('�����ؼ�');
SELECT * FROM ex2_1 WHERE nm LIKE '�ؼ�_';

-- member ���̺� ȸ�� ��  �达 ����(���̵�, �̸�, ���ϸ���, ����)�� ��ȸ�Ͻÿ�
SELECT * FROM member;
SELECT mem_id, mem_name, mem_mileage, mem_bir FROM member WHERE mem_name LIKE '��%';

-- member ȸ���� ������ ��ȸ�ϼ���
-- �� mem_mileage 6000 �̻� vip, 6000�̸� 3000�̻� gold, �׹ۿ� silver
SELECT mem_id, mem_name, mem_job, mem_mileage 
        ,CASE WHEN mem_mileage >= 6000 THEN 'VIP'
              WHEN mem_mileage < 6000 AND mem_mileage >= 3000 THEN 'GOLD'
              ELSE 'SILVER'
        END AS grade
        , mem_add1 ||' '|| mem_add2 AS ADDR
FROM member
ORDER BY mem_mileage DESC; -- ���ڷε� ���İ���(SELECT ���� �ִ� ������� �ϸ� ��)

-- null ��ȸ�� IS NULL or IS NOT NULL 
SELECT * FROM prod WHERE prod_size IS NULL;

-- ���� �Լ�
-- ����
SELECT ABS(10), ABS(-10) FROM dual;  -- dual ->�ӽ� ���̺�� ����(sql ��� ������ from �ڿ��� table�� �����ؾ��ؼ� ���)

-- CEIL �ø�, FLOOR ����, ROUND �ݿø�
SELECT CEIL(10.01), FLOOR(10.01), ROUND(10.01) FROM dual;

-- ROUND(n, i) �Ű����� n�� �Ҽ��� ���� i+1 ��°���� �ݿø��� ����� ��ȯ
-- i�� ����Ʈ0, i�� ������ �Ҽ����� �������� ���� i�������� �ݿø�
SELECT ROUND(10.154, 1), ROUND(10.154, 2), ROUND(19.154, -1) FROM dual;

-- MOD(m, n) m�� n���� ���������� ������ ��ȯ
SELECT MOD(4, 2), MOD(5, 2) FROM dual;

-- SQRT n�� ������ ��ȯ
SELECT SQRT(4), SQRT(8), ROUND(SQRT(8), 2) FROM dual;

-- ���� �Լ�
-- ��, �ҹ��� ����
SELECT LOWER('HI'), UPPER('hi') FROM dual; 

-- �̸��� smith�� �ִ� ���� ��ȸ
SELECT emp_name FROM employees WHERE LOWER(emp_name) LIKE '%' || LOWER('smith') || '%';
-- SELECT emp_name FROM employees WHERE LOWER(emp_name) LIKE '%' || LOWER(:nm) || '%'; :nm -> ���� ������ ����ó�� ����Ͽ� �Է��Ͽ� ����� �� ����.


-- SUBSTR(char, pos, len) char�� pos ��° ���ں��� len ���̸�ŭ �ڸ��� ��ȯ
-- len�� ������ pos ������ 
-- pos�� ������ �ڿ��� ����
SELECT SUBSTR('ABCDEFG', 1, 4), SUBSTR('ABCDEFG', -4, 3), SUBSTR('ABCDEFG', -4, 1), SUBSTR('ABCDEFG', 5) FROM dual;

-- ȸ���� ������ ����Ͻÿ�
-- �̸�, ����(�ֹι�ȣ ���ڸ� ù° �ڸ� Ȧ��(����), ¦��(����))
SELECT mem_name, 
    CASE WHEN MOD(SUBSTR(mem_regno2, 1, 1), 2) = 1 THEN '����'
         ELSE '����'
    END AS gender
    ,mem_regno2
FROM member;
