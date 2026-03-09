/* 
 * Cоздание витрин данных:
 *  
 * 1. Таблица 1 — Данные о клиентах маркетплейса
 * 		Отбор данных о клиентах маркетплейса, которые зарегистрировались в 2024 году. 
 * 		JSON-значения представим в виде отдельных столбцов для необходимых параметров. 
 * 		Дополнительно определим неделю привлечения (cohort_week) и месяц привлечения (cohort_month). 
 * 		Отсортируем полученные данные по дате регистрации в порядке возрастания
 * 		В срезе оставим все поля
 * 
 * 2. Таблица 2 - Данные о событиях на сайте / в приложении маркетплейса
 * 		Отбор данных о событиях, которые произошли в 2024 году. 
 * 		Отсортируем полученные данные по дате события. 
 * 		Оставим следующие поля:
 * 		- id события
 * 		- id пользователя
 * 		- дата и время события (event_date)
 * 		- тип события
 * 		- операционная система
 * 		- тип устройства
 * 		- наименование товара
 * 		- неделя события (event_week)
 * 		- месяц события (event_month)
 * 
 * 3. Таблица 3 - Данные о заказах
 * 		Отбор данных о заказах, которые были сделаны в 2024 году. 
 * 		Отсортируем полученные данные по дате заказа. 
 * 		Оставим следующие поля: 
 * 		- id заказа
 * 		- id пользователя
 * 		- дата заказа
 * 		- наименование товара
 * 		- количество единиц товара
 * 		- цена за одну единицу товара
 * 		- итоговая сумма
 * 		- наименование категории товара
 * 		- неделя заказа (order_week)
 * 		- месяц заказа (order_month)
*/

-- 1. Таблица 1 — Данные о клиентах маркетплейса

SELECT
    u.user_id,
    u.registration_date,
    u.user_params ->> 'age' AS age,
    u.user_params ->> 'gender' AS gender,
    u.user_params ->> 'region' AS region,
    u.user_params ->> 'acq_channel' AS acq_channel,
    u.user_params ->> 'buyer_segment' AS buyer_segment,
    CAST(DATE_TRUNC('month', u.registration_date) AS date) AS cohort_month,
    CAST(DATE_TRUNC('week', u.registration_date) AS date) AS cohort_week
FROM pa_graduate.Users as u
WHERE EXTRACT(YEAR FROM registration_date) = 2024
ORDER BY registration_date
LIMIT 100;

-- 2. Таблица 2 -  Данные о событиях на сайте / в приложении маркетплейса

SELECT
    e.event_id,
    e.user_id,
    e.timestamp AS event_date,
    e.event_type,
    e.event_params ->> 'os' AS os,
    e.event_params ->> 'device' AS device,
    pd.product_name,
    CAST(DATE_TRUNC('week', e.timestamp) AS date) AS event_week,
    CAST(DATE_TRUNC('month', e.timestamp) AS date) AS event_month
FROM pa_graduate.Events AS e
LEFT JOIN pa_graduate.Product_dict AS pd USING(product_id)
WHERE EXTRACT(YEAR FROM e.timestamp) = 2024
ORDER BY e.timestamp
LIMIT 100;
	

-- 3. Таблица 3 - Данные о заказах

SELECT 
    o.order_id,
    o.user_id,
    o.order_date,
    pd.product_name,
    o.quantity,
    o.unit_price,
    o.total_price,
    pd.category_name,
    CAST(DATE_TRUNC('week', o.order_date) AS date) AS order_week,
    CAST(DATE_TRUNC('month', o.order_date) AS date) AS order_month
FROM pa_graduate.Orders AS o
LEFT JOIN pa_graduate.Product_dict AS pd USING(product_id)
WHERE EXTRACT(YEAR FROM o.order_date) = 2024
ORDER BY o.order_date
LIMIT 100;