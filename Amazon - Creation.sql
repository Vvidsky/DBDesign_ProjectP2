DROP DATABASE IF EXISTS Amazon;
CREATE DATABASE Amazon;
USE Amazon;

CREATE TABLE `Product` (
	product_id 				int PRIMARY KEY,
    product_name 			varchar(255) NOT NULL,
    product_description 	text(1000) NOT NULL, 
    product_thumbnail		varchar(255) NOT NULL,
    brand					varchar(255),
    standard_price			decimal(10, 2),
    dimension				varchar(255),
    created_at				datetime,
    modified_at				datetime
) ENGINE=InnoDB;

CREATE TABLE `Product_vendor`(
	vendor_id			int PRIMARY KEY,
    vendor_name			varchar(255) UNIQUE,
    vendor_description 	text,
    business_domain		varchar(255),
    thumbnail_profile	varchar(255),
    email				varchar(255),
    password			varchar(255),
    phone_number		varchar(20),
    is_verified			bool
) ENGINE=InnoDB;

CREATE TABLE `Vendor_address`(
	vendor_address_id int PRIMARY KEY,
    first_name	varchar(255),
    last_name  varchar(255),
    street		varchar(255),
    city		varchar(255),
    zipcode		varchar(255),
    country		varchar(255),
    home_phone	varchar(255),
    vendor_id	int,
    FOREIGN KEY (vendor_id) REFERENCES Product_vendor(vendor_id)
) ENGINE=InnoDB;

CREATE TABLE `Product_vendor_map` (
	product_id			int,
	vendor_id			int,
    list_date			date,
    price				decimal(10, 2),
    discount_price		decimal(10, 2),
    
    PRIMARY KEY (product_id, vendor_id),
    FOREIGN KEY (product_id) REFERENCES Product(product_id), 
    FOREIGN KEY (vendor_id) REFERENCES Product_vendor(vendor_id)
);

CREATE TABLE `User`(
	user_id 		int PRIMARY KEY,
    first_name 		varchar(255) NOT NULL,
    last_name		varchar(255) NOT NULL,
    is_prime_member	bool,
    email			varchar(255) UNIQUE NOT NULL,
    password		varchar(255),
    created_at		datetime,
    modified_at		datetime,
    pin				char(6),
    currency		char(3),
    birthdate		date
) ENGINE=InnoDB;

CREATE TABLE `User_address`(
	user_address_id	int PRIMARY KEY,
    first_name		varchar(255),
    last_name		varchar(255),
    street			varchar(255),
    city			varchar(255),
    zipcode			varchar(255),
    country			varchar(255),
    mobile_phone	varchar(20),
    user_id			int,
    FOREIGN KEY (user_id) REFERENCES User(user_id)
) ENGINE=InnoDB;

CREATE TABLE `Payment_method`(
	payment_method_id	int,
    payment_method_name	enum('Credit Card', 'Debit Card', 'Paypal', 'Venmo'),
    credit_card			varchar(19),		# Maximum number of card number length
    user_id				int,
    PRIMARY KEY (payment_method_id, user_id),
    CONSTRAINT fk_payment_method_user_user_id FOREIGN KEY (user_id) REFERENCES User(user_id)
) ENGINE=InnoDB;

CREATE TABLE `Order_detail`(
	order_detail_id			int PRIMARY KEY,
    transaction_status		ENUM('Completed', 'Ongoing', 'Failed'),
    created_at				datetime,
    modified_at				datetime,
    payment_date			datetime,
    estimated_delivery_date	date,
    receive_date			date,
    comment					text,
	shipping_fee			decimal(10,2),
    tax_rate				decimal(10,2),
    user_id					int,
	payment_method_id		int,
    
    CONSTRAINT fk_order_detail_user_id FOREIGN KEY (user_id) REFERENCES `user`(user_id),
    CONSTRAINT fk_order_detail_payment_method_id FOREIGN KEY (payment_method_id) REFERENCES payment_method(payment_method_id)
) ENGINE=InnoDB;

