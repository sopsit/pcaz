USE pcaz;

INSERT INTO clients (Phone_number, First_name, Last_name, Wallet_balance, Referral_code)
VALUES 
('09183456789', 'John', 'Smith', 1000000000 , 'JOHNDOE123'),
('09183455290', 'Mamad', 'Slv', 5000000, 'MAMADSLV456'),
('09123459587', 'Ema', 'Doe', 750000, 'EMAD789');

INSERT INTO address (id, Province, Remainder)
VALUES 
-- (1, 'Tehran', '123 miad Street'),
(2, 'Hamedan', 'Ostadan Street'),
(3, 'Zanjan', '789 Mehrane Street'),
(3 , 'Zanjan' , '790 Mehrane Street') ;

INSERT INTO refers (Referee, Referrer)
VALUES 
(2 , 1),
(3 , 2);

INSERT INTO Locked_Shopping_Cart (id, Cart_Number, Locked_Cart_Number)
VALUES 
(1, 1, 1),
(2, 1, 2),
(3, 1, 3);

INSERT INTO Transactions (Tracking_code)
VALUES 
('TR1234567'),
('TR9876543'),
('TR1231231');

INSERT INTO Subscribes (Tracking_code, id)
VALUES 
('TR9876543', 1);

INSERT INTO Bank_Transactions (Tracking_code, Card_number)
VALUES 
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
(20.0, 200.0, 2 , '2025-11-30 23:59:59');

INSERT INTO Public_Code (Public_DCode)
VALUES 
(6);


INSERT INTO Product (Category, Current_price, Stock_count, Brand, Model)
VALUES 
('Case', 50000, 10, 'NZXT', 'H510'),
('HDD', 80000 , 20, 'Seagate', 'Barracuda'),
('Power Supply', 10000 , 30 , 'Corsair', 'RM850x'),
('GPU', 50000 , 55 , 'NVIDIA', 'RTX 3080'),
('SSD', 120000 , 30, 'Samsung', '970 EVO'),
('RAM', 70000 , 25, 'Corsair', 'Vengeance LPX'),
('Motherboard', 150000 , 12, 'ASUS', 'ROG Strix Z590-E'),
('CPU', 1000000, 89 , 'Intel', 'Core i7'),
('Cooler', 125000 , 18, 'Cooler Master', 'Hyper 212');


INSERT INTO Added_To (id, Cart_number, Locked_number, Product_ID, Quantity, Cart_price)
VALUES 
(1, 1, 1, 1, 2 , 100000),
(1 , 1, 1, 2, 1 , 80000 ),
(2 , 1, 2 , 3 , 1 , 10000 );

INSERT INTO Applied_To (id, Cart_number, Locked_number, ACode)
VALUES 
(1, 1, 1, 2);

INSERT INTO Issued_For (Tracking_code, id, Cart_number, Locked_number)
VALUES 
('TR1234567', 1, 1, 1);


INSERT INTO Case_p (id, Number_of_fans, Fan_size, Wattage, CASE_Type, Material, Color, Height, Width, Depth)
VALUES 
(1, 2, 120, 10.5, 'Mid Tower', 'Steel', 'Black', 480, 200, 450);

INSERT INTO HDD (id, Rotational_speed, Capacity, Wattage, Height, Width, Depth)
VALUES 
(2, 7200, 1000, 6.8, 26.1, 101.6, 147);

INSERT INTO POWER_SUPPLY (id, Supported_wattage, Height, Width, Depth)
VALUES 
(3, 850, 86, 150, 160);

INSERT INTO GPU (id, Clock_speed, Ram_size, Wattage, Number_of_fans, Height, Width, Depth)
VALUES 
(4, 1440, 10, 320, 3, 112, 285, 40);

INSERT INTO SSD (id, Wattage, Capacity)
VALUES 
(5, 5, 500);

INSERT INTO RAM_STICK (id, Frequency, Generation, Capacity, Wattage, Height, Width, Depth)
VALUES 
(6, 3200, 'DDR4', 16, 1.2, 31.25, 133.35, 7);

INSERT INTO MOTHERBOARD (id, Number_of_memory_slots, Memory_speed_range, Chipset, Wattage, Height, Width, Depth)
VALUES 
(7, 4, 'DDR4-3200', 590, 50, 305, 244, 30);

INSERT INTO CPU_P (id, Maximum_addressable_memory_limit, Boost_frequency, Base_frequency, Number_of_cores, Number_of_Threads, Wattage, Generation, Microarchitecture)
VALUES 
(8, 128, 5000, 3600, 8, 16, 125, '11th Gen', 14);

INSERT INTO COOLER (id, Maximum_rotational_speed, Fan_size, Height, Width, Wattage, Cooling_method, Depth)
VALUES 
(9, 2000, 120, 158.8, 120, 15, 'Air', 120);

INSERT INTO CC_SOCKET_COMPATIBLE_WITH (Cooler_ID, CPU_ID)
VALUES 
(9, 8);

INSERT INTO MC_SOCKET_COMPATIBLE_WITH (CPU_ID, Motherboard_ID)
VALUES 
(8, 7);

INSERT INTO RM_SLOT_COMPATIBLE_WITH (Ram_ID, Motherboard_ID)
VALUES 
(6 , 7);

INSERT INTO GM_SLOT_COMPATIBLE_WITH (GPU_ID, Motherboard_ID)
VALUES 
(4, 7);

INSERT INTO SM_SLOT_COMPATIBLE_WITH (SSD_ID, Motherboard_ID)
VALUES 
(5, 7);

INSERT INTO CONNECTOR_COMPATIBLE_WITH (GPU_ID, Power_ID)
VALUES 
(4, 3);




