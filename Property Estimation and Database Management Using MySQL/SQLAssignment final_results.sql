CREATE DATABASE properties;
USE properties;
CREATE TABLE properties.location(
location_code VARCHAR(45) NOT NULL PRIMARY KEY, 
location_name VARCHAR(20) NOT NULL, 
population INT NULL, 
avg_income FLOAT NULL);

CREATE TABLE properties.property(
  property_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  floor_number INT NULL,
  size FLOAT NULL,
  construction_year INT NULL,
  city VARCHAR(45) NULL,
  zip VARCHAR(5) NULL,
  street_number VARCHAR(3) NULL,
  street VARCHAR(30) NULL,
  location_code VARCHAR(45) NOT NULL,
  INDEX location_code_idx (location_code ASC) VISIBLE,
    FOREIGN KEY (location_code)
    REFERENCES properties.location (location_code));
    
CREATE TABLE properties.offices(
  property_id INT NOT NULL PRIMARY KEY,
  VAT VARCHAR(10) NULL,
    FOREIGN KEY (property_id)
    REFERENCES properties.property (property_id));
    
CREATE TABLE properties.residences(
  property_id INT NOT NULL PRIMARY KEY,
  ID_number VARCHAR(10) NULL,
    FOREIGN KEY (property_id)
    REFERENCES properties.property (property_id));
    
CREATE TABLE properties.estimator(
  estimator_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  first_name VARCHAR(45) NULL,
  last_name VARCHAR(45) NULL,
  gender VARCHAR(10) NULL,
  age INT NULL,
  city VARCHAR(45) NULL,
  zip VARCHAR(5) NULL,
  street_number VARCHAR(3) NULL,
  street VARCHAR(30) NULL);
  
CREATE TABLE properties.estimation(
  ecode INT NOT NULL PRIMARY KEY,
  price FLOAT NULL,
  estimation_date DATE NULL,
  property_id INT NULL,
  estimator_id INT NULL,
  INDEX property_id_idx(property_id ASC) VISIBLE,
  INDEX estimator_id_idx(estimator_id ASC) VISIBLE,
    FOREIGN KEY (property_id)
    REFERENCES properties.property(property_id),
    FOREIGN KEY (estimator_id)
    REFERENCES properties.estimator(estimator_id));

INSERT INTO properties.location (location_code, location_name, population, avg_income) VALUES
('CHL', 'CHALANDRI', '74190', '28000'), ('ALM', 'ALIMOS', '41000', '51000'), ('VRL', 'VRILISSIA', '35000', '55000'), ('PER', 'PERISTERI', '140000', '26000'), ('KFS', 'KIFISSIA', '45000', '67000'), ('GLF', 'GLYFADA', '87500', '70000'), ('KLT', 'KALLITHEA', '100000', '30000'), ('PIR', 'PIRAEUS','160000' ,'29000'), ('PEA', 'PEANIA', '27000', '41000'), ('EGL', 'EGALEO', '70000' ,'28000');

ALTER TABLE property auto_increment=1000;

