/*
    ����ǥ���� oracle 10g ���� ��밡�� REGEXP_�� �����ϴ� �Լ�.
    .(dot) or [] <-- ���� 1���ڸ� �ǹ���.
    ^ : ����, $ : ��, [^] : not 
    {n} : n�� �ݺ�, {n,} : n�̻� �ݺ�, {n,m} : n�̻� m���� �ݺ�
    REGEXP_LIKE(���, ����) : ���Խ� ���� �˻�
*/
SELECT mem_name, mem_comtel
FROM member
WHERE REGEXP_LIKE(mem_comtel, '^..-');
--WHERE REGEXP_LIKE(mem_comtel, '..-'); -- ������ �־�� �� �ƴҽ� ��� ��� (����)

--mem_mail ������ �� ������ ���� 3 ~ 5 �ڸ� �̸��� �ּ����� ����
SELECT mem_name, mem_mail
FROM member
WHERE REGEXP_LIKE(mem_mail, '^[a-zA-z]{3,5}@');

-- mem_add2 �ּҿ��� �ѱ۷� ������ ������ �ּҸ� ����Ͻÿ�.
SELECT mem_name, mem_add2 
FROM member
WHERE REGEXP_LIKE(mem_add2, '[��-�R]$');

-- �ѱ� + ���� + ���� ������ �ּҸ� ��ȸ�Ͻÿ�
SELECT mem_name, mem_add2
FROM member
WHERE REGEXP_LIKE(mem_add2, '[��-�R] [0-9]');

-- * : 0ȸ or �� �̻� Ƚ����, ? : 0ȸ or 1ȸ, + : 1ȸ or �� �̻�
-- mem_add2 �ѱ۸� �ִ� �ַθ� �˻��Ͻÿ�.
SELECT * FROM member;
SELECT mem_name, mem_add2 
FROM member
WHERE REGEXP_LIKE(mem_add2, '^[��-�R]+$');

-- �ѱ��� �ѱ��ڵ� ���� 
SELECT mem_name, mem_add2
FROM member
WHERE NOT REGEXP_LIKE(mem_add2, '[��-��]');

-- | : �Ǵ�, () : �׷�
-- J�� �����ϸ�, ����° ���ڰ� m or n �� ������ �̸� ��ȸ
SELECT emp_name
FROM employees
WHERE REGEXP_LIKE(emp_name, '^J.(m|n)');

-- REGEXP_SUBSTR ����ǥ���� ���ϰ� ��ġ�ϴ� ���ڿ��� ��ȯ
-- �̸��� ���� �� �� ���
SELECT mem_mail
    , REGEXP_SUBSTR(mem_mail, '[^@]+', 1, 1) as ���̵� -- �ƴ� ������ �������� �� ĭ�� ����
    , REGEXP_SUBSTR(mem_mail, '[^@]+', 2, 2) as ������
FROM member;
SELECT REGEXP_SUBSTR('A-B-C', '[^-]+', 1, 1) as ex1
    , REGEXP_SUBSTR('A-B-C', '[^-]+', 1, 2) as ex2
    , REGEXP_SUBSTR('A-B-C', '[^-]+', 1, 3) as ex3
    , REGEXP_SUBSTR('A-B-C', '[^-]+', 1, 4) as ex4
FROM dual;

SELECT mem_name, mem_id, mem_add1 -- �õ�, ���� ����Ͻÿ� (mem_id:p001����)
    , REGEXP_SUBSTR(mem_add1, '[^ ]+', 1, 1) as �õ�
    , REGEXP_SUBSTR(mem_add1, '[^ ]+', 1, 2) as ����
FROM member
WHERE mem_id != 'p001';

--REGEXP_REPLACE ��� ���ڿ��� ����ǥ���� ������ �����Ͽ� �ٸ� ��������
SELECT REGEXP_REPLACE('Ellen Hidi Smith', '(.*) (.*) (.*)', '\3, \1, \2') as re
FROM dual;
-- (.*) : �׷� \1 \2 \3 ������ �׷��� ����

SELECT REGEXP_REPLACE('�� ������  ����   ������     �پ���.', '[ ]{1,}', ' ') as re -- ������ �� �� �̻� ������ �� ĭ���� ����
FROM dual;

-- �� ǥ��� \w => [a-zA-Z0-9], \d => [0-9]

-- ��ȭ��ȣ ���ڸ� ���Ϲ�ȣ �ݺ��Ǵ� ��� ��ȸ
SELECT emp_name, phone_number
FROM employees
WHERE REGEXP_LIKE(phone_number, '(\d\d)\1$'); -- (���ϱ׷�) \1 �տ� �ִ� ������ �ٽ�����

