
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
                 Cart_Number   INT  CHECK ( Cart_Number >= 1 AND Cart_Number <= 5 ),
                 Cart_Status   ENUM ( 'active' ,
                                      'blocked' ,
                                      'locked' )         NOT NULL  DEFAULT 'active'  ,
		     
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

-- ------------ PROCEDURE -------------- 

CREATE PROCEDURE calculate_price (client_id INT , Cart_num INT , Locked_num INT , OUT total_price DOUBLE) 
BEGIN  
DECLARE temp_price DOUBLE;
DECLARE  current_code INT ; 
DECLARE current_amount DOUBLE;
DECLARE current_limit DOUBLE;
DECLARE done BOOLEAN DEFAULT FALSE;
DECLARE L_code CURSOR FOR SELECT ACode FROM Applied_To A 
WHERE A.Cart_number = Cart_num AND A.Locked_number = Locked_num AND A.id = client_id ORDER BY A.Apply_Time ;
DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

SELECT SUM(Cart_price * Quantity ) INTO temp_price FROM Added_To A WHERE  A.Cart_number = Cart_num AND A.Locked_number = Locked_num AND A.id = client_id;
 
OPEN L_code;
CLOOP : LOOP
FETCH NEXT FROM L_code INTO current_code;
IF done THEN LEAVE CLOOP;
END IF;   

SELECT Amount, Dis_Limit INTO current_amount , current_limit FROM Discount_Code WHERE current_code = Dis_Code ;
IF(current_amount BETWEEN 1 AND 100 ) AND current_limit IS NOT NULL THEN 
	SET temp_price = temp_price - LEAST(current_limit,temp_price *( current_amount / 100)) ;
ELSEIF (current_amount BETWEEN 1 AND 100 ) AND current_limit IS NULL THEN
	SET temp_price = temp_price - temp_price *( current_amount / 100) ;
ELSEIF (current_amount > 100) THEN
	SET temp_price = temp_price - current_amount;	
END IF;
END LOOP;
CLOSE L_code;

IF temp_price < 0 THEN 
SET total_price = 0 ;
ELSE 
SET total_price = temp_price ;
END IF;
END; //

CREATE PROCEDURE Add_dicount_code ( client_id INT , new_amount DOUBLE , new_limit DOUBLE )
BEGIN

		 DECLARE  new_code INT;
         -- Dis_code --> AUTO_INCREMENT  Usage_count --> DEFAULT 1
          INSERT INTO Discount_Code (Amount , Dis_Limit  , Expiration_date)
		  VALUES ( new_amount , new_limit , DATE_ADD(NOW(), INTERVAL 1 WEEK ));
          
          SET new_code = LAST_INSERT_ID();
          
         -- Code_Time --> DEFAULT CURRENT_TIMESTAMP
          INSERT INTO  Private_Code ( Private_DCode , id  )
          VALUES ( new_cod , client_id );

END; //

CREATE PROCEDURE add_15percent_of_vip_clients () 
BEGIN
     DECLARE VIP_client_id INT;
     DECLARE cur_cart_number INT;
     DECLARE cur_locked_cart_number INT;
     DECLARE Price DOUBLE;
     DECLARE done BOOLEAN DEFAULT FALSE;
	 DECLARE cart_list CURSOR FOR SELECT  I.id ,  I.Cart_number ,  I.Locked_number 
     FROM VIP_Clients VIP , Issued_For I , Transactions T 
     WHERE VIP.id=I.id AND I.Tracking_code = T.Tracking_code AND T.T_Status='Successful' AND
     T.Transactions_time >= DATE_SUB( NOW() , INTERVAL 1 MONTH ) AND T.Transactions_time <= NOW()
	 AND VIP.Subscription_expiration_time >= NOW();
     
     DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
     
     OPEN cart_list;
    cart_loop : LOOP
	FETCH NEXT FROM cart_list INTO VIP_client_id , cur_cart_number , cur_locked_cart_number ;
	IF done THEN LEAVE cart_loop;
    END IF;   
       
       CALL calculate_price( VIP_client_id , cur_cart_number , cur_locked_cart_number , price );
       
       UPDATE clients 
       SET    Wallet_balance = Wallet_balance + ( price * 0.15 )
       WHERE  id=VIP_client_id;
	
    END LOOP;
    CLOSE cart_list;
    
END; //

