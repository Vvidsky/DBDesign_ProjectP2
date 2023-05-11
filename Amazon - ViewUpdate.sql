/*-----------------------
|		 Product		|
-------------------------*/

-- 1.1 Show the list of products with their detail
SELECT * FROM product_list WHERE department_name = "appliances";

-- 1.2 Create/Edit/Delete the products
-- INSERT INTO product VALUES
-- (3001, `AMPEREUS RO Double Wrench Spanner-2 in 1 Model-Suited for 10" Pre Filter Housing and Membrane Housing (White)`, `Amazing wrench spanner`, `https://m.media-amazon.com/images/W/IMAGERENDERING_521856-T1/images/I/51dAgAPbRaL._AC_UL320_.jpg`, 259, 80, "AMPEREUS", "18 x 75 x 95", DATETIME("2017-06-25 00:33:50"), DATETIME("2019-06-25 00:33:50"));

-- UPDATE product SET discount = 300 WHERE product_id = 2;

-- DELETE FROM product WHERE product_id = 3002;
-- -- 1.3 Create/Edit/Delete the review description and image of each product
-- INSERT INTO review VALUES
-- (25001);


-- 1.4 Delete the product


-- 1.5 Delete the review


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


-- 2.3 See the order history of each customer
SELECT * FROM order_history WHERE transaction_status = "Ongoing";

/*-----------------------
|	   	 Shopping    	|
-------------------------*/
-- 3.1 Add product to the cart

-- 3.2 Process the payment