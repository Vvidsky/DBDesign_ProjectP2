/*-----------------------
|		 Product		|
-------------------------*/
-- NOTED that the standard_price is not the price that will be included in the order_item
-- the actual price will be derived from the discount_price in the product_vendor_map table
-- Standard price will help us to understand the query functions while the real result will need to 
-- JOIN the table on product_vendor_map with order_item ON both product_id and vendor_id.

-- 1.1 Show the lists of products with their details
-- 1.1.1 Show the list of products and their details whose product name includes the word "Panasonic".
SELECT
	product_name,
    product_description,
    product_thumbnail,
    pv.vendor_name,
    pvm.price,
	pvm.discount_price,
    100-ROUND(discount_price/price*100, 2) AS discount_percentage
FROM product p
JOIN product_vendor_map pvm ON pvm.product_id = p.product_id
JOIN product_vendor pv ON pvm.vendor_id = pv.vendor_id
WHERE product_name LIKE "%Panasonic%";

-- 1.1.2 Continue from 1.1.1, Show the rating score and helpful_rate_count of those products and sorted by weighting rating score and helpful_rate_count in descending order.
-- HINT: To weight the rating score, rating_star * helpful_rate_count
SELECT
	product_name,
    ROUND(AVG(r.rating_star), 2) AS avg_rating_star,
    ROUND(AVG(r.helpful_rate_count), 2) AS avg_helpful_rate_count
FROM product p
INNER JOIN review r ON r.product_id = p.product_id
WHERE product_name LIKE "%Panasonic%"
GROUP BY p.product_id
ORDER BY (avg_rating_star * avg_helpful_rate_count) DESC;

-- 1.1.3 Show the list of products where the product brand is equal to "LG" or "Blue Star" and the sub category is "Air Conditioners" 
SELECT
	product_name,
    product_description,
    pvm.price,
	pvm.discount_price,
    100-ROUND(discount_price/price*100, 2) AS discount_percentage,
    sub_category_name
FROM product p
JOIN product_vendor_map pvm ON pvm.product_id = p.product_id
INNER JOIN product_sub_category_map psm ON p.product_id = psm.product_id
INNER JOIN product_sub_category ps ON psm.sub_category_id = ps.sub_category_id
WHERE brand = "LG" OR "Blue Star" AND sub_category_name = "Air Conditioners";

-- 1.1.4 Show the list of Samsung products where the discount price is between 100 and 300 (Note that the discount price can be calculated by the price minus the discount column) and sorted the discount price by ascending order
SELECT
	product_name,
    product_description,
    pvm.price,
	pvm.discount_price,
    100-ROUND(discount_price/price*100, 2) AS discount_percentage
FROM product p
JOIN product_vendor_map pvm ON pvm.product_id = p.product_id
WHERE discount_price BETWEEN 100 AND 300
ORDER BY discount_price ASC;

-- 1.1.5 Show the product name and their details where their created and modified date is within the year 2022.
SELECT
	*
FROM product
WHERE YEAR(modified_at) = 2022;
    
-- ========================================================================================================= --
/* 1.2.1 Create/Insert new product with the following details (other columns just leave it blank for now)
         Product name: Elephant Stuffed Animal Toy Plushie
         Product description: Fluffy toy
         Product_thumbnail: https://m.media-amazon.com/images/I/41lrtqXPiWL._AC_UL399_.jpg
         Price: 23.50
         Brand: Lambs & Ivy
*/
SET @max_product_id = (SELECT MAX(product_id) FROM product);
INSERT INTO product(product_id, product_name, product_description, product_thumbnail, standard_price, brand)
VALUES(@max_product_id + 1, "Elephant Stuffed Animal Toy Plushie", "Fluffy toy", 'https://m.media-amazon.com/images/I/41lrtqXPiWL._AC_UL399_.jpg', 23.50, "Lambs & Ivy");

-- 1.2.2 Edit the brand name of all records where the brand is equal to "TOSHIBA" to "Toshiba".
UPDATE product
SET brand = "Toshiba"
WHERE brand = "TOSHIBA";

-- 1.2.3 Create the function to delete the product by passing the "product_id" on the parameter
-- Note that: You need to delete all of the product_id that has been deleted in other tables too.
DROP FUNCTION IF EXISTS delete_product;
DELIMITER //
CREATE FUNCTION delete_product(delete_product_id INTEGER)
RETURNS INTEGER
DETERMINISTIC
BEGIN
	SET SQL_SAFE_UPDATES = 0;
	SET FOREIGN_KEY_CHECKS = 0;
	IF EXISTS(
		SELECT * FROM product
        WHERE product_id = delete_product_id
    ) THEN
		DELETE FROM product WHERE product_id = delete_product_id;
        DELETE FROM product_vendor_map WHERE product_id = delete_product_id;
        DELETE FROM order_item WHERE product_id = delete_product_id;
		DELETE FROM product_department_map WHERE product_id = delete_product_id;
        DELETE FROM product_cart_map WHERE product_id = delete_product_id;
        DELETE FROM product_sub_category_map WHERE product_id = delete_product_id;
        DELETE FROM review WHERE product_id = delete_product_id;
		RETURN 1;
	ELSE
		RETURN 0;
	END IF;
	SET SQL_SAFE_UPDATES = 1;
	SET FOREIGN_KEY_CHECKS = 1;
