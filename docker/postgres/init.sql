CREATE DATABASE app_testing;
CREATE USER user_testing WITH ENCRYPTED PASSWORD 'password_testing';
GRANT ALL PRIVILEGES ON DATABASE app_testing TO user_testing;
