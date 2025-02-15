CREATE DATABASE peysaz;

USE peysaz;

CREATE TABLE clients 
             ( id         			INT       PRIMARY KEY			AUTO_INCREMENT ,
               Phone_number         CHAR(11)            NOT NULL       UNIQUE ,
               First_name           VARCHAR(30)         NOT NULL       ,
               Last_name            VARCHAR(30)         NOT NULL       ,
               Wallet_balance       INT                 NOT NULL      DEFAULT 0  CHECK(Wallet_balance >= 0),
               C_time               DATETIME            NOT NULL      DEFAULT CURRENT_TIMESTAMP ,
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
               FOREIGN KEY(Referee)	 REFERENCES clients(id)	ON UPDATE CASCADE	ON DELETE CASCADE ,
               FOREIGN KEY(Referrer) REFERENCES clients(id)	ON UPDATE CASCADE	ON DELETE CASCADE );

CREATE TABLE  Shopping_Cart 
               ( id           INT ,
                 Cart_Number   INT  ,
                 Cart_Status   ENUM ( 'acctive' ,
                                      'blocked' ,
                                      'locked' )         NOT NULL  DEFAULT 'acctive'  ,
		     
                   PRIMARY KEY ( id ,  Cart_Number ) ,
                   FOREIGN KEY(id) REFERENCES clients(id)	ON UPDATE CASCADE	ON DELETE CASCADE );
                   
CREATE TABLE Locked_Shopping_Cart 
			( id           INT ,
              Cart_Number   INT  ,
              Locked_Cart_Number   INT    ,
              Locked_Time     DATETIME   NOT NULL   DEFAULT CURRENT_TIMESTAMP ,
              PRIMARY KEY( id , Cart_Number , Locked_Cart_Number ) ,
              FOREIGN KEY( id , Cart_Number ) REFERENCES Shopping_Cart(id ,  Cart_Number) ON UPDATE CASCADE	ON DELETE CASCADE );


CREATE TABLE Transactions  
             ( Tracking_code         VARCHAR(20)          PRIMARY KEY  ,
               T_Status              ENUM                
                                     ( 'Successful',
                                        'UnSuccessful',
									    'Partially_Successful')    NOT NULL      DEFAULT 'Successful'  ,
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
                FOREIGN KEY(id , Cart_number , Locked_number) REFERENCES Locked_Shopping_Cart(id , Cart_Number , Locked_Cart_Number ) ON UPDATE CASCADE	ON DELETE CASCADE);
                
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
             ( Dis_Code          INT           PRIMARY KEY AUTO_INCREMENT , 
               Amount            FLOAT         NOT NULL    CHECK(Amount > 0 ) ,
               Dis_Limit         FLOAT         NOT NULL    CHECK(Dis_Limit > 0 ) ,
               Usage_count       INT           NOT NULL    DEFAULT 1  CHECK(Usage_count > 0 )   ,
               Expiration_date   DATETIME    );
              
CREATE TABLE Private_Code 
             ( Private_DCode      INT         PRIMARY KEY ,
			   id                 INT         NOT NULL    ,
               Code_Time          DATETIME    NOT NULL    DEFAULT CURRENT_TIMESTAMP ,
               FOREIGN KEY(Private_DCode) REFERENCES Discount_Code(Dis_Code)  ON UPDATE CASCADE	ON DELETE CASCADE ,
               FOREIGN KEY(id)	REFERENCES clients(id)	ON UPDATE CASCADE	ON DELETE CASCADE );
               
CREATE TABLE Public_Code  
             ( Public_DCode    INT   PRIMARY KEY ,
			  FOREIGN KEY(Public_DCode) REFERENCES Discount_Code(Dis_Code) ON UPDATE CASCADE	ON DELETE CASCADE );
              
CREATE TABLE  Product 
              ( id         			INT            PRIMARY KEY   AUTO_INCREMENT , 
                Category  			VARCHAR(20)     NOT NULL   ,
                Image     			BLOB ,
                Current_price   	INT      NOT NULL    CHECK ( Current_price > 0 ) ,
                Stock_count     	INT      NOT NULL    CHECK(Stock_count >= 0 ) ,
                Brand           	VARCHAR(30)    NOT NULL  ,
                Model           	VARCHAR(30)    NOT NULL );

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
              ACode         INT ,
              Apply_Time    DATETIME    NOT NULL     DEFAULT CURRENT_TIMESTAMP ,
			 PRIMARY KEY (id , Cart_number , Locked_number ,  ACode) ,
			 FOREIGN KEY(id , Cart_number , Locked_number ) REFERENCES Locked_Shopping_Cart(id , Cart_Number , Locked_Cart_Number ) ON UPDATE CASCADE ON DELETE CASCADE,
             FOREIGN KEY(ACode) REFERENCES Discount_Code(Dis_Code) ON UPDATE CASCADE ON DELETE RESTRICT );
               
