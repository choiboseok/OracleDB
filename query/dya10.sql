/*
    а╓╠тг╔гЖ╫д oracle 10g ╨нем ╩Г©К╟║╢и REGEXP_╥н ╫цюшго╢б гт╪Ж.
    .(dot) or [] <-- ╧╝юз 1╠шюз╦╕ юг╧лгт.
    ^ : ╫цюш, $ : Ё║, [^] : not 
    {n} : n╧Ь ╧щ╨╧, {n,} : nюл╩С ╧щ╨╧, {n,m} : nюл╩С mюлго ╧щ╨╧
    REGEXP_LIKE(╢К╩С, фпео) : а╓╠т╫д фпео ╟к╩Ж
*/
SELECT mem_name, mem_comtel
FROM member
WHERE REGEXP_LIKE(mem_comtel, '^..-');
--WHERE REGEXP_LIKE(mem_comtel, '..-'); -- ╫цюшюл юж╬Н╬ъ гт ╬ф╢р╫ц ╦П╣н цБ╥б (ажюг)

--mem_mail ╣╔юлем аъ ©╣╧╝юз ╫цюш 3 ~ 5 юз╦╝ юл╦чюо аж╪рфпео цъцБ
SELECT mem_name, mem_mail
FROM member
WHERE REGEXP_LIKE(mem_mail, '^[a-zA-z]{3,5}@');

-- mem_add2 аж╪р©║╪╜ гя╠ш╥н Ё║Ё╙╢б фпеоюг аж╪р╦╕ цБ╥бго╫ц©ю.
SELECT mem_name, mem_add2 
FROM member
WHERE REGEXP_LIKE(mem_add2, '[╟║-фR]$');

-- гя╠ш + ╤Г╬Н╬╡╠Б + ╪Щюз фпеоюг аж╪р╦╕ а╤х╦го╫ц©ю
SELECT mem_name, mem_add2
FROM member
WHERE REGEXP_LIKE(mem_add2, '[╟║-фR] [0-9]');

-- * : 0х╦ or ╠в юл╩С х╫╪Ж╥н, ? : 0х╦ or 1х╦, + : 1х╦ or ╠в юл╩С
-- mem_add2 гя╠ш╦╦ юж╢б аж╥н╦╕ ╟к╩Жго╫ц©ю.
SELECT * FROM member;
SELECT mem_name, mem_add2 
FROM member
WHERE REGEXP_LIKE(mem_add2, '^[╟║-фR]+$');

-- гя╠шюл гя╠шюз╣╣ ╬Ь╢б 
SELECT mem_name, mem_add2
FROM member
WHERE NOT REGEXP_LIKE(mem_add2, '[╟║-хЧ]');

-- | : ╤г╢б, () : ╠в╥Л
-- J╥н ╫цюшго╦Г, ╪╪╧Ьб╟ ╧╝юз╟║ m or n юн аВ©Ьюг юл╦╖ а╤х╦
SELECT emp_name
FROM employees
WHERE REGEXP_LIKE(emp_name, '^J.(m|n)');

-- REGEXP_SUBSTR а╓╠тг╔гЖ╫д фпео╟З юод║го╢б ╧╝юз©╜ю╩ ╧щх╞
-- юл╦чюо ╠Баь ╬у ╣з цБ╥б
SELECT mem_mail
    , REGEXP_SUBSTR(mem_mail, '[^@]+', 1, 1) as ╬фюл╣П -- ╬ф╢я фпеою╩ ╠Баью╦╥н гя д╜╬© аЖа╓
    , REGEXP_SUBSTR(mem_mail, '[^@]+', 2, 2) as ╣╣╦чюн
FROM member;
SELECT REGEXP_SUBSTR('A-B-C', '[^-]+', 1, 1) as ex1
    , REGEXP_SUBSTR('A-B-C', '[^-]+', 1, 2) as ex2
    , REGEXP_SUBSTR('A-B-C', '[^-]+', 1, 3) as ex3
    , REGEXP_SUBSTR('A-B-C', '[^-]+', 1, 4) as ex4
FROM dual;

SELECT mem_name, mem_id, mem_add1 -- ╫ц╣╣, ╠╨╠╦ цБ╥бго╫ц©ю (mem_id:p001╩╘╟М)
    , REGEXP_SUBSTR(mem_add1, '[^ ]+', 1, 1) as ╫ц╣╣
    , REGEXP_SUBSTR(mem_add1, '[^ ]+', 1, 2) as ╠╨╠╦
FROM member
WHERE mem_id != 'p001';

--REGEXP_REPLACE ╢К╩С ╧╝юз©╜ю╩ а╓╠тг╔гЖ╫д фпеою╩ юШ©Кго©╘ ╢ы╦╔ фпеою╦╥н
SELECT REGEXP_REPLACE('Ellen Hidi Smith', '(.*) (.*) (.*)', '\3, \1, \2') as re
FROM dual;
-- (.*) : ╠в╥Л \1 \2 \3 ╟╒╟╒юг ╠в╥Лю╩ ╤Фгт

SELECT REGEXP_REPLACE('юл ╧╝юЕю╨  ╟Ь╧И   ю╞гЭюл     ╢ы╬Ггт.', '[ ]{1,}', ' ') as re -- ╟Ь╧Июл гя ╟Ё юл╩С южю╩╫ц гя д╜ю╦╥н ╨╞╟Ф
FROM dual;

-- фч г╔╠Б╧Щ \w => [a-zA-Z0-9], \d => [0-9]

-- юЭх╜╧Ьхё ╣чюз╦╝ ╣©юо╧Ьхё ╧щ╨╧╣г╢б ╩Г©Ь а╤х╦
SELECT emp_name, phone_number
FROM employees
WHERE REGEXP_LIKE(phone_number, '(\d\d)\1$'); -- (фпео╠в╥Л) \1 ╬у©║ юж╢б фпеою╩ ╢ы╫цбЭа╤

