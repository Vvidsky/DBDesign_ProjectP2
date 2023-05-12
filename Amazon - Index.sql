-- Product
ALTER TABLE product ADD INDEX (brand);
ALTER TABLE product ADD FULLTEXT product_description_idx (product_description);
ALTER TABLE product ADD FULLTEXT product_name_idx (product_name);
ALTER TABLE product ADD INDEX (price);

SHOW INDEX IN product;

-- Review
CREATE FULLTEXT INDEX fulltext_comment ON review(comment);

-- User
CREATE INDEX authentication ON user(email, password);

-- Product_vendor
CREATE INDEX authentication ON Product_vendor(email, password);