CREATE TABLE Case_p
			 ( id			INT  PRIMARY KEY, 
             Number_of_fans INT, 
             Fan_size		INT,
             Wattage		FLOAT,
             CASE_Type 		VARCHAR(15),
             Material		VARCHAR(15),
             Color			VARCHAR(15),
             Height			INT,
             Width			INT,
             Depth			INT,
             FOREIGN KEY(id ) REFERENCES Product(id) ON UPDATE CASCADE ON DELETE CASCADE);
             
CREATE TABLE HDD
			 ( id			INT  PRIMARY KEY , 
             Rotational_speed INT, 
             Capacity		INT,
             Wattage		FLOAT,
             Height			INT,
             Width			INT,
             Depth			INT,
             FOREIGN KEY(id ) REFERENCES Product(id) ON UPDATE CASCADE ON DELETE CASCADE);
             
CREATE TABLE POWER_SUPPLY
			 ( id			INT  PRIMARY KEY, 
             Supported_wattage INT, 
             Height			INT,
             Width			INT,
             Depth			INT,
             FOREIGN KEY(id ) REFERENCES Product(id) ON UPDATE CASCADE ON DELETE CASCADE);
             
CREATE TABLE GPU
			 ( id			INT  PRIMARY KEY , 
             Clock_speed    INT, 
             Ram_size		INT,
             Wattage		FLOAT,
             Number_of_fans	INT,
             Height			INT,
             Width			INT,
             Depth			INT,
             FOREIGN KEY(id ) REFERENCES Product(id) ON UPDATE CASCADE ON DELETE CASCADE);  
CREATE TABLE SSD
			 ( id			INT , 
             Wattage		INT,
             Capacity		INT,
             PRIMARY KEY (id), 
             FOREIGN KEY(id ) REFERENCES Product(id) ON UPDATE CASCADE ON DELETE CASCADE);
             
CREATE TABLE RAM_STICK
			 ( id			INT  PRIMARY KEY, 
             Frequency      INT, 
             Generation		VARCHAR(10),
             Capacity		INT,
             Wattage		FLOAT,
             Height			INT,
             Width			INT,
             Depth			INT,
             FOREIGN KEY(id ) REFERENCES Product(id) ON UPDATE CASCADE ON DELETE CASCADE);
             
CREATE TABLE MOTHERBOARD
			 ( id			INT PRIMARY KEY, 
             Number_of_memory_slots      INT, 
             Memory_speed_range		VARCHAR(10),
             Chipset		INT,
             Wattage		FLOAT,
             Height			INT,
             Width			INT,
             Depth			INT,
             FOREIGN KEY(id ) REFERENCES Product(id) ON UPDATE CASCADE ON DELETE CASCADE);
             
CREATE TABLE CPU_P
			 ( id									INT  PRIMARY KEY, 
             Maximum_addressable_memory_limit       INT, 
             Boost_frequency						INT,
             Base_frequency							INT,
             Number_of_cores						INT,
             Number_of_Threads						INT,
             Wattage								FLOAT,
             Generation								VARCHAR(15),
             Microarchitecture						INT,
             FOREIGN KEY(id ) REFERENCES Product(id) ON UPDATE CASCADE ON DELETE CASCADE);
             
CREATE TABLE COOLER
			 ( id							INT  PRIMARY KEY, 
             Maximum_rotational_speed       INT, 
             Fan_size						INT,
             Height							INT,
             Width							INT,
             Wattage						FLOAT,
             Cooling_method					VARCHAR(15),
             Depth							INT,
             FOREIGN KEY(id ) REFERENCES Product(id) ON UPDATE CASCADE ON DELETE CASCADE);

