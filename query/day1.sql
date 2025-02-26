-- 주석 ctrl + /
/* 다중 주석 */
-- sqldeveloper에서 명령어는 파란색으로 표시됨
-- 명령어는 대소문자를 구별하지 않음
-- 명령어는 ; 세미콜론으로 구분

-- 11g 이후 계졍명에 ##을 붙여야 하는데
-- 예전 방법으로 계정명 만들기 위해서는 아래 명령어 실행 후 만들어야함.
ALTER SESSION SET "_ORACLE_SCRIPT"=true;
-- 계정 생성 계정명:java, 비번:oracle
CREATE USER java IDENTIFIED BY oracle;
-- 권한 부여(접속 & 리소스 생성 및 접근)
GRANT CONNECT, RESOURCE TO java;
-- 테이블 스페이스 접근권한(물리적인 저장 파일)
GRANT UNLIMITED TABLESPACE TO java;
-- 명렁어 실행은 세미콜론 기준으로 커서 위치 후 ctrl + enter or 실행버튼 or 영역 드래그 후 실행

--java 게정 실행 
CREATE TABLE members(
    mem_id VARCHAR2(10)
    ,mem_password VARCHAR2(10)
    ,mem_name VARCHAR2(10)
    ,mem_phone CHAR(11)
    ,mem_email VARCHAR2(100)
);
-- 데이터 삽입
INSERT INTO members VALUES('a001', '1234', '팽수', '0101234567', 'pangsu@gmail.com');
INSERT INTO members VALUES('a002', '1234', '동수', '0111234567', 'dongsu@gmail.com');
-- 데이터 조회
SELECT * FROM members;
