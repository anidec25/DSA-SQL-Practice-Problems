-- Q1. Find the date with the highest total energy consumption from Meta/Facebook data centers. Output the date along with the total energy consumption across all data centers.
-- If there are multiple days with the same highest energy consumption then display both dates.

-- drop table fb_eu_energy;
create table fb_eu_energy
(
date date,
consumption int
);

-- drop table fb_asia_energy;
create table fb_asia_energy
(
date date,
consumption int
); 

-- drop table fb_na_energy;
create table fb_na_energy
(
date date,
consumption int
); 

insert into fb_eu_energy values ('2020-01-01',400);
insert into fb_eu_energy values ('2020-01-02',350);
insert into fb_eu_energy values ('2020-01-03',500);
insert into fb_eu_energy values ('2020-01-04',500);
insert into fb_eu_energy values ('2020-01-07',600);

insert into fb_asia_energy values ('2020-01-01',400);
insert into fb_asia_energy values ('2020-01-02',400);
insert into fb_asia_energy values ('2020-01-04',675);
insert into fb_asia_energy values ('2020-01-05',1200);
insert into fb_asia_energy values ('2020-01-06',750);
insert into fb_asia_energy values ('2020-01-07',400);

insert into fb_na_energy values ('2020-01-01',250);
insert into fb_na_energy values ('2020-01-02',375);
insert into fb_na_energy values ('2020-01-03',600);
insert into fb_na_energy values ('2020-01-06',500);
insert into fb_na_energy values ('2020-01-07',250);


-- Solution
WITH all_data as
(
  Select * from fb_eu_energy
  UNION ALL
  Select * from fb_asia_energy
  UNION ALL
  Select * from fb_na_energy
),

final as (
Select date, SUM(consumption) as total_consumption, DENSE_RANK() OVER(ORDER BY SUM(consumption) DESC) as RNK
from all_data
GROUP BY 1
ORDER BY total_consumption DESC
)

Select date, total_consumption
from final
where RNK = 1


-- Q2. From the students table, WASQ to interchange the adjacent student names. 
-- Note if there are no adjacent student then the stdudent name should remain same. 

-- drop table students;
create table students
(
id int primary key,
student_name varchar(50) not null
);
insert into students values
(1, 'James'),
(2, 'Michael'),
(3, 'George'),
(4, 'Stewart'),
(5, 'Robin');


-- Solution:
Select 
CASE 
WHEN id % 2 != 0 THEN id + 1 
WHEN id % 2 = 0 THEN id - 1
ELSE id END as ID,
student_name
from students
where id != (Select MAX(id) from students)

UNION 

Select id, student_name from 
students
where id % 2 != 0 and id = (Select MAX(id) from students)

ORDER BY 1


-- Alternate Solution: Using LEAD AND LAG

Select 
ID,
CASE 
WHEN id % 2 != 0 THEN LEAD(student_name, 1, student_name) OVER(Order by id)
WHEN id % 2 = 0 THEN LAG(student_name, 1, 'No Record Found') OVER(Order by id)
END as new_student_name
from 
students;




-- Q3: Find the Best Selling Item for each month
/*
Find the best selling item for each month (no need to separate months by year)
where the biggest total invoice was paid.
The best selling item is calculated using the formula (unitprice * quantity).
Output the description of the item along with the amount paid.
*/

drop table online_retail;
create table online_retail
    (
        invoiceno       varchar(20),
        stockcode       varchar(20),
        description     varchar(200),
        quantity        int,
        invoicedate     date,
        unitprice       float,
        customerid      int,
        country         varchar(50)
    );
