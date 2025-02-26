select * from ex1_4;
update ex1_4 set age=11 where mem_id='a001';

SELECT *
FROM TB_INFO;

update tb_info set hobby='물멍' where info_no=14;
commit;

-- delete
delete ex1_4 where mem_id='a001';
select * from mem;
rollback;

-- 테이블 수정 alter
-- 이름변경 
ALTER TABLE ex1_4 RENAME COLUMN mem_nickname TO mem_nick;
-- 테이블 이름 변경
ALTER TABLE ex1_4 RENAME TO mem;
-- 컬럼 데이터 타입 변경 (변경시 제약조건 주의)
ALTER TABLE mem MODIFY (mem_nick VARCHAR2(500));
-- 제약조건 삭제 
SELECT * FROM user_constraints WHERE table_name='mem'; -- 해당 테이블 제약조건 이름 검색
ALTER TABLE mem DROP CONSTRAINT CH_EX_AGE; -- 제약조건 삭제
-- 제약조건 추가
ALTER TABLE mem ADD CONSTRAINT ck_ex_new_age CHECK(age BETWEEN 1 AND 150);
-- 컬럼 추가
ALTER TABLE mem ADD(new_en_nm VARCHAR2(100));
-- 컬럼 삭제
ALTER TABLE mem DROP COLUMN new_en_nm;
DESC mem;

-- TB_INFO에 MBTI 컬럼 추가
ALTER TABLE TB_INFO ADD(MBTI VARCHAR2(6));

DESC TB_INFO;

-- FK 외래키
CREATE TABLE dep(
    deptno NUMBER(3) PRIMARY KEY
    ,dept_nm VARCHAR2(20)
    ,dept_floor NUMBER(4)
);
CREATE TABLE emp(
    empno NUMBER(5) PRIMARY KEY
    ,emp__nm VARCHAR2(20)
    ,title VARCHAR2(20)
    -- 참조 하고자 하는 컬럼의 타입이 일치해야함.
    -- references 참조할 테이블(컬럼명)
    -- 참도 테이블, 컬럼이 존재해야 함(pk이면서)
    ,dno NUMBER(3) CONSTRAINT emp_fk REFERENCES dep(deptno) 
);
ALTER TABLE emp RENAME COLUMN emp__nm TO emp_nm;

INSERT INTO dep VALUES(1, '영업', 8);
INSERT INTO dep VALUES(2, '기획', 9);
INSERT INTO dep VALUES(3, '개발', 10);
INSERT INTO emp VALUES(100, '팽수', '대리', 2);
INSERT INTO emp VALUES(200, '동수', '과장', 3);
INSERT INTO emp VALUES(300, '길수', '부장', 4); -- 오류

SELECT * FROM dep;
SELECT emp.empno, emp.emp_nm, emp.title, dep.dept_nm || '부서(' || dep.dep_floor || '층)' as 부서
FROM emp, dep 
WHERE emp.dno = dep.deptno 
AND emp.emp_nm = '동수';

-- 참조하고 있는 테이블에서 사용중인 데이터는 삭제 안됨.
DELETE dep WHERE deptno = 3;
-- 방법1. 참조중인 데이터 삭제 후 삭제
DELETE emp where empno=200;
-- 방법2 제약조건 무시하고 삭제
DROP TABLE emp CASCADE CONSTRAINTS; -- 제약조건 무시하고 테이블 삭제

SELECT employee_id
      ,emp_name
      ,job_id
      ,manager_id 
      ,department_id
FROM employees;

-- 테이블 코멘트
COMMENT ON TABLE tb_info IS 'tech9';
-- 컬럼 코멘트
COMMENT ON COLUMN tb_info.info_no IS '출석번호';
COMMENT ON COLUMN tb_info.pc_no IS '좌석번호';
COMMENT ON COLUMN tb_info.nm IS '이름';
COMMENT ON COLUMN tb_info.en_nm IS '영문명';
COMMENT ON COLUMN tb_info.email IS '이메일';
COMMENT ON COLUMN tb_info.hobby IS '취미';
COMMENT ON COLUMN tb_info.create_dt IS '생성일';
COMMENT ON COLUMN tb_info.update_dt IS '수정일';
COMMENT ON COLUMN tb_info.mbti IS '성격유형검사';
-- 테이블 정보조회
SELECT *
FROM all_tab_comments
WHERE comments = 'tech9';
-- 컬럼 정보조회
SELECT *
FROM user_col_comments
WHERE comments = '성격유형검사';

-- 1. member 계정 만들기
-- 권한도 부여해야 접속&테이블 생성 가능
-- user id : member, password : member
ALTER SESSION SET "_ORACLE_SCRIPT"=true;
CREATE USER member IDENTIFIED BY member;
GRANT CONNECT, RESOURCE TO member;
GRANT UNLIMITED TABLESPACE TO member;
-- 2. member계정으로 접속(java 계정 X)
-- 3. member_table(utf-8) 문을 실행하여 (테이블 생성 및 데이터 저장)
-- SELECT * FROM member WHERE mem_id = 'a001';
