DROP DATABASE IF EXISTS tanksdb;
CREATE DATABASE tanksdb;

USE tanksdb;

CREATE TABLE users (
	username VARCHAR(30) NOT NULL,
    pass VARCHAR(50) NOT NULL,
    email VARCHAR(50) NOT NULL,
    wins INT(10) NOT NULL
);