CREATE TABLE `Order_item`(
	order_item_id	int PRIMARY KEY,
    quantity		int,
    price_each		double,
    created_at		datetime,
    modified_at		datetime,
    
	order_detail_id	int NOT NULL,
	user_address_id	int,
    product_id		int,
    user_id			int,
    vendor_id		int,
	
    CONSTRAINT fk_order_order_detail_id FOREIGN KEY (order_detail_id) REFERENCES Order_detail(order_detail_id),
    CONSTRAINT fk_order_user_address_id FOREIGN KEY (user_address_id) REFERENCES User_address(user_address_id),
    CONSTRAINT fk_order_product_id FOREIGN KEY (product_id) REFERENCES Product(product_id), 
    CONSTRAINT fk_order_user_id FOREIGN KEY (user_id) REFERENCES `User`(user_id) ,
	CONSTRAINT fk_order_vendor_id FOREIGN KEY (vendor_id) REFERENCES `Product_vendor`(vendor_id) 
) ENGINE=InnoDB;

CREATE TABLE `Review`(
	review_id		 	int PRIMARY KEY,
    rating_star			tinyint NOT NULL,
    comment				text,
    review_date			date NOT NULL,
    helpful_rate_count	smallint,
    product_id			int,
    user_id				int,
    CONSTRAINT fk_review_product_product_id FOREIGN KEY (product_id) REFERENCES Product(product_id),
    CONSTRAINT fk_revice_user_user_id FOREIGN KEY (user_id) REFERENCES User(user_id)
) ENGINE=InnoDB;

CREATE TABLE `Review_image`(
	review_id		int,
    review_image	varchar(255),
    PRIMARY KEY (review_id, review_image),
    CONSTRAINT fk_review_image_review_id FOREIGN KEY (review_id) REFERENCES Review(review_id) 
) ENGINE=InnoDB;

CREATE TABLE `Cart`(
	cart_id		int NOT NULL PRIMARY KEY,
    modified_at	datetime,
    user_id		int,
	CONSTRAINT fk_cart_user_id FOREIGN KEY(user_id) REFERENCES `User`(user_id)
) ENGINE=InnoDB;

CREATE TABLE `Product_cart_map` (
	product_id	int,
    cart_id		int,
    quantity	int,
    
    PRIMARY KEY(product_id, cart_id),
    CONSTRAINT fk_product_cart_map_product_id FOREIGN KEY (product_id) REFERENCES Product(product_id),
    CONSTRAINT fk_product_cart_map_cart_id FOREIGN KEY (cart_id) REFERENCES Cart(cart_id)
) ENGINE=InnoDB;

CREATE TABLE `Product_department` (
	department_id	int PRIMARY KEY,
    department_name	VARCHAR(255) NOT NULL UNIQUE,
    created_at		datetime
) ENGINE=InnoDB;

CREATE TABLE `product_department_map` (
	product_id		int,
    department_id	int,
    
    PRIMARY KEY (product_id, department_id),
    CONSTRAINT fk_product_department_map_product_id FOREIGN KEY (product_id) REFERENCES Product(product_id),
    CONSTRAINT fk_product_department_map_department_id FOREIGN KEY (department_id) REFERENCES Product_department(department_id)
) ENGINE=InnoDB;

CREATE TABLE `Product_sub_category` (
	sub_category_id				int PRIMARY KEY,
    sub_category_name			VARCHAR(255),
    sub_category_description	VARCHAR(255),
    created_at					datetime,
    modified_at					datetime,
    department_id				int,
		
	CONSTRAINT fk_product_sub_category_department_id FOREIGN KEY (department_id) REFERENCES Product_department(department_id)
) ENGINE=InnoDB;

CREATE TABLE `product_sub_category_map` (
	product_id		int,
    sub_category_id	int,
    
    PRIMARY KEY (product_id, sub_category_id),
    CONSTRAINT fk_product_sub_category_map_product_id FOREIGN KEY (product_id) REFERENCES Product(product_id),
    CONSTRAINT fk_product_sub_category_map_sub_category_id_id FOREIGN KEY (sub_category_id) REFERENCES Product_sub_category(sub_category_id)
) ENGINE=InnoDB;

DROP PROCEDURE IF EXISTS `register_user`;
DELIMITER //
CREATE PROCEDURE `register_user` (IN first_name VARCHAR(255), IN last_name VARCHAR(255), IN email VARCHAR(255), IN password VARCHAR(255))
BEGIN
	DECLARE maxId INT;
	SET maxId = IF((SELECT max(user_id) FROM user), (SELECT max(user_id) FROM user) + 1, 1);
    INSERT INTO user (user_id, first_name, last_name, email, password) VALUES 
    (maxId, first_name, last_name, email, password);
END
//
DELIMITER ;