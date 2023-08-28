USE sakila;

SELECT t.store_id, COUNT(r.rental_id) FROM rental r
JOIN staff s ON r.staff_id = s.staff_id
JOIN store t ON s.store_id = t.store_id
GROUP BY t.store_id;

DELIMITER //
CREATE PROCEDURE count_store()
BEGIN
	SELECT t.store_id, COUNT(r.rental_id) FROM rental r
JOIN staff s ON r.staff_id = s.staff_id
JOIN store t ON s.store_id = t.store_id
GROUP BY t.store_id;
END //
DELIMITER ;

CALL count_store();

DELIMITER //
CREATE PROCEDURE sales_store(IN store INT)
BEGIN
SELECT t.store_id, COUNT(r.rental_id), SUM(p.amount) FROM rental r
JOIN payment p ON p.rental_id = r.rental_id
JOIN staff s ON r.staff_id = s.staff_id
JOIN store t ON s.store_id = t.store_id
GROUP BY t.store_id
HAVING t.store_id = store;
END //
DELIMITER ;

CALL sales_store(2);

DROP PROCEDURE IF EXISTS sales_per_store;
DELIMITER //
CREATE PROCEDURE sales_per_store(IN store INT, OUT total_sales_value FLOAT)
BEGIN
SELECT t.store_id, SUM(p.amount) FROM rental r
JOIN payment p ON p.rental_id = r.rental_id
JOIN staff s ON r.staff_id = s.staff_id
JOIN store t ON s.store_id = t.store_id
GROUP BY t.store_id
HAVING t.store_id = store;
END //
DELIMITER ;

CALL sales_per_store(2, @total_sales_value);

DELIMITER //
CREATE PROCEDURE sales_store_flag(IN store INT)
BEGIN
SELECT t.store_id, SUM(p.amount), 
CASE
	WHEN SUM(p.amount) > 30000 THEN 'green_flag'
	ELSE 'red_flag'
END AS 'Flag'
FROM rental r
JOIN payment p ON p.rental_id = r.rental_id
JOIN staff s ON r.staff_id = s.staff_id
JOIN store t ON s.store_id = t.store_id
GROUP BY t.store_id
HAVING t.store_id = store;
END //
DELIMITER ;

CALL sales_store_flag(2)
