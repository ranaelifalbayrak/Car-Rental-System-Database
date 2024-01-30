DROP TABLE Customer CASCADE CONSTRAINTS;
DROP TABLE RentalContract CASCADE CONSTRAINTS;
DROP TABLE Vehicle CASCADE CONSTRAINTS;
DROP TABLE Staff CASCADE CONSTRAINTS;
DROP TABLE RentalRate CASCADE CONSTRAINTS;
DROP TABLE Receipt CASCADE CONSTRAINTS;
DROP TABLE Reservation;
DROP TABLE Maintenance CASCADE CONSTRAINTS;
DROP TABLE DamageRecord;
DROP TABLE Payroll CASCADE CONSTRAINTS;
DROP TABLE Schedule CASCADE CONSTRAINTS;
DROP TABLE CustomerEmail;
DROP TABLE CustomerPhoneNumber;
DROP TABLE StaffEmail;
DROP TABLE StaffPhoneNumber;


CREATE TABLE Customer (
    customer_id INT NOT NULL,
    first_name VARCHAR2(25) NOT NULL,
    last_name VARCHAR(25) NOT NULL,
    street VARCHAR2(100) NOT NULL,
    city VARCHAR2(40) NOT NULL,
    state VARCHAR2(40) NOT NULL,
    zip VARCHAR2(5) NOT NULL,
    CONSTRAINT Customer_customer_id_pk PRIMARY KEY(customer_id)
);


CREATE TABLE Vehicle(
    license_plate VARCHAR2(10) NOT NULL,
    make VARCHAR2(40) NOT NULL, 
    model VARCHAR2(40), 
    year NUMBER(4) NOT NULL, 
    transmission VARCHAR2(9) NOT NULL,
    fuel_type VARCHAR2(11) NOT NULL,
    daily_price INT NOT NULL,
    status VARCHAR2(20),
    CONSTRAINT Vehicle_license_plate_pk PRIMARY KEY(license_plate),
    CONSTRAINT chk_vehicle_status CHECK (status IN ('AVAILABLE', 'RENTED', 'MAINTENANCE', 'RESERVED')),
    CONSTRAINT chk_transmission CHECK (transmission IN ('MANUEL', 'AUTOMATIC')),
    CONSTRAINT chk_fuel_type CHECK (fuel_type IN ('PETROL', 'DIESEL', 'HYBRID', 'ELECTRICITY'))
   
);

CREATE TABLE Payroll(
    payroll_id INT NOT NULL, 
    salary INT NOT NULL, 
    pay_periods VARCHAR2(250) NOT NULL,
    CONSTRAINT Payroll_payroll_id_pk PRIMARY KEY(payroll_id)
);

CREATE TABLE Schedule(
    schedule_id INT NOT NULL,  
    work_hours VARCHAR2(40), 
    work_days VARCHAR2(100),
    CONSTRAINT Schedule_schedule_id_pk PRIMARY KEY(schedule_id)
);

CREATE TABLE Staff(
    staff_id INT NOT NULL, 
    first_name VARCHAR2(25) NOT NULL,
    last_name VARCHAR(25) NOT NULL, 
    position VARCHAR2(25) NOT NULL, 
    street VARCHAR2(40) NOT NULL,
    city VARCHAR2(40) NOT NULL,
    state VARCHAR2(40) NOT NULL,
    zip VARCHAR2(5) NOT NULL,
    payroll_id INT NOT NULL,
    schedule_id INT NOT NULL,
    CONSTRAINT Staff_staff_id_pk PRIMARY KEY(staff_id),
    CONSTRAINT Staff_payroll_id_fk FOREIGN KEY(payroll_id) REFERENCES Payroll(payroll_id) ON DELETE CASCADE,
    CONSTRAINT Staff_schedule_id_fk FOREIGN KEY(schedule_id) REFERENCES Schedule(schedule_id) ON DELETE CASCADE,
    CONSTRAINT chk_position CHECK (position IN ('SALES MANAGER', 'SALES', 'VALET', 'BACK-OFFICE', 'BACK-OFFICE MANAGER'))
    
);

CREATE TABLE RentalContract(
    rental_contract_id INT NOT NULL, 
    start_date DATE NOT NULL, 
    end_date DATE NOT NULL, 
    customer_id INT NOT NULL, 
    license_plate VARCHAR2(10) NOT NULL,
    staff_id INT NOT NULL,
    CONSTRAINT RentalContract_rental_contract_id_pk PRIMARY KEY(rental_contract_id),
    CONSTRAINT RentalContract_customer_id_fk FOREIGN KEY (customer_id) REFERENCES Customer(customer_id) ON DELETE CASCADE,
    CONSTRAINT RentalContract_license_plate_fk FOREIGN KEY (license_plate) REFERENCES Vehicle(license_plate) ON DELETE CASCADE,
    CONSTRAINT RentalContract_staff_id_fk FOREIGN KEY (staff_id) REFERENCES Staff(staff_id) ON DELETE CASCADE
);

CREATE TABLE RentalRate(
    rate_id VARCHAR2(20) NOT NULL, 
    rate FLOAT NOT NULL, 
    CONSTRAINT RentalRate_rate_id_pk PRIMARY KEY(rate_id),
    CONSTRAINT chk_rental_rate_id CHECK (rate_id IN ('DAILY','WEEKLY','MONTHLY')),
    CONSTRAINT chk_rental_rate_range CHECK (rate >= 0 AND rate <= 1)
);


CREATE TABLE Receipt(
    receipt_id INT NOT NULL,  
    payment_date DATE NOT NULL, 
    payment_method VARCHAR2(20) NOT NULL, 
    extra_charges FLOAT NOT NULL,
    rental_charge FLOAT NOT NULL, 
    total_charge FLOAT NOT NULL,
    rate_id VARCHAR2(20) NOT NULL,
    rental_contract_id INT NOT NULL,
    CONSTRAINT Receipt_receipt_id_pk PRIMARY KEY(receipt_id),
    CONSTRAINT Receipt_rate_id_fk FOREIGN KEY (rate_id) REFERENCES RentalRate(rate_id) ON DELETE CASCADE,
    CONSTRAINT Receipt_rental_contract_id_fk FOREIGN KEY (rental_contract_id) REFERENCES RentalContract(rental_contract_id) ON DELETE CASCADE,
    CONSTRAINT chk_payment_method CHECK (payment_method IN ('CASH', 'CREDIT CARD', 'DEBIT CARD'))

); 

CREATE TABLE Maintenance(
    maintenance_id INT NOT NULL, 
    maintenance_date DATE NOT NULL, 
    service_details VARCHAR2(250) NOT NULL, 
    license_plate VARCHAR2(10),
    CONSTRAINT Maintenance_maintenance_id_pk PRIMARY KEY(maintenance_id),
    CONSTRAINT Maintenance_license_plate_fk FOREIGN KEY(license_plate) REFERENCES Vehicle(license_plate) ON DELETE CASCADE
);

CREATE TABLE DamageRecord(
    damage_id INT NOT NULL, 
    date_reported DATE NOT NULL, 
    damage_description VARCHAR2(250) NOT NULL, 
    damage_cost INT NOT NULL, 
    rental_contract_id INT NOT NULL, 
    maintenance_id INT NOT NULL,
    CONSTRAINT DamageRecord_damage_id_pk PRIMARY KEY (damage_id),
    CONSTRAINT DamageRecord_rental_contract_id_fk FOREIGN KEY(rental_contract_id) REFERENCES RentalContract(rental_contract_id) ON DELETE CASCADE,
    CONSTRAINT DamageRecord_maintenance_id_fk FOREIGN KEY(maintenance_id) REFERENCES Maintenance(maintenance_id) ON DELETE CASCADE
);