CREATE PROCEDURE restore_products_and_block_carts() 
BEGIN

       DECLARE client_id INT;
       DECLARE c_num INT;
       DECLARE c_locked_num INT;
       DECLARE p_id INT;
       DECLARE product_quantity INT;
       DECLARE done BOOLEAN DEFAULT FALSE;
       DECLARE product_cart_list CURSOR FOR SELECT  A.id , A.Cart_number , A.Locked_number , A.Product_ID , A.Quantity
		FROM    Added_To A
		JOIN    Locked_Shopping_Cart L ON  A.id=L.id AND A.Cart_number=L.Cart_Number AND A.Locked_number=L.Locked_Cart_Number
		JOIN    ( SELECT id , Cart_Number , MAX(Locked_Time) AS Latest_time FROM Locked_Shopping_Cart GROUP BY id , Cart_Number ) AS L_cart 
				 ON L_cart.id=L.id AND L_cart.Cart_Number = L.Cart_Number AND L_cart.Latest_time= L.Locked_Time
		JOIN    Shopping_Cart S  ON  L_cart.id=S.id AND  L_cart.id.Cart_Number = S.Cart_Number
		WHERE   S.Cart_Status = 'locked' AND L.Locked_Time < NOW() - INTERVAL 3 DAY;
        DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
        
        
       OPEN product_cart_list;
       pc_loop : LOOP
               FETCH NEXT FROM product_cart_list INTO client_id , c_num , c_locked_num , p_id , product_quantity ;
               IF done THEN LEAVE pc_loop;
               END IF;   
   
               UPDATE Product 
               SET    Stock_count = Stock_count + product_quantity
               WHERE  id = p_id ;
               
               UPDATE Shopping_Cart
               SET    Cart_Status = 'blocked' 
               WHERE  id=client_id AND Cart_Number = c_num ; 

       END LOOP;
       CLOSE product_cart_list;

END; // 

CREATE PROCEDURE check_blocking_cart ( new_client_id INT , new_cart_num INT )
BEGIN
        DECLARE CartStatus ENUM ( 'active' ,
							      'blocked' ,
							       'locked' );
       
       SELECT Cart_Status INTO CartStatus FROM Shopping_Cart S WHERE S.id = new_client_id AND S.Cart_Number = new_cart_num ;
       
       IF ( CartStatus = 'blocked' ) THEN
           	SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'This cart is blocked !';
	 END IF;
END; //
-- ----------------------- TRIGGER ----------------------------

CREATE TRIGGER add_cart_for_clients AFTER INSERT ON clients  FOR EACH ROW
BEGIN
       -- Cart_Status --> DEFAULT active
       INSERT INTO Shopping_Cart ( id , Cart_Number )
       VALUES (NEW.id , 1 ) ;
END; //


CREATE TRIGGER add_cart_for_VIP_clients AFTER INSERT ON VIP_Clients  FOR EACH ROW
BEGIN
        -- Cart_Status --> DEFAULT active
        INSERT INTO Shopping_Cart ( id , Cart_Number )   
                    VALUES  (NEW.id , 2 ) ,
						    (NEW.id , 3 ) ,
                            (NEW.id , 4 ) ,
                            (NEW.id , 5 )  ;
END; //

CREATE TRIGGER check_blocked_cart_in_Added_To BEFORE INSERT ON Added_To FOR EACH ROW
BEGIN

    
      CALL check_blocking_cart ( NEW.id , NEW.Cart_number ) ;
    
END; //


CREATE TRIGGER check_blocked_cart_in_Issued_For BEFORE INSERT ON Issued_For FOR EACH ROW
BEGIN

    
      CALL check_blocking_cart ( NEW.id , NEW.Cart_number ) ;
    
END; //


CREATE TRIGGER decrease_wallet AFTER INSERT ON Issued_For FOR EACH ROW 
BEGIN

DECLARE TStatus ENUM  ( 'Successful',
							'UnSuccessful' ,
							'Partially_Successful') ;
DECLARE Price  DOUBLE ;
                            
SELECT T_Status INTO TStatus FROM Transactions T WHERE NEW.Tracking_code =T.Tracking_code;
IF TStatus = 'Successful' AND EXISTS (SELECT 1 FROM Wallet_Transactions W WHERE W.Tracking_code = NEW.Tracking_code) THEN 
CALL calculate_price(NEW.id , NEW.Cart_number, NEW.Locked_number , price);
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

END; //

CREATE TRIGGER check_blocked_cart_in_Applied_To BEFORE INSERT ON Applied_To FOR EACH ROW
BEGIN

    
      CALL check_blocking_cart ( NEW.id , NEW.Cart_number ) ;
    
END; //

