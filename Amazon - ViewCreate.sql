/*-------------------------------
|		 Product_list View		|
--------------------------------*/
CREATE OR REPLACE VIEW `product_list` AS
SELECT
	p.product_id,
    p.product_name,
    p.product_description,
    p.product_thumbnail,
    p.price,
    p.discount,
    p.price-p.discount AS discount_price,
    ROUND(p.discount/p.price*100, 2) AS discount_percentage,
    ps.sub_category_name,
    pd.department_name,
    p.modified_at
FROM product p
JOIN product_sub_category_map pm ON p.product_id = pm.product_id
JOIN product_sub_category ps ON ps.sub_category_id = pm.sub_category_id
JOIN product_department pd ON pd.department_id = ps.department_id
LIMIT 10000;
SELECT * FROM `product_list`;

/*-------------------------------
|		 Review_list View		|
--------------------------------*/
CREATE OR REPLACE VIEW `review_list` AS
SELECT
	r.review_id,
    rating_star,
    review_date,
    helpful_rate_count,
    user_id,
    product_id
FROM review r
JOIN review_image ri ON r.review_id = ri.review_id;
SELECT * FROM `review_list`;

/*-------------------------------
|		 User_order View		|
--------------------------------*/
CREATE OR REPLACE VIEW `user_order` AS
SELECT
	u.user_id,
    first_name,
    last_name,
    is_prime_member,
    email,
    password,
    order_detail_id,
    transaction_status,
    payment_date,
    pm.payment_method_id,
	payment_method_name
FROM user u
JOIN order_detail od ON u.user_id = od.user_id
JOIN payment_method pm ON u.user_id = pm.user_id;
SELECT * FROM `user_order`;

/*-----------------------------------
|		 Product_vendor View		|
------------------------------------*/
CREATE OR REPLACE VIEW `product_vendor_list` AS
SELECT
	*
FROM product_vendor;
SELECT * FROM `product_vendor_list`;