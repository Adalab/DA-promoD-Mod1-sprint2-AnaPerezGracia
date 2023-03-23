USE northwind;


/*Selecciona todos los campos de los productos, que pertenezcan a los proveedores con 
códigos: 1, 3, 7, 8 y 9, que tengan stock en el almacén, y al mismo tiempo que sus precios 
unitarios estén entre 50 y 100.
 Por último, ordena los resultados por código de proveedor de forma ascendente.*/
 
 -- Identificar las tablas:
	-- products
 
 SELECT *
 FROM products
 WHERE supplier_id IN (1, 3, 7, 8, 9) AND units_in_stock > 0 AND unit_price BETWEEN 50 AND 100;
 
 /*Devuelve el nombre y apellidos y el id de los empleados con códigos entre el 3 y el 6, 
 además que hayan vendido a clientes que tengan códigos que comiencen con las letras 
 de la A hasta la G. Por último, en esta búsqueda queremos filtrar solo por aquellos envíos
 que la fecha de pedido este comprendida entre el 22 y el 31 de Diciembre de cualquier año.*/
 
 SELECT DISTINCT e.employee_id, first_name, last_name
 FROM orders as o
 INNER JOIN employees as e
 ON e.employee_id = o.employee_id
 WHERE e.employee_id BETWEEN 3 AND 6 
	AND UPPER(substring(customer_id, 1)) BETWEEN 'A' AND 'G' 
    AND MONTH(order_date) = 12 AND DAY(order_date) BETWEEN 22 AND 31;
 
 /*Calcula el precio de venta de cada pedido una vez aplicado el descuento.
 Muestra el id del la orden, el id del producto, el nombre del producto, el precio unitario, 
 la cantidad, el descuento y el precio de venta después de haber aplicado el descuento.*/
 
 SELECT order_id, p.product_id, product_name, o.unit_price, o.quantity, discount, o.unit_price*(1-discount) AS price_after_discount
 FROM  order_details as o
 INNER JOIN products as p
 ON p.product_id = o.product_id;
 
/*Usando una subconsulta, muestra los productos cuyos precios estén por encima 
 del precio medio total de los productos de la BBDD.*/
-- 
SELECT *
FROM products
WHERE unit_price >
 (
	SELECT AVG(unit_price) 
    FROM products
);
 
 /*¿Qué productos ha vendido cada empleado y cuál es la cantidad vendida de cada uno de ellos?*/
 -- products, employees, order_details, orders
 SELECT product_name, e.first_name, e.last_name, od.quantity
 FROM order_details as od
 INNER JOIN products as p 
 ON p.product_id = od.product_id
 INNER JOIN orders as o -- aquí consigo el valor de o.employee_id, hace de puente para relacionar order_details con employees
 ON o.order_id = od.order_id
 INNER JOIN employees as e
 ON e.employee_id = o.employee_id;
 
 
 /*Basándonos en la query anterior, ¿qué empleado es el que vende más productos? 
 Soluciona este ejercicio con una subquery*/
 
SELECT best_seller.quantity_product_total_per_employee, e.first_name, e.last_name
FROM employees AS e
INNER JOIN (
    SELECT  employee_id, SUM(od.quantity) as quantity_product_total_per_employee
    FROM order_details as od
    INNER JOIN orders as o 
    ON o.order_id = od.order_id
    GROUP BY o.employee_id
    ORDER BY quantity_product_total_per_employee DESC 
    LIMIT 1
) as best_seller
ON best_seller.employee_id = e.employee_id;

/*BONUS ¿Podríais solucionar este mismo ejercicio con una CTE?*/

WITH best_seller
AS (
	 SELECT e.first_name, e.last_name, SUM(od.quantity) as quantity_product_total_per_employee
 FROM order_details as od
 INNER JOIN products as p 
 ON p.product_id = od.product_id
 INNER JOIN orders as o -- aquí consigo el valor de o.employee_id, hace de puente para relacionar order_details con employees
 ON o.order_id = od.order_id
 INNER JOIN employees as e
 ON e.employee_id = o.employee_id
 GROUP BY first_name, last_name
ORDER BY quantity_product_total_per_employee DESC 
    LIMIT 1
)
		
SELECT best_seller.quantity_product_total_per_employee, best_seller.first_name, best_seller.last_name
FROM best_seller
;



