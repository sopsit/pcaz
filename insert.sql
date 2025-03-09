USE pcaz;

INSERT INTO clients (Phone_number, First_name, Last_name, Wallet_balance, Referral_code)
VALUES 
('09183456789', 'John', 'Smith', 1500000000 , 'JOHNDOE123'),
('09183455290', 'Mamad', 'Slv', 5000000, 'MAMADSLV456'),
('09123459587', 'Ema', 'Doe', 750000, 'EMAD789');

INSERT INTO address (id, Province, Remainder)
VALUES 
(1, 'Tehran', '123 miad Street'),
(2, 'Hamedan', 'Ostadan Street'),
(3, 'Zanjan', '789 Mehrane Street'),
(3 , 'Zanjan' , '790 Mehrane Street') ;

INSERT INTO refers (Referee, Referrer)
VALUES 
(2 , 1),
(3 , 2);


INSERT INTO Transactions (Tracking_code , Transactions_time)
VALUES 
('TR1234567' , NOW()),
('TR9876543', NOW()),
('Transaction3' , NOW()),
('TR1231231' , NOW());

INSERT INTO Subscribes (Tracking_code, id)
VALUES 
('TR9876543', 1);

INSERT INTO Locked_Shopping_Cart (id, Cart_Number, Locked_Cart_Number , Locked_Time)
VALUES 
(1, 1, 1 , NOW()),
(2, 1, 2 , NOW() ),
(3, 1, 3 , NOW()),
(1 , 2 , 4 , NOW());

INSERT INTO Bank_Transactions (Tracking_code, Card_number)
VALUES 
('Transaction3' , '123') ,
('TR1231231', '585980123456');

INSERT INTO Wallet_Transactions (Tracking_code)
VALUES 
('TR1234567'),
('TR9876543');


INSERT INTO Deposits_Into_Wallet (Tracking_code, id, Amount)
VALUES 
('TR1231231', 2 , 10000);


INSERT INTO Discount_Code (Amount, Dis_Limit, Usage_count, Expiration_date)
VALUES 
(200.0, 200.0, 2 , '2025-11-30 23:59:59');


INSERT INTO Public_Code (Public_DCode)
VALUES 
(6);


INSERT INTO Product (Category, Current_price, Stock_count, Brand, Model)
VALUES 
('Power Supply', 10000 , 30 , 'Corsair', 'RM850x'), -- 1
('Power Supply', 20000 , 55 , 'Corsair', '750W'), -- 2
('GPU', 50000 , 35 , 'NVIDIA', 'RTX 3080'),  -- 3
('GPU', 50000 , 12 , 'NVIDIA', 'RTX 5080'),  -- 4
('GPU', 20000 , 45 , 'AMD', 'RTX 3090'), -- 5
('SSD', 120000 , 30, 'Samsung', 'MX'), -- 6
('SSD', 125000 , 70 , 'Samsung', 'MX700'), -- 7
('Case', 50000, 10, 'NZXT', 'H510'), -- 8
('RAM', 70000 , 25, 'Corsair', 'Vengeance LPX'), -- 9
('RAM', 80000 , 80 , 'Corsair', '8GB'), -- 10
('Motherboard', 150000 , 12, 'ASUS', 'ROG Strix Z590-E'), -- 11
('Motherboard', 180000 , 90 , 'MSI', 'B500'), -- 12
('CPU', 1000000, 89 , 'Intel', 'Core i7'), -- 13
('CPU' , 1200 , 20 , 'brand1' , 'model1'), -- 14
('HDD', 80000 , 20, 'Seagate', 'Barracuda'), -- 15
('Cooler', 125000 , 18, 'Cooler Master', 'Hyper 212'); -- 16




INSERT INTO Added_To (id, Cart_number, Locked_number, Product_ID, Quantity, Cart_price)
VALUES 
(1, 1, 1, 1, 2 , 10000),
(1 , 1, 1, 3 , 1 , 50000 ),
(1 , 2 , 4 , 7 , 10 , 125000 ) ,
(2 , 1, 2 , 15 , 1 , 80000 );

