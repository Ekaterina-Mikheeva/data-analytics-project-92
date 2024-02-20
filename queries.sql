select COUNT(*) as customers_count
from customers;

/*select COUNT(*) - это часть запроса, которая выбирает все строки из таблицы "customers". select COUNT(customer_id) даст тот же результат, нет NULL-значений в столбце.
as customers_count - это часть запроса, которая назначает псевдоним "customers_count" для результата подсчета.
from customers - это часть запроса, которая указывает, что таблица "customers" используется для выполнения запроса.*/

