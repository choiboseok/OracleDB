/*
    PL/SQL 절차 & 집합적 언어의 특징을 모두 가지고 있음
    DB내부에 만들어져 일반 프로그래밍 언어보다 빠름
    함수, 프로시져, 트리거... 를 만들 수 있음.
*/
SET SERVEROUTPUT ON; -- 스크립트에 출력하려면

DECLARE             -- 익명블록
    v_num NUMBER;   -- 선언부
BEGIN
    v_num := 100;   -- 실행부
    DBMS_OUTPUT.PUT_LINE(v_num);
END;

DECLARE
    emp_nm VARCHAR2(80);
    dep_nm departments.department_name%TYPE; -- 테이블의 컬럼 타입
BEGIN
    SELECT a.emp_name, b.department_name
    INTO emp_nm, dep_nm
    FROM employees a, departments b
    WHERE a.department_id = b.department_id
    AND a.employee_id = 100;
    DBMS_OUTPUT.PUT_LINE(emp_nm || ':' || dep_nm);
END;

-- 단순 루프
DECLARE
    dan NUMBER := 2;
    su NUMBER := 1;
BEGIN
     LOOP
         DBMS_OUTPUT.PUT_LINE(dan || 'x' || su || '=' || dan * su);
         su := su + 1;
         EXIT WHEN su > 9; -- 단순 루프는 무조건 필요(탈출 조건)
     END LOOP;
END;

-- 구구단 출력 2 ~ 9
DECLARE
    dan NUMBER := 1;
    su NUMBER := 1;
BEGIN
    LOOP
        dan := dan + 1;
        LOOP
            DBMS_OUTPUT.PUT_LINE(dan || 'x' || su || '=' || dan * su);
            su := su + 1;
            EXIT WHEN su > 9; -- 단순 루프는 무조건 필요(탈출 조건)
        END LOOP;
        su := 1;
        EXIT WHEN dan > 8;
    END LOOP;
END;

-- FOR 문 
DECLARE
    dan NUMBER := 2;
BEGIN
    FOR i IN 1..9
    LOOP
        CONTINUE WHEN i=5; -- i가 5일 때 건너뛰기
        DBMS_OUTPUT.PUT_LINE(dan || '*' || i || '=' || (dan * i));
    END LOOP;
END;

-- mem_id를 입력받아 등급을 리턴하는 함수.
-- VIP : 5000이상
-- GOLD : 5000미만 3000이상
-- SILVER : 나머지
-- INPUT VARCHAR2, OUPUT VARCHAR2
CREATE OR REPLACE FUNCTION fn_grade(p_id VARCHAR2) -- 함수 생성
    RETURN VARCHAR2 -- 리턴 타입 필수
IS
    m_mileage NUMBER;
    m_grade VARCHAR2(30);
BEGIN
    SELECT mem_mileage
        INTO m_mileage -- 변수에 담는 부분
    FROM member
    WHERE mem_id = p_id;
    IF m_mileage >= 5000 THEN m_grade := 'VIP';
    ELSIF m_mileage < 5000 AND m_mileage >= 3000 THEN m_grade := 'GOLD';
    ELSE m_grade := 'SILVER';
    END IF;
    
    RETURN m_grade; -- 리턴 값 필수
END;

SELECT mem_name, fn_grade(mem_id) 
FROM member;

-- default : IN (내부) / OUT(리턴가능) 
CREATE OR REPLACE PROCEDURE test_proc(p_v1 VARCHAR2, p_v2 OUT VARCHAR2, p_v3 IN OUT VARCHAR2)
IS
BEGIN
    DBMS_OUTPUT.PUT_LINE('p_v1:' || p_v1);
    DBMS_OUTPUT.PUT_LINE('p_v2:' || p_v2);
    DBMS_OUTPUT.PUT_LINE('p_v3:' || p_v3);
    p_v2 := '변경2';
    p_v3 := '변경3';
END;

DECLARE
    p1 VARCHAR2(10) := '입력1:';
    p2 VARCHAR2(10) := '입력2:';
    p3 VARCHAR2(10) := '입력3:';
BEGIN
    TEST_PROC(p1, p2, p3); -- 프로시져 호출
    DBMS_OUTPUT.PUT_LINE(p2 || ',' || p3);
END;

/*
    학번생성 함수를 만들어주세요
    신입생이 들어왔습니다.
    학생 테이블의 학번 중 가장 큰 학번의 앞자리(4자리)가 올해년도라면 +1
    아니라면 올해년도 +000001 로 번호를 생성해주세요
    ex 2002110112 -> 올해 아님 2025000001
       2025000001 -> 올해 +1 : 2025000002
*/
SELECT * FROM 학생;
DELETE FROM 학생 WHERE 이름='중고';
SELECT fn_make_hakno 
FROM dual;
INSERT INTO 학생(학번, 이름) VALUES(fn_make_hakno, '중고');

CREATE OR REPLACE FUNCTION fn_make_hakno
    RETURN NUMBER
IS
    make_no NUMBER;
    this_year VARCHAR2(4) := TO_CHAR(SYSDATE, 'yyyy');
BEGIN
-- 1. 가장 큰 학번 조회
    SELECT MAX(학번)
    INTO make_no
    FROM 학생;
-- 2. 올해와 비교
    IF SUBSTR(make_no, 1, 4) != this_year THEN make_no := TO_NUMBER(this_year || '000001');
    ELSE make_no := make_no + 1;
    END IF;
-- 조건에 따라 번호 생성
    RETURN make_no;
END;