--Number 1
SELECT city FROM agents WHERE aid in (
	SELECT aid 
	FROM orders
	WHERE cid in (
		SELECT cid
		FROM customers
		WHERE name = 'Tiptop')
		)

--Number 2
SELECT DISTINCT pid
FROM orders
WHERE aid in (
	SELECT aid from orders 
	WHERE cid in (
		SELECT cid
		FROM customers
		WHERE city = 'Kyoto')
		)

--Number 3
SELECT cid, name
FROM customers
WHERE cid NOT in (
	SELECT cid
	FROM orders
	WHERE aid = 'a04')


--Number 4 
SELECT cid, name
FROM Customers
WHERE cid in (
	SELECT cid
	FROM orders
	WHERE pid ='p01')
INTERSECT
SELECT cid, name
FROM Customers
WHERE cid in (
	SELECT cid
	FROM orders
	WHERE pid ='p07')

--Number 5
SELECT pid 
FROM orders 
WHERE cid in (
	SELECT cid 
	FROM orders 
	WHERE aid = 'a04')

--Number 6
SELECT name, discount
FROM customers
WHERE cid in (
	SELECT cid
	FROM orders
	WHERE aid in (
		SELECT aid
		FROM agents
		WHERE city = 'Dallas' OR city ='Newark'))

--Number 7
SELECT * 
FROM customers
WHERE discount = (
	SELECT discount
	FROM customers
	WHERE city = 'Dallas' OR city = 'Kyoto')