CREATE TABLE Reservation(
    reservation_id INT NOT NULL, 
    reserved_from DATE NOT NULL, 
    reserved_to DATE NOT NULL, 
    customer_id INT NOT NULL, 
    license_plate VARCHAR2(10) NOT NULL,
    CONSTRAINT Reservation_reservation_id_pk PRIMARY KEY(reservation_id),
    CONSTRAINT Reservation_customer_id_fk FOREIGN KEY(customer_id) REFERENCES Customer(customer_id) ON DELETE CASCADE,
    CONSTRAINT Reservation_license_plate FOREIGN KEY(license_plate) REFERENCES Vehicle(license_plate) ON DELETE CASCADE
);

CREATE TABLE CustomerEmail(
    customer_id INT NOT NULL,
    email VARCHAR2(100) NOT NULL,
    CONSTRAINT CustomerEmail_pk PRIMARY KEY(customer_id,email),
    CONSTRAINT CustomerEmail_customer_id_fk FOREIGN KEY(customer_id) REFERENCES Customer(customer_id) ON DELETE CASCADE,
    CONSTRAINT CustomerEmail_email_uk UNIQUE (email)
);

CREATE TABLE CustomerPhoneNumber(
    customer_id INT NOT NULL,
    phone_number VARCHAR2(12) NOT NULL,
    CONSTRAINT CustomerPhoneNumber_pk PRIMARY KEY(customer_id,phone_number),
    CONSTRAINT CustomerPhoneNumber_customer_id_fk FOREIGN KEY(customer_id) REFERENCES Customer(customer_id) ON DELETE CASCADE,
    CONSTRAINT CustomerPhoneNumber_phone_number_uk UNIQUE (phone_number)
);

CREATE TABLE StaffEmail(
    staff_id INT NOT NULL,
    email VARCHAR2(100) NOT NULL,
    CONSTRAINT StaffEmail_pk PRIMARY KEY(staff_id,email),
    CONSTRAINT StaffEmail_staff_id_fk FOREIGN KEY(staff_id) REFERENCES Staff(staff_id) ON DELETE CASCADE,
    CONSTRAINT StaffEmail_email_uk UNIQUE (email)
);

CREATE TABLE StaffPhoneNumber(
    staff_id INT NOT NULL,
    phone_number VARCHAR2(12) NOT NULL,
    CONSTRAINT StaffPhoneNumber_pk PRIMARY KEY(staff_id,phone_number),
    CONSTRAINT StaffPhoneNumber_staff_id_fk FOREIGN KEY(staff_id) REFERENCES Staff(staff_id) ON DELETE CASCADE,
    CONSTRAINT StaffPhoneNumber_phone_number_uk UNIQUE (phone_number)
);



CREATE OR REPLACE TRIGGER customer_zip_validate
BEFORE INSERT OR UPDATE ON Customer
FOR EACH ROW
BEGIN
    IF NOT REGEXP_LIKE(:new.zip, '^[0-9]{5}$') THEN
        RAISE_APPLICATION_ERROR(-20001, 'Invalid ZIP code format');
    END IF;
END;
/
CREATE OR REPLACE TRIGGER staff_zip_validate
BEFORE INSERT OR UPDATE ON Staff
FOR EACH ROW
BEGIN
    IF NOT REGEXP_LIKE(:new.zip, '^[0-9]{5}$') THEN
        RAISE_APPLICATION_ERROR(-20001, 'Invalid ZIP code format');
    END IF;
END;
/
CREATE OR REPLACE TRIGGER vehicle_year_validation
BEFORE INSERT OR UPDATE ON Vehicle
FOR EACH ROW
BEGIN
    IF :new.year > EXTRACT(YEAR FROM SYSDATE) OR :new.year < 1900 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Invalid year');
    END IF;
END;


/

CREATE OR REPLACE TRIGGER rentalcontract_date_check
BEFORE INSERT OR UPDATE ON RentalContract
FOR EACH ROW
BEGIN
    IF :new.start_date >= :new.end_date THEN
        RAISE_APPLICATION_ERROR(-20001, 'Start date cannot be after end date');
    END IF;
END;
/
CREATE OR REPLACE TRIGGER update_vehicle_status_rent
AFTER INSERT OR UPDATE ON RentalContract
FOR EACH ROW
BEGIN
    UPDATE Vehicle
    SET status = 'RENTED'
    WHERE license_plate = :new.license_plate;
END;
/
CREATE OR REPLACE TRIGGER is_vehicle_availabile
BEFORE INSERT OR UPDATE ON RentalContract
FOR EACH ROW
BEGIN
    DECLARE
        vehicle_status VARCHAR2(20);
    BEGIN
        SELECT status INTO vehicle_status FROM Vehicle WHERE license_plate = :new.license_plate;
        IF vehicle_status != 'AVAILABLE' THEN
            RAISE_APPLICATION_ERROR(-20002, 'Vehicle is not available for rental.');
        END IF;
    END;
END;


/
CREATE OR REPLACE TRIGGER calculate_charge
BEFORE INSERT OR UPDATE ON Receipt
FOR EACH ROW
DECLARE
    v_daily_price INT;
    v_rental_days INT;
    v_late_days INT;
    v_rental_rate FLOAT;
    v_start_date DATE;
    v_end_date DATE;
    v_license_plate VARCHAR2(10);
    v_total_damage_cost FLOAT;
    v_daily_late_fee FLOAT := 50;
BEGIN
    SELECT start_date, end_date, license_plate INTO v_start_date, v_end_date, v_license_plate
    FROM RentalContract 
    WHERE rental_contract_id = :new.rental_contract_id;

    v_rental_days := v_end_date - v_start_date;

    SELECT daily_price INTO v_daily_price
    FROM Vehicle 
    WHERE license_plate = v_license_plate;

    IF v_rental_days >= 30 THEN
        :new.rate_id := 'MONTHLY';
    ELSIF v_rental_days >= 7 THEN
        :new.rate_id := 'WEEKLY';
    ELSE
        :new.rate_id := 'DAILY';
    END IF;

    SELECT rate INTO v_rental_rate 
    FROM RentalRate 
    WHERE rate_id = :new.rate_id;

    :new.rental_charge := v_daily_price * v_rental_days * v_rental_rate;

    SELECT NVL(SUM(damage_cost), 0) 
    INTO v_total_damage_cost
    FROM DamageRecord
    WHERE rental_contract_id = :new.rental_contract_id;

    IF :new.payment_date > v_end_date THEN
        v_late_days := :new.payment_date - v_end_date;
        :new.extra_charges := v_total_damage_cost + (v_late_days * v_daily_late_fee);
    ELSE
        :new.extra_charges := v_total_damage_cost;
    END IF;

    :new.total_charge := :new.rental_charge + :new.extra_charges;
END;

/
CREATE OR REPLACE TRIGGER update_vehicle_status_reserve
AFTER INSERT OR UPDATE ON Reservation
FOR EACH ROW
BEGIN
    UPDATE Vehicle
    SET status = 'RESERVED'
    WHERE license_plate = :new.license_plate;
    IF :new.reserved_to < SYSDATE THEN
        UPDATE Vehicle
        SET status = 'AVAILABLE'
        WHERE license_plate = :new.license_plate;
    END IF;
END;


/
CREATE OR REPLACE TRIGGER update_vehicle_status_maintenance
AFTER INSERT OR UPDATE ON Maintenance
FOR EACH ROW
BEGIN
    UPDATE Vehicle
    SET status = 'MAINTENANCE'
    WHERE license_plate = :new.license_plate;
END;
/

CREATE OR REPLACE TRIGGER insert_salary
BEFORE INSERT ON Staff
FOR EACH ROW
BEGIN 
    IF :new.position LIKE '%MANAGER' THEN
        :new.payroll_id := 1;
    ELSIF :new.position LIKE 'SALES' THEN
        :new.payroll_id := 2;
    ELSIF :new.position LIKE 'BACK-OFFICE' THEN
        :new.payroll_id := 3;
    ELSIF :new.position LIKE 'VALET' THEN
        :new.payroll_id := 4;
    END IF;
END;
/


INSERT INTO Payroll (payroll_id, salary, pay_periods)
VALUES (1, 80000, 'Annually');

