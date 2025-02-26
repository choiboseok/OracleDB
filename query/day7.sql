-- 집합 연산자 UNION ------------------------------------------------------------------------

CREATE TABLE exp_goods_asia (
       country VARCHAR2(10),
       seq     NUMBER,
       goods   VARCHAR2(80));

INSERT INTO exp_goods_asia VALUES ('한국', 1, '원유제외 석유류');
INSERT INTO exp_goods_asia VALUES ('한국', 2, '자동차');
INSERT INTO exp_goods_asia VALUES ('한국', 3, '전자집적회로');
INSERT INTO exp_goods_asia VALUES ('한국', 4, '선박');
INSERT INTO exp_goods_asia VALUES ('한국', 5,  'LCD');
INSERT INTO exp_goods_asia VALUES ('한국', 6,  '자동차부품');
INSERT INTO exp_goods_asia VALUES ('한국', 7,  '휴대전화');
INSERT INTO exp_goods_asia VALUES ('한국', 8,  '환식탄화수소');
INSERT INTO exp_goods_asia VALUES ('한국', 9,  '무선송신기 디스플레이 부속품');
INSERT INTO exp_goods_asia VALUES ('한국', 10,  '철 또는 비합금강');

INSERT INTO exp_goods_asia VALUES ('일본', 1, '자동차');
INSERT INTO exp_goods_asia VALUES ('일본', 2, '자동차부품');
INSERT INTO exp_goods_asia VALUES ('일본', 3, '전자집적회로');
INSERT INTO exp_goods_asia VALUES ('일본', 4, '선박');
INSERT INTO exp_goods_asia VALUES ('일본', 5, '반도체웨이퍼');
INSERT INTO exp_goods_asia VALUES ('일본', 6, '화물차');
INSERT INTO exp_goods_asia VALUES ('일본', 7, '원유제외 석유류');
INSERT INTO exp_goods_asia VALUES ('일본', 8, '건설기계');
INSERT INTO exp_goods_asia VALUES ('일본', 9, '다이오드, 트랜지스터');
INSERT INTO exp_goods_asia VALUES ('일본', 10, '기계류');


/*
    행당위 집합 UNION, UNION ALL, MINUS, INTERSECT
    컬럼의 수와 타입 입치해야함. 정렬은 마지막에만.
*/

SELECT goods, seq
FROM exp_goods_asia
WHERE country = '한국';

SELECT goods, seq
FROM exp_goods_asia
WHERE country = '일본';

-- UNION 중복 제거 후 결합
SELECT goods
FROM exp_goods_asia
WHERE country = '한국'
UNION
SELECT goods
FROM exp_goods_asia
WHERE country = '일본'
UNION
SELECT '키보드'
FROM dual;

-- UNION ALL
SELECT goods
FROM exp_goods_asia
WHERE country = '한국'
UNION ALL
SELECT goods
FROM exp_goods_asia
WHERE country = '일본'
ORDER BY 1;

-- MINUS
SELECT goods
FROM exp_goods_asia
WHERE country = '한국'
MINUS
SELECT goods
FROM exp_goods_asia
WHERE country = '일본';

-- INTERSECT
SELECT goods
FROM exp_goods_asia
WHERE country = '한국'
INTERSECT
SELECT goods
FROM exp_goods_asia
WHERE country = '일본';

SELECT goods, seq
FROM exp_goods_asia
WHERE country = '한국'
UNION
SELECT goods, seq
FROM exp_goods_asia
WHERE country = '일본';

SELECT gubun, SUM(loan_jan_amt) AS 합
FROM kor_loan_status
GROUP BY ROLLUP(gubun);

-- rollup을 사용하지 않고 동일한 결과를 출력하시오
SELECT * FROM kor_loan_status;

SELECT gubun, SUM(loan_jan_amt) AS 합
FROM kor_loan_status
GROUP BY gubun
UNION
SELECT 'ㅎ', SUM(loan_jan_amt) AS 합 -- 각각의 컬럼의 갯수만 맞쳐주면 가능(타입 일치)
FROM kor_loan_status;

/*
    1. 내부조인 INNER JOIN or 동등 조인 EQUI-JOIN
        WHERE 절에서 = 등호 연산자 사용하여 조인함.
        A와 B 테이블에 공통된 값을 가진 컬럼을 연결해 조인 조건이 TRUE일 경우 값이 같은 행을 추출.
*/
SELECT * FROM 학생;
SELECT * 
FROM 학생, 수강내역
WHERE 학생.학번 = 수강내역.학번
AND 학생.이름 = '최숙경';

