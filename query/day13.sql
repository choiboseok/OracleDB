CREATE TABLE 영화(
    번호 NUMBER PRIMARY KEY
    , 이름 VARCHAR(100)
    , 개봉년도 NUMBER
    , 매출액 NUMBER
    , 관객수 NUMBER
    , 평점 NUMBER
);

CREATE TABLE 배우(
    번호 NUMBER PRIMARY KEY
    , 이름 VARCHAR2(100)
    , 출생일자 DATE
    , 키 NUMBER
    , 몸무게 NUMBER
    , 배우자 VARCHAR2(255)
);

CREATE TABLE 출연(
    영화번호 NUMBER
    , 배우번호 NUMBER
    , 역할 VARCHAR2(200)
    , PRIMARY KEY (영화번호, 배우번호, 역할) 
    , FOREIGN KEY (영화번호) REFERENCES 영화(번호) ON DELETE CASCADE
    , FOREIGN KEY (배우번호) REFERENCES 배우(번호) ON DELETE CASCADE
);

INSERT INTO 영화 VALUES(1, '기생충', 2019, 10000000, 10000000, 8.6);
INSERT INTO 영화 VALUES(2, '범죄도시', 2017, 56300000, 17613623, 8.5);

INSERT INTO 배우 VALUES(101, '송강호', TO_DATE('19670117'), 180, 75, NULL);
INSERT INTO 배우 VALUES(102, '마동석', TO_DATE('19710301'), 175, 90, '예정화');
INSERT INTO 배우(번호, 이름) VALUES(103, '하정우');

INSERT INTO 출연 VALUES(1, 101, '주연(기택)');
INSERT INTO 출연 VALUES(2, 102, '주연(마석도)');
INSERT INTO 출연 VALUES(2, 102, '제작자');

SELECT a.번호
    , a.이름 배우이름
    , c.역할
    , a.출생일자
    , b.*
FROM 배우 a, 영화 b, 출연 c
WHERE a.번호 = c.배우번호(+)
AND b.번호 = c.영화번호(+)
AND a.이름 = '하정우';

/*
    WINDOW 절
    rows : 로우 단위로 window절을 지정
    range : 논리적인 범위로 window절을 지정
    unbounded preceding : 파티션으로 구분되는 첫번째 로우
    unbounded following : 파티션으로 구분되는 마지막 로우가 끝 지정
    current row : 현재 지점
*/
SELECT department_id, emp_name, hire_date, salary
    , SUM(salary) OVER(PARTITION BY department_id ORDER BY hire_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) pre_cur
    , SUM(salary) OVER(PARTITION BY department_id ORDER BY hire_date ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) cur_fol
    , SUM(salary) OVER(PARTITION BY department_id ORDER BY hire_date ROWS BETWEEN 1 PRECEDING AND CURRENT ROW) p1_cur
    , SUM(salary) OVER(PARTITION BY department_id ORDER BY hire_date ROWS BETWEEN CURRENT ROW AND 2 FOLLOWING) cur_fol2
FROM employees
WHERE department_id IN (30, 90);

-- 대전의 년도별, 월별 누적금액을 출력하시오

SELECT * FROM kor_loan_status;

SELECT period
    , SUM(loan_jan_amt) OVER(PARTITION BY period ORDER BY period ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) 월별
FROM kor_loan_status
WHERE region = '대전';

SELECT period, region, SUM(loan_jan_amt)
FROM kor_loan_status 
GROUP BY period, region;

SELECT SUBSTR(period, 1, 4) yy
    , period
    , 월별 loan_jan_amt
    , SUM(월별) OVER(PARTITION BY SUBSTR(period, 1, 4) ORDER BY 월별 ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) 누적
FROM (
    SELECT period, region, SUM(loan_jan_amt) 월별
    FROM kor_loan_status 
    GROUP BY period, region
    )
WHERE region = '대전';
