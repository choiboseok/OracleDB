/*
    WITH�� (oracle 9 �̻� ����)
    ��Ī���� ����� SELECT ���� �ٸ� SELECT������ ������ ����.
    �ݺ��Ǵ� ������ �ִٸ� ȿ������.
    ��������� Ʃ���Ҷ� ���� ���.
    1. temp��� �ӽ� ���̺��� ����ؼ� ��ð� �ɸ��� ������ ����� ������ ���� ������ ���� �����͸� �׼����ϱ� ������ ������ ���� �� ����.
*/
-- ���� ����
-- ��ǰ�� ����
-- ���Ϻ� ���� ��� Ž���Ҷ� ����.

-- �μ��� ����
-- ��ü ���� ��ȸ
WITH A AS ( SELECT employee_id
                    , emp_name
                    , department_id
                    , job_id
                    , salary
            FROM employees
) , B AS ( SELECT department_id
                    , SUM(salary) dep_sum
                    , count(department_id) dep_cnt
            FROM a
            GROUP BY department_id
) , C AS( SELECT job_id
                    , SUM(salary) job_sum
                    , COUNT(job_id) job_cnt
            FROM a
            GROUP BY job_id
)
SELECT a.employee_id, a.emp_name, a.salary, b.dep_sum, b.dep_cnt, c.job_sum, c.job_cnt, ROUND(a.salary/b.dep_sum * 100, 2) dep_ratio 
FROM a, b, c
WHERE a.department_id = b.department_id
AND a.job_id = c.job_id;

-- kor_loan_status ���̺��� Ȱ���Ͽ� '������' ������(��������)' ����
-- ���� ������ ���帹�� ���ÿ� �ܾ����
-- 1. ������ ���� : 2011���� �������� 12������ 2013�� 11����. (������ ���� ū ���� ����)
-- 2. ������ �������� ������� �����ܾ��� ���� ū �ݾ��� ����. (1���� �����ؼ� �������� ���� ū �ܾ��� ����.)
-- 3. ����, ������ �����ܾװ� 2�� ����� ���� �ݾ��� ���� ���� ���

-- ������
SELECT MAX(period)
FROM kor_loan_status
GROUP BY substr(period, 1, 4); -- YYYY
-- ���������� �ܾ�
SELECT period, region, SUM(loan_jan_amt) jan_amt
FROM kor_loan_status
GROUP BY period, region;

-- ������ ���� �ܾ�max��
SELECT b.period
    , MAX(b.jan_amt) max_jan_amt
FROM(
    SELECT MAX(period) max_month
    FROM kor_loan_status
    GROUP BY substr(period, 1, 4)
    ) a
    , (    
    SELECT period, region, SUM(loan_jan_amt) jan_amt
    FROM kor_loan_status
    GROUP BY period, region
    ) b
WHERE a.max_month = b.period
GROUP BY b.period;

SELECT b2.*
FROM (
    SELECT period, region, SUM(loan_jan_amt) jan_amt
    FROM kor_loan_status
    GROUP BY period, region
    ) b2
    , (
    SELECT b.period
    , MAX(b.jan_amt) max_jan_amt
    FROM(
        SELECT MAX(period) max_month
        FROM kor_loan_status
        GROUP BY substr(period, 1, 4)
        ) a
        , (    
        SELECT period, region, SUM(loan_jan_amt) jan_amt
        FROM kor_loan_status
        GROUP BY period, region
        ) b
    WHERE a.max_month = b.period
    GROUP BY b.period
    ) c
WHERE b2.period = c.period
AND b2.jan_amt = c.max_jan_amt;

-- WITH
WITH b AS ( SELECT period, region, SUM(loan_jan_amt) jan_amt
            FROM kor_loan_status
            GROUP BY period, region
), c AS ( SELECT b.period, MAX(b.jan_amt) max_jan_amt
          FROM b,
            ( SELECT MAX(period) as max_month
              FROM kor_loan_status
              GROUP BY substr(period, 1, 4)) a
          WHERE b.period = a.max_month
          GROUP BY b.period
)
SELECT b.*
FROM b, c
WHERE b.period = c.period
AND b.jan_amt = c.max_jan_amt;

-- dP
WITH a AS ( SELECT '�ѱ�' as texts FROM dual
            UNION
            SELECT '�ѱ�ABC' as texts FROM dual
            UNION
            SELECT 'ABC' as texts FROM dual
)
SELECT *
FROM a
WHERE REGEXP_LIKE(texts, '^[��-��]+$');