END; //
DELIMITER ;
SELECT delete_product(2);

-- ========================================================================================================= --
/* 1.3.1 User id 10 want to create the review to product id 430 with this following details
         Rating star: 5
         Comment: Good! Must have item
         Review date: 2023-05-12
*/
SET @max_review_id = (SELECT MAX(review_id) FROM review);
INSERT INTO review(review_id, rating_star, comment, review_date, product_id)
VALUES(@max_review_id + 1, 5, "Good! Must have item", '2023-05-12', 430);

/* 1.3.2 Edit the 1.3.1 comment by updating the comment
         Comment: Good! Must-have item. I have used it since I was a high school student, currently, I am working, I still use it.
*/
UPDATE review
SET comment = "Good! Must-have item. I have used it since I was a high school student, currently, I am working, I still use it."
WHERE review_id = 25001;

-- 1.3.3  Delete the Review 1.3.1
DELETE FROM review
WHERE review_id = 25001;

-- ========================================================================================================= --
/* 1.4.1 Assuming that the product vendor “OceanOasis” (or vendor id 85) violates the set regulations of the company
by selling the prohibited products. With this action, all of his product vendor information and
any information related to him will be deleted.
*/
DROP FUNCTION IF EXISTS delete_vendor;
DELIMITER //
CREATE FUNCTION delete_vendor(delete_vendor_id INTEGER)
RETURNS INTEGER
DETERMINISTIC
BEGIN
    SET SQL_SAFE_UPDATES = 0;
    SET FOREIGN_KEY_CHECKS = 0;
    IF EXISTS(
        SELECT * FROM product_vendor
        WHERE vendor_id = delete_vendor_id
    ) THEN
        DELETE FROM product_vendor WHERE vendor_id = delete_vendor_id;
        DELETE FROM product_vendor_map WHERE vendor_id = delete_vendor_id;
        DELETE FROM order_item WHERE vendor_id = delete_vendor_id;
        DELETE FROM vendor_address WHERE vendor_id = delete_vendor_id;
        RETURN 1;
    ELSE
        RETURN 0;
    END IF;
    SET SQL_SAFE_UPDATES = 1;
    SET FOREIGN_KEY_CHECKS = 1;
END; //
DELIMITER ;
SELECT delete_vendor(85);

-- ========================================================================================================= --
/* 1.5.1 Assuming that comment that review id 1 has a rude word on the comment and should be deleted.
Therefore, you need to delete all of the reviews where it references to review id 1 to make
the website cleaner.
*/
DROP FUNCTION IF EXISTS delete_review;
DELIMITER //
CREATE FUNCTION delete_review(delete_review_id INTEGER)
RETURNS INTEGER
DETERMINISTIC
BEGIN
	SET SQL_SAFE_UPDATES = 0;
	SET FOREIGN_KEY_CHECKS = 0;
	IF EXISTS(
		SELECT * FROM review
        WHERE review_id = delete_review_id
    ) THEN
		DELETE FROM review WHERE review_id = delete_review_id;
        DELETE FROM review_image WHERE review_id = delete_review_id;
		RETURN 1;
	ELSE
		RETURN 0;
	END IF;
	SET SQL_SAFE_UPDATES = 1;
	SET FOREIGN_KEY_CHECKS = 1;
END; //
DELIMITER ;
SELECT delete_review(1);

-- ========================================================================================================= --
/* Create trigger if it has new user inserted with no created_at, then use today date */
DROP TRIGGER IF EXISTS add_new_user;
DELIMITER \\
CREATE TRIGGER add_new_user
BEFORE INSERT ON `user`
FOR EACH ROW
BEGIN
	DECLARE	chk_date	BOOLEAN;
    SET chk_date = (SELECT created_at FROM user WHERE user_id = NEW.user_id);
    IF(ISNULL(chk_date)) THEN
		SET NEW.created_at = NOW();
	END IF;
END; \\
DELIMITER ;

/* 2.1.1 Assuming that Kulawut is a new user, and he wants to register for an account with the following details.
         First lastname: Kulawut Makkamoltham
         Email: kulawut.mak@gmail.com
         Password: EaFgHyWbv
*/
SET @max_userid = (SELECT MAX(user_id) FROM user);
INSERT INTO `user`(user_id, first_name, last_name, email, password)
VALUES(@max_userid + 1, 'Kulawut', 'Makkamoltham', 'kulawut.mak@gmail.com', 'EaFgHyWbv');

