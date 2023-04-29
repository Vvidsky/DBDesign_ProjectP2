SHOW VARIABLES LIKE "secure_file_priv";

-- moves the csv files into the folder of path secure_file_priv
LOAD DATA 
	INFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/product.csv" INTO TABLE product
	FIELDS TERMINATED BY ',' ENCLOSED BY '"'
	LINES TERMINATED BY '\r\n'
	IGNORE 1 LINES;
SELECT * FROM product;

LOAD DATA 
	INFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/user.csv" INTO TABLE `user`
	FIELDS TERMINATED BY ',' ENCLOSED BY '"'
	LINES TERMINATED BY '\r\n'
	IGNORE 1 LINES;
SELECT * FROM user;
    
LOAD DATA 
	INFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/user_address.csv" INTO TABLE user_address
	FIELDS TERMINATED BY ',' ENCLOSED BY '"'
	LINES TERMINATED BY '\r\n'
	IGNORE 1 LINES;
SELECT * FROM user_address;
    
LOAD DATA 
	INFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/product_vendor.csv" INTO TABLE product_vendor
	FIELDS TERMINATED BY ',' ENCLOSED BY '"'
	LINES TERMINATED BY '\r\n'
	IGNORE 1 LINES;
SELECT * FROM product_vendor;

LOAD DATA 
	INFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/vendor_address.csv" INTO TABLE vendor_address
	FIELDS TERMINATED BY ',' ENCLOSED BY '"'
	LINES TERMINATED BY '\r\n'
	IGNORE 1 LINES;
SELECT * FROM vendor_address;
    
LOAD DATA 
	INFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/cart.csv" INTO TABLE cart
	FIELDS TERMINATED BY ',' ENCLOSED BY '"'
	LINES TERMINATED BY '\r\n'
	IGNORE 1 LINES;
SELECT * FROM cart;

LOAD DATA 
	INFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/product_cart_map.csv" INTO TABLE product_cart_map
	FIELDS TERMINATED BY ',' ENCLOSED BY '"'
	LINES TERMINATED BY '\r\n'
	IGNORE 1 LINES;
SELECT * FROM product_cart_map;

LOAD DATA 
	INFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/payment_method.csv" INTO TABLE payment_method
	FIELDS TERMINATED BY ',' ENCLOSED BY '"'
	LINES TERMINATED BY '\r\n'
	IGNORE 1 LINES;
SELECT * FROM payment_method;

LOAD DATA 
	INFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/order_item.csv" INTO TABLE order_item
	FIELDS TERMINATED BY ',' ENCLOSED BY '"'
	LINES TERMINATED BY '\r\n'
	IGNORE 1 LINES;
SELECT * FROM order_item;

LOAD DATA 
	INFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/order_detail.csv" INTO TABLE order_detail
	FIELDS TERMINATED BY ',' ENCLOSED BY '"'
	LINES TERMINATED BY '\r\n'
	IGNORE 1 LINES;
SELECT * FROM order_detail;





    

    
