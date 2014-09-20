select name, city from Agents where name = 'Bond';
select pid, name, quantity from products where priceusd > 0.99;
select ordno, qty from orders;
select name, city from customers where city = 'Duluth';
select name from agents where city != 'New York' AND city != 'London';
select * from products where city != 'Dallas' and city != 'Duluth' and priceusd <= 1.00;
select * from orders where mon = 'jan' Or mon = 'apr';
select * from orders where mon = 'feb' and dollars > 200.00;
select * from orders where cid = 'C005';