-- DELETE FROM user
-- SELECT * FROM user WHERE user_id = '10001';

/*-----------------------
|	   	  User		    |
-------------------------*/
-- 2.1 Register
DROP PROCEDURE IF EXISTS `register_user`;
DELIMITER //
CREATE PROCEDURE `register_user` (IN first_name VARCHAR(255), IN last_name VARCHAR(255), IN email VARCHAR(255), IN password VARCHAR(255))
BEGIN
	DECLARE maxId INT;
	SET maxId = IF((SELECT max(user_id) FROM user), (SELECT max(user_id) FROM user) + 1, 1);
    INSERT INTO user (user_id, first_name, last_name, email, password, created_at) VALUES 
    (maxId, first_name, last_name, email, password, current_time());
END
//
DELIMITER ;

CALL register_user('Nobi', 'Nobita', 'nobi.nobi@gmail.com', 'atibon888!');

SELECT * FROM user;

-- 2.2 Login
-- Correct Login
SELECT * FROM USER WHERE email = "kulawut.mak@gmail.com" AND password = "EaFgHyWbv";
-- Incorrect password
SELECT * FROM USER WHERE email = "kulawut.mak@gmail.com" AND password = "EaFgHyWbcccc1111";

-- 2.3 See the order history of each customer
-- 2.3.1 Assuming that you logged in as “Tina Walker”, and you want to see the number of transaction statuses (Completed, Ongoing, Failed) 
-- sorted by the highest count. For instance, Completed 10 orders, Ongoing 3 orders, and Failed 2 orders.
-- This query is just for understanding on what we are trying to implement. Since a product can be sold by many vendors, the acutal query
-- will need to associate with product_vendor map table, see the query below.
SELECT od.order_detail_id, oi.order_item_id, p.product_name, oi.quantity, p.standard_price * oi.quantity AS total_price FROM order_item oi
JOIN order_detail od ON oi.order_detail_id = od.order_detail_id
JOIN product p ON oi.product_id = p.product_id
JOIN `user` u ON oi.user_id = u.user_id 
-- WHERE CONCAT(u.first_name, " ", u.last_name) = "Tina Walker" 
WHERE u.user_id = 237 And od.transaction_status = "Failed"
ORDER BY od.created_at;

-- The real query. Our generated data is not linking in the real world situation. In the real use, the price and vendor_id in the order_item will be derived
-- from the product_vendor, so these data will be the same.
SELECT od.order_detail_id, oi.order_item_id, p.product_name, oi.quantity, pvm.discount_price * oi.quantity AS total_price FROM order_item oi
JOIN order_detail od ON oi.order_detail_id = od.order_detail_id
JOIN product p ON oi.product_id = p.product_id
JOIN product_vendor_map pvm ON pvm.product_id = p.product_id AND pvm.vendor_id = oi.vendor_id
JOIN `user` u ON oi.user_id = u.user_id 
-- WHERE CONCAT(u.first_name, " ", u.last_name) = "Tina Walker" 
WHERE u.user_id = 237 And od.transaction_status = "Failed"
ORDER BY od.created_at;

-- 2.3.2 List all of the order history where the transaction status is equal to “Failed”.
SELECT od.transaction_status, COUNT(transaction_status) AS TotalStatus FROM order_item o
JOIN order_detail od ON o.order_detail_id = od.order_detail_id
JOIN `user` u ON o.user_id = u.user_id 
WHERE u.user_id = 237 And od.transaction_status = "Failed"
-- WHERE CONCAT(u.first_name, " ", u.last_name) = "Tina Walker" And od.transaction_status = "Failed"
GROUP BY od.transaction_status
ORDER BY transaction_status;


-- ========================================================================================================= --
/* 3.1.1 Assuming that you logged in as “Lori Hunt” (or user id 492), and you want to add product id 95 or
“Hitachi SPLIT AC - 1.0 Ton HITACHI SHIZEN 3100S INVERTER - R32 - RAPG312HFEOZ1 (Gold)” to his cart for 99 items.
*/
INSERT INTO product_cart_map
VALUES(95, 492, 99);
/* 

-- ========================================================================================================= --
/* 3.2.1 Assuming that you logged in as “Lori Hunt” (or user id 492), and you want to process the payment of all products in his cart.
Note that the result should show the product_name, quantity ordered, and discount price.
*/
SELECT
	product_name,
    quantity AS quantity_ordered,
    standard_price * quantity AS total_price
FROM product_cart_map pc
JOIN product p ON pc.product_id = p.product_id
WHERE cart_id = 492;

-- 3.2.2 Continue from 3.2.1., in this query return the summation of the price he needs to pay in total (Hint: Summation of 3.2.1.)
SELECT
    SUM(standard_price * quantity) AS total_price
FROM product_cart_map pc
JOIN product p ON pc.product_id = p.product_id
WHERE cart_id = 492;