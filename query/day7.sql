-- ���� ������ UNION ------------------------------------------------------------------------

CREATE TABLE exp_goods_asia (
       country VARCHAR2(10),
       seq     NUMBER,
       goods   VARCHAR2(80));

INSERT INTO exp_goods_asia VALUES ('�ѱ�', 1, '�������� ������');
INSERT INTO exp_goods_asia VALUES ('�ѱ�', 2, '�ڵ���');
INSERT INTO exp_goods_asia VALUES ('�ѱ�', 3, '��������ȸ��');
INSERT INTO exp_goods_asia VALUES ('�ѱ�', 4, '����');
INSERT INTO exp_goods_asia VALUES ('�ѱ�', 5,  'LCD');
INSERT INTO exp_goods_asia VALUES ('�ѱ�', 6,  '�ڵ�����ǰ');
INSERT INTO exp_goods_asia VALUES ('�ѱ�', 7,  '�޴���ȭ');
INSERT INTO exp_goods_asia VALUES ('�ѱ�', 8,  'ȯ��źȭ����');
INSERT INTO exp_goods_asia VALUES ('�ѱ�', 9,  '�����۽ű� ���÷��� �μ�ǰ');
INSERT INTO exp_goods_asia VALUES ('�ѱ�', 10,  'ö �Ǵ� ���ձݰ�');

INSERT INTO exp_goods_asia VALUES ('�Ϻ�', 1, '�ڵ���');
INSERT INTO exp_goods_asia VALUES ('�Ϻ�', 2, '�ڵ�����ǰ');
INSERT INTO exp_goods_asia VALUES ('�Ϻ�', 3, '��������ȸ��');
INSERT INTO exp_goods_asia VALUES ('�Ϻ�', 4, '����');
INSERT INTO exp_goods_asia VALUES ('�Ϻ�', 5, '�ݵ�ü������');
INSERT INTO exp_goods_asia VALUES ('�Ϻ�', 6, 'ȭ����');
INSERT INTO exp_goods_asia VALUES ('�Ϻ�', 7, '�������� ������');
INSERT INTO exp_goods_asia VALUES ('�Ϻ�', 8, '�Ǽ����');
INSERT INTO exp_goods_asia VALUES ('�Ϻ�', 9, '���̿���, Ʈ��������');
INSERT INTO exp_goods_asia VALUES ('�Ϻ�', 10, '����');


/*
    ����� ���� UNION, UNION ALL, MINUS, INTERSECT
    �÷��� ���� Ÿ�� ��ġ�ؾ���. ������ ����������.
*/

SELECT goods, seq
FROM exp_goods_asia
WHERE country = '�ѱ�';

SELECT goods, seq
FROM exp_goods_asia
WHERE country = '�Ϻ�';

-- UNION �ߺ� ���� �� ����
SELECT goods
FROM exp_goods_asia
WHERE country = '�ѱ�'
UNION
SELECT goods
FROM exp_goods_asia
WHERE country = '�Ϻ�'
UNION
SELECT 'Ű����'
FROM dual;

-- UNION ALL
SELECT goods
FROM exp_goods_asia
WHERE country = '�ѱ�'
UNION ALL
SELECT goods
FROM exp_goods_asia
WHERE country = '�Ϻ�'
ORDER BY 1;

-- MINUS
SELECT goods
FROM exp_goods_asia
WHERE country = '�ѱ�'
MINUS
SELECT goods
FROM exp_goods_asia
WHERE country = '�Ϻ�';

-- INTERSECT
SELECT goods
FROM exp_goods_asia
WHERE country = '�ѱ�'
INTERSECT
SELECT goods
FROM exp_goods_asia
WHERE country = '�Ϻ�';

SELECT goods, seq
FROM exp_goods_asia
WHERE country = '�ѱ�'
UNION
SELECT goods, seq
FROM exp_goods_asia
WHERE country = '�Ϻ�';

SELECT gubun, SUM(loan_jan_amt) AS ��
FROM kor_loan_status
GROUP BY ROLLUP(gubun);

-- rollup�� ������� �ʰ� ������ ����� ����Ͻÿ�
SELECT * FROM kor_loan_status;

SELECT gubun, SUM(loan_jan_amt) AS ��
FROM kor_loan_status
GROUP BY gubun
UNION
SELECT '��', SUM(loan_jan_amt) AS �� -- ������ �÷��� ������ �����ָ� ����(Ÿ�� ��ġ)
FROM kor_loan_status;

/*
    1. �������� INNER JOIN or ���� ���� EQUI-JOIN
        WHERE ������ = ��ȣ ������ ����Ͽ� ������.
        A�� B ���̺� ����� ���� ���� �÷��� ������ ���� ������ TRUE�� ��� ���� ���� ���� ����.
*/
SELECT * FROM �л�;
SELECT * 
FROM �л�, ��������
WHERE �л�.�й� = ��������.�й�
AND �л�.�̸� = '�ּ���';

SELECT a.�й�, a.�̸�, a.����, b.����������ȣ, b.�����ȣ, b.�������
FROM �л� a, �������� b -- ���̺� ��Ī ( ���̺� �̸��� �� ��� ��Ī ���)
WHERE a.�й� = b.�й�
AND a.�̸� = '�ּ���';