insert into online_retail values ('544586',	'21890',			'S/6 WOODEN SKITTLES IN COTTON BAG',		3		,'2011-02-21',	2.95	,17338	,'United Kingdom');
insert into online_retail values ('541104',	'84509G',			'SET OF 4 FAIRY CAKE PLACEMATS',			3		,'2011-01-13',	3.29	,NULL		,'United Kingdom');
insert into online_retail values ('560772',	'22499',			'WOODEN UNION JACK BUNTING',				3		,'2011-07-20',	4.96	,NULL		,'United Kingdom');
insert into online_retail values ('555150',	'22488',			'NATURAL SLATE RECTANGLE CHALKBOARD',		5		,'2011-05-31',	3.29	,NULL		,'United Kingdom');
insert into online_retail values ('570521',	'21625',			'VINTAGE UNION JACK APRON',					3		,'2011-10-11',	6.95	,12371	,'Switzerland');
insert into online_retail values ('547053',	'22087',			'PAPER BUNTING WHITE LACE',					40		,'2011-03-20',	2.55	,13001	,'United Kingdom');
insert into online_retail values ('573360',	'22591',			'CARDHOLDER GINGHAM CHRISTMAS TREE',		6		,'2011-10-30',	3.25	,15748	,'United Kingdom');
insert into online_retail values ('571039',	'84536A',			'ENGLISH ROSE NOTEBOOK A7 SIZE',			1		,'2011-10-13',	0.42	,16121	,'United Kingdom');
insert into online_retail values ('578936',	'20723',			'STRAWBERRY CHARLOTTE BAG',					10		,'2011-11-27',	0.85	,16923	,'United Kingdom');
insert into online_retail values ('559338',	'21391',			'FRENCH LAVENDER SCENT HEART',				1		,'2011-07-07',	1.63	,NULL		,'United Kingdom');
insert into online_retail values ('568134',	'23171',			'REGENCY TEA PLATE GREEN',					1		,'2011-09-23',	3.29	,NULL		,'United Kingdom');
insert into online_retail values ('552061',	'21876',			'POTTERING MUG',							12		,'2011-05-06',	1.25	,13001	,'United Kingdom');
insert into online_retail values ('543179',	'22531',			'MAGIC DRAWING SLATE CIRCUS PARADE',		1		,'2011-02-04',	0.42	,12754	,'Japan');
insert into online_retail values ('540954',	'22381',			'TOY TIDY PINK POLKADOT',					4		,'2011-01-12',	2.1		,14606	,'United Kingdom');
insert into online_retail values ('572703',	'21818',			'GLITTER HEART DECORATION',					13		,'2011-10-25',	0.39	,16110	,'United Kingdom');
insert into online_retail values ('578757',	'23009',			'I LOVE LONDON BABY GIFT SET',				1		,'2011-11-25',	16.95,	12748	,'United Kingdom');
insert into online_retail values ('542616',	'22505',			'MEMO BOARD COTTAGE DESIGN',				4		,'2011-01-30',	4.95	,16816	,'United Kingdom');
insert into online_retail values ('554694',	'22921',			'HERB MARKER CHIVES',						1		,'2011-05-25',	1.63	,NULL		,'United Kingdom');
insert into online_retail values ('569545',	'21906',			'PHARMACIE FIRST AID TIN',					1		,'2011-10-04',	13.29   ,NULL			,'United Kingdom');
insert into online_retail values ('549562',	'21169',			'YOU''RE CONFUSING ME METAL SIGN',			1		,'2011-04-10',	1.69	,13232	,'United Kingdom');
insert into online_retail values ('580610',	'21945',			'STRAWBERRIES DESIGN FLANNEL',				1		,'2011-12-05',	1.63	,NULL		,'United Kingdom');
insert into online_retail values ('558066',	'gift_0001_50',		'Dotcomgiftshop Gift Voucher £50.00',		1		,'2011-06-24',	41.67   ,NULL			,'United Kingdom');
insert into online_retail values ('538349',	'21985',			'PACK OF 12 HEARTS DESIGN TISSUES',			1		,'2010-12-10',	0.85	,NULL		,'United Kingdom');
insert into online_retail values ('537685',	'22737',			'RIBBON REEL CHRISTMAS PRESENT',			15		,'2010-12-08',	1.65	,18077	,'United Kingdom');
insert into online_retail values ('545906',	'22614',			'PACK OF 12 SPACEBOY TISSUES',				24		,'2011-03-08',	0.29	,15764	,'United Kingdom');
insert into online_retail values ('550997',	'22629',			'SPACEBOY LUNCH BOX',						12		,'2011-04-26',	1.95	,17735	,'United Kingdom');
insert into online_retail values ('558763',	'22960',			'JAM MAKING SET WITH JARS',					3		,'2011-07-03',	4.25	,12841	,'United Kingdom');
insert into online_retail values ('562688',	'22918',			'HERB MARKER PARSLEY',						12		,'2011-08-08',	0.65	,13869	,'United Kingdom');
insert into online_retail values ('541424',	'84520B',			'PACK 20 ENGLISH ROSE PAPER NAPKINS',		9		,'2011-01-17',	1.63	,NULL		,'United Kingdom');
insert into online_retail values ('581405',	'20996',			'JAZZ HEARTS ADDRESS BOOK',					1		,'2011-12-08',	0.19	,13521	,'United Kingdom');
insert into online_retail values ('571053',	'23256',			'CHILDRENS CUTLERY SPACEBOY',				4		,'2011-10-13',	4.15	,12631	,'Finland');
insert into online_retail values ('563333',	'23012',			'GLASS APOTHECARY BOTTLE PERFUME',			1		,'2011-08-15',	3.95	,15996	,'United Kingdom');
insert into online_retail values ('568054',	'47559B',			'TEA TIME OVEN GLOVE',						4		,'2011-09-23',	1.25	,16978	,'United Kingdom');
insert into online_retail values ('574262',	'22561',			'WOODEN SCHOOL COLOURING SET',				12		,'2011-11-03',	1.65	,13721	,'United Kingdom');
insert into online_retail values ('569360',	'23198',			'PANTRY MAGNETIC SHOPPING LIST',			6		,'2011-10-03',	1.45	,14653	,'United Kingdom');
insert into online_retail values ('570210',	'22980',			'PANTRY SCRUBBING BRUSH',					2		,'2011-10-09',	1.65	,13259	,'United Kingdom');
insert into online_retail values ('576599',	'22847',			'BREAD BIN DINER STYLE IVORY',				1		,'2011-11-15',	16.95,	14544	,'United Kingdom');
insert into online_retail values ('579777',	'22356',			'CHARLOTTE BAG PINK POLKADOT',				4		,'2011-11-30',	1.63	,NULL		,'United Kingdom');
insert into online_retail values ('566060',	'21106',			'CREAM SLICE FLANNEL CHOCOLATE SPOT',		1		,'2011-09-08',	5.79	,NULL		,'United Kingdom');
insert into online_retail values ('550514',	'22489',			'PACK OF 12 TRADITIONAL CRAYONS',			24		,'2011-04-18',	0.42	,14631	,'United Kingdom');
insert into online_retail values ('569898',	'23437',			'50''S CHRISTMAS GIFT BAG LARGE',			2		,'2011-10-06',	2.46	,NULL		,'United Kingdom');
insert into online_retail values ('563566',	'23548',			'WRAP MAGIC FOREST',						25		,'2011-08-17',	0.42	,13655	,'United Kingdom');
insert into online_retail values ('539492',	'90209C',			'PINK ENAMEL+GLASS HAIR COMB',				1		,'2010-12-20',	2.11	,NULL		,'United Kingdom');
insert into online_retail values ('559693',	'21169',			'YOU''RE CONFUSING ME METAL SIGN',			1		,'2011-07-11',	4.13	,NULL		,'United Kingdom');
insert into online_retail values ('573386',	'22112',			'CHOCOLATE HOT WATER BOTTLE',				24		,'2011-10-30',	4.25	,17183	,'United Kingdom');
insert into online_retail values ('536520',	'84985A',			'SET OF 72 GREEN PAPER DOILIES',			1		,'2010-12-01',	1.45	,14729	,'United Kingdom');
insert into online_retail values ('556283',	'23306',			'SET OF 36 DOILIES PANTRY DESIGN',			12		,'2011-06-10',	1.45	,15628	,'United Kingdom');
insert into online_retail values ('571909',	'21117',			'BLOND DOLL DOORSTOP',						2		,'2011-10-19',	1.25	,15006	,'United Kingdom');
insert into online_retail values ('565378',	'21155',			'RED RETROSPOT PEG BAG',					7		,'2011-09-02',	4.96	,NULL		,'United Kingdom');
insert into online_retail values ('536592',	'90214H',			'LETTER "H" BLING KEY RING',				1		,'2010-12-01',	0.85	,NULL		,'United Kingdom');
insert into online_retail values ('580613',	'23438',			'RED SPOT GIFT BAG LARGE',					12		,'2011-12-05',	1.25	,14759	,'United Kingdom');
insert into online_retail values ('544336',	'21034',			'REX CASH+CARRY JUMBO SHOPPER',				1		,'2011-02-17',	0.95	,13230	,'United Kingdom');
insert into online_retail values ('542633',	'22382',			'LUNCH BAG SPACEBOY DESIGN',				2		,'2011-01-31',	4.13	,NULL		,'United Kingdom');
insert into online_retail values ('558485',	'23285',			'PINK VINTAGE SPOT BEAKER',					1		,'2011-06-30',	0.85	,NULL		,'United Kingdom');
insert into online_retail values ('564231',	'22424',			'ENAMEL BREAD BIN CREAM',					1		,'2011-08-24',	12.75,	13468	,'United Kingdom');
insert into online_retail values ('578746',	'84029E',			'RED WOOLLY HOTTIE WHITE HEART.',			25		,'2011-11-25',	9.13	,NULL		,'United Kingdom');
insert into online_retail values ('558564',	'23176',			'ABC TREASURE BOOK BOX',					3		,'2011-06-30',	2.25	,14057	,'United Kingdom');
insert into online_retail values ('C559345','21439',			'BASKET OF TOADSTOOLS',						-408	,'2011-07-07',	1.06	,13984	,'United Kingdom');
insert into online_retail values ('576920',	'23312',			'VINTAGE CHRISTMAS GIFT SACK',				4		,'2011-11-17',	4.15	,13871	,'United Kingdom');
insert into online_retail values ('564473',	'22384',			'LUNCH BAG PINK POLKADOT',					10		,'2011-08-25',	1.65	,16722	,'United Kingdom');
insert into online_retail values ('562264',	'23321',			'SMALL WHITE HEART OF WICKER',				3		,'2011-08-03',	3.29	,NULL		,'United Kingdom');
insert into online_retail values ('542541',	'79030D',			'TUMBLER, BAROQUE',							1		,'2011-01-28',	12.46,NULL			,'United Kingdom');
insert into online_retail values ('579937',	'22090',			'PAPER BUNTING RETROSPOT',					12		,'2011-12-01',	2.95	,13509	,'United Kingdom');
insert into online_retail values ('574076',	'22483',			'RED GINGHAM TEDDY BEAR',					1		,'2011-11-02',	5.79	,NULL		,'United Kingdom');
insert into online_retail values ('C571707','10135',			'COLOURING PENCILS BROWN TUBE',				-1		,'2011-10-18',	1.25	,14056	,'United Kingdom');
insert into online_retail values ('565617','84598',				'BOYS ALPHABET IRON ON PATCHES',			3		,'2011-09-05',	0.42	,NULL		,'United Kingdom');
insert into online_retail values ('579187','20665',				'RED RETROSPOT PURSE',						1		,'2011-11-28',	5.79	,NULL		,'United Kingdom');
insert into online_retail values ('542922','22423',				'REGENCY CAKESTAND 3 TIER',					3		,'2011-02-02',	12.75,	12682	,'France');
insert into online_retail values ('570677','23008',				'DOLLY GIRL BABY GIFT SET',					2		,'2011-10-11',	16.95,	12836	,'United Kingdom');
insert into online_retail values ('577182','21930',				'JUMBO STORAGE BAG SKULLS',					10		,'2011-11-18',	2.08	,16945	,'United Kingdom');
insert into online_retail values ('576686','20992',				'JAZZ HEARTS PURSE NOTEBOOK',				1		,'2011-11-16',	0.39	,16916	,'United Kingdom');
insert into online_retail values ('553844','22569',				'FELTCRAFT CUSHION BUTTERFLY',				4		,'2011-05-19',	3.75	,13450	,'United Kingdom');
insert into online_retail values ('580689','23150',				'IVORY SWEETHEART SOAP DISH',				6		,'2011-12-05',	2.49	,12994	,'United Kingdom');
insert into online_retail values ('545000','85206A',			'CREAM FELT EASTER EGG BASKET',				6		,'2011-02-25',	1.65	,15281	,'United Kingdom');
insert into online_retail values ('541975','22382',				'LUNCH BAG SPACEBOY DESIGN',				40		,'2011-01-24',	1.65	,NULL		,'Hong Kong');
insert into online_retail values ('544942','22551',				'PLASTERS IN TIN SPACEBOY',					12		,'2011-02-25',	1.65	,15544	,'United Kingdom');
insert into online_retail values ('543177','22667',				'RECIPE BOX RETROSPOT',						6		,'2011-02-04',	2.95	,14466	,'United Kingdom');
insert into online_retail values ('574587','23356',				'LOVE HOT WATER BOTTLE',					4		,'2011-11-06',	5.95	,14936	,'Channel Islands');
insert into online_retail values ('543451','22774',				'RED DRAWER KNOB ACRYLIC EDWARDIAN',		1		,'2011-02-08',	2.46	,NULL		,'United Kingdom');
insert into online_retail values ('578270','22579',				'WOODEN TREE CHRISTMAS SCANDINAVIAN',		1		,'2011-11-23',	1.63	,14096	,'United Kingdom');
insert into online_retail values ('551413','84970L',			'SINGLE HEART ZINC T-LIGHT HOLDER',			12		,'2011-04-28',	0.95	,16227	,'United Kingdom');
insert into online_retail values ('567666','22900',				'SET 2 TEA TOWELS I LOVE LONDON',			6		,'2011-09-21',	3.25	,12520	,'Germany');
insert into online_retail values ('571544','22810',				'SET OF 6 T-LIGHTS SNOWMEN',				2		,'2011-10-17',	2.95	,17757	,'United Kingdom');
insert into online_retail values ('558368','23249',				'VINTAGE RED ENAMEL TRIM PLATE',			12		,'2011-06-28',	1.65	,14329	,'United Kingdom');
insert into online_retail values ('546430','22284',				'HEN HOUSE DECORATION',						2		,'2011-03-13',	1.65	,15918	,'United Kingdom');
insert into online_retail values ('565233','23000',				'TRAVEL CARD WALLET TRANSPORT',				1		,'2011-09-02',	0.83	,NULL		,'United Kingdom');
insert into online_retail values ('559984','16012',				'FOOD/DRINK SPONGE STICKERS',				50		,'2011-07-14',	0.21	,16657	,'United Kingdom');
insert into online_retail values ('C546997','22398',			'MAGNETS PACK OF 4 SWALLOWS',				-6		,'2011-03-18',	1.25	,12748	,'United Kingdom');
insert into online_retail values ('538597','21824',				'PAINTED METAL STAR WITH HOLLY BELLS',		5		,'2010-12-13',	1.45	,15555	,'United Kingdom');
insert into online_retail values ('557892','23191',				'BUNDLE OF 3 RETRO NOTE BOOKS',				1		,'2011-06-23',	1.65	,14534	,'United Kingdom');
insert into online_retail values ('539314','21114',				'LAVENDER SCENTED FABRIC HEART',			20		,'2010-12-16',	1.25	,13874	,'United Kingdom');
insert into online_retail values ('561369','23009',				'I LOVE LONDON BABY GIFT SET',				1		,'2011-07-26',	24.96,NULL			,'United Kingdom');
insert into online_retail values ('562560','22411',				'JUMBO SHOPPER VINTAGE RED PAISLEY',		2		,'2011-08-05',	2.08	,14156	,'EIRE');
insert into online_retail values ('580848','72799E',			'IVORY PILLAR CANDLE SILVER FLOCK',			1		,'2011-12-06',	0.79	,18005	,'United Kingdom');
insert into online_retail values ('555388','22725',				'ALARM CLOCK BAKELIKE CHOCOLATE',			4		,'2011-06-02',	3.75	,17719	,'United Kingdom');
insert into online_retail values ('539451','22470',				'HEART OF WICKER LARGE',					3		,'2010-12-17',	5.91	,NULL		,'United Kingdom');
insert into online_retail values ('580730','21126',				'SET OF 6 GIRLS CELEBRATION CANDLES',		1		,'2011-12-05',	1.25	,NULL		,'United Kingdom');
insert into online_retail values ('577598','23210',				'WHITE ROCKING HORSE HAND PAINTED',			24		,'2011-11-21',	1.25	,13430	,'United Kingdom');
insert into online_retail values ('537141','22193',				'RED DINER WALL CLOCK',						1		,'2010-12-05',	8.5		,15570	,'United Kingdom');
insert into online_retail values ('579161','23493',				'VINTAGE DOILY TRAVEL SEWING KIT',			5		,'2011-11-28',	1.95	,17379	,'United Kingdom');
insert into online_retail values ('11','22087','PAPER BUNTING WHITE LACE',20,'2011-05-28',	2.55,NULL,'United Kingdom');
insert into online_retail values ('12','22087','PAPER BUNTING WHITE LACE',12,'2011-07-28',	2.55,NULL,'United Kingdom');
insert into online_retail values ('13','22087','PAPER BUNTING WHITE LACE',1	,'2011-08-28',	2.55,NULL,'United Kingdom');
insert into online_retail values ('14','22087','PAPER BUNTING WHITE LACE',10,'2011-07-28',	2.55,NULL,'United Kingdom');
insert into online_retail values ('15','22087','PAPER BUNTING WHITE LACE',2	,'2011-06-28',	2.55,NULL,'United Kingdom');
insert into online_retail values ('16','22087','PAPER BUNTING WHITE LACE',1	,'2011-04-28',	2.55,NULL,'United Kingdom');
insert into online_retail values ('17','22087','PAPER BUNTING WHITE LACE',1	,'2011-02-28',	2.55,NULL,'United Kingdom');
insert into online_retail values ('18','22087','PAPER BUNTING WHITE LACE',10,'2011-01-28',	2.55,NULL,'United Kingdom');
    


