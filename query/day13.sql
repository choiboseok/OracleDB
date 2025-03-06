CREATE TABLE ��ȭ(
    ��ȣ NUMBER PRIMARY KEY
    , �̸� VARCHAR(100)
    , �����⵵ NUMBER
    , ����� NUMBER
    , ������ NUMBER
    , ���� NUMBER
);

CREATE TABLE ���(
    ��ȣ NUMBER PRIMARY KEY
    , �̸� VARCHAR2(100)
    , ������� DATE
    , Ű NUMBER
    , ������ NUMBER
    , ����� VARCHAR2(255)
);

CREATE TABLE �⿬(
    ��ȭ��ȣ NUMBER
    , ����ȣ NUMBER
    , ���� VARCHAR2(200)
    , PRIMARY KEY (��ȭ��ȣ, ����ȣ, ����) 
    , FOREIGN KEY (��ȭ��ȣ) REFERENCES ��ȭ(��ȣ) ON DELETE CASCADE
    , FOREIGN KEY (����ȣ) REFERENCES ���(��ȣ) ON DELETE CASCADE
);

INSERT INTO ��ȭ VALUES(1, '�����', 2019, 10000000, 10000000, 8.6);
INSERT INTO ��ȭ VALUES(2, '���˵���', 2017, 56300000, 17613623, 8.5);

INSERT INTO ��� VALUES(101, '�۰�ȣ', TO_DATE('19670117'), 180, 75, NULL);
INSERT INTO ��� VALUES(102, '������', TO_DATE('19710301'), 175, 90, '����ȭ');
INSERT INTO ���(��ȣ, �̸�) VALUES(103, '������');

INSERT INTO �⿬ VALUES(1, 101, '�ֿ�(����)');
INSERT INTO �⿬ VALUES(2, 102, '�ֿ�(������)');
INSERT INTO �⿬ VALUES(2, 102, '������');

SELECT a.��ȣ
    , a.�̸� ����̸�
    , c.����
    , a.�������
    , b.*
FROM ��� a, ��ȭ b, �⿬ c
WHERE a.��ȣ = c.����ȣ(+)
AND b.��ȣ = c.��ȭ��ȣ(+)
AND a.�̸� = '������';

/*
    WINDOW ��
    rows : �ο� ������ window���� ����
    range : ������ ������ window���� ����
    unbounded preceding : ��Ƽ������ ���еǴ� ù��° �ο�
    unbounded following : ��Ƽ������ ���еǴ� ������ �ο찡 �� ����
    current row : ���� ����
*/
SELECT department_id, emp_name, hire_date, salary
    , SUM(salary) OVER(PARTITION BY department_id ORDER BY hire_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) pre_cur
    , SUM(salary) OVER(PARTITION BY department_id ORDER BY hire_date ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) cur_fol
    , SUM(salary) OVER(PARTITION BY department_id ORDER BY hire_date ROWS BETWEEN 1 PRECEDING AND CURRENT ROW) p1_cur
    , SUM(salary) OVER(PARTITION BY department_id ORDER BY hire_date ROWS BETWEEN CURRENT ROW AND 2 FOLLOWING) cur_fol2
FROM employees
WHERE department_id IN (30, 90);

-- ������ �⵵��, ���� �����ݾ��� ����Ͻÿ�

SELECT * FROM kor_loan_status;

SELECT period
    , SUM(loan_jan_amt) OVER(PARTITION BY period ORDER BY period ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) ����
FROM kor_loan_status
WHERE region = '����';

SELECT period, region, SUM(loan_jan_amt)
FROM kor_loan_status 
GROUP BY period, region;

SELECT SUBSTR(period, 1, 4) yy
    , period
    , ���� loan_jan_amt
    , SUM(����) OVER(PARTITION BY SUBSTR(period, 1, 4) ORDER BY ���� ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) ����
FROM (
    SELECT period, region, SUM(loan_jan_amt) ����
    FROM kor_loan_status 
    GROUP BY period, region
    )
WHERE region = '����';
