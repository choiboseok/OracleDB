-- 17002 lsnrctl status 오라클 서버 작동중인걸 확인하는 명령어 (상태확인)
-- 꺼져있을시 lsnrctl start (실행)
/*
    집계함수와 그룹바이
    집계함수 대상 데이터에 대해 총합, 평균, 최댓값, 최솟값 등을 구하는 함수
*/
SELECT COUNT(*)                   -- null 포함
    , COUNT(department_id)          -- default all
    , COUNT(ALL department_id)      -- 중복 o, null x
    , COUNT(DISTINCT department_id) -- 중복 x, null x
    , COUNT(employee_id)
FROM employees; 

SELECT SUM(salary) as 합계
    , MAX(salary) as 최대
    , MIN(salary) as 최소
    , ROUND(AVG(salary), 2) as 평균
FROM employees;

SELECT department_id
    , SUM(salary) as 합계
    , MAX(salary) as 최대
    , MIN(salary) as 최소
    , ROUND(AVG(salary), 2) as 평균
    , COUNT(employee_id) as 직원수
FROM employees
WHERE department_id IS NOT NULL
AND department_id IN(30, 60, 90)
GROUP BY department_id
ORDER BY 1;

-- 부서별, 직종별 집계
SELECT department_id
    , job_id
    , SUM(salary) as 합계
    , MAX(salary) as 최대
    , MIN(salary) as 최소
    , ROUND(AVG(salary), 2) as 평균
    , COUNT(employee_id) as 직원수
FROM employees
WHERE department_id IS NOT NULL
AND department_id IN(30, 60, 90)
GROUP BY department_id, job_id
ORDER BY 1;

-- member의 회원수와 마일리지의 합계, 평균을 출력하시오
SELECT * FROM member;
SELECT COUNT(mem_id) as 회원수 -- COUNT(*)
    , SUM(mem_mileage) as 마일리지
    , ROUND(AVG(mem_mileage), 2) as 평균
FROM member;

-- 직업별, 회원수, 마일리지 합계, 평균 (마일리지 평균 내림차순)
SELECT mem_job  
    , COUNT(mem_id) as 회원수 -- COUNT(*)
    , SUM(mem_mileage) as 마일리지
    , ROUND(AVG(mem_mileage), 2) as 평균
FROM member
GROUP BY mem_job
ORDER BY 평균 DESC;

-- 직업별 마일리지 평균이 3000 이상인 회원의 직업과 회원수를 출력
SELECT mem_job  
    , COUNT(mem_id) as 회원수 -- COUNT(*)
    , SUM(mem_mileage) as 마일리지
    , ROUND(AVG(mem_mileage), 2) as 평균
FROM member
GROUP BY mem_job
HAVING AVG(mem_mileage) >= 3000 -- 집계결과에 대해서 검색조건 추가할때 사용
ORDER BY 평균 DESC;

-- kor_loan_status (java 계정) 테이블의 2013년도 기간별, 지역별 총 대출단액을 출력하시오.
SELECT * FROM kor_loan_status;
SELECT SUBSTR(period,1, 4) as 년도
    , region as 지역
    , SUM(loan_jan_amt) as 대출합
FROM kor_loan_status
WHERE SUBSTR(period,1, 4) = '2013'
GROUP BY SUBSTR(period,1, 4), region -- 집계함수를 제외한 컬럼들을 GROUP BY에 작성해야 한다.
ORDER BY 지역;

-- 지역별 대출잔액합계가 200000 이상인 지역을 출력하시오
SELECT region as 지역
    , SUM(loan_jan_amt) as 대출합
FROM kor_loan_status
GROUP BY region -- 집계함수를 제외한 컬럼들을 GROUP BY에 작성해야 한다.
HAVING SUM(loan_jan_amt) >= 300000
ORDER BY 대출합 DESC;

-- 대전, 서울, 부산의 년도별 대출 합계에서 대출의 합이 60000넘는 결과를 출력하시오.
-- 정렬 : 지역 오름차순, 대출합 내림차순

SELECT SUBSTR(period,1, 4) as 년도
    , region as 지역
    , SUM(loan_jan_amt) as 대출합계
FROM kor_loan_status
WHERE region IN ('대전', '서울', '부산')
GROUP BY SUBSTR(period,1, 4), region
HAVING SUM(loan_jan_amt) >= 60000
ORDER BY 지역, 대출합계 DESC;

SELECT NVL(region, '합계')
    , SUM(loan_jan_amt) as 합계
FROM kor_loan_status
GROUP BY ROLLUP(region);

-- 년도별 대출의 합계와 총계
SELECT SUBSTR(period,1, 4) as 년도
    , SUM(loan_jan_amt) as 대출합
FROM kor_loan_status
GROUP BY ROLLUP(SUBSTR(period,1, 4));

-- employees 직원들의 입사년도별 직원수를 출력하시오 (정렬 입사년도 오름차순)
SELECT * FROM employees;
SELECT TO_CHAR(HIRE_DATE, 'YYYY') as 년도
    , COUNT(*)
FROM employees
GROUP BY TO_CHAR(HIRE_DATE, 'YYYY')
ORDER BY 1;

-- employees 직원들의 고용일자를 활용 입사한 날의 요일의 직원수를 출력
SELECT TO_CHAR(HIRE_DATE, 'day') as 요일
    , COUNT(*)
FROM employees
GROUP BY TO_CHAR(HIRE_DATE, 'day'), TO_CHAR(HIRE_DATE, 'd') -- 출력(SELECT)은 하지 않아도 정렬에 사용하기 위해서 그룹바이에 추가
ORDER BY TO_CHAR(HIRE_DATE, 'd');

-- customers 회원의 전체 회원수, 남자 회원수, 여자 회원수를 출력하시오
-- 남자, 여자라는 컬럼은 없음
-- customers 테이블의 컬럼을 활용해서 만들어야함.
SELECT * FROM customers;
SELECT COUNT(DECODE(cust_gender, 'F', cust_gender)) as 여자
    , COUNT(DECODE(cust_gender, 'M', cust_gender)) as 남자
    , COUNT(cust_gender) as  전체
--    ,COUNT(DECODE(cust_gender, 'F', '여자') as 여자
--    ,COUNT(DECODE(cust_gender, 'F', '남자') as 남자
FROM customers;