CREATE DATABASE peysaz;

USE peysaz;

CREATE TABLE clients 
             ( id         INT       PRIMARY KEY			AUTO_INCREMENT ,
               Phone_number         CHAR(11)            NOT NULL       UNIQUE ,
               First_name           VARCHAR(30)         NOT NULL       ,
               Last_name            VARCHAR(30)         NOT NULL       ,
               Wallet_balance       INT                 NOT NULL      DEFAULT 0  CHECK(Wallet_balance >= 0),
               C_time                DATETIME           NOT NULL      DEFAULT CURRENT_TIMESTAMP ,
               Referral_code        VARCHAR(20)         NOT NULL      UNIQUE );

CREATE TABLE address
             ( id         INT       ,
               Province   VARCHAR(20) ,
               Remainder   VARCHAR(80) ,
               PRIMARY KEY (id , Province , Remainder ) ,
               FOREIGN KEY(id)	REFERENCES clients(id)	ON UPDATE CASCADE	ON DELETE CASCADE );

CREATE TABLE VIP_Clients
			( id        INT           PRIMARY KEY ,
              Subscription_expiration_time    DATETIME      NOT NULL   ,
              FOREIGN KEY(id)	REFERENCES clients(id)	ON UPDATE CASCADE	ON DELETE CASCADE  );

CREATE TABLE refers 
             ( Referee      INT        PRIMARY KEY ,
			   Referrer     INT        NOT NULL    ,
               FOREIGN KEY(Referee)	 REFERENCES clients(id)	ON UPDATE CASCADE	ON DELETE RESTRICT ,
               FOREIGN KEY(Referrer) REFERENCES clients(id)	ON UPDATE CASCADE	ON DELETE RESTRICT );

CREATE TABLE  Shopping_Cart 
               ( id           INT ,
                 Cart_Number   INT  ,
                 Cart_Status   ENUM ( 'free' ,
                                      'blocked' ,
                                      'locked' )         NOT NULL  DEFAULT 'free'  ,
		     
                   PRIMARY KEY ( id ,  Cart_Number ) ,
                   FOREIGN KEY(id) REFERENCES clients(id)	ON UPDATE CASCADE	ON DELETE RESTRICT );
                   
CREATE TABLE Locked_Shopping_Cart 
			( id           INT ,
              Cart_Number   INT  ,
              Locked_Cart_Number   INT    ,
              Locked_Time     DATETIME   NOT NULL   DEFAULT CURRENT_TIMESTAMP ,
              PRIMARY KEY( id , Cart_Number , Locked_Cart_Number ) ,
              FOREIGN KEY( id , Cart_Number ) REFERENCES Shopping_Cart(id ,  Cart_Number) ON UPDATE CASCADE	ON DELETE RESTRICT );


CREATE TABLE Transactions  
             ( Tracking_code         VARCHAR(20)          PRIMARY KEY  ,
               T_Status              ENUM                
                                     ( 'Successful',
                                        'UnSuccessful'   ,
									    'Partially_Successful'          )    NOT NULL      DEFAULT 'Successful'  ,
			 Transactions_time      DATETIME             NOT NULL      DEFAULT CURRENT_TIMESTAMP );
             
CREATE TABLE Bank_Transactions 
             ( Tracking_code            VARCHAR(20)            PRIMARY KEY ,
                Card_number             VARCHAR(16)            NOT NULL    ,
				FOREIGN KEY(Tracking_code) REFERENCES Transactions(Tracking_code)	ON UPDATE CASCADE	ON DELETE CASCADE );

CREATE TABLE Wallet_Transactions 
             ( Tracking_code   VARCHAR(20)            PRIMARY KEY ,
               FOREIGN KEY(Tracking_code) REFERENCES Transactions(Tracking_code)	ON UPDATE CASCADE	ON DELETE CASCADE );


CREATE TABLE  Issued_For 
              ( Tracking_code   VARCHAR(20)          PRIMARY KEY  ,
				id              INT  NOT NULL,
                Cart_number     INT NOT NULL,
                Locked_number   INT NOT NULL,
                FOREIGN KEY(Tracking_code) REFERENCES Transactions(Tracking_code)	ON UPDATE CASCADE	ON DELETE RESTRICT , 
                FOREIGN KEY(id , Cart_number , Locked_number) REFERENCES Locked_Shopping_Cart(id , Cart_Number , Locked_Cart_Number ) ON UPDATE CASCADE	ON DELETE RESTRICT);
                
