-- 6
SELECT b.product_name, 합계 
FROM (
    SELECT item_id 
    , SUM(SALES) 합계
    FROM order_info
    GROUP BY item_id
    ) a, item b
WHERE a.item_id = b.item_id
ORDER BY 2 DESC;

-- 7 
SELECT * FROM order_info;
SELECT * 
FROM order_info 
WHERE item_id = 'M0003'
ORDER BY reserv_no;

SELECT * FROM item;

SELECT SUBSTR(reserv_no, 1, 6) 매출월
    , product_name
    , SUM(sales)
    , DECODE(item_id, 'M0001', 'SPECIAL_SET', 'PASTA')
FROM order_info a, item b
WHERE a.item_id = b.item_id
GROUP BY reserv_no, product_name
ORDER BY 1;

SELECT SUBSTR(reserv_no, 1, 6) 월
    , COUNT(item_id)
    , SUM(sales * quantity) 합계
FROM order_info
GROUP BY reserv_no;