INSERT INTO Applied_To (id, Cart_number, Locked_number, ACode , Apply_Time)
VALUES 
  (1, 2 , 4 , 2 , NOW()) ,
 (1 ,1 , 1 , 5 ,  NOW() - interval 1 DAY) ,
 (1,1,1,6, '2024-02-05 23:59:59') ;

INSERT INTO Issued_For (Tracking_code, id, Cart_number, Locked_number)
VALUES 
('Transaction3' , 1 , 2 , 4 ) ,
('TR1234567', 1, 1, 1);



INSERT INTO Case_p (id, Number_of_fans, Fan_size, Wattage, CASE_Type, Material, Color, Height, Width, Depth)
VALUES 
(8 , 2, 120, 10.5, 'Mid Tower', 'Steel', 'Black', 480, 200, 450);

INSERT INTO HDD (id, Rotational_speed, Capacity, Wattage, Height, Width, Depth)
VALUES 
(15 , 7200, 1000, 6.8, 26.1, 101.6, 147);

INSERT INTO POWER_SUPPLY (id, Supported_wattage, Height, Width, Depth)
VALUES 
(1 , 850, 90 , 180 , 160),
(2 , 800 , 86, 150, 130);

INSERT INTO GPU (id, Clock_speed, Ram_size, Wattage, Number_of_fans, Height, Width, Depth)
VALUES 
(3 , 1340, 10, 320, 3, 112, 290, 40),
(4, 1500, 10, 350, 2, 115 , 285, 55),
(5 , 1000 , 10, 320, 5 , 112, 300, 80);

INSERT INTO SSD (id, Wattage, Capacity)
VALUES 
(6, 5, 500) ,
(7, 2 , 500);

INSERT INTO RAM_STICK (id, Frequency, Generation, Capacity, Wattage, Height, Width, Depth)
VALUES 
(9 , 2000 , 'DDR4', 16, 1.2, 31.25, 100.35, 11),
(10 , 3200, 'DDR4', 20 , 1.2, 35.25, 157.25, 10);

INSERT INTO MOTHERBOARD (id, Number_of_memory_slots, Memory_speed_range, Chipset, Wattage, Height, Width, Depth)
VALUES 
(11 , 5 , 'DDR4-3200', 590, 50, 305, 244, 30),
(12 , 8 , 'DDR4-3200', 570 , 50, 315, 240 , 30);

INSERT INTO CPU_P (id, Maximum_addressable_memory_limit, Boost_frequency, Base_frequency, Number_of_cores, Number_of_Threads, Wattage, Generation, Microarchitecture)
VALUES 
(13 , 128, 5000, 3600, 8, 16, 125, '11th', 14) ,
 (14 , 128 , 5000 , 12 , 4 , 8 ,11 , '11th', 15 );

INSERT INTO COOLER (id, Maximum_rotational_speed, Fan_size, Height, Width, Wattage, Cooling_method, Depth)
VALUES 
(16 , 2000, 120, 158.8, 120, 15, 'Air', 120);

INSERT INTO CC_SOCKET_COMPATIBLE_WITH (Cooler_ID, CPU_ID)
VALUES 
(16 , 14);


INSERT INTO RM_SLOT_COMPATIBLE_WITH (Ram_ID, Motherboard_ID)
VALUES 
(10 , 11),
(9 , 12);

INSERT INTO GM_SLOT_COMPATIBLE_WITH (GPU_ID, Motherboard_ID)
VALUES 
(3 , 12),
(4 , 11),
(5 , 11);

INSERT INTO SM_SLOT_COMPATIBLE_WITH (SSD_ID, Motherboard_ID)
VALUES 
(6 , 12),
(7 , 11);

INSERT INTO CONNECTOR_COMPATIBLE_WITH (GPU_ID, Power_ID)
VALUES
(5 , 2), 
(4 , 1);

INSERT INTO MC_SOCKET_COMPATIBLE_WITH (CPU_ID, Motherboard_ID)
VALUES 
(13 , 11);