INSERT INTO properties.property (floor_number, size, construction_year, city, zip, street_number, street, location_code) VALUES
(3, 80, 2010, 'CHALANDRI', '15231', '20', 'EPTANISOU', 'CHL'), (1, 90, 2004, 'CHALANDRI', '15233', '3', 'RODODAFNIS', 'CHL'), (4, 110, 2008, 'CHALANDRI', '15234','17', 'KYKLADON', 'CHL'), (4, 120, 2012, 'ALIMOS', '17342', '24', 'LOUKIANOU', 'ALM'), (2, 56, 2002, 'ALIMOS', '17342', '5', 'SOULIOU', 'ALM'), (1, 60, 1997, 'EGALEO', '12243', '6', 'MYKINON', 'EGL'), (2, 27, 1995, 'EGALEO', '12243', '15', 'SERIFOU', 'EGL'), (3, 45, 2003, 'GLYFADA', '16674', '3', 'AGRINIOU', 'GLF'), 
(4, 150, 2006, 'GLYFADA', '16562','17', 'AKROTIRIOU', 'GLF'), (2, 125, 2008,'GLYFADA', '16674','23', 'SOFOKLEOUS', 'GLF'), (1, 35, 2008,'GLYFADA', '16675','35', 'SPARTIS', 'GLF'), (2, 95, 2010, 'KIFISSIA', '14564','2B', 'ERMIONIS', 'KFS'), (1, 75, 2010, 'KIFISSIA', '14561','180', 'PEFKON', 'KFS'), (5, 130, 2005, 'KALLITHEA', '17675','55', 'FAISTOU', 'KLT'), (1, 55, 2011, 'KALLITHEA', '17673','12', 'SPARTIS', 'KLT'), (1, 120, 2007, 'PEANIA', '19002','6','KONSTANTINOU PRIFTI', 'PEA'), (3, 30, 2012, 'PERISTERI', '12136','11', 'MASSALIAS', 'PER'), (4, 55, 2006, 'PERISTERI', '12131','111', 'AKTIOU', 'PER'),
(2, 46, 2000, 'PERISTERI', '12134','19','AMISOU', 'PER'), (1, 59, 1998, 'PIRAEUS', '18546','66', 'ELLIS', 'PIR'), (2, 75, 1999, 'PIRAEUS', '18543','32', 'GYTHEIOU', 'PIR'), (6, 105, 2005, 'PIRAEUS', '18545','50', 'DAFNIOU', 'PIR'), (3, 125, 1997, 'VRILISSIA', '15235','3A', 'ACHILLEOS', 'VRL'),  (3, 115, 2001, 'VRILISSIA', '15235','3', 'DODEKANISOU', 'VRL');

INSERT INTO properties.offices (property_id, VAT) VALUES
(1006, 800919735), (1010, 601829558), (1007, 142854217), (1001, 513857814), (1012, 433585444), (1014, 639611136), (1020, 321989410);

INSERT INTO properties.residences (property_id, ID_number) VALUES
(1000, 'AM 201567'), (1002, 'AK 145987'), (1003, 'AN 456784'), (1004, 'A 151387'), (1005, 'Z 194698'), (1008, 'AZ 601678'),
(1009, 'X 132025'), (1011, 'AI 669346'), (1013, 'AT 914295'), (1015, 'AK 163797'), (1016, 'ZM 758392'), (1017, 'E 987634'),
(1018, 'AZ 562798'), (1019, 'AB 465986'), (1021, 'T 197643'), (1022, 'OA 628375'), (1023, 'AT 157398');

INSERT INTO properties.estimator (estimator_id, first_name, last_name, gender, age, city, zip, street_number, street) VALUES
(51, 'MARIA', 'MARKOU', 'FEMALE', 28, 'PIRAEUS', '18546', '8', 'KARAOLI'), (52, 'NIKOS', 'ANTONOPOULOS', 'MALE', 40, 'KIFISIA', '14564', '21', 'CHELIDONOUS'),
(53, 'ELENI', 'ZAXOU',  'FEMALE', 38, 'ALIMOS', '17455', '2', 'TSOUDEROU'), (54, 'ANNA', 'PETROPOULOU', 'FEMALE', 50, 'CHALANDRI', '15233', '15','PAROU'),
(55, 'ANTONIS', 'PAPASTAVROU', 'MALE', 26, 'PIRAEUS', '18546', '9', 'MIKROLIMANO');

INSERT INTO properties.estimation (ecode, price, estimation_date, property_id, estimator_id) VALUES
(1, '300578', '2020-12-24', 1008, 52), (2, '1023000', '2020-04-09', 1023, 55), (3, '900567', '2020-11-11', 1000, 54), (4, '859987', '2018-07-09', 1003, 51), (5, '1349678', '2020-03-19', 1015, 54), (6, '987145', '2018-10-21', 1020, 53), 
(7, '456108', '2019-06-13', 1019, 54), (8, '873126', '2019-09-17', 1011, 51), (9, '799251', '2020-08-01', 1021, 53), (10, '1560100', '2020-12-27', 1001, 53), (11, '991342', '2018-01-29', 1007, 52), (12, '798256', '2019-08-14', 1017, 51),
(13, '793120', '2019-12-05', 1005, 55), (14, '159876', '2019-10-12', 1022, 54), (15, '986301', '2020-12-26', 1013, 52), (16, '793120', '2018-12-05', 1005, 55), (17, '941875', '2020-12-31', 1002, 53), (18, '159876', '2019-02-28', 1022, 54),
(19, '598299', '2020-12-30', 1010, 52), (20, '986301', '2019-01-27', 1013, 52), (21, '892789', '2017-09-09', 1009, 53), (22, '1000000', '2020-09-10', 1004, 55), (23, '998610', '2019-08-20', 1012, 54), (24, '1793209', '2020-11-09', 1006, 53),
(25, '841905', '2019-05-20', 1014, 51), (26, '98186', '2018-10-06', 1016, 53), (27, '892789', '2020-09-29', 1009, 53), (28, '929106', '2019-10-19', 1018, 52), (29,  '841905', '2020-12-29', 1014, 51), (30, '929106', '2020-08-09', 1018, 52),
(31, '500000','2020-10-12',1018, 53), (32, '350000', '2020-06-03', 1009, 52), (33, '450000', '2020-10-12', 1009, 51), (34, '455000', '2020-02-27', 1018, 54);