INSERT INTO Payroll (payroll_id, salary, pay_periods)
VALUES (2, 3200, 'Monthly');

INSERT INTO Payroll (payroll_id, salary, pay_periods)
VALUES (3, 4000, 'Monthly');

INSERT INTO Payroll (payroll_id, salary, pay_periods)
VALUES (4, 3000, 'Monthly');

INSERT INTO Schedule (schedule_id, work_hours, work_days)
VALUES (1, '08:00 - 16:00', 'Monday to Sunday');

INSERT INTO Schedule (schedule_id, work_hours, work_days)
VALUES (2, '16:00 - 00:00', 'Monday to Sunday');

INSERT INTO Schedule (schedule_id, work_hours, work_days)
VALUES (3, '00:00 - 08:00', 'Monday to Sunday');

INSERT INTO Customer (customer_id,first_name, last_name, street, city, state, zip)
VALUES (101,'Alis', 'Prower', '386 Emma Street', 'Lakeview', 'Texas', '79239');

INSERT INTO Customer (customer_id,first_name, last_name, street, city, state, zip)
VALUES (102,'Carolynn', 'Rosenwald', '4942 Fidler Drive', 'San Antonio', 'Texas', '78233');

INSERT INTO Customer (customer_id,first_name, last_name, street, city, state, zip)
VALUES (103,'Arman', 'Neal', '126 Bubby Drive', 'Austin', 'Texas', '78701');

INSERT INTO Customer (customer_id,first_name, last_name, street, city, state, zip)
VALUES (104,'Izaak', 'Mckenzie', '3831 Glenview Drive', 'San Antonio', 'Texas', '77979');

INSERT INTO Customer (customer_id,first_name, last_name, street, city, state, zip)
VALUES (105,'Robbie', 'Fischer', '3207 Charla Lane', 'Dallas', 'Texas', '75240');

INSERT INTO Customer (customer_id,first_name, last_name, street, city, state, zip)
VALUES (106,'Harriet', 'Davidson', '1092 Freshour Circle', 'San Antonio', 'Texas', '78205');

INSERT INTO Customer (customer_id,first_name, last_name, street, city, state, zip)
VALUES (107,'Anais', 'Simon', '1118 Ashton Lane', 'Austin', 'Texas', '78701');

INSERT INTO Customer (customer_id,first_name, last_name, street, city, state, zip)
VALUES (108,'Tim', 'Fitzgerald', '4730 Alexander Drive', 'Dallas', 'Texas', '75212');

INSERT INTO Customer (customer_id,first_name, last_name, street, city, state, zip)
VALUES (109,'Taylor', 'Acosta', '3844 Monroe Street', 'Houston', 'Texas', '77030');

INSERT INTO Customer (customer_id,first_name, last_name, street, city, state, zip)
VALUES (110,'Joel', 'Stokes', '2608 Brannon Street', 'Los Angeles', 'California', '90071');

INSERT INTO Customer (customer_id,first_name, last_name, street, city, state, zip)
VALUES (111,'Stefan', 'Stuart', '3890 Crestview Terrace', 'New Braunfels', 'Texas', '78130');

INSERT INTO Customer (customer_id,first_name, last_name, street, city, state, zip)
VALUES (112,'Leonard', 'Ayala', '2550 Brookview Drive', 'Beaumont', 'Texas', '77701');

INSERT INTO Customer (customer_id,first_name, last_name, street, city, state, zip)
VALUES (113,'Benjamin', 'Cohen', '3586 White Avenue', 'Corpus Christi', 'Texas', '78415');

INSERT INTO Customer (customer_id,first_name, last_name, street, city, state, zip)
VALUES (114,'Oliver', 'Key', '747 Clair Street', 'Gorman', 'Texas', '76454');

INSERT INTO Customer (customer_id,first_name, last_name, street, city, state, zip)
VALUES (115,'Raphael', 'Weaver', '3185 Layman Avenue', 'Elizabethtown', 'North Carolina', '28337');

INSERT INTO Customer (customer_id,first_name, last_name, street, city, state, zip)
VALUES (116,'Chelsey', 'Suarez', '431 Parrish Avenue', 'Kerrville', 'Texas', '78028');

INSERT INTO Customer (customer_id,first_name, last_name, street, city, state, zip)
VALUES (117,'Tim', 'Hamilton', '1831 Ryder Avenue', 'Everett', 'Washington', '98204');

INSERT INTO Customer (customer_id,first_name, last_name, street, city, state, zip)
VALUES (118,'Logan', 'Rosenwald', '4353 Holden Street', 'San Diego', 'California', '92121');

INSERT INTO Customer (customer_id,first_name, last_name, street, city, state, zip)
VALUES (119,'Lucas', 'Jimenez', '2336 Liberty Street', 'Dallas', 'Texas', '75248');

INSERT INTO Customer (customer_id,first_name, last_name, street, city, state, zip)
VALUES (120,'Camille', 'Davenport', '179 Poco Mas Drive', 'Dallas', 'Texas', '75212');

INSERT INTO Vehicle (license_plate, make, model, year, transmission, fuel_type, daily_price, status)
VALUES ('LJY-9444', 'Volkswagen', 'Passat', '2020', 'AUTOMATIC', 'DIESEL','60','AVAILABLE');

INSERT INTO Vehicle (license_plate, make, model, year, transmission, fuel_type, daily_price, status)
VALUES ('RCJ-9798', 'Volkswagen', 'Golf', '2021', 'AUTOMATIC', 'DIESEL','60','AVAILABLE');

INSERT INTO Vehicle (license_plate, make, model, year, transmission, fuel_type, daily_price, status)
VALUES ('ZFM-8752', 'Volkswagen', 'Golf', '2021', 'AUTOMATIC', 'PETROL','50','AVAILABLE');

INSERT INTO Vehicle (license_plate, make, model, year, transmission, fuel_type, daily_price, status)
VALUES ('BZV-7192', 'Volkswagen', 'Passat', '2020', 'MANUEL', 'DIESEL','50','AVAILABLE');

INSERT INTO Vehicle (license_plate, make, model, year, transmission, fuel_type, daily_price, status)
VALUES ('DZT-3575', 'Toyota', 'Corolla', '2022', 'AUTOMATIC', 'HYBRID','70','AVAILABLE');

INSERT INTO Vehicle (license_plate, make, model, year, transmission, fuel_type, daily_price, status)
VALUES ('GSW-9304', 'Toyota', 'Yaris', '2022', 'AUTOMATIC', 'HYBRID','70','AVAILABLE');

INSERT INTO Vehicle (license_plate, make, model, year, transmission, fuel_type, daily_price, status)
VALUES ('MYZ-2310', 'Fiat', 'Egea', '2022', 'MANUEL', 'PETROL','50','AVAILABLE');

INSERT INTO Vehicle (license_plate, make, model, year, transmission, fuel_type, daily_price, status)
VALUES ('YFM-4774', 'Fiat', 'Egea', '2022', 'AUTOMATIC', 'PETROL','60','AVAILABLE');

INSERT INTO Vehicle (license_plate, make, model, year, transmission, fuel_type, daily_price, status)
VALUES ('DCZ-4834', 'Fiat', '500X', '2020', 'AUTOMATIC', 'DIESEL','60','AVAILABLE');

INSERT INTO Vehicle (license_plate, make, model, year, transmission, fuel_type, daily_price, status)
VALUES ('UVP-5491', 'Fiat', '500X', '2020', 'AUTOMATIC', 'PETROL','50','AVAILABLE');

INSERT INTO Vehicle (license_plate, make, model, year, transmission, fuel_type, daily_price, status)
VALUES ('YYY-3801', 'Audi', 'A6', '2022', 'AUTOMATIC', 'DIESEL','90','AVAILABLE');

INSERT INTO Vehicle (license_plate, make, model, year, transmission, fuel_type, daily_price, status)
VALUES ('BVP-8162', 'Audi', 'A6', '2022', 'AUTOMATIC', 'PETROL','80','AVAILABLE');

