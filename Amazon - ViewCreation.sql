/*-----------------------
|		 Product		|
-------------------------*/

-- 1.1 Show the list of products with their detail
DROP VIEW IF EXISTS `product_list`;
CREATE VIEW `product_list` AS
SELECT p.product_id, p.product_name, p.product_thumbnail, p.price, p.price-p.discount AS discount_price, ROUND(p.discount/p.price*100, 2) AS discount_percentage, ps.sub_category_name, pd.department_name
FROM product p
JOIN product_sub_category_map pm ON p.product_id = pm.product_id
JOIN product_sub_category ps ON ps.sub_category_id = pm.sub_category_id
JOIN product_department pd ON pd.department_id = ps.department_id
LIMIT 10000;

-- 2.3 See the order history of each customer
DROP VIEW IF EXISTS `order_history`;
CREATE VIEW `order_history` AS
SELECT p.product_name, oi.quantity, oi.price_each, od.order_detail_id, od.created_at AS `Ordered on`, payment_method_name, od.transaction_status
FROM order_detail od
JOIN `order` o ON o.order_detail_id = od.order_detail_id
JOIN order_item oi ON oi.order_item_id = o.order_item_id
JOIN product p ON p.product_id = o.product_id
JOIN payment_method pm ON od.payment_method_id = pm.payment_method_id
ORDER BY od.order_detail_id
LIMIT 100000;

-- User Cart
DROP VIEW IF EXISTS `user_cart`;
CREATE VIEW `user_cart` AS
SELECT u.user_id, CONCAT(u.first_name,  " ", u.last_name) AS full_name, p.product_name, p.price-p.discount AS price, pm.quantity, (p.price-p.discount) * pm.quantity AS total
FROM product_cart_map pm
JOIN product p ON pm.product_id = p.product_id
JOIN cart c ON c.cart_id = pm.cart_id
JOIN user u ON c.user_id = u.user_id
ORDER BY u.user_id
LIMIT 100000;





