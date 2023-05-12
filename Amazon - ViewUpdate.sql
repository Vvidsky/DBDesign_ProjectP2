/*-----------------------
|		 Product		|
-------------------------*/
-- 1.1 Show the lists of products with their details
-- 1.1.1 Show the list of products and their details whose product name includes the word "Panasonic".
SELECT
	product_name,
    product_description,
    product_thumbnail,
    price,
	(price - discount) AS discount_price,
    ROUND(discount/price*100, 2) AS discount_percentage
FROM product
WHERE product_name LIKE "%Panasonic%"
GROUP BY product_id;

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
    price,
	(price - discount) AS discount_price,
    ROUND(discount/price*100, 2) AS discount_percentage,
    sub_category_name
FROM product p
INNER JOIN product_sub_category_map psm ON p.product_id = psm.product_id
INNER JOIN product_sub_category ps ON psm.sub_category_id = ps.sub_category_id
WHERE brand = "LG" OR "Blue Star" AND sub_category_name = "Air Conditioners";

-- 1.1.4 Show the list of Samsung products where the discount price is between 100 and 300 (Note that the discount price can be calculated by the price minus the discount column) and sorted the discount price by ascending order
SELECT
	product_name,
    product_description,
    price,
	(price - discount) AS discount_price,
    ROUND(discount/price*100, 2) AS discount_percentage
FROM product
WHERE (price - discount) BETWEEN 100 AND 300
ORDER BY (price - discount) ASC;

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
INSERT INTO product(product_id, product_name, product_description, product_thumbnail, price, brand)
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
        DELETE FROM `order` WHERE product_id = delete_product_id;
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
		SELECT * FROM product
        WHERE vendor_id = delete_vendor_id
    ) THEN
		DELETE FROM product_vendor WHERE vendor_id = delete_vendor_id;
        DELETE FROM product_vendor_map WHERE vendor_id = delete_vendor_id;
        DELETE FROM product WHERE vendor_id = delete_vendor_id;
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
SELECT * FROM USER WHERE email = "arel.Gomer@hotmail.com" AND password = "JxQ0G3j";
-- Incorrect password
SELECT * FROM USER WHERE email = "arel.Gomer@hotmail.com" AND password = "abcdef";

-- 2.3 See the order history of each customer
-- 2.3.1 Assuming that you logged in as “Tina Walker”, and you want to see the number of transaction statuses (Completed, Ongoing, Failed) 
-- sorted by the highest count. For instance, Completed 10 orders, Ongoing 3 orders, and Failed 2 orders.
SELECT od.order_detail_id, oi.order_item_id, p.product_name, oi.quantity, p.price * oi.quantity AS total_price FROM `order` o 
JOIN order_item oi ON o.order_item_id = oi.order_item_id
JOIN order_detail od ON o.order_detail_id = od.order_detail_id
JOIN product p ON o.product_id = p.product_id
JOIN `user` u ON o.user_id = u.user_id 
-- WHERE CONCAT(u.first_name, " ", u.last_name) = "Tina Walker" 
WHERE u.user_id = 237 And od.transaction_status = "Failed"
ORDER BY od.created_at;

-- 2.3.2 List all of the order history where the transaction status is equal to “Failed”.
SELECT od.transaction_status, COUNT(transaction_status) AS TotalStatus FROM `order` o 
JOIN order_detail od ON o.order_detail_id = od.order_detail_id
JOIN `user` u ON o.user_id = u.user_id 
WHERE CONCAT(u.first_name, " ", u.last_name) = "Tina Walker" And od.transaction_status = "Failed"
GROUP BY od.transaction_status
ORDER BY transaction_status;


/*-----------------------
|	   	 Shopping    	|
-------------------------*/
-- 3.1 Add product to the cart

-- 3.2.1 Assuming that you logged in as “Lori Hunt”, and you want to process the payment of all products in his cart. Note that the result should show the product_name, quantity ordered, and price (each).
SELECT p.product_name, pm.quantity, p.price
FROM product p
JOIN product_cart_map pm ON p.product_id = pm.product_id
JOIN cart c ON c.cart_id = pm.cart_id
JOIN `user` u ON c.user_id = u.user_id 
WHERE u.user_id = 492;
-- WHERE CONCAT(u.first_name, " ", u.last_name) = "Lori Hunt";


-- 3.2.2 Continue from 3.2.1., in this query return the summation of the price he needs to pay in total (Hint: Summation of 3.2.1.)
SELECT SUM(pm.quantity * p.price) AS total
FROM product p
JOIN product_cart_map pm ON p.product_id = pm.product_id
JOIN cart c ON c.cart_id = pm.cart_id
JOIN `user` u ON c.user_id = u.user_id 
WHERE u.user_id = 492;
-- WHERE CONCAT(u.first_name, " ", u.last_name) = "Lori Hunt";

SELECT * FROM `user` u WHERE CONCAT(u.first_name, " ", u.last_name) = "Lori Hunt";

