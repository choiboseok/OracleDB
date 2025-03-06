/*
    WITH절 (oracle 9 이상 지원)
    별칭으로 사용한 SELECT 문을 다른 SELECT문에서 참조가 가능.
    반복되는 쿼리가 있다면 효과적임.
    통계쿼리나 튜닝할때 많이 사용.
    1. temp라는 임시 테이블을 사용해서 장시간 걸리는 쿼리의 결과를 저장해 놓고 저장해 놓은 데이터를 액세스하기 때문에 성능이 좋을 수 있음.
*/
-- 고객별 매출
-- 상품별 매출
-- 요일별 매출 등등 탐색할때 좋음.

-- 부서별 비중
-- 전체 비중 조회
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

-- kor_loan_status 테이블을 활용하여 '연도별' 최종월(마지막월)' 기준
-- 가장 대출이 가장많은 도시와 잔액출력
-- 1. 연도별 최종 : 2011년의 최종월은 12월지만 2013은 11월임. (연도별 가장 큰 월을 구함)
-- 2. 연도별 최종월을 대상으로 대출잔액이 가장 큰 금액을 구함. (1번과 조인해서 연도별로 가장 큰 잔액을 구함.)
-- 3. 월별, 지역별 대출잔액과 2의 결과를 비교해 금액이 같은 건을 출력

-- 최종월
SELECT MAX(period)
FROM kor_loan_status
GROUP BY substr(period, 1, 4); -- YYYY
-- 월별지역별 잔액
SELECT period, region, SUM(loan_jan_amt) jan_amt
FROM kor_loan_status
GROUP BY period, region;

-- 최종월 대출 잔액max값
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
WITH a AS ( SELECT '한글' as texts FROM dual
            UNION
            SELECT '한글ABC' as texts FROM dual
            UNION
            SELECT 'ABC' as texts FROM dual
)
SELECT *
FROM a
WHERE REGEXP_LIKE(texts, '^[가-힝]+$');

/*
    분석함수
    테이블에 있는 로우에 대해 특정 그룹별로 집계 값을 산출할 때 사용
    집계 함수와 다른점은 로우 손실 없이 집계값을 산출 할 수 있음.
    분석함수는 자원을 많이 소비하기 때문에 
    여러 분석함수를 동시에 사용할 경우(partition, order 동일하게 하면 빠름)
    최대한 메인쿼리에서 사용, 서브쿼리에서는 사용X
    
    분석함수(매개변수) OVER(PARTITION by expr1.. ORDER BY expr2.. WINDOW절..)
    종류 : AVG, SUM, MAX, COUNT, DENSE_RANK, RANK, ROW_NUMBER, PERCENT_RANK, LAG, LEAD..
    PARTITON BY : 계산 대상 그룹
    ORDER BY : 대상 그룹에 대한 정렬
    WINDOW : 파티션으로 분할된 그룹에 대해 더 상세한 그룹으로 분할(논리, 행)
*/
-- 직원들의 부서별 salary 기준 높은 순위 출력.
SELECT emp_name, department_id, salary
    , RANK() OVER(PARTITION BY department_id ORDER BY salary DESC) rnk -- 동일한 값이 있을경우 1,2,2,4
    , DENSE_RANK() OVER(PARTITION BY department_id ORDER BY salary DESC) dense_rnk -- 동일한 값이 있을경우 1,2,2,3
    , ROW_NUMBER() OVER(PARTITION BY department_id ORDER BY salary DESC) row_num -- rownum 생성
FROM employees;

SELECT department_id
    , emp_name
    , salary
    , SUM(salary) OVER(PARTITION BY department_id) 부서합계
    , ROUND(AVG(salary) OVER(PARTITION BY department_id), 2) 부서평균
    , MIN(salary) OVER(PARTITION BY department_id) 부서최소
    , MAX(salary) OVER(PARTITION BY department_id) 부서최대
    , COUNT(employee_id) OVER() 직원수
FROM employees;

-- 부서별 salary 내림차순기준으로 랭킹 1위만 출력하시오
SELECT *
FROM (
    SELECT department_id
        , emp_name
        , salary
        , RANK() OVER(PARTITION BY department_id ORDER BY salary DESC) dep_rank
    FROM employees
    )
WHERE dep_rank = 1;

-- 회원의 직업별 마일리지 순위를 출력하시오.
SELECT mem_name, mem_job, mem_mileage
    , RANK() OVER(PARTITION BY mem_job ORDER BY mem_mileage DESC) rank
FROM member;

-- LAG 선행로우의 값을 가져와서 반환
-- LEAD 후행로우의 값을 가져와서 반환
SELECT mem_name, mem_job, mem_mileage
    -- (mem_name을 출력, 1행 높은, 없을경우 출력)
    , LAG(mem_name, 1, '가장높음') OVER(PARTITION BY mem_job ORDER BY mem_mileage DESC) lags
    , LEAD(mem_name, 1, '가장낮음') OVER(PARTITION BY mem_job ORDER BY mem_mileage DESC) leads
FROM member;

-- 학생들의 전공별 각 학생의 평점이 한단계 높은 학생과의 평점 차이를 출력하시오.
SELECT 이름, 전공, 평점
    , NVL(LAG(평점, 1) OVER(PARTITION BY 전공 ORDER BY 평점 DESC) - LAG(평점, 0) OVER(PARTITION BY 전공 ORDER BY 평점 DESC), 0) 차이 -- LAG(평점, 1, 평점) OVER(PARTITION BY 전공 ORDER BY 평점 DESC) - 평점
    , LAG(이름, 1, '1등') OVER(PARTITION BY 전공 ORDER BY 평점 DESC) 대상이름
FROM 학생;

-- CART, PROD를 활용하여 물품별 판매 PROD_PRICE 합계 순위를 출력하시오 (동일 순위 건너뜀 RANK)
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