-- a.
select property.property_id, property.city, property.zip, property.street_number, property.street
from location, estimation, property
where location.avg_income > 40000
and property.property_id=estimation.property_id
and location.location_code=property.location_code
and (estimation.estimation_date between CAST('2020-12-24' as date) and CAST('2020-12-31' as date));

-- b.
select estimator.first_name as 'First Name', estimator.last_name as 'Last Name', count(estimation.ecode) as 'Number of estimations'
from estimator, estimation
where estimator.estimator_id=estimation.estimator_id
group by estimation.estimator_id;

-- c.
select property_id
from estimation
where year(estimation_date)=2020
group by property_id
having count(*)>2;

-- d.
select ecode
from estimation
where 25000 < all (select avg_income
from location);
         
-- e.
select count(estimation.ecode) as "Count of estimations"
from estimation, property, location
where year(estimation_date)=2020
and property.property_id=estimation.property_id
and property.location_code=location.location_code
and location.population>50000;

-- f.
select property.location_code, round(avg(estimation.price/property.size))
from location, estimation, property
where location.location_code=property.location_code
and property.property_id=estimation.property_id
group by property.location_code
order by avg(estimation.price/property.size);

-- g.
select estimator.estimator_id, count(residences.property_id) as 'Number of residences', count(offices.property_id) as 'Number of offices estimation'
from estimator
join estimation
	on estimator.estimator_id=estimation.estimator_id
    and year(estimation_date)=2020
join property
	on estimation.property_id=property.property_id
left join residences
	on property.property_id=residences.property_id
left join offices
	on property.property_id=offices.property_id
group by estimator.estimator_id;

-- h.
create view average_price2019 as
select location.location_code, avg(estimation.price/property.size) as av_price19
from property
join estimation on property.property_id=estimation.property_id
join location on location.location_code=property.location_code
where year(estimation_date)=2019
group by location.location_code;

create view average_price2020 as
select location.location_code, avg(estimation.price/property.size) as av_price20
from property
join estimation on property.property_id=estimation.property_id
join location on location.location_code=property.location_code
where year(estimation_date)=2020
group by location.location_code;

select average_price2019.location_code, round(average_price2019.av_price19-average_price2020.av_price20,2) as "Change_average_estimated_value"
from average_price2019
join average_price2020 on average_price2019.location_code=average_price2020.location_code;

-- i.
create view location_estimations2020 as
select property.location_code, count(estimation.ecode) as "estimations"
from property
join estimation on estimation.property_id=property.property_id
				and year(estimation_date)=2020
join location on property.location_code=location.location_code
group by property.location_code;

create view total_estimations2020 as
select count(estimation.ecode) as "total_estimations"
from estimation
where year(estimation_date)=2020;

create view location_population2020 as
select location.location_code, location.population
from location;

create view total_population2020 as
select sum(location.population) as "total_population"
from location;

select location_population2020.location_code as "Locations", 
concat(round((location_estimations2020.estimations/total_estimations2020.total_estimations * 100 ),2),'%') 
as "Percentage of estimations per location", 
concat(round((location_population2020.population/total_population2020.total_population * 100 ),2),'%') 
as "Percentage of population per location"
from total_estimations2020,  total_population2020, location_estimations2020
join location_population2020 on location_population2020.location_code=location_estimations2020.location_code;
