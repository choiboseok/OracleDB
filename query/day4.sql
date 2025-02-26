/*
    데이터 조작어 DML
    테이블에 데이터 검색, 삽입, 수정, 삭제에 사용
    SELECT, UPDATE, INSERT, DELETE, MERGE
*/
-- 논리 연산자 >, <, >=, <=, =, <>, !=, ^=
SELECT * FROM employees WHERE salary = 2600;
SELECT * FROM employees WHERE salary <> 2600;
SELECT * FROM employees WHERE salary != 2600;
SELECT * FROM employees WHERE salary ^= 2600;
SELECT * FROM employees WHERE salary < 2600;
SELECT * FROM employees WHERE salary > 2600;
SELECT * FROM employees WHERE salary <= 2600;
SELECT * FROM employees WHERE salary >= 2600;

-- 논리 연산자를 사용하여 PRODUCTS 테이블에서 
-- 상품 최저금액(prod_min_price) 이 30 '이상' 50 '미만'의 '상품명'을 조회하시오
SELECT * FROM products ;

--SELECT prod_name, prod_min_price FROM products WHERE prod_min_price >= 30 AND prod_min_price <=50 ORDER BY prod_min_price, prod_name;

-- 하위 카테고리가 'CD-ROM'
SELECT prod_name, prod_min_price FROM products WHERE prod_min_price >= 30 AND prod_min_price <=50 AND prod_subcategory = 'CD-ROM' 
ORDER BY prod_min_price, prod_name;

-- 직원 중 10, 20번 부서인 직원만 조회하시오 (이름, 부서번호, 봉급)
SELECT emp_name, department_id, salary FROM employees WHERE department_id=10 OR department_id=20;

-- 표현식 CASE 문
-- table의 값을 특정 조건에 따라 다르게 표현하고 싶을때 사용
-- salary가 5000 이하 C등급, 5000초과 15000이하 B등급, 15000초과 A등급

SELECT emp_name, salary 
    ,CASE WHEN salary<=5000 THEN 'C등급' 
          WHEN salary >5000 AND salary <=15000 THEN 'B등급'
          ELSE 'A등급'
    END AS salary_grade
FROM employees
ORDER BY salary DESC;

-- 논리 조건식 AND OR NOT
SELECT emp_name, salary FROM employees WHERE NOT(salary >= 2500);

-- IN 조건(or이 많을때)
SELECT * FROM employees WHERE department_id IN (10, 20, 30, 40);
SELECT * FROM employees WHERE department_id NOT IN (10, 20, 30, 40);

-- BETWEEN a AND b 조건식
SELECT emp_name, salary FROM employees WHERE salary BETWEEN 2000 AND 2500;

-- LIKE 조건식
SELECT emp_name FROM employees WHERE emp_name LIKE 'A%';
SELECT emp_name FROM employees WHERE emp_name LIKE '%a';
SELECT emp_name FROM employees WHERE emp_name LIKE '%a%';

CREATE TABLE ex2_1(
    nm VARCHAR2(30)
);

INSERT INTO ex2_1 VALUES('김팽수');
INSERT INTO ex2_1 VALUES('팽수');
INSERT INTO ex2_1 VALUES('팽수닷');
INSERT INTO ex2_1 VALUES('남궁팽수');
SELECT * FROM ex2_1 WHERE nm LIKE '팽수_';

-- member 테이블 회원 중  김씨 정보(아이디, 이름, 마일리지, 생일)만 조회하시오
SELECT * FROM member;
SELECT mem_id, mem_name, mem_mileage, mem_bir FROM member WHERE mem_name LIKE '김%';

-- member 회원의 정보를 조회하세요
-- 단 mem_mileage 6000 이상 vip, 6000미만 3000이상 gold, 그밖에 silver
SELECT mem_id, mem_name, mem_job, mem_mileage 
        ,CASE WHEN mem_mileage >= 6000 THEN 'VIP'
              WHEN mem_mileage < 6000 AND mem_mileage >= 3000 THEN 'GOLD'
              ELSE 'SILVER'
        END AS grade
        , mem_add1 ||' '|| mem_add2 AS ADDR
FROM member
ORDER BY mem_mileage DESC; -- 숫자로도 정렬가능(SELECT 절에 있는 순서대로 하면 됨)

-- null 조회는 IS NULL or IS NOT NULL 
SELECT * FROM prod WHERE prod_size IS NULL;

-- 숫자 함수
-- 절댓값
SELECT ABS(10), ABS(-10) FROM dual;  -- dual ->임시 테이블과 같은(sql 사용 문법이 from 뒤에는 table이 존재해야해서 사용)

-- CEIL 올림, FLOOR 버림, ROUND 반올림
SELECT CEIL(10.01), FLOOR(10.01), ROUND(10.01) FROM dual;

-- ROUND(n, i) 매개변수 n을 소수점 기준 i+1 번째에서 반올림한 결과를 반환
-- i는 디폴트0, i가 음수면 소수점을 기준으로 왼쪽 i번쨰에서 반올림
SELECT ROUND(10.154, 1), ROUND(10.154, 2), ROUND(19.154, -1) FROM dual;

-- MOD(m, n) m을 n으로 나누었을때 나머지 반환
SELECT MOD(4, 2), MOD(5, 2) FROM dual;

-- SQRT n의 제곱근 반환
SELECT SQRT(4), SQRT(8), ROUND(SQRT(8), 2) FROM dual;

-- 문자 함수
-- 대, 소문자 변경
SELECT LOWER('HI'), UPPER('hi') FROM dual; 

-- 이름에 smith가 있는 직원 조회
SELECT emp_name FROM employees WHERE LOWER(emp_name) LIKE '%' || LOWER('smith') || '%';
-- SELECT emp_name FROM employees WHERE LOWER(emp_name) LIKE '%' || LOWER(:nm) || '%'; :nm -> 값이 많을시 변수처럼 사용하여 입력하여 사용할 수 있음.


-- SUBSTR(char, pos, len) char의 pos 번째 문자부터 len 길이만큼 자른뒤 반환
-- len이 없으면 pos 끝까지 
-- pos가 음수면 뒤에서 부터
SELECT SUBSTR('ABCDEFG', 1, 4), SUBSTR('ABCDEFG', -4, 3), SUBSTR('ABCDEFG', -4, 1), SUBSTR('ABCDEFG', 5) FROM dual;

-- 회원의 성별을 출력하시오
-- 이름, 성별(주민번호 뒷자리 첫째 자리 홀수(남자), 짝수(여자))
SELECT mem_name, 
    CASE WHEN MOD(SUBSTR(mem_regno2, 1, 1), 2) = 1 THEN '남자'
         ELSE '여자'
    END AS gender
    ,mem_regno2
FROM member;
