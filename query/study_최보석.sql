-- 1
SELECT *
FROM (
    SELECT * 
    FROM customer
    WHERE JOB IN ('자영업', '의사')
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
SELECT 요일, 건수
FROM (
    SELECT 요일, SUM(건수) as 건수
    FROM (
        SELECT TO_CHAR(first_reg_date, 'day') as 요일
            , COUNT(TO_CHAR(first_reg_date, 'day')) as 건수
        FROM customer
        GROUP BY first_reg_date
        )
    GROUP BY 요일
    )
WHERE ROWNUM <=1;

-- 4-2
SELECT NVL(gender, '합계') gender, SUM(CNT) cnt
FROM ( 
    SELECT CASE WHEN sex_code='M' THEN '남자'
                WHEN sex_code='F' THEN '여자'
                WHEN sex_code IS NULL THEN '미등록'
            END AS gender
        , COUNT(*) CNT
    FROM customer
    GROUP BY sex_code
    )
GROUP BY ROLLUP(gender);

-- 5
SELECT 월, SUM(취소건수)
FROM (
    SELECT TO_CHAR(TO_DATE(reserv_date, 'yyyymmdd'), 'mm') 월
        , COUNT(cancel) 취소건수
    FROM reservation
    WHERE cancel='Y'
    GROUP BY reserv_date
    )
GROUP BY 월
ORDER BY 2 DESC, 1;