CREATE TRIGGER management_of_referral AFTER INSERT ON  refers FOR EACH ROW 
BEGIN 
	   DECLARE  r_id INT;
       DECLARE  current_level INT DEFAULT 1;
       DECLARE  temp_amount DOUBLE;
	   DECLARE  temp_limit DOUBLE;
       
       CALL Add_dicount_code (NEW.Referee , 50 , 1000000 );
       
       SET r_id = NEW.Referrer ;
       
        WHILE r_id IS NOT NULL DO
          SET temp_amount= 50 / ( current_level * 2 );
          IF ( temp_amount < 1 ) THEN 
              SET temp_amount=50000;
              SET temp_limit=50000;
		 ELSE 
              SET temp_limit=1000000;
		 END IF;   
         
         CALL Add_dicount_code( r_id , temp_amount , temp_limit );
         
         IF EXISTS ( SELECT 1 FROM refers r WHERE r.Referee=r_id ) THEN
              SELECT  Referrer  INTO r_id  FROM refers r WHERE r.Referee = r_id ;
          ELSE 
              SET r_id = NULL ;
          END IF;
          SET current_level=current_level+1;
	
    END WHILE;
    
END; //
          

CREATE TRIGGER charge_wallet AFTER INSERT ON Deposits_Into_Wallet FOR EACH ROW
BEGIN 
        DECLARE TStatus ENUM  ( 'Successful',
							    'UnSuccessful' ,
							    'Partially_Successful') ;
		
        SELECT T_Status INTO TStatus FROM Transactions T WHERE T.Tracking_code=NEW.Tracking_code;
        
        IF(TStatus='Successful') THEN
          UPDATE clients c
          SET    Wallet_balance = Wallet_balance + NEW.Amount 
          WHERE  c.id=NEW.id;
		END IF;

END//

CREATE TRIGGER Check_inventory  BEFORE INSERT ON Added_To  FOR EACH ROW
BEGIN
       DECLARE StockCount INT;
       
       SELECT Stock_count INTO StockCount FROM Product P WHERE P.id = NEW.Product_ID ;      
       
       IF ( NEW.Quantity > StockCount  ) THEN
           	SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'This product is not available';
	 END IF;
END//

CREATE TRIGGER Product_Stock_Decrease  AFTER INSERT ON Added_To  FOR EACH ROW
BEGIN
		UPDATE Product P
        SET Stock_count = Stock_count - NEW.Quantity
		WHERE P.id = NEW.Product_ID ;
END//


CREATE TRIGGER add_to_VIP AFTER INSERT ON Subscribes FOR EACH ROW
BEGIN
       IF EXISTS ( SELECT 1 FROM VIP_Clients VIP WHERE VIP.id=NEW.id) THEN
          UPDATE VIP_Clients 
          SET  Subscription_expiration_time = DATE_ADD(NOW() , INTERVAL 1 MONTH )
          WHERE VIP.ID = NEW.id;
          
          UPDATE Shopping_Cart S
          SET    Cart_Status = 'active'
          WHERE  S.id = NEW.id AND ( Cart_Number >=2 AND Cart_Number <= 5 ) ;
          
	  ELSE
          INSERT INTO VIP_Clients ( id , Subscription_expiration_time )
          VALUES ( NEW.id , DATE_ADD(NOW() , INTERVAL 1 MONTH ) );
	END IF;
    
END; //

		     
CREATE TRIGGER decrease_wallet_for_sub AFTER INSERT ON Subscribes FOR EACH ROW
BEGIN
           DECLARE TStatus ENUM  ( 'Successful',
						        	'UnSuccessful' ,
							        'Partially_Successful') ;
		
	IF EXISTS ( SELECT 1 FROM Wallet_Transactions W WHERE W.Tracking_code = NEW.Tracking_code ) THEN
        SELECT T_Status INTO TStatus FROM Transactions T WHERE T.Tracking_code = NEW.Tracking_code;
		IF ( TStatus = 'Successful' ) THEN
            UPDATE clients c
            SET    Wallet_balance = Wallet_balance - 100000
            WHERE  c.id = NEW.id;
		END IF;
	END IF;

END; //
       

CREATE TRIGGER check_locked_cart BEFORE INSERT ON Locked_Shopping_Cart FOR EACH ROW
BEGIN

    DECLARE CartStatus ENUM ( 'active' ,
							  'blocked' ,
							  'locked' );
       
       SELECT Cart_Status INTO CartStatus FROM Shopping_Cart S WHERE S.id = NEW.id AND S.Cart_Number = NEW.Cart_Number ;
       
       IF ( CartStatus = 'blocked' OR CartStatus = 'locked' ) THEN
           	SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'This cart is not available';
	 END IF;
END; //


