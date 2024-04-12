select COUNT(*) as customers_count
from customers;

/*select COUNT(*) - это часть запроса, которая выбирает все строки из таблицы "customers". select COUNT(customer_id) даст тот же результат, нет NULL-значений в столбце.
as customers_count - это часть запроса, которая назначает псевдоним "customers_count" для результата подсчета.
from customers - это часть запроса, которая указывает, что таблица "customers" используется для выполнения запроса.*/

select
	concat(e.first_name, ' ', e.last_name) as seller, -- соединяем имя и фамилию продавца
	count(distinct s.sales_id) as operations, -- считаем количество уникальных продаж
	floor(sum(p.price * s.quantity)) as income -- вычисляем доход как сумму произведений цены и количества. Округляем до целого значения в меньшую сторону
from employees e -- соединяем таблицы. Ипользуем left join, чтобы не потерять продавцов
left join sales s 
	on e.employee_id = s.sales_person_id 
left join products p 
	on s.product_id = p.product_id
group by 1 -- группировка по первому полу - имени и фамилии продавца. Поле не использовалось в агрегирующих функциях
order by 3 desc nulls last -- сортируем по третьему полю (доходу) по убыванию. Поле с "NULL" последнее
limit 10; -- ограничиваем выборку десятью значениями

select
	concat(e.first_name, ' ', e.last_name) as seller, -- соединяем имя и фамилию продавца
	floor(avg(p.price * s.quantity)) as average_income -- вычисляем среднее значение дохода за сделку как среднее произведений цены и количества. Округляем до целого значения в меньшую сторону
from employees e -- соединяем таблицы 
inner join sales s 
	on e.employee_id = s.sales_person_id 
inner join products p 
	on s.product_id = p.product_id
group by 1 -- группировка по первому полу - имени и фамилии продавца. Поле не использовалось в агрегирующих функциях
having avg(p.price * s.quantity) < ( -- после группировки отбираем тот средний доход за сделку по продавцу, который ниже среднего по всем продавцам
	select avg(p.price * s.quantity) -- передаем подзапрос, который вычисляет среднее значение дохода за сделку по всем продавцам
	from employees e 
	inner join sales s 
		on e.employee_id = s.sales_person_id 
	inner join products p 
		on s.product_id = p.product_id
)
order by 2; -- сортируем по второму полю (среднему доходу за сделку) по возрастанию

with tab as ( -- формируем подзапрос
	select
		concat(e.first_name, ' ', e.last_name) as seller, -- соединяем имя и фамилию продавца
		to_char(s.sale_date, 'day') as day_of_week, -- получаем название дня недели из значения даты
		extract (isodow from s.sale_date) as number_of_weekday, -- присваиваем дню недели порядковый номер (для сортировки по данному полю в основном запросе)
		floor(sum(p.price * s.quantity)) as income -- вычисляем доход как сумму произведений цены и количества. Округляем до целого значения в меньшую сторону
	from employees e -- соединяем таблицы
	inner join sales s 
		on e.employee_id = s.sales_person_id 
	inner join products p 
		on s.product_id = p.product_id
	group by 1, 2, 3 -- группировка по первому, второму и третьему полю. Поля не использовалось в агрегирующих функциях
)

select -- в основном запросе выбираем необходимые для отчета поля из подзапроса
	seller,
	day_of_week,
	income
from tab
order by number_of_weekday, seller; -- сортируем по порядковому номеру дня недели и по продавцу
