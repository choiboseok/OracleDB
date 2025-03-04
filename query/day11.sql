/*
    
*/
SELECT department_id
    , LPAD(' ', 3*(LEVEL-1)) || department_name as 부서명
    -- 가상-열로서 트리 내에서 어떤 단계에 있는지 나타내는 정수값
    , LEVEL
    , parent_id
FROM departments
START WITH parent_id IS NULL                    -- 해당 조건 로우부터 시작
CONNECT BY PRIOR department_id = parent_id;     -- 계층 구조가 어떤 식으로 연결되는지 
                                                -- 이전 부서들의 parent_id를 찾도록 

-- 관리자와 직원
SELECT * FROM employees;
SELECT a.employee_id
    , a.manager_id
    , LPAD(' ', 3*(LEVEL-1)) || a. emp_name emp_nm
    , b.department_name
    , LEVEL
FROM employees a, departments b
WHERE a.department_id = b.department_id 
START WITH a.manager_id IS NULL
CONNECT BY PRIOR a.employee_id = a.manager_id; -- 조건이 있을시 조건에 위치에 따라 결과가 달라짐.(START WITH 위, CONNECT BY 아래)
/*
    1. 조인이 있으면 조인 먼저 처리
    2. START WITH 절을 참조해 최상위 계층 로우를 선택
    3. CONNECT BY 절에 명시된 구문에 따라 계층형 관계 LEVEL 생성
    4. 자식 로우 찾기가 끝나면 조인 조건을 제외한 검색 조건에 대한하는 로우를 걸러냄.
*/

-- 계층형 쿼리는 정렬조건을 넣으면 계층형 트리가 깨짐.
-- SIBLINGS를 넣어줘야함.
SELECT department_id
    , LPAD(' ', 3*(LEVEL-1)) || department_name as 부서명
    , LEVEL
    , parent_id
FROM departments
START WITH parent_id IS NULL
CONNECT BY PRIOR department_id = parent_id
ORDER SIBLINGS BY department_name;

-- 계층형 쿼리에서 사용할 수 있는 함수
SELECT department_id
    , LPAD(' ', 3*(LEVEL-1)) || department_name as 부서명
    -- 루트 노드에서 시작해 current row까지 정보 반환
    , SYS_CONNECT_BY_PATH(department_name, '|') 부서들
    -- 마지막 노드 1, 자식이 있으면 0
    , CONNECT_BY_ISLEAF 
    , CONNECT_BY_ROOT department_name as root_nm -- 최상위(ROOT의 값)
FROM departments
START WITH parent_id IS NULL
CONNECT BY PRIOR department_id = parent_id;

-- 신규 부서가 생겼습니다.
-- IT 밑에 'SNS팀'
-- IT 헬프 데스크 부서 밑에 '댓글부대'
-- 알맞게 데이터를 삽입해주세요
INSERT INTO departments(department_id, department_name, parent_id, manager_id) VALUES(280, 'SNS팀', 60, '');
INSERT INTO departments(department_id, department_name, parent_id, manager_id) VALUES(290, '댓글부대', 230, '');

SELECT department_id
    , LPAD(' ', 3*(LEVEL-1)) || department_name as 부서명
    , LEVEL
FROM departments
START WITH parent_id IS NULL
CONNECT BY PRIOR department_id = parent_id;

CREATE TABLE 팀(
    아이디 NUMBER
    , 이름 VARCHAR2(100)
    , 직책 VARCHAR2(100)
    , 상위아이디 NUMBER
);
-- 다음과 같이 출력되도록 데이터를 삽입 후 계층형 쿼리를 작성하시오
SELECT * FROM 팀;
INSERT INTO 팀(아이디, 이름, 직책, 상위아이디) VALUES(1, '이사장', '사장', '');
INSERT INTO 팀(아이디, 이름, 직책, 상위아이디) VALUES(2, '김부장', '부장', 1);
INSERT INTO 팀(아이디, 이름, 직책, 상위아이디) VALUES(3, '서차장', '차장', 2);
INSERT INTO 팀(아이디, 이름, 직책, 상위아이디) VALUES(4, '장과장', '과장', 3);
INSERT INTO 팀(아이디, 이름, 직책, 상위아이디) VALUES(5, '박과장', '과장', 3);
INSERT INTO 팀(아이디, 이름, 직책, 상위아이디) VALUES(6, '이대리', '대리', 4);
INSERT INTO 팀(아이디, 이름, 직책, 상위아이디) VALUES(7, '김대리', '대리', 5);
INSERT INTO 팀(아이디, 이름, 직책, 상위아이디) VALUES(8, '최사원', '사원', 6);
INSERT INTO 팀(아이디, 이름, 직책, 상위아이디) VALUES(9, '강사원', '사원', 6);
INSERT INTO 팀(아이디, 이름, 직책, 상위아이디) VALUES(10, '주사원', '사원', 7);
UPDATE 팀 SET 아이디 = 10 WHERE 이름 = '주사원';