CREATE TABLE  Deposits_Into_Wallet
              ( Tracking_code   VARCHAR(20)          PRIMARY KEY  ,
                id              INT  NOT NULL ,
                Amount          INT          NOT NULL    CHECK(Amount > 0) ,
			    FOREIGN KEY(Tracking_code) REFERENCES Bank_Transactions(Tracking_code)	ON UPDATE CASCADE	ON DELETE CASCADE ); 
                
CREATE TABLE  Subscribes 
              ( Tracking_code   VARCHAR(20)          PRIMARY KEY  ,
                id              INT                  NOT NULL ,
                FOREIGN KEY(Tracking_code) REFERENCES  Transactions(Tracking_code)	ON UPDATE CASCADE	ON DELETE CASCADE ,
                FOREIGN KEY(id)	REFERENCES clients(id)	ON UPDATE CASCADE	ON DELETE CASCADE );
                
CREATE TABLE Discount_Code 
             ( Dis_Code        VARCHAR(10)          PRIMARY KEY , 
               Amount          INT                  NOT NULL    CHECK(Amount > 0 ) ,
               Dis_Limit       INT                  NOT NULL    CHECK(Dis_Limit > 0 ) ,
               Usage_count     INT                  NOT NULL    CHECK(Usage_count > 0 ) ,
               Expiration_date   DATETIME                 NOT NULL  );
              
CREATE TABLE Private_Code 
             ( Private_DCode      VARCHAR(10)  PRIMARY KEY ,
			   id                 INT         NOT NULL    ,
               Code_Time           DATETIME   NOT NULL    DEFAULT CURRENT_TIMESTAMP ,
               FOREIGN KEY(Private_DCode) REFERENCES Discount_Code(Dis_Code)  ON UPDATE CASCADE	ON DELETE CASCADE ,
               FOREIGN KEY(id)	REFERENCES clients(id)	ON UPDATE CASCADE	ON DELETE CASCADE );
               
CREATE TABLE Public_Code  
             ( Public_DCode    VARCHAR(10)  PRIMARY KEY ,
			  FOREIGN KEY(Public_DCode) REFERENCES Discount_Code(Dis_Code) ON UPDATE CASCADE	ON DELETE CASCADE );
              
CREATE TABLE  Product 
              ( id         INT            PRIMARY KEY   AUTO_INCREMENT , 
                Category  VARCHAR(20)     NOT NULL   ,
                Image     BLOB ,
                Current_price   INT      NOT NULL    CHECK ( Current_price > 0 ) ,
                Stock_count     INT      NOT NULL    CHECK(Stock_count >= 0 ) ,
                Brand           VARCHAR(30)    NOT NULL  ,
                Model           VARCHAR(30)    NOT NULL );

CREATE TABLE  Added_To 
               ( id       INT ,
                 Cart_number    INT ,
                 Locked_number  INT ,
                 Product_ID     INT ,
                 Quantity       INT     NOT NULL  DEFAULT 1  CHECK ( Quantity > 0 ) ,
                 Cart_price     INT     NOT NULL  CHECK(Cart_price > 0),
                 PRIMARY KEY (id , Cart_number , Locked_number ,  Product_ID) ,
                 FOREIGN KEY(id , Cart_number , Locked_number ) REFERENCES Locked_Shopping_Cart(id , Cart_Number , Locked_Cart_Number ) ON UPDATE CASCADE ON DELETE CASCADE,
                 FOREIGN KEY(Product_ID)  REFERENCES Product(id) ON UPDATE CASCADE ON DELETE RESTRICT );
                 
CREATE TABLE Applied_To 
			( id       INT ,
			  Cart_number    INT ,
			  Locked_number  INT ,
              ACode         VARCHAR(10) ,
              Apply_Time    DATETIME    NOT NULL     DEFAULT CURRENT_TIMESTAMP ,
			 PRIMARY KEY (id , Cart_number , Locked_number ,  ACode) ,
			 FOREIGN KEY(id , Cart_number , Locked_number ) REFERENCES Locked_Shopping_Cart(id , Cart_Number , Locked_Cart_Number ) ON UPDATE CASCADE ON DELETE CASCADE,
             FOREIGN KEY(ACode) REFERENCES Discount_Code(Dis_Code) ON UPDATE CASCADE ON DELETE RESTRICT );
               
                
                
                              