-- �ּ��澾�� �� ���� ���� �Ǽ��� ����Ͻÿ�.
SELECT A.�̸�, COUNT(B.����������ȣ) AS ���������Ǽ�
FROM �л� A, �������� B
WHERE A.�й� = B.�й�
AND A.�̸� = '�ּ���'
GROUP BY A.�й�,  A.�̸�; -- ������ �̸��� �������� ������ �й��� ���� ����


SELECT �л�.�̸�, �л�.�й�, ��������.���ǽ�, ����.�����̸�
FROM �л�, ��������, ����
WHERE �л�.�й� = ��������.�й�
AND ��������.�����ȣ = ����.�����ȣ
AND �л�.�̸� = '�ּ���';

-- �ּ��澾�� �� ���� ������ ����ϼ���.
SELECT �л�.�̸�, �л�.�й�
    , COUNT(��������.����������ȣ) as �����Ǽ�
    , SUM(����.����) as ��������
FROM �л�, ��������, ����
WHERE �л�.�й� = ��������.�й�
AND ��������.�����ȣ = ����.�����ȣ
AND �л�.�̸� = '�ּ���'
GROUP BY �л�.�̸�, �л�.�й�;

-- ������ ���� �̷¼����� ����Ͻÿ�
SELECT ����.�����̸�
    , COUNT(���ǳ���.���ǳ�����ȣ) as ���ǰǼ�
FROM ����, ���ǳ���
WHERE ����.������ȣ = ���ǳ���.������ȣ
GROUP BY ����.�����̸�, ����.������ȣ
ORDER BY 2 DESC;

/*
    2. �ܺ����� OUTER JOIN
        null ���� �����͵� �����ؾ� �Ҷ� 
        null ���� ���Ե� ���̺� ���ι��� (+) ��ȣ ���
        �ܺ������� �ߴٸ� ��� ���̺��� ���ǿ� �ɾ������.
*/

SELECT A.�̸�, A.�й�
    , COUNT(B.����������ȣ)
FROM �л� A, �������� B
WHERE A.�й� = B.�й�(+)
GROUP BY A.�̸�, A.�й�;

SELECT A.�̸�, A.�й�
    , COUNT(B.����������ȣ) AS �Ǽ�
    , COUNT(*) -- ���� �����ϱ� ������ ī��Ʈ�� ����
FROM �л� A, �������� B, ���� C 
WHERE A.�й� = B.�й�(+)
AND B.�����ȣ = C.�����ȣ(+)
GROUP BY A.�̸�, A.�й�, C.�����̸�;

-- ��� ������ ���� �Ǽ��� ����Ͻÿ�
SELECT ����.�����̸�
    , COUNT(���ǳ���.���ǳ�����ȣ) as ���ǰǼ�
FROM ����, ���ǳ���
WHERE ����.������ȣ = ���ǳ���.������ȣ(+)
GROUP BY ����.�����̸�, ����.������ȣ
ORDER BY 2 DESC;

SELECT * 
FROM member;

SELECT * 
FROM cart;

SELECT a.mem_id, a.mem_name, COUNT(b.cart_no)
FROM member a, cart b
WHERE a.mem_id = b.cart_member(+)
GROUP BY a.mem_id, b.mem_name;

-- �����뾾�� ��ǰ �����̷� ���
SELECT a.mem_id, a.mem_name, b.cart_no, b.cart_prod, b.cart_qty, c.prod_name, c.* -- ��ü ���
FROM member a, cart b, prod c
WHERE a.mem_id = b.cart_member(+)
AND b.cart_prod = c.prod_id(+)
AND a.mem_name = '������';

/*
    ��� ���� �����̷��� ����Ͻÿ�.
    ����ھ��̵�, �̸�, īƮ���Ƚ��, ��ǰǰ���, ��ü��ǰ���ż�, �ѱ��űݾ�
    member, cart, prod ���̺� ���(���� �ݾ��� prod_price)�� ���
    ����(īƮ���Ƚ��)
*/
SELECT COUNT(b.cart_qty) * COUNT(c.prod_price)
FROM member a, cart b, prod c
WHERE b.cart_prod = c.prod_id(+)
GROUP BY b.cart_prod
ORDER BY 1 DESC;

SELECT cart_member, COUNT(cart_prod)
FROM cart
GROUP BY cart_member
ORDER BY 2 DESC;

SELECT COUNT(prod_id)
FROM prod;

SELECT a.mem_id as ���̵�, a.mem_name as �̸� 
    , COUNT(DISTINCT b.cart_no) as īƮ���Ƚ��
    , COUNT(DISTINCT b.cart_prod) as ��ǰǰ���
    , NVL(SUM(b.cart_qty), 0) as ��ǰ���ż�
    , NVL(SUM(b.cart_qty*c.prod_price), 0) as �ѱ��űݾ�
FROM member a, cart b, prod c
WHERE a.mem_id = b.cart_member(+)
AND b.cart_prod = c.prod_id(+)
GROUP BY a.mem_id, a.mem_name
ORDER BY 3 DESC;