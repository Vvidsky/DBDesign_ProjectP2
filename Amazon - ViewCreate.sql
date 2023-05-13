/*-------------------------------
|		 Product List View		|
--------------------------------*/
-- Used by users and product vendors
CREATE OR REPLACE VIEW `product_list` AS
SELECT
	p.product_id,
    p.product_name,
    p.product_description,
    p.product_thumbnail,
    pvm.price,
    pvm.price - pvm.discount_price AS discount_price,
    ROUND(pvm.discount_price/pvm.price * 100, 2) AS discount_percentage,
    ps.sub_category_name,
    pd.department_name,
    p.modified_at
FROM product p
JOIN product_sub_category_map pm ON p.product_id = pm.product_id
JOIN product_sub_category ps ON ps.sub_category_id = pm.sub_category_id
JOIN product_vendor_map pvm ON pvm.product_id = p.product_id
JOIN product_department pd ON pd.department_id = ps.department_id
LIMIT 10000;
SELECT * FROM `product_list`;

/*-------------------------------
|		 Review_list View		|
--------------------------------*/
-- Used by users and product vendors
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
-- Used by users and product vendors
CREATE OR REPLACE VIEW `user_order` AS
SELECT
	u.user_id,
    first_name,
    last_name,
    is_prime_member,
    email,
    password,
    od.order_detail_id,
    oi.order_item_id,
    p.product_name,
    transaction_status,
    payment_date,
    pm.payment_method_id,
	payment_method_name
FROM user u
JOIN order_detail od ON u.user_id = od.user_id
RIGHT JOIN order_item oi ON oi.order_detail_id = od.order_detail_id
JOIN product p ON p.product_id = oi.product_id
JOIN payment_method pm ON od.payment_method_id = pm.payment_method_id;

SELECT * FROM `user_order`;

/*-----------------------------------
|		 Product_vendor View		|
------------------------------------*/
-- Used by staffs
CREATE OR REPLACE VIEW `product_vendor_list` AS
SELECT 
	pv.vendor_id, 
    pv.vendor_name,
	pv.vendor_description,
    pv.business_domain,
    pv.thumbnail_profile,
    pv.email,
    pv.password,
    pv.phone_number,
    pv.is_verified,
    va.street,
    va.city,
    va.zipcode,
    va.country,
    va.home_phone
FROM product_vendor pv
LEFT JOIN vendor_address va ON pv.vendor_id = va.vendor_id
ORDER BY pv.vendor_id;

SELECT * FROM `product_vendor_list`;