SELECT 이름
    , 아이디
    , LPAD(' ', 3*(LEVEL-1)) || 직책 as 직책
    , LEVEL
FROM 팀
START WITH 상위아이디 IS NULL
CONNECT BY PRIOR 아이디 = 상위아이디;

-- (top-down) 부모에서 자식으로 트리구성(순방향)
SELECT department_id
    , LPAD(' ', 3*(LEVEL-1)) || department_name as 부서명
    , LEVEL
FROM departments
START WITH parent_id IS NULL
CONNECT BY PRIOR department_id = parent_id;

-- (bottom-up) 자식에서 부모로 (역방향)
SELECT department_id
    , parent_id
    , LPAD(' ', 3*(LEVEL-1)) || department_name as 부서명
    , LEVEL
FROM departments
START WITH department_id = 280
CONNECT BY PRIOR parent_id = department_id;

-- 계층형쿼리 응용 CONNECT BY 절과 LEVEl 사용 (샘플 데이터가 필요할때)
SELECT LEVEL
FROM dual
CONNECT BY LEVEL <= 12;

-- 1 ~ 12월 출력
SELECT TO_CHAR(sysdate, 'YYYY') || LPAD(LEVEL, 2, '0') yy
from dual
CONNECT BY LEVEL <= 12;

 -- a
SELECT '2013' || LPAD(LEVEL, 2, '0') yy
from dual
CONNECT BY LEVEL <= 12;

-- b
SELECT period
    , SUM(loan_jan_amt) 합계
FROM kor_loan_status
WHERE period LIKE '2013%'
GROUP BY period
ORDER BY 1;
/* 
SELECT a.yy, b.합계
FROM () a
    , () b
WHERE a.yy = b.yy
*/
SELECT a.yy, 
    NVL(b.합계, 0) 합계
FROM (SELECT '2013' || LPAD(LEVEL, 2, '0') yy
        from dual
        CONNECT BY LEVEL <= 12) a
    , (SELECT period yy
        , SUM(loan_jan_amt) 합계
        FROM kor_loan_status
        WHERE period LIKE '2013%'
        GROUP BY period
        ORDER BY 1) b
WHERE a.yy = b.yy(+)
ORDER BY 1;

-- 마지막날 일자를 구하여 해당 행 만큼 생성
SELECT TO_DATE(TO_CHAR(sysdate, 'yyyymm') || LPAD(LEVEL, 2, '0')) dates
from dual
CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(sysdate), 'dd');

-- study 계정
-- reservation 테이블의 reserv_date, cancel 컬럼을 활용하여 
-- '금천'점의 모든 요일별 예약건수를 출력하시오(취소건 제외)
SELECT * FROM reservation;

SELECT LPAD(LEVEL, 1)
FROM dual
CONNECT BY LEVEL <= 7;

SELECT TO_CHAR(TO_DATE(reserv_date), 'day') 요일
    , branch
    , cancel
FROM reservation
WHERE branch = '금천';

SELECT *
FROM (
    SELECT LPAD(LEVEL, 1) 요일
    FROM dual
    CONNECT BY LEVEL <= 7) a,
    (SELECT TO_CHAR(TO_DATE(reserv_date), 'day') 요일
    , branch
    , cancel
    FROM reservation
    WHERE branch = '금천') b
WHERE a.요일 = b.요일(+);