/*
    �м��Լ�
    ���̺� �ִ� �ο쿡 ���� Ư�� �׷캰�� ���� ���� ������ �� ���
    ���� �Լ��� �ٸ����� �ο� �ս� ���� ���谪�� ���� �� �� ����.
    �м��Լ��� �ڿ��� ���� �Һ��ϱ� ������ 
    ���� �м��Լ��� ���ÿ� ����� ���(partition, order �����ϰ� �ϸ� ����)
    �ִ��� ������������ ���, �������������� ���X
    
    �м��Լ�(�Ű�����) OVER(PARTITION by expr1.. ORDER BY expr2.. WINDOW��..)
    ���� : AVG, SUM, MAX, COUNT, DENSE_RANK, RANK, ROW_NUMBER, PERCENT_RANK, LAG, LEAD..
    PARTITON BY : ��� ��� �׷�
    ORDER BY : ��� �׷쿡 ���� ����
    WINDOW : ��Ƽ������ ���ҵ� �׷쿡 ���� �� ���� �׷����� ����(��, ��)
*/
-- �������� �μ��� salary ���� ���� ���� ���.
SELECT emp_name, department_id, salary
    , RANK() OVER(PARTITION BY department_id ORDER BY salary DESC) rnk -- ������ ���� ������� 1,2,2,4
    , DENSE_RANK() OVER(PARTITION BY department_id ORDER BY salary DESC) dense_rnk -- ������ ���� ������� 1,2,2,3
    , ROW_NUMBER() OVER(PARTITION BY department_id ORDER BY salary DESC) row_num -- rownum ����
FROM employees;

SELECT department_id
    , emp_name
    , salary
    , SUM(salary) OVER(PARTITION BY department_id) �μ��հ�
    , ROUND(AVG(salary) OVER(PARTITION BY department_id), 2) �μ����
    , MIN(salary) OVER(PARTITION BY department_id) �μ��ּ�
    , MAX(salary) OVER(PARTITION BY department_id) �μ��ִ�
    , COUNT(employee_id) OVER() ������
FROM employees;

-- �μ��� salary ���������������� ��ŷ 1���� ����Ͻÿ�
SELECT *
FROM (
    SELECT department_id
        , emp_name
        , salary
        , RANK() OVER(PARTITION BY department_id ORDER BY salary DESC) dep_rank
    FROM employees
    )
WHERE dep_rank = 1;

-- ȸ���� ������ ���ϸ��� ������ ����Ͻÿ�.
SELECT mem_name, mem_job, mem_mileage
    , RANK() OVER(PARTITION BY mem_job ORDER BY mem_mileage DESC) rank
FROM member;

-- LAG ����ο��� ���� �����ͼ� ��ȯ
-- LEAD ����ο��� ���� �����ͼ� ��ȯ
SELECT mem_name, mem_job, mem_mileage
    -- (mem_name�� ���, 1�� ����, ������� ���)
    , LAG(mem_name, 1, '�������') OVER(PARTITION BY mem_job ORDER BY mem_mileage DESC) lags
    , LEAD(mem_name, 1, '���峷��') OVER(PARTITION BY mem_job ORDER BY mem_mileage DESC) leads
FROM member;

-- �л����� ������ �� �л��� ������ �Ѵܰ� ���� �л����� ���� ���̸� ����Ͻÿ�.
SELECT �̸�, ����, ����
    , NVL(LAG(����, 1) OVER(PARTITION BY ���� ORDER BY ���� DESC) - LAG(����, 0) OVER(PARTITION BY ���� ORDER BY ���� DESC), 0) ���� -- LAG(����, 1, ����) OVER(PARTITION BY ���� ORDER BY ���� DESC) - ����
    , LAG(�̸�, 1, '1��') OVER(PARTITION BY ���� ORDER BY ���� DESC) ����̸�
FROM �л�;

-- CART, PROD�� Ȱ���Ͽ� ��ǰ�� �Ǹ� PROD_PRICE �հ� ������ ����Ͻÿ� (���� ���� �ǳʶ� RANK)
SELECT * FROM cart;
SELECT * FROM prod;

SELECT prod_id, prod_name, sum_sale
    , RANK() OVER(ORDER BY sum_sale DESC) rank_sale
FROM(
    SELECT a.prod_id, a.prod_name
        , SUM(cart_qty)*prod_price sum_sale
    FROM prod a, cart b
    WHERE a.prod_id = b.cart_prod
    GROUP BY a.prod_id, a.prod_name, prod_price
);

SELECT a.prod_id, a.prod_name
    , SUM(cart_qty)*prod_price sum_sale
    , RANK() OVER(ORDER BY SUM(cart_qty*prod_price) DESC) as rnk
FROM prod a, cart b
WHERE a.prod_id = b.cart_prod
GROUP BY a.prod_id, a.prod_name, prod_price;