CREATE TRIGGER unlock_cart AFTER INSERT ON Issued_For FOR EACH ROW
BEGIN

    DECLARE TStatus ENUM  ( 'Successful',
							'UnSuccessful' ,
							'Partially_Successful') ;
	DECLARE IS_VIP_FLAG BOOLEAN DEFAULT FALSE;
    
    IF EXISTS ( SELECT VIP.id FROM VIP_Clients VIP WHERE VIP.id=NEW.id AND Subscription_expiration_time >= NOW() ) THEN
               SET IS_VIP_FLAG = TRUE ;
	END IF;
       SELECT T_Status INTO TStatus FROM Transactions T WHERE T.Tracking_code = NEW.Tracking_code ;
       
       IF ( TStatus = 'Successful' ) THEN
           	IF ( NEW.Cart_number >= 2 AND NEW.Cart_number <= 5 AND IS_VIP_FLAG = FALSE ) THEN
                 UPDATE  Shopping_Cart S
                 SET     Cart_Status =  'blocked'
                 WHERE   S.id = NEW.id AND S.Cart_Number = NEW.Cart_Number ;
		   ELSE 
                 UPDATE  Shopping_Cart S
                 SET     Cart_Status = 'active'
                 WHERE   S.id = NEW.id AND S.Cart_Number = NEW.Cart_Number ;
		END IF;		
	 END IF;
END; //


CREATE TRIGGER check_count_of_carts BEFORE INSERT ON Shopping_Cart FOR EACH ROW
BEGIN
       DECLARE IS_VIP_FLAG BOOLEAN DEFAULT FALSE;
       DECLARE count_of_carts INT;
     IF EXISTS ( SELECT VIP.id FROM VIP_Clients VIP WHERE VIP.id=NEW.id AND Subscription_expiration_time >= NOW() ) THEN
               SET IS_VIP_FLAG = TRUE ;
     END IF;
     
     IF(IS_VIP_FLAG = TRUE ) THEN
        SELECT COUNT(*) INTO count_of_carts FROM Shopping_Cart S WHERE S.id = NEW.id;
        IF ( count_of_carts >= 5 ) THEN
		   SIGNAL SQLSTATE '45000'
			SET MESSAGE_TEXT = 'VIP users can have only five carts!';
		END IF;
	ELSE 
         IF ((EXISTS ( SELECT 1 FROM Shopping_Cart S WHERE S.id = NEW.id AND S.Cart_number = 1 )) OR NEW.Cart_number <> 1 ) THEN
			SIGNAL SQLSTATE '45000'
			SET MESSAGE_TEXT = 'NOT VIP users can have only one cart!';
		END IF;
	END IF;

END; //



        

-- ------------------------ EVENT --------------------------

SET GLOBAL event_scheduler = ON;

CREATE EVENT add_15percent
ON SCHEDULE
	EVERY 1 MONTH STARTS
	CURRENT_DATE + INTERVAL 1 MONTH
	ON COMPLETION PRESERVE
DO
    CALL add_15percent_of_vip_clients() ;    
    


CREATE EVENT check_VIP_end
ON SCHEDULE
	EVERY 1 DAY STARTS
	CURRENT_DATE + INTERVAL 1 DAY
	ON COMPLETION PRESERVE
DO

    UPDATE  Shopping_Cart
    SET     Cart_Status =  'blocked' 
    WHERE   ( Cart_Number >= 2 AND Cart_Number <= 5 ) AND Cart_Status <> 'locked' AND 
			id IN ( SELECT V.id FROM VIP_Clients V WHERE  V.Subscription_expiration_time < NOW() ) ;
            


        
CREATE EVENT block_after_3days
ON SCHEDULE
	EVERY 1 DAY STARTS
	CURRENT_DATE + INTERVAL 1 DAY
	ON COMPLETION PRESERVE
DO
   
    CALL restore_products_and_block_carts();
    

CREATE EVENT unlock_after_7days
ON SCHEDULE
	EVERY 1 DAY STARTS
	CURRENT_DATE + INTERVAL 1 DAY
	ON COMPLETION PRESERVE
DO
    UPDATE Shopping_Cart S
    JOIN ( SELECT id , Cart_Number , MAX(Locked_Time) AS Latest_time FROM Locked_Shopping_Cart GROUP BY id , Cart_Number) AS L_cart
    ON S.id = L_cart.id AND S.Cart_Number=L_cart.Cart_Number
    SET    S.Cart_Status = 'active' 
    WHERE  S.Cart_Status='blocked' AND L_cart.Latest_time < NOW() - INTERVAL 10 DAY AND S.id NOT IN ( SELECT V.id FROM VIP_Clients V WHERE  V.Subscription_expiration_time < NOW() ) ;
                              