INSERT INTO Vehicle (license_plate, make, model, year, transmission, fuel_type, daily_price, status)
VALUES ('JXC-5644', 'Audi', 'A4', '2022', 'AUTOMATIC', 'DIESEL','80','AVAILABLE');

INSERT INTO Vehicle (license_plate, make, model, year, transmission, fuel_type, daily_price, status)
VALUES ('HFY-2539', 'Audi', 'A4', '2022', 'AUTOMATIC', 'PETROL','70','AVAILABLE');

INSERT INTO Vehicle (license_plate, make, model, year, transmission, fuel_type, daily_price, status)
VALUES ('UFH-7572', 'Renault', 'Clio', '2021', 'AUTOMATIC', 'PETROL','55','AVAILABLE');

INSERT INTO Vehicle (license_plate, make, model, year, transmission, fuel_type, daily_price, status)
VALUES ('LDU-7715', 'Renault', 'Clio', '2021', 'MANUEL', 'PETROL','50','AVAILABLE');

INSERT INTO Vehicle (license_plate, make, model, year, transmission, fuel_type, daily_price, status)
VALUES ('XLH-4702', 'Renault', 'Clio', '2021', 'AUTOMATIC', 'DIESEL','60','AVAILABLE');

INSERT INTO Vehicle (license_plate, make, model, year, transmission, fuel_type, daily_price, status)
VALUES ('CJS-7067', 'Renault', 'Megane', '2023', 'AUTOMATIC', 'DIESEL','70','AVAILABLE');

INSERT INTO Vehicle (license_plate, make, model, year, transmission, fuel_type, daily_price, status)
VALUES ('NTV-3431', 'Renault', 'Megane', '2023', 'MANUEL', 'DIESEL','60','AVAILABLE');

INSERT INTO Vehicle (license_plate, make, model, year, transmission, fuel_type, daily_price, status)
VALUES ('KCM-7687', 'Renault', 'Megane', '2023', 'AUTOMATIC', 'PETROL','65','AVAILABLE');

INSERT INTO Staff (staff_id, first_name, last_name, position, street, city, state, zip,schedule_id)
VALUES (201,'Emilia', 'Ray', 'SALES MANAGER', '406 Whitetail Lane','Dallas', 'Texas', '75234',1);

INSERT INTO Staff (staff_id,first_name, last_name, position, street, city, state, zip,schedule_id)
VALUES (202,'Hannah', 'Griffin','SALES', '4644 Poco Mas Drive', 'Dallas','Texas', '75212',1);

INSERT INTO Staff (staff_id,first_name, last_name, position, street, city, state, zip,schedule_id)
VALUES (203,'Rowan', 'Morse','SALES', '2998 Sycamore Circle', 'Dallas', 'Texas', '75204',2);

INSERT INTO Staff (staff_id,first_name, last_name, position, street, city, state, zip,schedule_id)
VALUES (204,'Haseeb', 'Foster','SALES', '3126 Formula Lane', 'Dallas', 'Texas', '75240',2);

INSERT INTO Staff (staff_id,first_name, last_name, position, street, city, state, zip,schedule_id)
VALUES (205,'Juliette', 'Foster','SALES', '3126 Formula Lane', 'Dallas', 'Texas', '75240',3);

INSERT INTO Staff (staff_id,first_name, last_name, position, street, city, state, zip,schedule_id)
VALUES (206,'Joanne', 'Reed','BACK-OFFICE MANAGER', '4730 Alexander Drive', 'Dallas', 'Texas', '75212',1);

INSERT INTO Staff (staff_id,first_name, last_name, position, street, city, state, zip,schedule_id)
VALUES (207,'Pearl', 'Mcconnell','BACK-OFFICE', '2922 Moore Avenue', 'Dallas', 'Texas', '75207',1);

INSERT INTO Staff (staff_id,first_name, last_name, position, street, city, state, zip,schedule_id)
VALUES (208,'Humza', 'Kelley','BACK-OFFICE', '3322 Ersel Street', 'Dallas', 'Texas', '75209',2);

INSERT INTO Staff (staff_id,first_name, last_name, position, street, city, state, zip,schedule_id)
VALUES (209,'Benedict', 'Wade','BACK-OFFICE', '3755 Carolyns Circle', 'Dallas', 'Texas', '75212',2);

INSERT INTO Staff (staff_id,first_name, last_name, position, street, city, state, zip,schedule_id)
VALUES (210,'Joanne', 'Kelley','BACK-OFFICE', '3322 Ersel Street', 'Dallas', 'Texas', '75209',3);

INSERT INTO Staff (staff_id,first_name, last_name, position, street, city, state, zip,schedule_id)
VALUES (211,'Earl', 'Underwood','VALET', '787 Baker Avenue', 'Dallas', 'Texas', '75207',1);

INSERT INTO Staff (staff_id,first_name, last_name, position, street, city, state, zip,schedule_id)
VALUES (212,'Billy', 'Harding','VALET', '3322 Ersel Street', 'Dallas', 'Texas', '75209',2);

INSERT INTO Staff (staff_id,first_name, last_name, position, street, city, state, zip,schedule_id)
VALUES (213,'Bernard', 'Hall','VALET', '3755 Carolyns Circle', 'Dallas', 'Texas', '75212',2);

INSERT INTO Staff (staff_id,first_name, last_name, position, street, city, state, zip,schedule_id)
VALUES (214,'Jack', 'Bradford','VALET', '2202 Romines Mill Road', 'Dallas', 'Texas', '75201',3);

INSERT INTO Staff (staff_id,first_name, last_name, position, street, city, state, zip,schedule_id)
VALUES (215,'Ben', 'Bradford','SALES', '2202 Romines Mill Road', 'Dallas', 'Texas', '75201',1);

INSERT INTO Staff (staff_id,first_name, last_name, position, street, city, state, zip,schedule_id)
VALUES (216,'Rufus', 'Harding','SALES', '2624 Fancher Drive', 'Dallas', 'Texas', '75207',1);

INSERT INTO Staff (staff_id,first_name, last_name, position, street, city, state, zip,schedule_id)
VALUES (217,'Ismael', 'Wolf','BACK-OFFICE', '3857 Moore Avenue', 'Dallas', 'Texas', '75207',1);

INSERT INTO Staff (staff_id,first_name, last_name, position, street, city, state, zip,schedule_id)
VALUES (218,'Marley', 'Davies','BACK-OFFICE', '2222 Ash Street', 'Dallas', 'Texas', '75201',1);

INSERT INTO Staff (staff_id,first_name, last_name, position, street, city, state, zip,schedule_id)
VALUES (219,'Roger', 'Bolton','VALET', '2202 Romines Mill Road', 'Dallas', 'Texas', '75201',1);

INSERT INTO Staff (staff_id,first_name, last_name, position, street, city, state, zip,schedule_id)
VALUES (220,'Zakariya', 'Davidson','VALET', '3857 Moore Avenue', 'Dallas', 'Texas', '75207',1);

INSERT INTO RentalContract(rental_contract_id,start_date, end_date, customer_id, license_plate ,staff_id)
VALUES(1001,'07/15/2023','08/15/2023',102,'UVP-5491',204);
UPDATE Vehicle
SET status = 'AVAILABLE'
WHERE license_plate = 'UVP-5491';

INSERT INTO RentalContract(rental_contract_id,start_date, end_date, customer_id, license_plate ,staff_id)
VALUES(1002,'08/01/2023','08/03/2023',105,'XLH-4702',204);
UPDATE Vehicle
SET status = 'AVAILABLE'
WHERE license_plate = 'XLH-4702';

INSERT INTO RentalContract(rental_contract_id,start_date, end_date, customer_id, license_plate ,staff_id)
VALUES(1003,'05/05/2023','05/15/2023',112,'KCM-7687',204);
UPDATE Vehicle
SET status = 'AVAILABLE'
WHERE license_plate = 'KCM-7687';

