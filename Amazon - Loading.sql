SHOW VARIABLES LIKE "secure_file_priv";

-- moves the csv files into the folder of path secure_file_priv
LOAD DATA 
	INFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/product.csv" INTO TABLE product
	FIELDS TERMINATED BY ',' ENCLOSED BY '"'
	LINES TERMINATED BY '\r\n'
	IGNORE 1 LINES;

LOAD DATA 
	INFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/user.csv" INTO TABLE `user`
	FIELDS TERMINATED BY ',' ENCLOSED BY '"'
	LINES TERMINATED BY '\r\n'
	IGNORE 1 LINES;
    
LOAD DATA 
	INFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/user_address.csv" INTO TABLE user_address
	FIELDS TERMINATED BY ',' ENCLOSED BY '"'
	LINES TERMINATED BY '\r\n'
	IGNORE 1 LINES;
    
LOAD DATA 
	INFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/product_vendor.csv" INTO TABLE product_vendor
	FIELDS TERMINATED BY ',' ENCLOSED BY '"'
	LINES TERMINATED BY '\r\n'
	IGNORE 1 LINES;
    
LOAD DATA 
	INFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/cart.csv" INTO TABLE cart
	FIELDS TERMINATED BY ',' ENCLOSED BY '"'
	LINES TERMINATED BY '\r\n'
	IGNORE 1 LINES;
    

    
