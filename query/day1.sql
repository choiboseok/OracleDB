-- �ּ� ctrl + /
/* ���� �ּ� */
-- sqldeveloper���� ��ɾ�� �Ķ������� ǥ�õ�
-- ��ɾ�� ��ҹ��ڸ� �������� ����
-- ��ɾ�� ; �����ݷ����� ����

-- 11g ���� ������ ##�� �ٿ��� �ϴµ�
-- ���� ������� ������ ����� ���ؼ��� �Ʒ� ��ɾ� ���� �� ��������.
ALTER SESSION SET "_ORACLE_SCRIPT"=true;
-- ���� ���� ������:java, ���:oracle
CREATE USER java IDENTIFIED BY oracle;
-- ���� �ο�(���� & ���ҽ� ���� �� ����)
GRANT CONNECT, RESOURCE TO java;
-- ���̺� �����̽� ���ٱ���(�������� ���� ����)
GRANT UNLIMITED TABLESPACE TO java;
-- ���� ������ �����ݷ� �������� Ŀ�� ��ġ �� ctrl + enter or �����ư or ���� �巡�� �� ����

--java ���� ���� 
CREATE TABLE members(
    mem_id VARCHAR2(10)
    ,mem_password VARCHAR2(10)
    ,mem_name VARCHAR2(10)
    ,mem_phone CHAR(11)
    ,mem_email VARCHAR2(100)
);
-- ������ ����
INSERT INTO members VALUES('a001', '1234', '�ؼ�', '0101234567', 'pangsu@gmail.com');
INSERT INTO members VALUES('a002', '1234', '����', '0111234567', 'dongsu@gmail.com');
-- ������ ��ȸ
SELECT * FROM members;
