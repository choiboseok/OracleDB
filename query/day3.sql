select * from ex1_4;
update ex1_4 set age=11 where mem_id='a001';

SELECT *
FROM TB_INFO;

update tb_info set hobby='����' where info_no=14;
commit;

-- delete
delete ex1_4 where mem_id='a001';
select * from mem;
rollback;

-- ���̺� ���� alter
-- �̸����� 
ALTER TABLE ex1_4 RENAME COLUMN mem_nickname TO mem_nick;
-- ���̺� �̸� ����
ALTER TABLE ex1_4 RENAME TO mem;
-- �÷� ������ Ÿ�� ���� (����� �������� ����)
ALTER TABLE mem MODIFY (mem_nick VARCHAR2(500));
-- �������� ���� 
SELECT * FROM user_constraints WHERE table_name='mem'; -- �ش� ���̺� �������� �̸� �˻�
ALTER TABLE mem DROP CONSTRAINT CH_EX_AGE; -- �������� ����
-- �������� �߰�
ALTER TABLE mem ADD CONSTRAINT ck_ex_new_age CHECK(age BETWEEN 1 AND 150);
-- �÷� �߰�
ALTER TABLE mem ADD(new_en_nm VARCHAR2(100));
-- �÷� ����
ALTER TABLE mem DROP COLUMN new_en_nm;
DESC mem;

-- TB_INFO�� MBTI �÷� �߰�
ALTER TABLE TB_INFO ADD(MBTI VARCHAR2(6));

DESC TB_INFO;

-- FK �ܷ�Ű
CREATE TABLE dep(
    deptno NUMBER(3) PRIMARY KEY
    ,dept_nm VARCHAR2(20)
    ,dept_floor NUMBER(4)
);
CREATE TABLE emp(
    empno NUMBER(5) PRIMARY KEY
    ,emp__nm VARCHAR2(20)
    ,title VARCHAR2(20)
    -- ���� �ϰ��� �ϴ� �÷��� Ÿ���� ��ġ�ؾ���.
    -- references ������ ���̺�(�÷���)
    -- ���� ���̺�, �÷��� �����ؾ� ��(pk�̸鼭)
    ,dno NUMBER(3) CONSTRAINT emp_fk REFERENCES dep(deptno) 
);
ALTER TABLE emp RENAME COLUMN emp__nm TO emp_nm;

INSERT INTO dep VALUES(1, '����', 8);
INSERT INTO dep VALUES(2, '��ȹ', 9);
INSERT INTO dep VALUES(3, '����', 10);
INSERT INTO emp VALUES(100, '�ؼ�', '�븮', 2);
INSERT INTO emp VALUES(200, '����', '����', 3);
INSERT INTO emp VALUES(300, '���', '����', 4); -- ����

SELECT * FROM dep;
SELECT emp.empno, emp.emp_nm, emp.title, dep.dept_nm || '�μ�(' || dep.dep_floor || '��)' as �μ�
FROM emp, dep 
WHERE emp.dno = dep.deptno 
AND emp.emp_nm = '����';

-- �����ϰ� �ִ� ���̺��� ������� �����ʹ� ���� �ȵ�.
DELETE dep WHERE deptno = 3;
-- ���1. �������� ������ ���� �� ����
DELETE emp where empno=200;
-- ���2 �������� �����ϰ� ����
DROP TABLE emp CASCADE CONSTRAINTS; -- �������� �����ϰ� ���̺� ����

SELECT employee_id
      ,emp_name
      ,job_id
      ,manager_id 
      ,department_id
FROM employees;

-- ���̺� �ڸ�Ʈ
COMMENT ON TABLE tb_info IS 'tech9';
-- �÷� �ڸ�Ʈ
COMMENT ON COLUMN tb_info.info_no IS '�⼮��ȣ';
COMMENT ON COLUMN tb_info.pc_no IS '�¼���ȣ';
COMMENT ON COLUMN tb_info.nm IS '�̸�';
COMMENT ON COLUMN tb_info.en_nm IS '������';
COMMENT ON COLUMN tb_info.email IS '�̸���';
COMMENT ON COLUMN tb_info.hobby IS '���';
COMMENT ON COLUMN tb_info.create_dt IS '������';
COMMENT ON COLUMN tb_info.update_dt IS '������';
COMMENT ON COLUMN tb_info.mbti IS '���������˻�';
-- ���̺� ������ȸ
SELECT *
FROM all_tab_comments
WHERE comments = 'tech9';
-- �÷� ������ȸ
SELECT *
FROM user_col_comments
WHERE comments = '���������˻�';

-- 1. member ���� �����
-- ���ѵ� �ο��ؾ� ����&���̺� ���� ����
-- user id : member, password : member
ALTER SESSION SET "_ORACLE_SCRIPT"=true;
CREATE USER member IDENTIFIED BY member;
GRANT CONNECT, RESOURCE TO member;
GRANT UNLIMITED TABLESPACE TO member;
-- 2. member�������� ����(java ���� X)
-- 3. member_table(utf-8) ���� �����Ͽ� (���̺� ���� �� ������ ����)
-- SELECT * FROM member WHERE mem_id = 'a001';
