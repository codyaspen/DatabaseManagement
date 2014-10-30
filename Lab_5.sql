--Cody Eichelberger
--Lab 5

--1.
SELECT DISTINCT Agents.city
FROM Agents
INNER JOIN Orders
ON Agents.aid = Orders.aid
INNER JOIN Customers
ON Orders.cid = Customers.cid
WHERE customers.name = 'Tiptop';

--2.
SELECT DISTINCT pid 
FROM Orders 
INNER JOIN Customers 
ON Orders.cid = Customers.cid
WHERE city ='Kyoto'

--3.
SELECT name
FROM Customers
WHERE cid NOT IN (SELECT cid
				  FROM Orders
				 )

--4.
SELECT name
FROM Customers
LEFT OUTER JOIN Orders
ON Customers.cid = Orders.cid
WHERE ordno IS NULL

--5. 
SELECT DISTINCT Customers.name, Agents.name
FROM Customers
INNER JOIN Orders
ON Customers.cid = Orders.cid
INNER JOIN Agents
ON Orders.aid = Agents.aid
WHERE Customers.city = Agents.city

--6.
SELECT Customers.name as Cust_name, Agents.name as Agent_name, Customers.city
FROM Customers
INNER JOIN Agents
ON Customers.city = Agents.city
WHERE Customers.city = Agents.city

--7.
WITH ProductCount as (SELECT COUNT(pid) as Count, city
		      		  FROM products
		              GROUP BY(city)
		            )
SELECT DISTINCT customers.name, customers.city
FROM Customers
INNER JOIN Products
ON Customers.city = Products.city
WHERE Customers.city = (SELECT city
						FROM ProductCount
						WHERE Count = (SELECT Min(count)
						FROM ProductCount
					   )
		
			)




























