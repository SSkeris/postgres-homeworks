-- Напишите запросы, которые выводят следующую информацию:
-- 1. Название компании заказчика (company_name из табл. customers) и ФИО сотрудника, работающего над заказом
-- этой компании (см таблицу employees),
-- когда и заказчик и сотрудник зарегистрированы в городе London,
-- а доставку заказа ведет компания United Package (company_name в табл shippers)
select c.company_name as customer, CONCAT(e.first_name, ' ', e.last_name) as employee
FROM orders as o
JOIN customers as c USING(customer_id)
JOIN employees as e USING(employee_id)
JOIN shippers as s ON o.ship_via = s.shipper_id
where c.city='London' and e.city='London' and s.shipper_id=2

-- 2. Наименование продукта, количество товара (product_name и units_in_stock в табл products),
-- имя поставщика и его телефон (contact_name и phone в табл suppliers) для таких продуктов,
-- которые не сняты с продажи (поле discontinued) и которых меньше 25 и которые в категориях Dairy Products и Condiments.
-- Отсортировать результат по возрастанию количества оставшегося товара.
select p.product_name, p.units_in_stock, s.contact_name, s.phone
FROM products as p
JOIN suppliers as s USING(supplier_id)
JOIN categories as c USING(category_id)
where p.units_in_stock < 25 and p.discontinued = 0
and c.category_name in ('Dairy Products', 'Condiments')
order by p.units_in_stock

-- 3. Список компаний заказчиков (company_name из табл customers), не сделавших ни одного заказа
select company_name from customers as c
LEFT JOIN orders as o USING(customer_id)
where not EXISTS (select * from orders
				 where o.customer_id=c.customer_id)

-- 4. уникальные названия продуктов, которых заказано ровно 10 единиц
--(количество заказанных единиц см в колонке quantity табл order_details)
-- Этот запрос написать именно с использованием подзапроса.
SELECT DISTINCT product_name
FROM products
WHERE product_id = ANY
(SELECT product_id FROM order_details WHERE quantity=10);