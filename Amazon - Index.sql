-- Product
ALTER TABLE product ADD INDEX (brand);
ALTER TABLE product ADD FULLTEXT product_description_idx (product_description);
ALTER TABLE product ADD FULLTEXT product_name_idx (product_name);
CREATE INDEX price ON product(price);

DROP INDEX price ON product;

SHOW INDEX IN product;

-- User
ALTER TABLE user ADD INDEX (email, password);