CREATE TABLE CC_SOCKET_COMPATIBLE_WITH
			 ( Cooler_ID	 INT , 
				CPU_ID       INT, 
             PRIMARY KEY (Cooler_ID, CPU_ID), 
             FOREIGN KEY(Cooler_ID ) REFERENCES COOLER(id) ON UPDATE CASCADE ON DELETE CASCADE,
             FOREIGN KEY(CPU_ID ) REFERENCES CPU_P(id) ON UPDATE CASCADE ON DELETE CASCADE);
             
CREATE TABLE MC_SOCKET_COMPATIBLE_WITH
			 (  CPU_ID	 			INT , 
				Motherboard_ID       INT, 
				PRIMARY KEY (Motherboard_ID, CPU_ID), 
				FOREIGN KEY(CPU_ID ) REFERENCES CPU_P(id) ON UPDATE CASCADE ON DELETE CASCADE,
				FOREIGN KEY(Motherboard_ID ) REFERENCES MOTHERBOARD(id) ON UPDATE CASCADE ON DELETE CASCADE);
                
CREATE TABLE RM_SLOT_COMPATIBLE_WITH
			 (  Ram_ID	 			INT , 
				Motherboard_ID       INT, 
				PRIMARY KEY (Motherboard_ID, Ram_ID), 
				FOREIGN KEY(Ram_ID ) REFERENCES CPU_P(id) ON UPDATE CASCADE ON DELETE CASCADE,
				FOREIGN KEY(Motherboard_ID ) REFERENCES MOTHERBOARD(id) ON UPDATE CASCADE ON DELETE CASCADE);
                
CREATE TABLE GM_SLOT_COMPATIBLE_WITH
			 (  GPU_ID	 			INT , 
				Motherboard_ID       INT, 
				PRIMARY KEY (Motherboard_ID, GPU_ID), 
				FOREIGN KEY(GPU_ID ) REFERENCES GPU(id) ON UPDATE CASCADE ON DELETE CASCADE,
				FOREIGN KEY(Motherboard_ID ) REFERENCES MOTHERBOARD(id) ON UPDATE CASCADE ON DELETE CASCADE);
                
CREATE TABLE SM_SLOT_COMPATIBLE_WITH
			 (  SSD_ID	 			INT , 
				Motherboard_ID       INT, 
				PRIMARY KEY (Motherboard_ID, SSD_ID), 
				FOREIGN KEY(SSD_ID ) REFERENCES SSD(id) ON UPDATE CASCADE ON DELETE CASCADE,
				FOREIGN KEY(Motherboard_ID ) REFERENCES MOTHERBOARD(id) ON UPDATE CASCADE ON DELETE CASCADE);
                
CREATE TABLE CONNECTOR_COMPATIBLE_WITH
			 (  GPU_ID	 			INT , 
				Power_ID       INT, 
				PRIMARY KEY (Power_ID, GPU_ID), 
				FOREIGN KEY(GPU_ID ) REFERENCES GPU(id) ON UPDATE CASCADE ON DELETE CASCADE,
				FOREIGN KEY(Power_ID ) REFERENCES POWER_SUPPLY(id) ON UPDATE CASCADE ON DELETE CASCADE);
                

-- TRIGGERS

DELIMITER //

CREATE PROCEDURE apply_discount (client_id INT , Cart_num INT , Locked_num INT , OUT total_price DOUBLE) 
BEGIN  
DECLARE first_price DOUBLE;
DECLARE  current_code INT ; 
DECLARE current_amount DOUBLE;
DECLARE current_limit DOUBLE;
DECLARE L_code CURSOR FOR SELECT ACode FROM Applied_To A 
WHERE A.Cart_number = Cart_num AND A.Locked_number = Locked_num AND A.id = client_id ORDER BY A.Apply_Time ;
DECLARE CONTINUE HANDLER FOR NOT FOUND SET flag = TRUE;

SELECT SUM(Cart_price * Quantity ) INTO first_price FROM Added_To WHERE   Cart_number = Cart_num AND Locked_number = Locked_num AND id = client_id;
 
OPEN L_code;
CLOOP : LOOP
FETCH NEXT FROM L_code INTO current_code;
IF flag THEN LEAVE CLOOP;
END IF;   

SELECT Amount, Dis_Limit INTO current_amount , current_limit FROM Discount_Code WHERE current_code = Dis_Code ;
IF(current_amount BETWEEN 0 AND 100 ) AND current_limit IS NOT NULL THEN 
	SET first_price = first_price - LEAST(current_limit,first_price *( current_amount / 100)) ;