INSERT INTO RentalContract(rental_contract_id,start_date, end_date, customer_id, license_plate ,staff_id)
VALUES(1004,'07/23/2023','07/25/2023',113,'UVP-5491',204);
UPDATE Vehicle
SET status = 'AVAILABLE'
WHERE license_plate = 'UVP-5491';

INSERT INTO RentalContract(rental_contract_id,start_date, end_date, customer_id, license_plate ,staff_id)
VALUES(1005,'07/10/2023','07/17/2023',113,'KCM-7687',204);
UPDATE Vehicle
SET status = 'AVAILABLE'
WHERE license_plate = 'KCM-7687';

INSERT INTO RentalContract(rental_contract_id,start_date, end_date, customer_id, license_plate ,staff_id)
VALUES(1006,'02/10/2023','02/17/2023',114,'JXC-5644',205);
UPDATE Vehicle
SET status = 'AVAILABLE'
WHERE license_plate = 'JXC-5644';

INSERT INTO RentalContract(rental_contract_id,start_date, end_date, customer_id, license_plate ,staff_id)
VALUES(1007,'02/20/2023','02/24/2023',115,'MYZ-2310',205);
UPDATE Vehicle
SET status = 'AVAILABLE'
WHERE license_plate = 'MYZ-2310';

INSERT INTO RentalContract(rental_contract_id,start_date, end_date, customer_id, license_plate ,staff_id)
VALUES(1008,'03/20/2023','03/30/2023',116,'YYY-3801',205);
UPDATE Vehicle
SET status = 'AVAILABLE'
WHERE license_plate = 'YYY-3801';

INSERT INTO RentalContract(rental_contract_id,start_date, end_date, customer_id, license_plate ,staff_id)
VALUES(1009,'07/10/2023','07/13/2023',117,'YYY-3801',205);
UPDATE Vehicle
SET status = 'AVAILABLE'
WHERE license_plate = 'YYY-3801';

INSERT INTO RentalContract(rental_contract_id,start_date, end_date, customer_id, license_plate ,staff_id)
VALUES(1010,'07/10/2023','07/17/2023',118,'JXC-5644',205);
UPDATE Vehicle
SET status = 'AVAILABLE'
WHERE license_plate = 'JXC-5644';

INSERT INTO RentalContract(rental_contract_id,start_date, end_date, customer_id, license_plate,staff_id)
VALUES(1011,'12/01/2023','12/04/2023',101,'LJY-9444',202);
UPDATE Vehicle
SET status = 'AVAILABLE'
WHERE license_plate = 'LJY-9444';

INSERT INTO RentalContract(rental_contract_id,start_date, end_date, customer_id, license_plate,staff_id)
VALUES(1012,'12/01/2023','12/05/2023',102,'RCJ-9798',202);
UPDATE Vehicle
SET status = 'AVAILABLE'
WHERE license_plate = 'RCJ-9798';

INSERT INTO RentalContract(rental_contract_id,start_date, end_date, customer_id, license_plate,staff_id)
VALUES(1013,'11/15/2023','12/15/2023',103,'ZFM-8752',202);
UPDATE Vehicle
SET status = 'AVAILABLE'
WHERE license_plate = 'ZFM-8752';

INSERT INTO RentalContract(rental_contract_id,start_date, end_date, customer_id, license_plate,staff_id)
VALUES(1014,'12/06/2023','12/17/2023',104,'BZV-7192',202);
UPDATE Vehicle
SET status = 'AVAILABLE'
WHERE license_plate = 'BZV-7192';

INSERT INTO RentalContract(rental_contract_id,start_date, end_date, customer_id, license_plate,staff_id)
VALUES(1015,'12/01/2023','12/04/2023',105,'DZT-3575',202);
UPDATE Vehicle
SET status = 'AVAILABLE'
WHERE license_plate = 'DZT-3575';

INSERT INTO RentalContract(rental_contract_id,start_date, end_date, customer_id, license_plate,staff_id)
VALUES(1016,'10/01/2023','12/01/2023',108,'YFM-4774',203);
UPDATE Vehicle
SET status = 'AVAILABLE'
WHERE license_plate = 'YFM-4774';

INSERT INTO RentalContract(rental_contract_id,start_date, end_date, customer_id, license_plate,staff_id)
VALUES(1017,'09/01/2023','09/08/2023',109,'DCZ-4834',203);
UPDATE Vehicle
SET status = 'AVAILABLE'
WHERE license_plate = 'DCZ-4834';

INSERT INTO RentalContract(rental_contract_id,start_date, end_date, customer_id, license_plate ,staff_id)
VALUES(1018,'08/23/2023','08/25/2023',110,'DCZ-4834',203);
UPDATE Vehicle
SET status = 'AVAILABLE'
WHERE license_plate = 'DCZ-4834';

INSERT INTO RentalContract(rental_contract_id,start_date, end_date, customer_id, license_plate,staff_id)
VALUES(1019,'12/01/2023','12/05/2023',102,'BZV-7192',202);
UPDATE Vehicle
SET status = 'AVAILABLE'
WHERE license_plate = 'BZV-7192';

INSERT INTO RentalContract(rental_contract_id,start_date, end_date, customer_id, license_plate,staff_id)
VALUES(1020,'12/13/2023','12/17/2023',106,'DZT-3575',203);
UPDATE Vehicle
SET status = 'AVAILABLE'
WHERE license_plate = 'DZT-3575';

INSERT INTO RentalContract(rental_contract_id,start_date, end_date, customer_id, license_plate,staff_id)
VALUES(1021,'12/31/2023','01/02/2024',107,'LJY-9444',203);

INSERT INTO RentalContract(rental_contract_id,start_date, end_date, customer_id, license_plate,staff_id)
VALUES(1022,'12/31/2023','01/02/2024',110,'BZV-7192',203);


INSERT INTO RentalRate(rate_id, rate)
VALUES ('DAILY', 1);

INSERT INTO RentalRate(rate_id, rate)
VALUES ('WEEKLY', 0.85);

INSERT INTO RentalRate(rate_id, rate)
VALUES ('MONTHLY', 0.75);

INSERT INTO CustomerEmail(customer_id, email)
VALUES(101, 'alisprower@gmail.com');

INSERT INTO CustomerEmail(customer_id, email)
VALUES(102, 'carolynnrosenwald@gmail.com');

INSERT INTO CustomerEmail(customer_id, email)
VALUES(103, 'armanneal@gmail.com');

INSERT INTO CustomerEmail(customer_id, email)
VALUES(103, 'armanneal@hotmail.com');

INSERT INTO CustomerEmail(customer_id, email)
VALUES(104, 'izaakmckenzie@gmail.com');

INSERT INTO CustomerEmail(customer_id, email)
VALUES(105, 'robbiefischer@gmail.com');

INSERT INTO CustomerEmail(customer_id, email)
VALUES(106, 'harrietdavidson@gmail.com');

INSERT INTO CustomerEmail(customer_id, email)
VALUES(107, 'anaissimon@gmail.com');

INSERT INTO CustomerEmail(customer_id, email)
VALUES(108, 'timfitzgerald@gmail.com');

INSERT INTO CustomerEmail(customer_id, email)
VALUES(109, 'tayloracosta@gmail.com');

INSERT INTO CustomerEmail(customer_id, email)
VALUES(109, 'tayloracosta@hotmail.com');

INSERT INTO CustomerEmail(customer_id, email)
VALUES(110, 'joelstokes@hotmail.com');

INSERT INTO CustomerEmail(customer_id, email)
VALUES(111, 'stefanstuart@hotmail.com');

INSERT INTO CustomerEmail(customer_id, email)
VALUES(112, 'leonardayala@hotmail.com');

INSERT INTO CustomerEmail(customer_id, email)
VALUES(114, 'oliverkey@hotmail.com');

INSERT INTO CustomerEmail(customer_id, email)
VALUES(114, 'oliverkey@gmail.com');

INSERT INTO CustomerEmail(customer_id, email)
VALUES(115, 'raphaelweaver@hotmail.com');

