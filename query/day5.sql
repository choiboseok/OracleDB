-- 공백 제거 TRIM, LTRIM, RTRIM
SELECT LTRIM(' ABC ') as l
    , RTRIM(' ABC ')  as r 
    , TRIM(' ABC ')   as al
FROM dual;

-- 문자열 패딩 (LPAD, RPAD)
SELECT LPAD(123, 5, '0')   as lp1 --LPAD(대상, 길이, 패드) 길이만큼 채움
    , LPAD(1, 5, '0')      as lp2 
    , LPAD(123456, 5, '0') as lp3 --주의 길이 만큼(넘어서면 제거됨)
    , RPAD(2, 5, '*')      as rp1 -- R은 오른쪽부터
FROM dual;

-- REPLACE(대상, 찾는, 변경)
-- TRANSLATE 한글자 씩 매칭
SELECT REPLACE('나는 너를 모르는데 너는 나를 알겠는가?', '나는', '너를')  as re
    , TRANSLATE('나는 너를 모르는데 너는 나를 알겠는가?', '나는', '너를') as tr
FROM dual;

-- INSTR 문자열 위치 찾기(p1, p2, p3, p4) p1 : 대상문자열, p2 : 찾을 문자열, p3 : 시작, p4 : 번째
SELECT INSTR('안녕 만나서 반가워, 안녕은 hi', '안녕')      as ins1 -- 디폴트 1, 1
    , INSTR('안녕 만나서 반가워, 안녕은 hi', '안녕', 5)    as ins2
    , INSTR('안녕 만나서 반가워, 안녕은 hi', '안녕', 1, 2) as ins3
    , INSTR('안녕 만나서 반가워, 안녕은 hi', 'hello')      as ins4
FROM dual;

-- tb_info 학생의 이메일 주소를 (id, domain으로 분리하여 출력하시오)
-- pangsu@gamil.com->> id : pangsu, domain : gmail.com
SELECT * FROM tb_info;

SELECT nm, email
    , SUBSTR(email, 1, (INSTR(email, '@')-1)) as 아이디
    , SUBSTR(email, (INSTR(email, '@')+1)) as 도메인
FROM tb_info;

/* 변환함수(타입) 많이 사용함.
    TO_CHAR 문자형으로
    TO_DATE 날짜
    TO_NUMBER 숫자 ~ 
*/
SELECT TO_CHAR(12345, '999,999,999')            as ex1
    , TO_CHAR(SYSDATE, 'YYYY-MM-DD')            as ex2
    , TO_CHAR(SYSDATE, 'YYYYMMDD')              as ex3
    , TO_CHAR(SYSDATE, 'YYYY/MM/DD HH24:MI:SS') as ex4
    , TO_CHAR(SYSDATE, 'YYYY/MM/DD HH12:MI:SS') as ex5
    , TO_CHAR(SYSDATE, 'day')                   as ex6
    , TO_CHAR(SYSDATE, 'YY')                    as ex7
    , TO_CHAR(SYSDATE, 'dd')                    as ex8 
    , TO_CHAR(SYSDATE, 'd')                     as ex9 --요일
FROM dual;

SELECT TO_DATE('231229', 'YYMMDD')                            as ex1
    , TO_DATE('2025 01 21 09:10:00', 'YYYY MM DD HH24:MI:SS') as ex2
    , TO_DATE('45', 'YY')                                     as ex3
    , TO_DATE('50', 'RR')                                     as ex4
    , TO_DATE('40', 'RR') -- Y2K 2000년 문제에 대한 대응책으로 도입됨. 50->1950, 49->2049
FROM dual;

CREATE TABLE ex5_1(
    seq1 VARCHAR2(100)
    ,sec2 NUMBER
);
INSERT INTO ex5_1 VALUES('1234', '1234');
INSERT INTO ex5_1 VALUES('99', '99');
INSERT INTO ex5_1 VALUES('195', '195');
SELECT * FROM ex5_1 ORDER BY TO_NUMBER(seq1);

CREATE TABLE ex5_2(
    title VARCHAR2(100)
    ,d_day DATE
);
INSERT INTO ex5_2 VALUES('시작일', '20250121');
INSERT INTO ex5_2 VALUES('종료일', '2025.07.09');

SELECT * FROm ex5_2;
INSERT INTO ex5_2 VALUES('탄소교육', '2025 02 24');
INSERT INTO ex5_2 VALUES('취업특강', '2025 03 31 10:00:00'); -- 오류남
INSERT INTO ex5_2 VALUES('취업특강', TO_DATE('2025 03 31 10:00:00', 'YYYY MM DD HH24:MI:SS'));