ELSEIF (current_amount BETWEEN 0 AND 100 ) AND current_limit IS NULL THEN
	SET first_price = first_price - (current_limit,first_price *( current_amount / 100)) ;
ELSEIF (current_amount > 100) THEN
	SET first_price = first_price - current_amount;	
END IF;
END LOOP;
CLOSE L_code;

IF first_price < 0 THEN 
SET total_price = 0 ;
ELSE 
SET total_price = first_price ;
END IF;
END; //

CREATE TRIGGER decrease_wallet AFTER INSERT ON Issued_For FOR EACH ROW 
BEGIN

DECLARE TStatus ENUM  ( 'Successful',
							'UnSuccessful' ,
							'Partially_Successful') ;
DECLARE Price  DOUBLE;
                            
SELECT T_Status INTO TStatus FROM Transactions T WHERE NEW.Tracking_code =T.Tracking_code;
IF TStatus = 'Successful' AND EXISTS (SELECT 1 FROM Wallet_Transactions W WHERE W.Tracking_code = NEW.Tracking_code) THEN 
CALL apply_discount (NEW.id , NEW.Cart_number, NEW.Locked_number , price);
UPDATE clients c
SET Wallet_balance = Wallet_balance - price
WHERE c.id = NEW.id;
END IF;
END;

CREATE TRIGGER discount_code_usage BEFORE INSERT ON Applied_To  FOR EACH ROW 
BEGIN
       DECLARE Max_usage INT;
	   DECLARE client_usage INT;
       
    SELECT  Usage_count INTO Max_usage FROM Discount_Code WHERE  Dis_Code = NEW.ACode ;
    SELECT COUNT(*) INTO client_usage FROM Applied_To WHERE id = NEW.id AND ACode = NEW.ACode ;
    
    IF ( client_usage >= Max_usage) THEN
       	SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'The limit of using this discount code has been reached.';
	END IF;
    

END//

CREATE TRIGGER discount_code_time  BEFORE INSERT ON Applied_To  FOR EACH ROW
BEGIN
       DECLARE edate DATETIME;
       
       SELECT Expiration_date INTO edate FROM Discount_Code WHERE Dis_Code = NEW.ACode ;
       
       IF ( edate < CURRENT_TIMESTAMP ) THEN
           	SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'This code has exxpired.';
	 END IF;

END//


CREATE TRIGGER management_of_referral AFTER INSERT ON  refers FOR EACH ROW 
BEGIN 
       DECLARE  referee_id INT;
       DECLARE  referrer_id INT;
	   DECLARE  new_code INT;
       DECLARE  current_level INT DEFAULT 0;
       DECLARE  new_amount FLOAT;
	   DECLARE  new_limit FLOAT;
       
       SET referee_id = NEW.Referee ;
       SET referrer_id=NEW.Referrer ;
       
       WHILE referee_id IS NOT NULL DO
		  SET new_amount = 50 / POW ( 2 , current_level);
          IF ( new_amount < 1 ) THEN 
              SET new_amount=50000;
              SET new_limit=50000;
		 ELSE 
              SET new_limit=1000000;
		 END IF;
       
          
          -- Dis_code --> AUTO_INCREMENT  Usage_count --> DEFAULT 1
          INSERT INTO Discount_Code (Amount , Dis_Limit  , Expiration_date)
		  VALUES ( new_amount , new_limit , DATE_ADD(NOW(), INTERVAL 1 WEEK ));
          
          SET new_code = LAST_INSERT_ID();
          
         -- Code_Time --> DEFAULT CURRENT_TIMESTAMP
          INSERT INTO  Private_Code ( Private_DCode , id  )
          VALUES ( new_cod , referee_id );
          
          IF EXISTS ( SELECT 1 FROM refers r WHERE r.Referee=referrer_id ) THEN
              SELECT Referee , Referrer  INTO referrer_id ,  referrer_id FROM refers r WHERE r.Referee = referrer_id ;
          ELSE 
              SET referrer_id = NULL ;
          END IF;
          SET current_level=current_level+1;
	
    END WHILE;
    
END//

CREATE TRIGGER Check_inventory  BEFORE INSERT ON Added_To  FOR EACH ROW
BEGIN
       DECLARE StockCount INT;
       
       SELECT Stock_count INTO StockCount FROM Product WHERE id = NEW.id ;
       
       IF ( StockCount < 0 ) THEN
           	SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'This product is not available';
	 END IF;