INSERT INTO CustomerEmail(customer_id, email)
VALUES(117, 'timhamilton@hotmail.com');

INSERT INTO CustomerEmail(customer_id, email)
VALUES(118, 'loganrosenwald@hotmail.com');

INSERT INTO CustomerEmail(customer_id, email)
VALUES(119, 'lucasjimenez@hotmail.com');

INSERT INTO CustomerEmail(customer_id, email)
VALUES(120, 'camilledavenport@hotmail.com');

INSERT INTO CustomerPhoneNumber(customer_id, phone_number)
VALUES(101, '+16059714423');

INSERT INTO CustomerPhoneNumber(customer_id, phone_number)
VALUES(101, '+12794992386');

INSERT INTO CustomerPhoneNumber(customer_id, phone_number)
VALUES(102, '+13479466861');

INSERT INTO CustomerPhoneNumber(customer_id, phone_number)
VALUES(103, '+16059719337');

INSERT INTO CustomerPhoneNumber(customer_id, phone_number)
VALUES(104, '+18332403627');

INSERT INTO CustomerPhoneNumber(customer_id, phone_number)
VALUES(105, '+18332405104');

INSERT INTO CustomerPhoneNumber(customer_id, phone_number)
VALUES(106, '+18332626819');

INSERT INTO CustomerPhoneNumber(customer_id, phone_number)
VALUES(107, '+18332631063');

INSERT INTO CustomerPhoneNumber(customer_id, phone_number)
VALUES(108, '+18332633159');

INSERT INTO CustomerPhoneNumber(customer_id, phone_number)
VALUES(109, '+18332648106');

INSERT INTO CustomerPhoneNumber(customer_id, phone_number)
VALUES(110, '+18332656434');

INSERT INTO CustomerPhoneNumber(customer_id, phone_number)
VALUES(111, '+18332672839');

INSERT INTO CustomerPhoneNumber(customer_id, phone_number)
VALUES(111, '+18332691066');

INSERT INTO CustomerPhoneNumber(customer_id, phone_number)
VALUES(112, '+18332691067');

INSERT INTO CustomerPhoneNumber(customer_id, phone_number)
VALUES(113, '+18332691068');

INSERT INTO CustomerPhoneNumber(customer_id, phone_number)
VALUES(114, '+16059714424');

INSERT INTO CustomerPhoneNumber(customer_id, phone_number)
VALUES(115, '+16059714425');

INSERT INTO CustomerPhoneNumber(customer_id, phone_number)
VALUES(116, '+16059714426');

INSERT INTO CustomerPhoneNumber(customer_id, phone_number)
VALUES(117, '+12794992387');

INSERT INTO CustomerPhoneNumber(customer_id, phone_number)
VALUES(118, '+12794992388');

INSERT INTO CustomerPhoneNumber(customer_id, phone_number)
VALUES(119, '+13479466862');

INSERT INTO CustomerPhoneNumber(customer_id, phone_number)
VALUES(120, '+13479466863');

INSERT INTO StaffEmail(staff_id, email)
VALUES(201, 'emiliaray@gmail.com');

INSERT INTO StaffEmail(staff_id, email)
VALUES(202, 'hannahgriffin@gmail.com');

INSERT INTO StaffEmail(staff_id, email)
VALUES(203, 'rowenmorse@gmail.com');

INSERT INTO StaffEmail(staff_id, email)
VALUES(204, 'haseebfoster@gmail.com');

INSERT INTO StaffEmail(staff_id, email)
VALUES(205, 'juliettefoster@gmail.com');

INSERT INTO StaffEmail(staff_id, email)
VALUES(206, 'joannereed@gmail.com');

INSERT INTO StaffEmail(staff_id, email)
VALUES(206, 'joannereed@hotmail.com');

INSERT INTO StaffEmail(staff_id, email)
VALUES(207, 'pearlmcconnell@gmail.com');

INSERT INTO StaffEmail(staff_id, email)
VALUES(208, 'humzakelley@gmail.com');

INSERT INTO StaffEmail(staff_id, email)
VALUES(209, 'benedictwade@gmail.com');

INSERT INTO StaffEmail(staff_id, email)
VALUES(209, 'benedictwade@hotmail.com');

INSERT INTO StaffEmail(staff_id, email)
VALUES(210, 'joannekelley@gmail.com');

INSERT INTO StaffEmail(staff_id, email)
VALUES(211, 'earlunderwood@gmail.com');

INSERT INTO StaffEmail(staff_id, email)
VALUES(212, 'billyharding@gmail.com');

INSERT INTO StaffEmail(staff_id, email)
VALUES(213, 'bernardhall@gmail.com');

INSERT INTO StaffEmail(staff_id, email)
VALUES(214, 'jackbradford@gmail.com');

INSERT INTO StaffEmail(staff_id, email)
VALUES(215, 'benbradford@gmail.com');

INSERT INTO StaffEmail(staff_id, email)
VALUES(216, 'rufusharding@gmail.com');

INSERT INTO StaffEmail(staff_id, email)
VALUES(217, 'ismaelwolf@gmail.com');

INSERT INTO StaffEmail(staff_id, email)
VALUES(218, 'marleydavis@gmail.com');

INSERT INTO StaffEmail(staff_id, email)
VALUES(219, 'rogerbolton@gmail.com');

INSERT INTO StaffEmail(staff_id, email)
VALUES(220, 'zakariyadavidson@gmail.com');

INSERT INTO StaffEmail(staff_id, email)
VALUES(220, 'zakariyadavidson@hotmail.com');

INSERT INTO StaffPhoneNumber(staff_id, phone_number)
VALUES(201,'+16059714427');

INSERT INTO StaffPhoneNumber(staff_id, phone_number)
VALUES(202,'+16059714428');

INSERT INTO StaffPhoneNumber(staff_id, phone_number)
VALUES(203,'+16059714429');

INSERT INTO StaffPhoneNumber(staff_id, phone_number)
VALUES(203,'+16059714430');

INSERT INTO StaffPhoneNumber(staff_id, phone_number)
VALUES(204,'+16059714431');

INSERT INTO StaffPhoneNumber(staff_id, phone_number)
VALUES(204,'+16059714432');

INSERT INTO StaffPhoneNumber(staff_id, phone_number)
VALUES(205,'+16059714433');

INSERT INTO StaffPhoneNumber(staff_id, phone_number)
VALUES(206,'+16059714434');

INSERT INTO StaffPhoneNumber(staff_id, phone_number)
VALUES(207,'+16059714435');

INSERT INTO StaffPhoneNumber(staff_id, phone_number)
VALUES(208,'+16059714436');

INSERT INTO StaffPhoneNumber(staff_id, phone_number)
VALUES(209,'+16059714437');

INSERT INTO StaffPhoneNumber(staff_id, phone_number)
VALUES(210,'+16059714438');

INSERT INTO StaffPhoneNumber(staff_id, phone_number)
VALUES(210,'+16059714439');

INSERT INTO StaffPhoneNumber(staff_id, phone_number)
VALUES(211,'+16059714440');

INSERT INTO StaffPhoneNumber(staff_id, phone_number)
VALUES(212,'+16059714441');

INSERT INTO StaffPhoneNumber(staff_id, phone_number)
VALUES(213,'+16059714442');

INSERT INTO StaffPhoneNumber(staff_id, phone_number)
VALUES(214,'+16059714443');

INSERT INTO StaffPhoneNumber(staff_id, phone_number)
VALUES(215,'+16059714444');

INSERT INTO StaffPhoneNumber(staff_id, phone_number)
VALUES(216,'+16059714445');

INSERT INTO StaffPhoneNumber(staff_id, phone_number)
VALUES(217,'+16059714446');

INSERT INTO StaffPhoneNumber(staff_id, phone_number)
VALUES(218,'+16059714447');

INSERT INTO StaffPhoneNumber(staff_id, phone_number)
VALUES(219,'+16059714448');

INSERT INTO StaffPhoneNumber(staff_id, phone_number)
VALUES(220,'+16059714449');

