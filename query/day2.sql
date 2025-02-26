/*
    table 테이블
    1. 테이블명 컬럼명의 최대 크기는 30byte (영문자 1개 1byte)
    2. 테이블명 컬럼명으로 예약어는 사용할 수 없음(select, varchar2)
    3. 테이블명 컬럼명으로 문자, 숫자, _, #을 사용할 수 있지만
    첫 글자는 문자만 올 수 있음.
    4. 한 테이블에 사용 가능한 컬럼은 최대 255개 
    
    명령어는 대소문자를 구별하지 않음. (저장되는 테이블 정보는 대문자로 저장됨.)
    데이터는 대소문자를 구별함.
    
*/
CREATE TABLE ex1_1(
    col1 CHAR(10)
    ,col2 VARCHAR2(10) -- 컬럼은 ,로 구분되며 하나의 컬럼은 하나의 타입과 사이즈를 가짐.
);
-- INSERT 데이터 삽입
INSERT INTO ex1_1(col1, col2)
VALUES ('oracle', 'oracle');
INSERT INTO ex1_1(col1, col2)
VALUES ('오라클', '오라클');
INSERT INTO ex1_1(col1, col2)
VALUES ('오라클db', '오라클db');

SELECT * FROM ex1_1;

SELECT col1 FROM ex1_1;

-- length <-- 함수 문자열 길이,  lengthb <-- 문자열의 크기(byte)
SELECT col1, col2, length(col1), length(col2), lengthb(col1), lengthb(col2) 
FROM ex1_1;

SELECT *
FROM employees; --from 절은 조회하고자 하는 티이블 작성.
-- 테이블 정보 간단조회 (ORDER BY 절에서 사용하는 것과는 다름)
DESC employees;

SELECT emp_name     as nm  -- AS alias 별칭
    , hire_date     hd  -- 콤마를 구부으로 컬럼명 띄어쓰기 이후 단어는 별칭으로 인식
    , salary        sa_la -- 별칭으로 띄어쓰기는 안됨.(언더바 사용) 
    , department_id "부서아이디" -- 한글 별칭은 안쓰지만 쓰려면 "" 를 사용
FROM employees;

-- 검색조건 where
SELECT * FROM employees WHERE salary >= 20000;
SELECT * FROM employees WHERE salary >= 10000 AND 11000 > salary AND department_id = 80;

-- 정렬조건 ASC: 오름, DESC: 내림
SELECT * 
FROM employees 
WHERE salary >= 10000 
AND 11000 > salary 
AND department_id = 80
ORDER BY emp_name;

-- 사칙연산 사용가능
SELECT emp_name             AS 직원
    , salary                AS 월급
    , salary - salary * 0.1 AS 실수령액
    , salary * 12           AS 연봉
    , ROUND(salary/22.5, 2) AS 일당
FROM employees;

/* 
    숫자 데이터 타입 NUMBER 
    number(p, s) p는 소수점을 기준으로 모든 유효숫자 자릿수를 의미함.
                 s는 소수점을 자리수를 의미함(디폴트 0)
                 s가 2면 소수점 2자리 까지 (나머지는 반올리됨.)
                 s가 음수이면 소수점 기준으로 왼쪽 자리만큼 반올림됨.
*/
CREATE TABLE ex1_2(
    col1 NUMBER(3)          -- 정수만 3자리
    , col2 NUMBER(3, 2)     -- 정수1, 소수점 2자리까지
    , col3 NUMBER(5, -2)    -- 십의 자리까지 반올림(총7자리)
    , col4 NUMBER
);
INSERT INTO ex1_2 (col1) VALUES (0.789);
INSERT INTO ex1_2 (col1) VALUES (99.6);
INSERT INTO ex1_2 (col1) VALUES (1004); -- 오류 발생

INSERT INTO ex1_2 (col2) VALUES (0.7898);
INSERT INTO ex1_2 (col2) VALUES (1.7898);
INSERT INTO ex1_2 (col2) VALUES (9.9998); -- 오류 
INSERT INTO ex1_2 (col2) VALUES (10);     -- 오류

INSERT INTO ex1_2 (col3) VALUES (12345.2345);
INSERT INTO ex1_2 (col3) VALUES (1234569.2345);
INSERT INTO ex1_2 (col3) VALUES (12345699.2345); -- 오류

SELECT * FROM ex1_2;

/*
    날짜 데이터 타입(data 년월일시분초, timestamp 년월일시분초.밀리초)
    sysdate 현재시간, systimstamp 현재시간.밀리초
*/
CREATE TABLE ex1_3(
    date1 DATE
    , date2 TIMESTAMP
);
INSERT INTO ex1_3 VALUES(SYSDATE, SYSTIMESTAMP);
SELECT * FROM ex1_3;
--COMMIT;
--ROLLBACK

SELECT employee_id
    ,emp_name
    ,department_id
FROM employees;

SELECT *
FROM departments;

-- PK, FK를 활용하여 각 테이블의 관계를 맺어 데이터를 가져옴.
SELECT employees.employee_id        -- 직원 테이브의 PK
    ,employees.department_id        -- 직원 테이블의 FK(부서 테이블 번호참조)
    ,employees.emp_name
    ,departments.department_id
    ,departments.department_name    -- 부서 테이블의 PK
FROM employees
    ,departments
WHERE employees.department_id = departments.department_id;

/* 제약조건
    테이브을 관리하기 위한 규칙
    NOT NULL 널을 허용하지 않겠다.
    UNIQUE 중복을 허용하지 않겠다
    CHECK 특정 데이터만 받겠다
    PRIMARY KEY 기본키(하나의 테이블에 1개만 설정가능 (n개의 컬럼을 결합해서 사용가능)
                        하나의 행을 구분하는 식별자 or 키값 or PK or 기본키라고 함.
                        PK는 UNIQUE 하며 NOT NULL임
    FOREIGN KEY 외래키(참조키, FK라 함, 다른 테이블의 PK를 참조하는 키
*/
CREATE TABLE ex1_4(
    mem_id VARCHAR2(50) PRIMARY KEY     -- 기본키
    ,mem_nm VARCHAR2(50) NOT NULL       -- 널 허용안함
    ,mem_nickname VARCHAR2(100) UNIQUE  -- 중복 허용안함
    ,age NUMBER                         -- 1 ~ 150
    ,gender VARCHAR2(1)                 -- F or M
    ,create_dt DATE DEFAULT SYSDATE     -- 디폴트값 설정
    ,CONSTRAINT ck_ex_age CHECK(age BETWEEN 1 AND 150)
    ,CONSTRAINT ch_ex_gender CHECK(gender IN('F', 'M'))
);

INSERT INTO ex1_4 (mem_id, mem_nm, mem_nickname, age, gender)
VALUES('a001', '팽수', '팽하', 10, 'M');

INSERT INTO ex1_4 (mem_id, mem_nm, mem_nickname, age, gender)
VALUES('a003', '동기', '동하', 10, 'F');

SELECT*
FROM ex1_4;

SELECT *
FROM user_constraints
WHERE table_name = 'EX1_4';

CREATE TABLE TB_INFO(
    INFO_NO NUMBER(2) PRIMARY KEY NOT NULL
    ,PC_NO VARCHAR(10) UNIQUE NOT NULL
    ,NM VARCHAR2(20) NOT NULL
    ,EN_NM VARCHAR2(50) NOT NULL
    ,EMAIL VARCHAR2(50) NOT NULL
    ,HOBBY VARCHAR2(500)
    ,CREATE_DT DATE DEFAULT SYSDATE
    ,UPDATE_DT DATE DEFAULT SYSDATE 
);