-- Solution
Select 
*
from 
(
Select description,
MONTH(invoicedate),
SUM(quantity * unitprice) as total_price, 
DENSE_RANK() OVER(PARTITION BY MONTH(invoicedate) ORDER BY SUM(quantity * unitprice) DESC) as RNK
from 
online_retail
# where MONTH(invoicedate) = 1
GROUP BY 1,2
) X
where X.RNK = 1


-- Q4: Write query to display the most expensive product under each category (corresponding to each record)

select * from product;

DROP TABLE product;
CREATE TABLE product
(
    product_category varchar(255),
    brand varchar(255),
    product_name varchar(255),
    price int
);

INSERT INTO product VALUES
('Phone', 'Apple', 'iPhone 12 Pro Max', 1300),
('Phone', 'Apple', 'iPhone 12 Pro', 1100),
('Phone', 'Apple', 'iPhone 12', 1000),
('Phone', 'Samsung', 'Galaxy Z Fold 3', 1800),
('Phone', 'Samsung', 'Galaxy Z Flip 3', 1000),
('Phone', 'Samsung', 'Galaxy Note 20', 1200),
('Phone', 'Samsung', 'Galaxy S21', 1000),
('Phone', 'OnePlus', 'OnePlus Nord', 300),
('Phone', 'OnePlus', 'OnePlus 9', 800),
('Phone', 'Google', 'Pixel 5', 600),
('Laptop', 'Apple', 'MacBook Pro 13', 2000),
('Laptop', 'Apple', 'MacBook Air', 1200),
('Laptop', 'Microsoft', 'Surface Laptop 4', 2100),
('Laptop', 'Dell', 'XPS 13', 2000),
('Laptop', 'Dell', 'XPS 15', 2300),
('Laptop', 'Dell', 'XPS 17', 2500),
('Earphone', 'Apple', 'AirPods Pro', 280),
('Earphone', 'Samsung', 'Galaxy Buds Pro', 220),
('Earphone', 'Samsung', 'Galaxy Buds Live', 170),
('Earphone', 'Sony', 'WF-1000XM4', 250),
('Headphone', 'Sony', 'WH-1000XM4', 400),
('Headphone', 'Apple', 'AirPods Max', 550),
('Headphone', 'Microsoft', 'Surface Headphones 2', 250),
('Smartwatch', 'Apple', 'Apple Watch Series 6', 1000),
('Smartwatch', 'Apple', 'Apple Watch SE', 400),
('Smartwatch', 'Samsung', 'Galaxy Watch 4', 600),
('Smartwatch', 'OnePlus', 'OnePlus Watch', 220);