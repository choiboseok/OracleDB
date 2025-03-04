-- 1
SELECT *
FROM (
    SELECT * 
    FROM customer
    WHERE JOB IN ('�ڿ���', '�ǻ�')
    ORDER BY birth DESC
    )
WHERE ROWNUM <10;

-- 2
SELECT customer_name, phone_number
FROM customer
WHERE zip_code = 135100;

-- 3

SELECT job, COUNT(job) as cnt
FROM customer
GROUP BY job
HAVING job IS NOT NULL
ORDER BY 2 DESC;

-- 4-1
SELECT ����, �Ǽ�
FROM (
    SELECT ����, SUM(�Ǽ�) as �Ǽ�
    FROM (
        SELECT TO_CHAR(first_reg_date, 'day') as ����
            , COUNT(TO_CHAR(first_reg_date, 'day')) as �Ǽ�
        FROM customer
        GROUP BY first_reg_date
        )
    GROUP BY ����
    )
WHERE ROWNUM <=1;

-- 4-2
SELECT NVL(gender, '�հ�') gender, SUM(CNT) cnt
FROM ( 
    SELECT CASE WHEN sex_code='M' THEN '����'
                WHEN sex_code='F' THEN '����'
                WHEN sex_code IS NULL THEN '�̵��'
            END AS gender
        , COUNT(*) CNT
    FROM customer
    GROUP BY sex_code
    )
GROUP BY ROLLUP(gender);

-- 5
SELECT ��, SUM(��ҰǼ�)
FROM (
    SELECT TO_CHAR(TO_DATE(reserv_date, 'yyyymmdd'), 'mm') ��
        , COUNT(cancel) ��ҰǼ�
    FROM reservation
    WHERE cancel='Y'
    GROUP BY reserv_date
    )
GROUP BY ��
ORDER BY 2 DESC, 1;