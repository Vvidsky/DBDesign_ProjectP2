/*-----------------------
|		Customer		|
-------------------------*/

-- 1.1 Show the list of products with their detail
DROP VIEW IF EXISTS `product_list`;
CREATE VIEW `product_list` AS
SELECT p.product_id, p.product_name, p.product_thumbnail, p.price, p.price-p.discount AS discount_price, ROUND(p.discount/p.price*100, 2) AS discount_percentage, pd.department_name
FROM product_department_map pm
JOIN product p ON p.product_id = pm.product_id
JOIN product_department pd ON pd.department_id = pm.department_id 
LIMIT 10000;

SELECT * FROM product_list LIMIT 10000;

-- 1.2 Create/Edit/Delete the products

-- 1.3 Create/Edit/Delete the review description and image of each product

-- 1.4 Delete the product

-- 1.5 Delete the review

/*-----------------------
|	   	  User		    |
-------------------------*/
-- 2.1 Register

-- 2.2 Login

-- 2.3 See the order history of each customer

/*-----------------------
|	   	 Shopping    	|
-------------------------*/
-- 3.1 Add product to the cart

-- 3.2 Process the payment