SELECT a.학번, a.이름, a.전공, b.수강내역번호, b.과목번호, b.취득학점
FROM 학생 a, 수강내역 b -- 테이블 별칭 ( 테이블 이름이 길 경우 별칭 사용)
WHERE a.학번 = b.학번
AND a.이름 = '최숙경';

-- 최숙경씨의 총 수강 내역 건수를 출력하시오.
SELECT A.이름, COUNT(B.수강내역번호) AS 수강내역건수
FROM 학생 A, 수강내역 B
WHERE A.학번 = B.학번
AND A.이름 = '최숙경'
GROUP BY A.학번,  A.이름; -- 동일한 이름이 있을수도 있으니 학번도 같이 포함


SELECT 학생.이름, 학생.학번, 수강내역.강의실, 과목.과목이름
FROM 학생, 수강내역, 과목
WHERE 학생.학번 = 수강내역.학번
AND 수강내역.과목번호 = 과목.과목번호
AND 학생.이름 = '최숙경';

-- 최숙경씨의 총 수강 학점을 출력하세요.
SELECT 학생.이름, 학생.학번
    , COUNT(수강내역.수강내역번호) as 수강건수
    , SUM(과목.학점) as 수강학점
FROM 학생, 수강내역, 과목
WHERE 학생.학번 = 수강내역.학번
AND 수강내역.과목번호 = 과목.과목번호
AND 학생.이름 = '최숙경'
GROUP BY 학생.이름, 학생.학번;

-- 교수의 강의 이력선수를 출력하시오
SELECT 교수.교수이름
    , COUNT(강의내역.강의내역번호) as 강의건수
FROM 교수, 강의내역
WHERE 교수.교수번호 = 강의내역.교수번호
GROUP BY 교수.교수이름, 교수.교수번호
ORDER BY 2 DESC;

/*
    2. 외부조인 OUTER JOIN
        null 값의 데이터도 포함해야 할때 
        null 값이 포함될 테이블 조인문에 (+) 기호 사용
        외부조인을 했다면 모든 테이블의 조건에 걸어줘야함.
*/

SELECT A.이름, A.학번
    , COUNT(B.수강내역번호)
FROM 학생 A, 수강내역 B
WHERE A.학번 = B.학번(+)
GROUP BY A.이름, A.학번;

SELECT A.이름, A.학번
    , COUNT(B.수강내역번호) AS 건수
    , COUNT(*) -- 행이 존재하기 때문에 카운트가 잡힘
FROM 학생 A, 수강내역 B, 과목 C 
WHERE A.학번 = B.학번(+)
AND B.과목번호 = C.과목번호(+)
GROUP BY A.이름, A.학번, C.과목이름;

-- 모든 교수의 강의 건수를 출력하시오
SELECT 교수.교수이름
    , COUNT(강의내역.강의내역번호) as 강의건수
FROM 교수, 강의내역
WHERE 교수.교수번호 = 강의내역.교수번호(+)
GROUP BY 교수.교수이름, 교수.교수번호
ORDER BY 2 DESC;

SELECT * 
FROM member;

SELECT * 
FROM cart;

SELECT a.mem_id, a.mem_name, COUNT(b.cart_no)
FROM member a, cart b
WHERE a.mem_id = b.cart_member(+)
GROUP BY a.mem_id, b.mem_name;

-- 김은대씨의 상품 구매이력 출력
SELECT a.mem_id, a.mem_name, b.cart_no, b.cart_prod, b.cart_qty, c.prod_name, c.* -- 전체 출력
FROM member a, cart b, prod c
WHERE a.mem_id = b.cart_member(+)
AND b.cart_prod = c.prod_id(+)
AND a.mem_name = '김은대';

/*
    모든 고객의 구매이력을 출력하시오.
    사용자아이디, 이름, 카트사용횟수, 상품품목수, 전체상품구매수, 총구매금액
    member, cart, prod 테이블 사용(구매 금액은 prod_price)로 사용
    정렬(카트사용횟수)
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

SELECT a.mem_id as 아이디, a.mem_name as 이름 
    , COUNT(DISTINCT b.cart_no) as 카트사용횟수
    , COUNT(DISTINCT b.cart_prod) as 상품품목수
    , NVL(SUM(b.cart_qty), 0) as 상품구매수
    , NVL(SUM(b.cart_qty*c.prod_price), 0) as 총구매금액
FROM member a, cart b, prod c
WHERE a.mem_id = b.cart_member(+)
AND b.cart_prod = c.prod_id(+)
GROUP BY a.mem_id, a.mem_name
ORDER BY 3 DESC;