INSERT INTO Maintenance(maintenance_id, maintenance_date, service_details, license_plate)
VALUES(1,'08/15/2023','Bodywork and paint touch-up for rear bumper scratches.','UVP-5491');

INSERT INTO DamageRecord(damage_id, date_reported,damage_description, damage_cost, rental_contract_id, maintenance_id)
VALUES(1,'08/15/2023','Minor scratches and a small dent on the rear bumper.',120,1001,1);

INSERT INTO Maintenance(maintenance_id, maintenance_date, service_details, license_plate)
VALUES(2,'08/15/2023','Tire replacement.','UVP-5491');

INSERT INTO DamageRecord(damage_id, date_reported,damage_description, damage_cost, rental_contract_id, maintenance_id)
VALUES(2,'08/15/2023','Right rear tire punctured and flat, requiring replacement.',100,1001,2);

INSERT INTO Receipt(receipt_id, payment_date, payment_method, rental_contract_id)
VALUES(2001,'08/15/2023','CASH',1001);

UPDATE Vehicle
SET status = 'AVAILABLE'
WHERE license_plate = 'UVP-5491';

INSERT INTO Receipt(receipt_id, payment_date, payment_method,rental_contract_id )
VALUES(2002,'08/03/2023','CASH',1002);

INSERT INTO Receipt(receipt_id, payment_date, payment_method,rental_contract_id )
VALUES(2003,'05/15/2023','CASH',1003);

INSERT INTO Receipt(receipt_id, payment_date, payment_method,rental_contract_id )
VALUES(2004,'07/25/2023','CREDIT CARD',1004);

INSERT INTO Maintenance(maintenance_id, maintenance_date, service_details, license_plate)
VALUES(3,'07/18/2023','Bodywork and paint touch-up for rear bumper scratches.','KCM-7687');

INSERT INTO DamageRecord(damage_id, date_reported,damage_description, damage_cost, rental_contract_id, maintenance_id)
VALUES(3,'07/17/2023','Minor scratches and a small dent on the rear bumper.',120,1005,3);

INSERT INTO Maintenance(maintenance_id, maintenance_date, service_details, license_plate)
VALUES(4,'07/18/2023','Interior cleaning and upholstery repair for back seat stains.','KCM-7687');

INSERT INTO DamageRecord(damage_id, date_reported,damage_description, damage_cost, rental_contract_id, maintenance_id)
VALUES(4,'07/17/2023','Stain and burn mark on the back seat.',150,1005,4);

INSERT INTO Receipt(receipt_id, payment_date, payment_method,rental_contract_id )
VALUES(2005,'07/18/2023','DEBIT CARD',1005);
UPDATE Vehicle
SET status = 'AVAILABLE'
WHERE license_plate = 'KCM-7687';

INSERT INTO Receipt(receipt_id, payment_date, payment_method,rental_contract_id )
VALUES(2006,'02/20/2023','DEBIT CARD',1006);

INSERT INTO Maintenance(maintenance_id, maintenance_date, service_details, license_plate)
VALUES(5,'02/24/2023','Interior cleaning and upholstery repair for back seat stains.','MYZ-2310');

INSERT INTO DamageRecord(damage_id, date_reported,damage_description, damage_cost, rental_contract_id, maintenance_id)
VALUES(5,'02/24/2023','Stain and burn mark on the back seat.',150,1007,5);

INSERT INTO Maintenance(maintenance_id, maintenance_date, service_details, license_plate)
VALUES(6,'02/24/2023','Driver side door replacement.','MYZ-2310');

INSERT INTO DamageRecord(damage_id, date_reported,damage_description, damage_cost, rental_contract_id, maintenance_id)
VALUES(6,'02/24/2023','Significant dent and scratches on the driver side door, caused by a collision.',450,1007,6);

INSERT INTO Maintenance(maintenance_id, maintenance_date, service_details, license_plate)
VALUES(7,'02/24/2023','Windshield replacement.','MYZ-2310');

INSERT INTO DamageRecord(damage_id, date_reported,damage_description, damage_cost, rental_contract_id, maintenance_id)
VALUES(7,'02/24/2023','Cracked windshield.',250,1007,7);

INSERT INTO Maintenance(maintenance_id, maintenance_date, service_details, license_plate)
VALUES(8,'02/24/2023','Right headlight replacement.','MYZ-2310');

INSERT INTO DamageRecord(damage_id, date_reported,damage_description, damage_cost, rental_contract_id, maintenance_id)
VALUES(8,'02/24/2023','Broken right headlight.',100,1007,8);

INSERT INTO Receipt(receipt_id, payment_date, payment_method,rental_contract_id )
VALUES(2007,'02/24/2023','DEBIT CARD',1007);
UPDATE Vehicle
SET status = 'AVAILABLE'
WHERE license_plate = 'MYZ-2310';

INSERT INTO Receipt(receipt_id, payment_date, payment_method,rental_contract_id )
VALUES(2008,'03/30/2023','CREDIT CARD',1008);

INSERT INTO Receipt(receipt_id, payment_date, payment_method,rental_contract_id )
VALUES(2009,'07/13/2023','CREDIT CARD',1009);

INSERT INTO Maintenance(maintenance_id, maintenance_date, service_details, license_plate)
VALUES(9,'02/24/2023','Left side mirror replacement.','JXC-5644');

INSERT INTO DamageRecord(damage_id, date_reported,damage_description, damage_cost, rental_contract_id, maintenance_id)
VALUES(9,'02/24/2023','Left side mirror broken.',100,1010,9);

INSERT INTO Maintenance(maintenance_id, maintenance_date, service_details, license_plate)
VALUES(10,'02/24/2023','Left headlight replacement.','JXC-5644');

INSERT INTO DamageRecord(damage_id, date_reported,damage_description, damage_cost, rental_contract_id, maintenance_id)
VALUES(10,'02/24/2023','Broken left headlight.',100,1010,10);

INSERT INTO Receipt(receipt_id, payment_date, payment_method,rental_contract_id )
VALUES(2010,'07/17/2023','DEBIT CARD',1010);
UPDATE Vehicle
SET status = 'AVAILABLE'
WHERE license_plate = 'JXC-5644';

INSERT INTO Receipt(receipt_id, payment_date, payment_method,rental_contract_id )
VALUES(2011,'12/04/2023','CREDIT CARD',1011);

INSERT INTO Maintenance(maintenance_id, maintenance_date, service_details, license_plate)
VALUES(11,'12/05/2023','Interior cleaning and upholstery repair for back seat stains.','RCJ-9798');

INSERT INTO DamageRecord(damage_id, date_reported,damage_description, damage_cost, rental_contract_id, maintenance_id)
VALUES(11,'12/05/2023','Stain and burn mark on the back seat.',150,1012,11);

INSERT INTO Receipt(receipt_id, payment_date, payment_method,rental_contract_id )
VALUES(2012,'12/05/2023','CREDIT CARD',1012);
UPDATE Vehicle
SET status = 'AVAILABLE'
WHERE license_plate = 'RCJ-9798';

INSERT INTO Receipt(receipt_id, payment_date, payment_method,rental_contract_id )
VALUES(2013,'12/15/2023','CREDIT CARD',1013);

INSERT INTO Receipt(receipt_id, payment_date, payment_method,rental_contract_id )
VALUES(2014,'12/17/2023','DEBIT CARD',1014);

INSERT INTO Receipt(receipt_id, payment_date, payment_method,rental_contract_id )
VALUES(2015,'12/04/2023','CREDIT CARD',1015);

INSERT INTO Maintenance(maintenance_id, maintenance_date, service_details, license_plate)
VALUES(12,'12/01/2023','Interior cleaning and upholstery repair for front seat stains.','YFM-4774');

INSERT INTO DamageRecord(damage_id, date_reported,damage_description, damage_cost, rental_contract_id, maintenance_id)
VALUES(12,'12/01/2023','Stain and burn mark on the front seat.',150,1016,12);

