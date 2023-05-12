-- 1.1 Show the list of products with their detail
CREATE OR REPLACE VIEW `product_list` AS
SELECT p.product_id, p.product_name, p.product_thumbnail, pvm.price, pvm.discount_price, 100-ROUND(pvm.discount_price/pvm.price*100, 2) AS discount_percentage, ps.sub_category_name, pd.department_name
FROM product_vendor_map pvm
JOIN product p ON p.product_id = pvm.product_id
JOIN product_sub_category_map pm ON p.product_id = pm.product_id
JOIN product_sub_category ps ON ps.sub_category_id = pm.sub_category_id
JOIN product_department pd ON pd.department_id = ps.department_id
WHERE pd.department_id = 1
LIMIT 10000;

SELECT * FROM product_list;

-- 2.3 See the order history of each customer
CREATE OR REPLACE VIEW `order_history` AS
SELECT p.product_name, oi.quantity, oi.price_each, od.order_detail_id, od.created_at AS `Ordered on`, payment_method_name, od.transaction_status
FROM order_detail od
JOIN order_item oi ON od.order_detail_id = oi.order_detail_id
JOIN `user` u ON u.user_id = oi.user_id
JOIN product p ON p.product_id = oi.product_id
JOIN payment_method pm ON od.payment_method_id = pm.payment_method_id
WHERE u.user_id = 5000
ORDER BY od.order_detail_id
LIMIT 100000;

SELECT * FROM order_history;