-- 회원의 생년월일을 이용하여 나이를 출력하세요.
-- 올해 년도이용(ex 2025 - 2000) 25세
-- 정렬은 나이 내림차순.

SELECT * FROM member; 
SELECT mem_name, mem_bir, TO_CHAR(SYSDATE, 'YYYY') - TO_CHAR(mem_bir, 'YYYY') || '세' as age 
FROM member
ORDER BY mem_bir DESC;

/* 날짜 데이터 타입 관련 함수
    ADD_MONTHS(날짜, 1) 다음달
    LAST_DAY(날짜) 해당 월의 마지막 날
    NEXT_DAY(날짜, '요일') 가까운 해당 요일의 날짜
*/
SELECT ADD_MONTHS(SYSDATE, 1)     as ex1 -- 다음달
    , ADD_MONTHS(SYSDATE, -1)     as ex2 -- 이전달
    , LAST_DAY(SYSDATE)           as ex3
    , NEXT_DAY(SYSDATE, '금요일') as ex4
    , NEXT_DAY(SYSDATE, '토요일') as ex5
    , SYSDATE -1                  as ex6 -- 어제
    , ADD_MONTHS(SYSDATE, 1) - ADD_MONTHS(SYSDATE, -1) as ex7
FROM dual;

SELECT SYSDATE - mem_bir, SYSDATE sy, mem_bir, 
        TO_CHAR(SYSDATE, 'YYYYMMDD') - TO_CHAR(mem_bir, 'YYYYMMDD') as ex1
        , TO_DATE(TO_CHAR(SYSDATE, 'YYYYMMDD')) - TO_DATE(TO_CHAR(mem_bir, 'YYYYMMDD')) as ex2
FROM member;

-- 그럼 이번달은 몇일 남았을까요?

SELECT LAST_DAY(SYSDATE) - SYSDATE as 이번달
FROM dual;

-- 20250709 까지 얼마나 남았을까요
SELECT TO_DATE(20250709, 'YYYY-MM-DD') - TO_DATE(TO_CHAR(SYSDATE, 'YYYY-MM-DD')) as 종료일까지
FROM dual;

-- DECODE 표현식 특정 '값'일때 표현변경
SELECT * FROM customers;

SELECT cust_id, cust_name, cust_gender, 
    DECODE(cust_gender, 'M', '남자', '여자') as gender -- cust_gender가 M이면(true) 남자, 그 밖에는 여자
 --   DECODE(cust_gender, 'M', '남자', 'F', '여자', '!!?')
FROM customers;

-- DISTINCT (중복 제거)
-- 중복된 데이터를 제거하고 고유한 값을 반환
SELECT DISTINCT prod_category
FROM products;
-- 행 조합이 중복되지 않는 값 반환
SELECT DISTINCT prod_category, prod_subcategory
FROM products
ORDER BY 1;

-- NVL(컬럼, 반환값) 컬럼 값이 null일 경우 반환값 리턴
SELECT emp_name, salary, commission_pct, salary + salary * commission_pct, salary + salary *  NVL(commission_pct, 0) as 상여금
FROM employees;

/*
    1. employees 직원중 근속년수가 30년 이상인 직원만 출력하시오 (근속년수 내림차순)
    2. customers 고객의 나이를 기준으로 30대, 40대, 50대를 구분하여 출력(나머지 연령대는 '기타')
      정렬(연령 오름차순), 검색조건(1, 도시 : Aachen, 2. 출생년도 : 1960 ~ 1990년 출생까지, 3. 결혼상태 : single, 4. 성별 : 남자)
*/
SELECT * FROM employees;
SELECT * FROM customers;
SELECT cust_year_of_birth FROM customers;
-- 1번 문제
SELECT emp_name, hire_date,
    TO_CHAR(SYSDATE, 'YYYY') - TO_CHAR(hire_date, 'YYYY') AS 근속년수
FROM employees
WHERE TO_CHAR(SYSDATE, 'YYYY') - TO_CHAR(hire_date, 'YYYY') >= 26
ORDER BY hire_date , 근속년수 DESC;

-- 2번 문제
SELECT cust_name, cust_year_of_birth
    , TO_CHAR(SYSDATE, 'YYYY') - cust_year_of_birth as 나이
    , DECODE(SUBSTR((TO_CHAR(SYSDATE, 'YYYY') - cust_year_of_birth), 1, 1), '3', '30대', '4', '40대', '5', '50대', '기타') as 연령대
FROM customers
WHERE cust_city = 'Aachen' AND cust_year_of_birth BETWEEN 1960 AND 1990 AND cust_marital_status = 'single' AND cust_gender = 'M'
ORDER BY 나이 ;