INSERT INTO Maintenance(maintenance_id, maintenance_date, service_details, license_plate)
VALUES(13,'12/01/2023','Tire replacement and wheel balancing for punctured tire.','YFM-4774');

INSERT INTO DamageRecord(damage_id, date_reported,damage_description, damage_cost, rental_contract_id, maintenance_id)
VALUES(13,'12/01/2023','Flat tire due to puncture.',100,1016,13);

INSERT INTO Maintenance(maintenance_id, maintenance_date, service_details, license_plate)
VALUES(14,'12/01/2023','Left side mirror replacement.','YFM-4774');

INSERT INTO DamageRecord(damage_id, date_reported,damage_description, damage_cost, rental_contract_id, maintenance_id)
VALUES(14,'12/01/2023','Left side mirror broken.',100,1016,14);

INSERT INTO Maintenance(maintenance_id, maintenance_date, service_details, license_plate)
VALUES(15,'12/01/2023','Bodywork and paint touch-up for rear bumper scratches.','YFM-4774');

INSERT INTO DamageRecord(damage_id, date_reported,damage_description, damage_cost, rental_contract_id, maintenance_id)
VALUES(15,'12/01/2023','Minor scratches on rear bumper.',120,1016,15);

INSERT INTO Receipt(receipt_id, payment_date, payment_method,rental_contract_id )
VALUES(2016,'12/01/2023','CREDIT CARD',1016);
UPDATE Vehicle
SET status = 'AVAILABLE'
WHERE license_plate = 'YFM-4774';

INSERT INTO Maintenance(maintenance_id, maintenance_date, service_details, license_plate)
VALUES(16,'09/08/2023','Bodywork and paint touch-up for rear bumper scratches.','DCZ-4834');

INSERT INTO DamageRecord(damage_id, date_reported,damage_description, damage_cost, rental_contract_id, maintenance_id)
VALUES(16,'09/08/2023','Minor scratches on rear bumper.',120,1017,16);

INSERT INTO Maintenance(maintenance_id, maintenance_date, service_details, license_plate)
VALUES(17,'09/08/2023','Tire replacement and wheel balancing for punctured tire.','DCZ-4834');

INSERT INTO DamageRecord(damage_id, date_reported,damage_description, damage_cost, rental_contract_id, maintenance_id)
VALUES(17,'09/08/2023','Flat tire due to puncture.',100,1017,17);

INSERT INTO Receipt(receipt_id, payment_date, payment_method,rental_contract_id )
VALUES(2017,'09/08/2023','CASH',1017);
UPDATE Vehicle
SET status = 'AVAILABLE'
WHERE license_plate = 'DCZ-4834';

INSERT INTO Receipt(receipt_id, payment_date, payment_method,rental_contract_id )
VALUES(2018,'08/25/2023','CASH',1018);

INSERT INTO Receipt(receipt_id, payment_date, payment_method,rental_contract_id )
VALUES(2019,'12/05/2023','CASH',1019);

INSERT INTO Maintenance(maintenance_id, maintenance_date, service_details, license_plate)
VALUES(18,'12/17/2023','Tire replacement and wheel balancing for punctured tire.','DZT-3575');

INSERT INTO DamageRecord(damage_id, date_reported,damage_description, damage_cost, rental_contract_id, maintenance_id)
VALUES(18,'12/17/2023','Flat tire due to puncture.',100,1020,18);

INSERT INTO Maintenance(maintenance_id, maintenance_date, service_details, license_plate)
VALUES(19,'12/17/2023','Windshield replacement.','DZT-3575');

INSERT INTO DamageRecord(damage_id, date_reported,damage_description, damage_cost, rental_contract_id, maintenance_id)
VALUES(19,'12/17/2023','Cracked windshield.',250,1020,19);

INSERT INTO Maintenance(maintenance_id, maintenance_date, service_details, license_plate)
VALUES(20,'12/17/2023','Windshield replacement.','DZT-3575');

INSERT INTO DamageRecord(damage_id, date_reported,damage_description, damage_cost, rental_contract_id, maintenance_id)
VALUES(20,'12/17/2023','Front bumper cracked due to a low-speed impact with a barrier.',300,1020,20);

INSERT INTO Receipt(receipt_id, payment_date, payment_method,rental_contract_id )
VALUES(2020,'12/17/2023','CASH',1020);

INSERT INTO Reservation(reservation_id, reserved_from, reserved_to, customer_id, license_plate)
VALUES(1,'01/01/2023','01/04/2023',101,'RCJ-9798');

INSERT INTO Reservation(reservation_id, reserved_from, reserved_to, customer_id, license_plate)
VALUES(2,'01/01/2023','01/04/2023',102,'ZFM-8752');

INSERT INTO Reservation(reservation_id, reserved_from, reserved_to, customer_id, license_plate)
VALUES(3,'01/01/2023','01/04/2023',103,'GSW-9304');

INSERT INTO Reservation(reservation_id, reserved_from, reserved_to, customer_id, license_plate)
VALUES(4,'02/02/2023','02/05/2023',104,'RCJ-9798');

INSERT INTO Reservation(reservation_id, reserved_from, reserved_to, customer_id, license_plate)
VALUES(5,'02/02/2023','02/05/2023',105,'ZFM-8752');

INSERT INTO Reservation(reservation_id, reserved_from, reserved_to, customer_id, license_plate)
VALUES(6,'02/02/2023','02/05/2023',106,'GSW-9304');

INSERT INTO Reservation(reservation_id, reserved_from, reserved_to, customer_id, license_plate)
VALUES(7,'03/08/2023','03/11/2023',107,'YYY-3801');

INSERT INTO Reservation(reservation_id, reserved_from, reserved_to, customer_id, license_plate)
VALUES(8,'03/08/2023','03/11/2023',108,'UVP-5491');

INSERT INTO Reservation(reservation_id, reserved_from, reserved_to, customer_id, license_plate)
VALUES(9,'03/08/2023','03/11/2023',109,'DCZ-4834');

INSERT INTO Reservation(reservation_id, reserved_from, reserved_to, customer_id, license_plate)
VALUES(10,'04/08/2023','04/11/2023',110,'YYY-3801');

INSERT INTO Reservation(reservation_id, reserved_from, reserved_to, customer_id, license_plate)
VALUES(11,'04/08/2023','04/11/2023',111,'UVP-5491');

INSERT INTO Reservation(reservation_id, reserved_from, reserved_to, customer_id, license_plate)
VALUES(12,'03/08/2023','03/11/2023',112,'DCZ-4834');

INSERT INTO Reservation(reservation_id, reserved_from, reserved_to, customer_id, license_plate)
VALUES(13,'03/08/2023','03/11/2023',113,'KCM-7687');

INSERT INTO Reservation(reservation_id, reserved_from, reserved_to, customer_id, license_plate)
VALUES(14,'03/15/2023','03/18/2023',114,'KCM-7687');

INSERT INTO Reservation(reservation_id, reserved_from, reserved_to, customer_id, license_plate)
VALUES(15,'03/22/2023','03/25/2023',115,'DCZ-4834');

INSERT INTO Reservation(reservation_id, reserved_from, reserved_to, customer_id, license_plate)
VALUES(16,'03/28/2023','03/30/2023',116,'CJS-7067');

INSERT INTO Reservation(reservation_id, reserved_from, reserved_to, customer_id, license_plate)
VALUES(17,'04/08/2023','04/11/2023',117,'KCM-7687');

INSERT INTO Reservation(reservation_id, reserved_from, reserved_to, customer_id, license_plate)
VALUES(18,'04/08/2023','04/11/2023',118,'LDU-7715');

INSERT INTO Reservation(reservation_id, reserved_from, reserved_to, customer_id, license_plate)
VALUES(19,'12/17/2023','03/01/2024',119,'LDU-7715');

INSERT INTO Reservation(reservation_id, reserved_from, reserved_to, customer_id, license_plate)
VALUES(20,'12/17/2023','03/01/2024',119,'CJS-7067');

