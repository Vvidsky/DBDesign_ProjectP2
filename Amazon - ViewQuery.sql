-- 1.1.1 Show the list of products and their details whose product name includes the word "Panasonic".= Product table
SELECT
	product_name,
    product_description,
    product_thumbnail,
    price,
	(price - discount) AS discount_price,
    ROUND(discount/price*100, 2) AS discount_percentage
FROM `product_list`
WHERE product_name LIKE "%Panasonic%"
GROUP BY product_id;

-- 1.1.2 Continue from 1.1.1, Show the rating score of those products and sorted rating_star in descending order. = Product table and Review table
SELECT
	product_name,
    ROUND(AVG(r.rating_star), 2) AS avg_rating_star,
    ROUND(AVG(r.helpful_rate_count), 2) AS avg_helpful_rate_count
FROM `product_list` p
INNER JOIN `review_list` r ON r.product_id = p.product_id
WHERE product_name LIKE "%Panasonic%"
GROUP BY p.product_id
ORDER BY (avg_rating_star * avg_helpful_rate_count) DESC;

-- 2.3.1 Assuming that you logged in as “Tina Walker”, and you want to see the number of transaction statuses (Completed, Ongoing, Failed) sorted by the highest count. For instance, Completed 10 orders, Ongoing 3 orders, and Failed 2 orders. = User table and Order_detail table
SELECT transaction_status, COUNT(order_detail_id) AS count_transaction_status
FROM `user_order`
WHERE CONCAT(first_name, ' ', last_name) = "Tina Sievewright"
GROUP BY transaction_status
ORDER BY count_transaction_status DESC;

-- 2.2.2 Assuming that you are Nearlyded, and he wants to log in to his new account with the following details. Please show all of his information. = Product_vendor table
SELECT *
FROM `product_vendor_list`
WHERE vendor_name = "Nearlyded";

-- 2.3.2 List all of the order history where the transaction status is equal to “Failed”. = Order_detail table and Payment_method table
SELECT
	payment_method_name,
    count(payment_method_id) AS count_payment_name
FROM `user_order`
WHERE transaction_status = "Failed"
GROUP BY payment_method_name
ORDER BY count_payment_name DESC;

-- 1.1.5 Show the product name and their details where their created and modified date is within the year 2022. = Product table
SELECT
	*
FROM `product_list`
WHERE YEAR(modified_at) = 2022;