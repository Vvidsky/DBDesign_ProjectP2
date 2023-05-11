-- Product
ALTER TABLE product ADD INDEX (brand);
ALTER TABLE product ADD FULLTEXT product_description_idx (product_description);
ALTER TABLE product ADD FULLTEXT product_name_idx (product_name);

SHOW INDEX IN product;