END//

CREATE TRIGGER Product_Stock_Decrease  AFTER INSERT ON Added_To  FOR EACH ROW
BEGIN
		UPDATE Product
        SET Stock_count = Stock_count - 1
		WHERE id = NEW.id ;
END//

CREATE TRIGGER check_and_update_date BEFORE INSERT ON VIP_Clients FOR EACH ROW
BEGIN
    IF EXISTS (SELECT id FROM VIP_Clients WHERE id = NEW.id) THEN
        UPDATE VIP_Clients
        SET Subscription_expiration_time = CURDATE()
        WHERE id = NEW.id;
    ELSE
        SET NEW.Subscription_expiration_time = CURDATE();
    END IF;
END//


CREATE TRIGGER check_locked_cart BEFORE INSERT ON Locked_Shopping_Cart FOR EACH ROW
BEGIN

    DECLARE CartStatus ENUM ( 'acctive' ,
							  'blocked' ,
							  'locked' );
       
       SELECT Cart_Status INTO CartStatus FROM Shopping_Cart WHERE id = NEW.id ;
       
       IF ( Cart_Status = 'blocked' ) THEN
           	SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'This cart is block';
	 END IF;
END//

CREATE TRIGGER convert_to_free AFTER INSERT ON Issued_For FOR EACH ROW
BEGIN

    DECLARE TStatus ENUM  ( 'Successful',
							'UnSuccessful' ,
							'Partially_Successful') ;
       
       SELECT T_Status INTO TStatus FROM Transactions WHERE Tracking_code = NEW.Tracking_code ;
       IF ( T_Status = 'Successful' ) THEN
           	UPDATE Shopping_Cart
			SET Cart_Status = 'acctive'
            WHERE Cart_Number = NEW.Cart_number AND NEW.id = id ;
	 END IF;
END//

CREATE TRIGGER one_or_five_cart BEFORE INSERT ON Locked_Shopping_Cart FOR EACH ROW
BEGIN

	   DECLARE count_cart INT ;
       SELECT COUNT(id) INTO count_cart FROM Locked_Shopping_Cart WHERE id = NEW.id ;
       
       IF ( count_cart > 0 and   EXISTS (SELECT id FROM VIP_Clients WHERE id = NEW.id AND ((NOW() - Subscription_expiration_time ) > '0000-01-00 00:00:00'))) THEN
           	SIGNAL SQLSTATE '45000'
			SET MESSAGE_TEXT = 'you already got one cart!';
	  END IF;
      IF ( count_cart > 4 and   EXISTS (SELECT id FROM VIP_Clients WHERE id = NEW.id AND ((NOW() - Subscription_expiration_time ) < '0000-01-00 00:00:00'))) THEN
			SIGNAL SQLSTATE '45000'
			SET MESSAGE_TEXT = 'you already got five cart!';
		END IF;
END//

CREATE EVENT unblocke_carts ON SCHEDULE EVERY 1 MINUTE STARTS '2025-03-00 00:00:00'
	DO
		UPDATE Shopping_Cart SET Cart_Status = 'acctive'
        WHERE (SELECT * FROM Locked_Shopping_Cart NATURAL JOIN  Shopping_Cart WHERE ((NOW() - Locked_Time ) > '0000-00-07 00:00:00') AND Cart_Status = 'blocked' 
				AND (EXISTS (SELECT id FROM VIP_Clients WHERE id = id AND ((NOW() - Subscription_expiration_time ) > '0000-01-00 00:00:00')) AND Cart_Number = 1));


CREATE EVENT after_3_days ON SCHEDULE EVERY 1 DAY STARTS '2025-03-00 00:00:00'
	DO
		DECLARE _Quantity INT DEFAULT 0;
        SELECT Quantity INTO _Quantity FROM (Locked_Shopping_Cart  L NATURAL JOIN Added_To) NATURAL JOIN Shopping_Cart  WHERE (((NOW() - Locked_Time) > '0000-00-03 00:00:00') AND (Cart_Status = 'locked'))
		UPDATE Product SET Stock_count = Stock_count + _Quantity WHERE id = Product_ID ;
		UPDATE Shopping_Cart  SET Cart_Status = 'acctive' WHERE id = L.id 
        



          



       
                              
