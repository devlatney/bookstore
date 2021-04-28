DROP TABLE Books;
DROP TABLE Publishers;
DROP TABLE People;
DROP TABLE Roles;
DROP TABLE PersonToRole;
DROP TABLE Passwords;

CREATE TABLE Books(
ISBN13 		nvarchar(13) primary key,
title 		nvarchar(50),
year 		int,
isbn 		nvarchar(10),
weight 		float,
binding 	nvarchar(40),
pages 		int,
language 	nvarchar(20),
publisher 	nvarchar(40)
);

CREATE TABLE Publishers(
publisherID	int primary key,
name 		nvarchar(75),
city 		nvarchar(50),
State 		nvarchar(10),
Country 	nvarchar(50)
);

CREATE TABLE People(
id 			nvarchar(40) primary key,
firstname 	nvarchar(25),
lastname 	nvarchar(30),
email 		nvarchar(50),
isadmin		int
);

CREATE TABLE Roles(
roleid 		nvarchar(40) primary key,
roletitle 	nvarchar(25) 
);

CREATE TABLE PersonToRole(
ptrid 		nvarchar(40),
bookid 		nvarchar(13),
personid 	nvarchar(40)
);

CREATE TABLE Passwords(
personId	nvarchar(40) primary key,
password	nvarchar(64) 
);