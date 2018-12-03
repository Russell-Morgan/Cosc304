--DROP TABLES
DROP TABLE Articles;
DROP TABLE Candidate;
DROP TABLE PoliticalParty;
DROP TABLE ArtOrder;
DROP TABLE Author;
DROP TABLE Cart;


DROP TABLE Account;

CREATE TABLE Account (
	UserID INT,
	UserName VARCHAR(20) NOT NULL,
	Password VARCHAR(20) NOT NULL,
	FirstName VARCHAR(20) NOT NULL,
	LastName VARCHAR(20) NOT NULL,
	Address VARCHAR(50),
	email VARCHAR(50) NOT NULL,
	Age int NOT NULL,
	isAdmin BIT,
	PRIMARY KEY (UserID)
);

CREATE TABLE Cart (
CartID INT,
UserId INT,
PRIMARY KEY(CartID),
CONSTRAINT FK_CART_Account FOREIGN KEY(UserID) References Account(UserId)
							ON UPDATE CASCADE
							ON DELETE NO ACTION
);

CREATE TABLE Author(
	UserID INT,
	Earnings DECIMAL(9,2),
	PRIMARY KEY (UserID),
	CONSTRAINT FK_Author_USERID FOREIGN KEY(USERID) References Account(UserID)
								ON DELETE NO ACTION 
								ON UPDATE NO ACTION
);


CREATE TABLE ArtOrder(
ArticleID int,
CartID int,
Price DECIMAL(6,2),
PRIMARY KEY(ArticleID, CartID),
FOREIGN KEY(CartID) References Cart(CartID)
			ON DELETE NO ACTION 
			ON UPDATE NO ACTION
);

CREATE TABLE PoliticalParty(
	PartyName VARCHAR(30), 
	PRIMARY KEY(PartyName)
);

CREATE TABLE Candidate(
	CID INT, 
	Address VARCHAR(50),
	Position VARCHAR(10) CHECK(Position in ('PrimeMinister', 'MP', 'Premier', 'MLA', 'Mayor', 'Councilor')),
	FirstName VARCHAR(30),
	LastName VARCHAR(30),
	PartyName VARCHAR(30),
	PRIMARY KEY(CID),
	CONSTRAINT FK_CANDIDATE_POLITICALPARTY FOREIGN KEY (PartyName) REFERENCES PoliticalParty(PartyName) 
							 			   ON DELETE NO ACTION 
										   ON UPDATE NO ACTION
);

CREATE TABLE Articles(
	ArticleID int,
	CID int,
	Views int,
	ArticleTitle VARCHAR(50),
	text VARCHAR(1500),
	Theme VarChar(15),
	ReleaseDate DATE,
	Price DECIMAL(10,2),
	IsSold BIT,
	Rating INT,
	UserID INT,
	OwnerID INT,
	Primary Key(ArticleID),
	CONSTRAINT FK_Articles_Author FOREIGN KEY (UserID) REFERENCES Author(UserID)
							  	  ON DELETE NO ACTION
						      	  ON UPDATE NO ACTION,
 	CONSTRAINT FK_Articles_Candidate FOREIGN KEY (CID) REFERENCES Candidate(CID) 
 								  	 ON DELETE NO ACTION 
 									 ON UPDATE NO ACTION,
 	CONSTRAINT FK_Articles_Account FOREIGN KEY (OwnerID) REFERENCES Account(UserID)
 									ON DELETE NO ACTION
 									ON UPDATE NO ACTION
 );
 

 
 INSERT INTO Account VALUES (1, 'DandyMatt', 'DandyCandy', 'Matthew', 'Locklee', '777 Hahaha Street', 'dandy.matt@live.com', 24, 1);
 INSERT INTO Account VALUES (2, 'Mattew', 'pikachu', 'Matt', 'NumberTwo', '666 wastreet', 'dandy.candy@fakeemail.com', 30, 0);
 INSERT INTO Account VALUES (3, '420potxJointMan', 'Lul', 'Jose', 'Noway', '123 toomany addreses street', 'ugh@ugh.com', 100, 0);
  INSERT INTO Account VALUES (4, 'admin', 'admin', 'Admin', 'Admin', '123 toomany addreses street', 'admin@admin.com', 100, 1);
 
 INSERT INTO Author VALUES (1,1);
 INSERT INTO Author VALUES (2, 0.25);
 INSERT INTO Author VALUES (3, 420);
 
 INSERT INTO Cart VALUES (1, 1);
 INSERT INTO Cart VALUES (2, 2);
 INSERT INTO Cart VALUES (3, 3);
 INSERT INTO Cart VALUES (4,4);
 
 INSERT INTO ArtOrder VALUES(1,1,5);
 INSERT INTO ArtOrder VALUES(2,2,5);
 INSERT INTO ArtOrder VALUES(3,3,5);

 
INSERT INTO PoliticalParty VALUES ('Green Party');
INSERT INTO PoliticalParty VALUES ('Republican Party');
INSERT INTO PoliticalParty VALUES ('Democratic Party');
INSERT INTO PoliticalParty VALUES ('Rhinoceros Party');
INSERT INTO PoliticalParty VALUES ('Liberal Party');
INSERT INTO PoliticalParty VALUES ('Matthew''s dope Party');

DECLARE @CID int
INSERT INTO Candidate VALUES (1, '256 Hastings Ave', 'Mayor', 'Matthew', 'Lockhart', 'Green Party');
INSERT INTO Candidate VALUES (2, '123 John Snow Road', 'MLA', 'Russell', 'Morgan', 'Rhinoceros Party');
INSERT INTO Candidate VALUES (3, '555 Yellow Brick Rd', 'Councilor', 'Carla', 'Mathers', 'Liberal Party');

 INSERT INTO Articles VALUES (1,2, 0, 'Russell Is left handed, GROSS','At a young age, he was hated
 among his peers, because of his challenge. He is left handed. :(', 'Horror', '2018-11-29',5, 0, 0, 1, null );
 INSERT INTO Articles VALUES (2,2, 0, 'Russell Was a Bully in highschool','testtesttest', 'Psychological', '2018-11-28',5, 1, 0, 1,3 );
 INSERT INTO Articles VALUES (3,3, 0, 'Matthew Is Exhausted','testetestestests', 'Truth', '2018-11-27',5, 1, 0, 3,1 );
 INSERT INTO Articles VALUES (6,3, 0, 'Article 2','testetestestests', 'Truth', '2018-11-26',5, 0, 0, 2,null );
 INSERT INTO Articles VALUES (7,1, 0, 'Article 3','testetestestests', 'Truth', '2018-11-25',5, 0, 0, 3,null );
 INSERT INTO Articles VALUES (8,3, 0, 'Article 4','testetestestests', 'Truth', '2018-11-24',5, 0, 0, 2,null );
 INSERT INTO Articles VALUES (9,1, 0, 'Article 5','testetestestests', 'Truth', '2018-11-23',5, 0, 0, 2,null );
 INSERT INTO Articles VALUES (10,2, 0, 'Article 6','testetestestests', 'Truth', '2018-11-22',5, 0, 0, 1,null );
 INSERT INTO Articles VALUES (4,2, 0, 'Makes COSC 304 Designed To','testetestestsetestsetests', 'Drama', '2018-11-21',5, 1, 0, 3,2 );
 INSERT INTO Articles VALUES (5,3, 0, 'Carla Said WHAT?!','tesssssssssssssstttt', 'Horror', '2018-11-20',5, 1, 0, 2,2 );

