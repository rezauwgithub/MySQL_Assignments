
/* Reza Naeemi

/*
NOTE: 	I set the SESSION sql_mode to STRICT_ALL_TABLES because
		MySQL Workbench 6.0 and 5.2.47 (did not test 6.1 yet...) was allowing NULL to be assigned
		to NOT NULL columns when using the UPDATE clause. (It was not allowed with the INSERT clause.)
		http://bugs.mysql.com/bug.php?id=33699

		NOW, with this setting, the UPDATE clause also produces the expected error to occur on 
*/
SET SESSION sql_mode = 'STRICT_ALL_TABLES';

DROP DATABASE IF EXISTS team22_paranormalsightings_db;
CREATE DATABASE team22_paranormalsightings_db;

USE team22_paranormalsightings_db;

ALTER DATABASE team22_paranormalsightings_db CHARACTER SET utf8 COLLATE utf8_general_ci;



CREATE TABLE Weather
(
	weatherCode						INT					PRIMARY KEY 	AUTO_INCREMENT,
    description						VARCHAR(20)
);

CREATE TABLE Category
(
	categoryCode					INT					PRIMARY KEY 	AUTO_INCREMENT,
    description						VARCHAR(20)
);

CREATE TABLE City
(
	cityCode						CHAR(3)				PRIMARY KEY,
    name							VARCHAR(20)			NOT NULL,
    abbreviation					VARCHAR(10)
);

CREATE TABLE State
(
	statePostalCode					CHAR(2)				PRIMARY KEY,
    name							VARCHAR(20)			NOT NULL,
    abbreviation					VARCHAR(10)
);

CREATE TABLE Country
(
	countryISOCode					CHAR(3)			PRIMARY KEY,
    name							VARCHAR(50)
);

CREATE TABLE PersonType
(
	personType						INT					PRIMARY KEY		AUTO_INCREMENT,
    description						VARCHAR(50)
);

CREATE TABLE Event
(
	eventID							INT					PRIMARY KEY		AUTO_INCREMENT,
    duration						INT,
    datetime						DATETIME			NOT NULL,
    summary							VARCHAR(200),
    reportedPostDate				DATE,
    weather							INT,
    category						INT					NOT NULL,
    environmentalChanges			VARCHAR(100),
    mechanicalInterference 			VARCHAR(100),
    witnessCount					INT,
    CONSTRAINT event_fk_weather
		FOREIGN KEY (weather)
        REFERENCES Weather (weatherCode),
	CONSTRAINT event_fk_category
		FOREIGN KEY (category)
		REFERENCES Category (categoryCode)
);

CREATE TABLE Location
(
    streetAddress					VARCHAR(30)			NOT NULL,
    city							CHAR(3)				NOT NULL,
    state							CHAR(2),
    zipCode							VARCHAR(10),
    country							CHAR(3)				NOT NULL,
	yearBuilt						INT,
    paranormalHistory				VARCHAR(100),
    criminalActivity				VARCHAR(100),
    nearestLandmark					VARCHAR(100),
    PRIMARY KEY (streetAddress, city),
    CONSTRAINT location_fk_state
		FOREIGN KEY (state)
        REFERENCES State (statePostalCode),
	CONSTRAINT location_fk_country
		FOREIGN KEY (country)
		REFERENCES Country (countryISOCode),
	CONSTRAINT location_fk_city
		FOREIGN KEY (city)
        REFERENCES City (cityCode)
);

CREATE TABLE EventLocation			
(
	eventID							INT					NOT NULL,
    streetAddress					VARCHAR(20)			NOT NULL,
    city							VARCHAR(20)			NOT NULL,
    PRIMARY KEY event_location_pk (eventID, streetAddress, city),
	CONSTRAINT event_fk_location
		FOREIGN KEY (eventID)
        REFERENCES Event (eventID),
	CONSTRAINT location_fk_event
		FOREIGN KEY (streetAddress, city)
        REFERENCES Location (streetAddress, city)
);

CREATE TABLE Documentation
(
	documentationID					INT					PRIMARY KEY			AUTO_INCREMENT,
    audioRecording					VARCHAR(100),
	videoRecording					VARCHAR(100),
    photograph						VARCHAR(100)
);

CREATE TABLE EventDocumentation
(
	eventID							INT					NOT NULL,
    documentationID					INT					NOT NULL,
    CONSTRAINT event_documentation_pk
		PRIMARY KEY (eventID, documentationID),
	CONSTRAINT event_fk_documentation
		FOREIGN KEY (eventID)
        REFERENCES Event (eventID),
	CONSTRAINT document_fk_event
		FOREIGN KEY (documentationID)
        REFERENCES Documentation (documentationID)
);

CREATE TABLE Person
(
	personID						INT					PRIMARY KEY,
	firstName						VARCHAR(25)			NOT NULL,
	lastName						VARCHAR(25)			NOT NULL,
    dob								DATE,
    mobilePhoneNumber				VARCHAR(15),
    faxNumber						VARCHAR(15),
    homePhoneNumber					VARCHAR(15),
    workPhoneNumber					VARCHAR(15),
    emailAddress					VARCHAR(50),
    occuptation						VARCHAR(50),
    mentalHealth					VARCHAR(100),
    historyWithParanormal			VARCHAR(100),
    credentials						VARCHAR(100),
    organization					VARCHAR(50)
);

CREATE TABLE EventPerson
(
	eventID							INT					NOT NULL,
    personID						INT					NOT NULL,
    personType						INT					NOT NULL,
    CONSTRAINT event_person_pk
		PRIMARY KEY (eventID, personID, personType),
	CONSTRAINT event_fk_person
		FOREIGN KEY (eventID)
        REFERENCES Event (eventID),
	CONSTRAINT person_fk_event
		FOREIGN KEY (personID)
        REFERENCES Person (personID),
	CONSTRAINT event_person_fk_persontype
		FOREIGN KEY (personType)
        REFERENCES PersonType (personType)
);

CREATE TABLE SasquatchSighting
(
	sasquatchID						INT					PRIMARY KEY		AUTO_INCREMENT,
    eventID							INT,
    sasquatchBehaviorDescription	VARCHAR(100),
    sasquatchVisualDescription		VARCHAR(100),
    CONSTRAINT sasquatchsighting_fk_event
		FOREIGN KEY (eventID)
        REFERENCES Event (eventID)     
);

CREATE TABLE GhostSighting
(
	ghostID							INT					PRIMARY KEY		AUTO_INCREMENT,
    eventID							INT,
    ghostCount						INT,
    ghostBehaviorDescription		VARCHAR(100),
    ghostVisualDescription			VARCHAR(100),
    CONSTRAINT ghostsighting_fk_event
		FOREIGN KEY (eventID)
        REFERENCES Event (eventID)     
);

CREATE TABLE UFOSighting
(
	ufoID							INT					PRIMARY KEY		AUTO_INCREMENT,
    eventID							INT,
    ufoCount						INT,
    shape							VARCHAR(50),
    sound							VARCHAR(50),
    altitude						INT,
    speed							INT,
    CONSTRAINT ufosighting_fk_event
		FOREIGN KEY (eventID)
        REFERENCES Event (eventID) 
);



/*
CREATE INDEX downloads_download_date_ix
	ON downloads (download_date DESC);
*/



INSERT INTO Weather VALUES
(DEFAULT, 'Sunny'),
(DEFAULT, 'Overcast'),
(DEFAULT, 'Rainy'),
(DEFAULT, 'Stormy'),
(DEFAULT, 'Clear-Night');


INSERT INTO Category VALUES
(DEFAULT, 'Ghost'),
(DEFAULT, 'UFO'),
(DEFAULT, 'Sasquatch');

INSERT INTO City VALUES
('SEA', 'Seattle', NULL),
('WDV', 'Woodinville', NULL),
('LA', 'Los Angeles', NULL),
('KNA', 'Kuna', NULL),
('BIL', 'Billings', NULL),
('THP', 'Throop', NULL),
('LND', 'London', NULL),
('BHL',	'Buhl', NULL),
('MTH',	'Mountain Home', NULL),
('DSM', 'DeSmet', NULL),
('NMP',	'Nampa', NULL),
('EDN', 'Eden', NULL),
('FRT',	'Firth', NULL);

INSERT INTO State VALUES
('AL', 'Alabama', 'Ala'),
('AK', 'Alaska', 'Alaska'),
('AS', 'American Samoa', NULL),	
('AZ', 'Arizona', 'Ariz.'),
('AR', 'Arkansas', 'Ark.'),
('CA', 'California', 'Calif.'),
('CO', 'Colorado', 'Colo.'),
('CT', 'Connecticut', 'Conn.'),
('DE', 'Delaware', 'Del.'),
('DC', 'Dist. of Columbia', 'D.C.'),
('FL', 'Florida', 'Fla.'),
('GA', 'Georgia', 'Ga.'),
('GU', 'Guam', 'Guam'),
('HI', 'Hawaii', 'Hawaii'),
('ID', 'Idaho', 'Idaho'),
('IL', 'Illinois', 'Ill.'),
('IN', 'Indiana', 'Ind.'),
('IA', 'Iowa', 'Iowa'),
('KS', 'Kansas', 'Kans.'),
('KY', 'Kentucky', 'Ky.'),
('LA', 'Louisiana', 'La.'),
('ME', 'Maine', 'Maine'),
('MD', 'Maryland', 'Md.'),
('MH', 'Marshall Islands', NULL),	
('MA', 'Massachusetts', 'Mass.'),
('MI', 'Michigan', 'Mich.'),
('FM', 'Micronesia', NULL),
('MN', 'Minnesota', 'Minn.'),
('MS', 'Mississippi', 'Miss.'),
('MO', 'Missouri', 'Mo.'),
('MT', 'Montana', 'Mont.'),
('NE', 'Nebraska', 'Nebr.'),
('NV', 'Nevada', 'Nev.'),
('NH', 'New Hampshire', 'N.H.'),
('NJ', 'New Jersey', 'N.J.'),
('NM', 'New Mexico', 'N.M.'),
('NY', 'New York', 'N.Y.'),
('NC', 'North Carolina', 'N.C.'),
('ND', 'North Dakota', 'N.D.'),
('MP', 'Northern Marianas', NULL),	
('OH', 'Ohio', 'Ohio'),
('OK', 'Oklahoma', 'Okla.'),
('OR', 'Oregon', 'Ore.'),
('PW', 'Palau', NULL),
('PA', 'Pennsylvania', 'Pa.'),
('PR', 'Puerto Rico', 'P.R.'),
('RI', 'Rhode Island', 'R.I.'),
('SC', 'South Carolina', 'S.C.'),
('SD', 'South Dakota', 'S.D.'),
('TN', 'Tennessee', 'Tenn.'),
('TX', 'Texas', 'Tex.'),
('UT', 'Utah', 'Utah'),
('VT', 'Vermont', 'Vt.'),
('VA', 'Virginia', 'Va.'),
('VI', 'Virgin Islands', 'V.I.'),
('WA', 'Washington', 'Wash.'),
('WV', 'West Virginia', 'W.Va.'),
('WI', 'Wisconsin', 'Wis.'),
('WY', 'Wyoming', 'Wyo.');


INSERT INTO Country VALUES
('ZWE', 'Zimbabwe'),
('ZMB', 'Zambia'),
('ZAF', 'South Africa'),
('MYT', 'Mayotte'),
('YEM', 'Yemen'),
('XKX', 'Kosovo'),
('WSM', 'Samoa'),
('WLF', 'Wallis and Futuna'),
('VUT', 'Vanuatu'),
('VNM', 'Vietnam'),
('VIR', 'U.S. Virgin Islands'),
('VGB', 'British Virgin Islands'),
('VEN', 'Venezuela'),
('VCT', 'Saint Vincent and the Grenadines'),
('VAT', 'Vatican'),
('UZB', 'Uzbekistan'),
('URY', 'Uruguay'),
('USA', 'United States'),
('UGA', 'Uganda'),
('UKR', 'Ukraine'),
('TZA', 'Tanzania'),
('TWN', 'Taiwan'),
('TUV', 'Tuvalu'),
('TTO', 'Trinidad and Tobago'),
('TUR', 'Turkey'),
('TON', 'Tonga'),
('TUN', 'Tunisia'),
('TKM', 'Turkmenistan'),
('TLS', 'East Timor'),
('TKL', 'Tokelau'),
('TJK', 'Tajikistan'),
('THA', 'Thailand'),
('TGO', 'Togo'),
('TCD', 'Chad'),
('TCA', 'Turks and Caicos Islands'),
('SWZ', 'Swaziland'),
('SYR', 'Syria'),
('SXM', 'Sint Maarten'),
('SLV', 'El Salvador'),
('STP', 'Sao Tome and Principe'),
('SSD', 'South Sudan'),
('SUR', 'Suriname'),
('SOM', 'Somalia'),
('SEN', 'Senegal'),
('SMR', 'San Marino'),
('SLE', 'Sierra Leone'),
('SVK', 'Slovakia'),
('SJM', 'Svalbard and Jan Mayen'),
('SVN', 'Slovenia'),
('SHN', 'Saint Helena'),
('SGP', 'Singapore'),
('SWE', 'Sweden'),
('SDN', 'Sudan'),
('SYC', 'Seychelles'),
('SLB', 'Solomon Islands'),
('SAU', 'Saudi Arabia'),
('RWA', 'Rwanda'),
('RUS', 'Russia'),
('SRB', 'Serbia'),
('ROU', 'Romania'),
('REU', 'Reunion'),
('QAT', 'Qatar'),
('PRY', 'Paraguay'),
('PLW', 'Palau'),
('PRT', 'Portugal'),
('PSE', 'Palestine'),
('PRI', 'Puerto Rico'),
('PCN', 'Pitcairn'),
('SPM', 'Saint Pierre and Miquelon'),
('POL', 'Poland'),
('PAK', 'Pakistan'),
('PHL', 'Philippines'),
('PNG', 'Papua New Guinea'),
('PYF', 'French Polynesia'),
('PER', 'Peru'),
('PAN', 'Panama'),
('OMN', 'Oman'),
('NZL', 'New Zealand'),
('NIU', 'Niue'),
('NRU', 'Nauru'),
('NPL', 'Nepal'),
('NOR', 'Norway'),
('NLD', 'Netherlands'),
('NIC', 'Nicaragua'),
('NGA', 'Nigeria'),
('NER', 'Niger'),
('NCL', 'New Caledonia'),
('NAM', 'Namibia'),
('MOZ', 'Mozambique'),
('MYS', 'Malaysia'),
('MEX', 'Mexico'),
('MWI', 'Malawi'),
('MDV', 'Maldives'),
('MUS', 'Mauritius'),
('MLT', 'Malta'),
('MSR', 'Montserrat'),
('MRT', 'Mauritania'),
('MNP', 'Northern Mariana Islands'),
('MAC', 'Macau'),
('MNG', 'Mongolia'),
('MMR', 'Myanmar'),
('MLI', 'Mali'),
('MKD', 'Macedonia'),
('MHL', 'Marshall Islands'),
('MDG', 'Madagascar'),
('MAF', 'Saint Martin'),
('MNE', 'Montenegro'),
('MDA', 'Moldova'),
('MCO', 'Monaco'),
('MAR', 'Morocco'),
('LBY', 'Libya'),
('LVA', 'Latvia'),
('LUX', 'Luxembourg'),
('LTU', 'Lithuania'),
('LSO', 'Lesotho'),
('LBR', 'Liberia'),
('LKA', 'Sri Lanka'),
('LIE', 'Liechtenstein'),
('LCA', 'Saint Lucia'),
('LBN', 'Lebanon'),
('LAO', 'Laos'),
('KAZ', 'Kazakhstan'),
('CYM', 'Cayman Islands'),
('KWT', 'Kuwait'),
('KOR', 'South Korea'),
('PRK', 'North Korea'),
('KNA', 'Saint Kitts and Nevis'),
('COM', 'Comoros'),
('KIR', 'Kiribati'),
('KHM', 'Cambodia'),
('KGZ', 'Kyrgyzstan'),
('KEN', 'Kenya'),
('JPN', 'Japan'),
('JOR', 'Jordan'),
('JAM', 'Jamaica'),
('JEY', 'Jersey'),
('ITA', 'Italy'),
('ISL', 'Iceland'),
('IRN', 'Iran'),
('IRQ', 'Iraq'),
('IOT', 'British Indian Ocean Territory'),
('IND', 'India'),
('IMN', 'Isle of Man'),
('ISR', 'Israel'),
('IRL', 'Ireland'),
('IDN', 'Indonesia'),
('HUN', 'Hungary'),
('HTI', 'Haiti'),
('HRV', 'Croatia'),
('HND', 'Honduras'),
('HKG', 'Hong Kong'),
('GUY', 'Guyana'),
('GNB', 'Guinea-Bissau'),
('GUM', 'Guam'),
('GTM', 'Guatemala'),
('GRC', 'Greece'),
('GNQ', 'Equatorial Guinea'),
('GIN', 'Guinea'),
('GMB', 'Gambia'),
('GRL', 'Greenland'),
('GIB', 'Gibraltar'),
('GHA', 'Ghana'),
('GGY', 'Guernsey'),
('GEO', 'Georgia'),
('GRD', 'Grenada'),
('GBR', 'United Kingdom'),
('GAB', 'Gabon'),
('FRA', 'France'),
('FRO', 'Faroe Islands'),
('FSM', 'Micronesia'),
('FLK', 'Falkland Islands'),
('FJI', 'Fiji'),
('FIN', 'Finland'),
('ETH', 'Ethiopia'),
('ESP', 'Spain'),
('ERI', 'Eritrea'),
('ESH', 'Western Sahara'),
('EGY', 'Egypt'),
('EST', 'Estonia'),
('ECU', 'Ecuador'),
('DZA', 'Algeria'),
('DOM', 'Dominican Republic'),
('DMA', 'Dominica'),
('DNK', 'Denmark'),
('DJI', 'Djibouti'),
('DEU', 'Germany'),
('CZE', 'Czech Republic'),
('CYP', 'Cyprus'),
('CXR', 'Christmas Island'),
('CUW', 'Curacao'),
('CPV', 'Cape Verde'),
('CUB', 'Cuba'),
('CRI', 'Costa Rica'),
('COL', 'Colombia'),
('CHN', 'China'),
('CMR', 'Cameroon'),
('CHL', 'Chile'),
('COK', 'Cook Islands'),
('CIV', 'Ivory Coast'),
('CHE', 'Switzerland'),
('COG', 'Republic of the Congo'),
('CAF', 'Central African Republic'),
('COD', 'Democratic Republic of the Congo'),
('CCK', 'Cocos Islands'),
('CAN', 'Canada'),
('BLZ', 'Belize'),
('BLR', 'Belarus'),
('BWA', 'Botswana'),
('BTN', 'Bhutan'),
('BHS', 'Bahamas'),
('BRA', 'Brazil'),
('BOL', 'Bolivia'),
('BRN', 'Brunei'),
('BMU', 'Bermuda'),
('BLM', 'Saint Barthelemy'),
('BEN', 'Benin'),
('BDI', 'Burundi'),
('BHR', 'Bahrain'),
('BGR', 'Bulgaria'),
('BFA', 'Burkina Faso'),
('BEL', 'Belgium'),
('BGD', 'Bangladesh'),
('BRB', 'Barbados'),
('BIH', 'Bosnia and Herzegovina'),
('AZE', 'Azerbaijan'),
('ABW', 'Aruba'),
('AUS', 'Australia'),
('AUT', 'Austria'),
('ASM', 'American Samoa'),
('ARG', 'Argentina'),
('ATA', 'Antarctica'),
('AGO', 'Angola'),
('ANT', 'Netherlands Antilles'),
('ARM', 'Armenia'),
('ALB', 'Albania'),
('AIA', 'Anguilla'),
('ATG', 'Antigua and Barbuda'),
('AFG', 'Afghanistan'),
('ARE', 'United Arab Emirates'),
('AND', 'Andorra');


INSERT INTO PersonType VALUES
(DEFAULT, 'Witness'),
(DEFAULT, 'Paranormal Investigator');




/* Reporting Inserts start here! The Inserts above were mainly to get the database ready for Paranormal Sighting reports */
INSERT INTO Location VALUES
('12420 NE 155th Place', 'WDV', 'WA', '98072', 'USA', NULL, NULL, NULL, NULL);

INSERT INTO Event VALUES
(DEFAULT, NULL, '2011-01-01', NULL, NULL, (SELECT weatherCode FROM Weather WHERE description = 'Sunny'), (SELECT categoryCode FROM Category WHERE description = 'Ghost'), 'Blah Blah', 'Ha Ha', 1);

SET @last_id_in_event_table = LAST_INSERT_ID();

INSERT INTO EventLocation VALUES
(@last_id_in_event_table, '12420 NE 155th Place', 'WDV');

INSERT INTO Documentation VALUES
(DEFAULT, NULL, NULL, NULL);

SET @last_id_in_documentation_table = LAST_INSERT_ID();

INSERT INTO EventDocumentation VALUES
(@last_id_in_event_table, @last_id_in_documentation_table);

SET @person_id = 555342340;

INSERT INTO Person VALUES
(@person_id, 'Joe', 'Nses', '1984-05-14', '425-435-0544', NULL, NULL, NULL, 'rezauw@uw.edu', 'Parent', 'Crazy!', 'Somewhat', 'Jedi Master Coder', 'University of Washington Bothell');

INSERT INTO EventPerson VALUES
(@last_id_in_event_table, @person_id, (SELECT personType FROM PersonType WHERE description = 'Witness')); 

INSERT INTO GhostSighting VALUES
(DEFAULT, @last_id_in_event_table, 2, 'Moving around in circles', 'Something about Visual Descripton');

SET @last_id_in_ghostsighting_table = LAST_INSERT_ID();





INSERT INTO Location VALUES
('1420 NW 22nd Street', 'SEA', 'WA', '98034', 'USA', 1829, 'Same paranormal report from different people', 'Murder', NULL);

INSERT INTO Event VALUES
(DEFAULT, NULL, '2002-02-07', NULL, NULL, (SELECT weatherCode FROM Weather WHERE description = 'Rainy'), (SELECT categoryCode FROM Category WHERE description = 'UFO'), 'Blah Blah', 'Ha Ha', 1);

SET @last_id_in_event_table = LAST_INSERT_ID();

INSERT INTO EventLocation VALUES
(@last_id_in_event_table, '1420 NW 22nd Street', 'SEA');

INSERT INTO Documentation VALUES
(DEFAULT, NULL, NULL, NULL);

SET @last_id_in_documentation_table = LAST_INSERT_ID();

INSERT INTO EventDocumentation VALUES
(@last_id_in_event_table, @last_id_in_documentation_table);

SET @person_id = 555332240;

INSERT INTO Person VALUES
(@person_id, 'Reza', 'Naeemi', '1982-02-12', '425-435-0588', NULL, NULL, NULL, 'rezauw@uw.edu', 'Student', 'Crazy!', 'Somewhat', 'Jedi Master Coder', 'University of Washington Bothell');

INSERT INTO EventPerson VALUES
(@last_id_in_event_table, @person_id, (SELECT personType FROM PersonType WHERE description = 'Witness')); 

INSERT INTO UFOSighting VALUES
(DEFAULT, @last_id_in_event_table, 1, 'Round', NULL, NULL, NULL);

SET @last_id_in_ufosighting_table = LAST_INSERT_ID();









INSERT INTO Location VALUES
('1222 SW 11th Street', 'LA', 'CA', '38472', 'USA', NULL, NULL, NULL, NULL);

INSERT INTO Event VALUES
(DEFAULT, NULL, '2012-02-01', NULL, NULL, (SELECT weatherCode FROM Weather WHERE description = 'Sunny'), (SELECT categoryCode FROM Category WHERE description = 'Sasquatch'), 'Blah Blah', 'Ha Ha', 1);

SET @last_id_in_event_table = LAST_INSERT_ID();

INSERT INTO EventLocation VALUES
(@last_id_in_event_table, '1222 SW 11th Street', 'LA');

INSERT INTO Documentation VALUES
(DEFAULT, NULL, NULL, NULL);

SET @last_id_in_documentation_table = LAST_INSERT_ID();

INSERT INTO EventDocumentation VALUES
(@last_id_in_event_table, @last_id_in_documentation_table);

SET @person_id = 555322310;

INSERT INTO Person VALUES
(@person_id, 'John', 'Smith', '1972-07-17', '425-425-0238', NULL, NULL, NULL, 'johnuw@uw.edu', 'Student', 'Cool!', 'Somewhat', 'Coder', 'University of Washington Bothell');

INSERT INTO EventPerson VALUES
(@last_id_in_event_table, @person_id, (SELECT personType FROM PersonType WHERE description = 'Witness')); 

INSERT INTO SasquatchSighting VALUES
(DEFAULT, @last_id_in_event_table, 'Something about behavior', 'Something about Visual Descripton');

SET @last_id_in_sasquatchsighting_table = LAST_INSERT_ID();







INSERT INTO Location VALUES
('12420 NE 175th Place', 'WDV', 'WA', '98072', 'USA', NULL, NULL, NULL, NULL);

INSERT INTO Event VALUES
(DEFAULT, NULL, '2012-02-01', NULL, NULL, (SELECT weatherCode FROM Weather WHERE description = 'Sunny'), (SELECT categoryCode FROM Category WHERE description = 'Sasquatch'), 'Blah Blah', 'Ha Ha', 1);

SET @last_id_in_event_table = LAST_INSERT_ID();

INSERT INTO EventLocation VALUES
(@last_id_in_event_table, '12420 NE 155th Place', 'WDV');

INSERT INTO Documentation VALUES
(DEFAULT, NULL, NULL, NULL);

SET @last_id_in_documentation_table = LAST_INSERT_ID();

INSERT INTO EventDocumentation VALUES
(@last_id_in_event_table, @last_id_in_documentation_table);

SET @person_id = 525342240;

INSERT INTO Person VALUES
(@person_id, 'Reza', 'Naeemi', '1982-02-12', '425-435-0588', NULL, NULL, NULL, 'rezauw@uw.edu', 'Student', 'Crazy!', 'Somewhat', 'Jedi Master Coder', 'University of Washington Bothell');

INSERT INTO EventPerson VALUES
(@last_id_in_event_table, @person_id, (SELECT personType FROM PersonType WHERE description = 'Witness')); 

INSERT INTO SasquatchSighting VALUES
(DEFAULT, @last_id_in_event_table, 'Something about behavior', 'Something about Visual Descripton');

SET @last_id_in_sasquatchsighting_table = LAST_INSERT_ID();







INSERT INTO Location VALUES
('124 NE 158th Place', 'SEA', 'WA', '98133', 'USA', NULL, NULL, NULL, NULL);

INSERT INTO Event VALUES
(DEFAULT, NULL, '2012-02-01', NULL, NULL, (SELECT weatherCode FROM Weather WHERE description = 'Sunny'), (SELECT categoryCode FROM Category WHERE description = 'Ghost'), 'Blah Blah', 'Ha Ha', 1);

SET @last_id_in_event_table = LAST_INSERT_ID();

INSERT INTO EventLocation VALUES
(@last_id_in_event_table, '12420 NE 155th Place', 'WDV');

INSERT INTO Documentation VALUES
(DEFAULT, NULL, NULL, NULL);

SET @last_id_in_documentation_table = LAST_INSERT_ID();

INSERT INTO EventDocumentation VALUES
(@last_id_in_event_table, @last_id_in_documentation_table);

SET @person_id = 255342340;

INSERT INTO Person VALUES
(@person_id, 'Reza', 'Naeemi', '1982-02-12', '425-435-0588', NULL, NULL, NULL, 'rezauw@uw.edu', 'Student', 'Crazy!', 'Somewhat', 'Jedi Master Coder', 'University of Washington Bothell');

INSERT INTO EventPerson VALUES
(@last_id_in_event_table, @person_id, (SELECT personType FROM PersonType WHERE description = 'Witness')); 

INSERT INTO GhostSighting VALUES
(DEFAULT, @last_id_in_event_table, 2, 'Moving around in circles', 'Something about Visual Descripton');

SET @last_id_in_ghostsighting_table = LAST_INSERT_ID();








INSERT INTO Location VALUES
('12420 NW 55th Street', 'SEA', 'WA', '98122', 'USA', NULL, NULL, NULL, NULL);

INSERT INTO Event VALUES
(DEFAULT, NULL, '2012-02-01', NULL, NULL, (SELECT weatherCode FROM Weather WHERE description = 'Sunny'), (SELECT categoryCode FROM Category WHERE description = 'Ghost'), 'Blah Blah', 'Ha Ha', 1);

SET @last_id_in_event_table = LAST_INSERT_ID();

INSERT INTO EventLocation VALUES
(@last_id_in_event_table, '12420 NE 155th Place', 'WDV');

INSERT INTO Documentation VALUES
(DEFAULT, NULL, NULL, NULL);

SET @last_id_in_documentation_table = LAST_INSERT_ID();

INSERT INTO EventDocumentation VALUES
(@last_id_in_event_table, @last_id_in_documentation_table);

SET @person_id = 558312320;

INSERT INTO Person VALUES
(@person_id, 'Reza', 'Naeemi', '1982-02-12', '425-235-1588', NULL, NULL, NULL, 'rezauw@uw.edu', 'Student', 'Crazy!', 'Somewhat', 'Jedi Master Coder', 'University of Washington Bothell');

INSERT INTO EventPerson VALUES
(@last_id_in_event_table, @person_id, (SELECT personType FROM PersonType WHERE description = 'Witness')); 

INSERT INTO GhostSighting VALUES
(DEFAULT, @last_id_in_event_table, 2, 'Moving around in circles', 'Something about Visual Descripton');

SET @last_id_in_ghostsighting_table = LAST_INSERT_ID();




INSERT INTO Location VALUES
('12420 NE 151th Place', 'SEA', 'WA', '98071', 'USA', NULL, NULL, NULL, NULL);

INSERT INTO Event VALUES
(DEFAULT, NULL, '2012-02-01', NULL, NULL, (SELECT weatherCode FROM Weather WHERE description = 'Sunny'), (SELECT categoryCode FROM Category WHERE description = 'Sasquatch'), 'Blah Blah', 'Ha Ha', 1);

SET @last_id_in_event_table = LAST_INSERT_ID();

INSERT INTO EventLocation VALUES
(@last_id_in_event_table, '12420 NE 155th Place', 'WDV');

INSERT INTO Documentation VALUES
(DEFAULT, NULL, NULL, NULL);

SET @last_id_in_documentation_table = LAST_INSERT_ID();

INSERT INTO EventDocumentation VALUES
(@last_id_in_event_table, @last_id_in_documentation_table);

SET @person_id = 551342244;

INSERT INTO Person VALUES
(@person_id, 'Reza', 'Naeemi', '1982-01-01', '425-433-0288', NULL, NULL, NULL, 'rezauw@uw.edu', 'Student', 'Crazy!', 'Somewhat', 'Jedi Master Coder', 'University of Washington Bothell');

INSERT INTO EventPerson VALUES
(@last_id_in_event_table, @person_id, (SELECT personType FROM PersonType WHERE description = 'Witness')); 

INSERT INTO SasquatchSighting VALUES
(DEFAULT, @last_id_in_event_table, 'Something about behavior', 'Something about Visual Descripton');

SET @last_id_in_sasquatchsighting_table = LAST_INSERT_ID();





INSERT INTO Location VALUES
('12420 NE 152th Place', 'WDV', 'WA', '98072', 'USA', NULL, NULL, NULL, NULL);

INSERT INTO Event VALUES
(DEFAULT, NULL, '2012-02-01', NULL, NULL, (SELECT weatherCode FROM Weather WHERE description = 'Sunny'), (SELECT categoryCode FROM Category WHERE description = 'UFO'), 'Blah Blah', 'Ha Ha', 1);

SET @last_id_in_event_table = LAST_INSERT_ID();

INSERT INTO EventLocation VALUES
(@last_id_in_event_table, '12420 NE 155th Place', 'WDV');

INSERT INTO Documentation VALUES
(DEFAULT, NULL, NULL, NULL);

SET @last_id_in_documentation_table = LAST_INSERT_ID();

INSERT INTO EventDocumentation VALUES
(@last_id_in_event_table, @last_id_in_documentation_table);

SET @person_id = 565342640;

INSERT INTO Person VALUES
(@person_id, 'Reza', 'Naeemi', '1982-02-12', '425-435-0588', NULL, NULL, NULL, 'rezauw@uw.edu', 'Student', 'Crazy!', 'Somewhat', 'Jedi Master Coder', 'University of Washington Bothell');

INSERT INTO EventPerson VALUES
(@last_id_in_event_table, @person_id, (SELECT personType FROM PersonType WHERE description = 'Witness')); 

INSERT INTO UFOSighting VALUES
(DEFAULT, @last_id_in_event_table, 1, 'Round', NULL, NULL, NULL);

SET @last_id_in_ufosighting_table = LAST_INSERT_ID();




INSERT INTO Location VALUES
('12420 NE 115th Place', 'WDV', 'WA', '98072', 'USA', NULL, NULL, NULL, NULL);

INSERT INTO Event VALUES
(DEFAULT, NULL, '2012-02-01', NULL, NULL, (SELECT weatherCode FROM Weather WHERE description = 'Sunny'), (SELECT categoryCode FROM Category WHERE description = 'UFO'), 'Blah Blah', 'Ha Ha', 1);

SET @last_id_in_event_table = LAST_INSERT_ID();

INSERT INTO EventLocation VALUES
(@last_id_in_event_table, '12420 NE 155th Place', 'WDV');

INSERT INTO Documentation VALUES
(DEFAULT, NULL, NULL, NULL);

SET @last_id_in_documentation_table = LAST_INSERT_ID();

INSERT INTO EventDocumentation VALUES
(@last_id_in_event_table, @last_id_in_documentation_table);

SET @person_id = 655342346;

INSERT INTO Person VALUES
(@person_id, 'Reza', 'Naeemi', '1982-02-12', '425-435-1288', NULL, NULL, NULL, 'rezauw@uw.edu', 'Student', 'Crazy!', 'Really?', 'Coder', 'University of Washington Bothell');

INSERT INTO EventPerson VALUES
(@last_id_in_event_table, @person_id, (SELECT personType FROM PersonType WHERE description = 'Witness')); 

INSERT INTO UFOSighting VALUES
(DEFAULT, @last_id_in_event_table, 1, 'Round', NULL, NULL, NULL);

SET @last_id_in_ufosighting_table = LAST_INSERT_ID();





INSERT INTO Location VALUES
('12420 NE 155th Street', 'SEA', 'WA', '98122', 'USA', NULL, NULL, NULL, NULL);

INSERT INTO Event VALUES
(DEFAULT, NULL, '2012-02-01', NULL, NULL, (SELECT weatherCode FROM Weather WHERE description = 'Sunny'), (SELECT categoryCode FROM Category WHERE description = 'UFO'), 'Blah Blah', 'Ha Ha', 1);

SET @last_id_in_event_table = LAST_INSERT_ID();

INSERT INTO EventLocation VALUES
(@last_id_in_event_table, '12420 NE 155th Place', 'WDV');

INSERT INTO Documentation VALUES
(DEFAULT, NULL, NULL, NULL);

SET @last_id_in_documentation_table = LAST_INSERT_ID();

INSERT INTO EventDocumentation VALUES
(@last_id_in_event_table, @last_id_in_documentation_table);

SET @person_id = 565642360;

INSERT INTO Person VALUES
(@person_id, 'Reza', 'Naeemi', '1982-02-12', '425-435-0588', NULL, NULL, NULL, 'rezauw@uw.edu', 'Student', NULL, NULL, 'Jedi Master Coder', 'University of Washington Bothell');

INSERT INTO EventPerson VALUES
(@last_id_in_event_table, @person_id, (SELECT personType FROM PersonType WHERE description = 'Witness')); 

INSERT INTO UFOSighting VALUES
(DEFAULT, @last_id_in_event_table, 1, 'Round', NULL, NULL, NULL);

SET @last_id_in_ufosighting_table = LAST_INSERT_ID();







INSERT INTO Location VALUES
('12422 SW 155th Place', 'SEA', 'WA', '98072', 'USA', NULL, NULL, NULL, NULL);

INSERT INTO Event VALUES
(DEFAULT, NULL, '2012-02-01', NULL, NULL, (SELECT weatherCode FROM Weather WHERE description = 'Sunny'), (SELECT categoryCode FROM Category WHERE description = 'Sasquatch'), 'Blah Blah', 'Ha Ha', 1);

SET @last_id_in_event_table = LAST_INSERT_ID();

INSERT INTO EventLocation VALUES
(@last_id_in_event_table, '12420 NE 155th Place', 'WDV');

INSERT INTO Documentation VALUES
(DEFAULT, NULL, NULL, NULL);

SET @last_id_in_documentation_table = LAST_INSERT_ID();

INSERT INTO EventDocumentation VALUES
(@last_id_in_event_table, @last_id_in_documentation_table);

SET @person_id = 565342360;

INSERT INTO Person VALUES
(@person_id, 'Reza', 'Naeemi', '1982-02-12', '425-435-0588', NULL, NULL, NULL, 'rezauw@uw.edu', 'Student', 'Crazy!', 'Somewhat', 'Jedi Master Coder', 'University of Washington Bothell');

INSERT INTO EventPerson VALUES
(@last_id_in_event_table, @person_id, (SELECT personType FROM PersonType WHERE description = 'Witness')); 

INSERT INTO SasquatchSighting VALUES
(DEFAULT, @last_id_in_event_table, 'Something about behavior', 'Something about Visual Descripton');

SET @last_id_in_sasquatchsighting_table = LAST_INSERT_ID();





INSERT INTO Location VALUES
('12420 SE 155th Street', 'WDV', 'WA', '98072', 'USA', NULL, NULL, NULL, NULL);

INSERT INTO Event VALUES
(DEFAULT, NULL, '2012-02-01', NULL, NULL, (SELECT weatherCode FROM Weather WHERE description = 'Sunny'), (SELECT categoryCode FROM Category WHERE description = 'Ghost'), 'Blah Blah', 'Ha Ha', 1);

SET @last_id_in_event_table = LAST_INSERT_ID();

INSERT INTO EventLocation VALUES
(@last_id_in_event_table, '12420 NE 155th Place', 'WDV');

INSERT INTO Documentation VALUES
(DEFAULT, NULL, NULL, NULL);

SET @last_id_in_documentation_table = LAST_INSERT_ID();

INSERT INTO EventDocumentation VALUES
(@last_id_in_event_table, @last_id_in_documentation_table);

SET @person_id = 535342340;

INSERT INTO Person VALUES
(@person_id, 'Reza', 'Naeemi', '1982-02-12', '425-435-0588', NULL, NULL, NULL, 'rezauw@uw.edu', 'Student', 'Crazy!', 'Somewhat', 'Jedi Master Coder', 'University of Washington Bothell');

INSERT INTO EventPerson VALUES
(@last_id_in_event_table, @person_id, (SELECT personType FROM PersonType WHERE description = 'Witness')); 

INSERT INTO GhostSighting VALUES
(DEFAULT, @last_id_in_event_table, 2, 'Moving around in circles', 'Something about Visual Descripton');

SET @last_id_in_ghostsighting_table = LAST_INSERT_ID();




INSERT INTO Location VALUES
('12320 NE 152th Place', 'SEA', 'WA', '98072', 'USA', NULL, NULL, NULL, NULL);

INSERT INTO Event VALUES
(DEFAULT, NULL, '2012-02-01', NULL, NULL, (SELECT weatherCode FROM Weather WHERE description = 'Sunny'), (SELECT categoryCode FROM Category WHERE description = 'Sasquatch'), NULL, 'Ha Ha', 4);

SET @last_id_in_event_table = LAST_INSERT_ID();

INSERT INTO EventLocation VALUES
(@last_id_in_event_table, '12320 NE 152th Place', 'SEA');

INSERT INTO Documentation VALUES
(DEFAULT, NULL, NULL, NULL);

SET @last_id_in_documentation_table = LAST_INSERT_ID();

INSERT INTO EventDocumentation VALUES
(@last_id_in_event_table, @last_id_in_documentation_table);

SET @person_id = 525342342;

INSERT INTO Person VALUES
(@person_id, 'Alex', 'O', '1982-02-12', '425-435-0588', NULL, NULL, NULL, 'alexuw@uw.edu', 'Student', NULL, 'Somewhat', 'Coder', 'University of Washington Seattle');

INSERT INTO EventPerson VALUES
(@last_id_in_event_table, @person_id, (SELECT personType FROM PersonType WHERE description = 'Paranormal Investigator')); 

INSERT INTO SasquatchSighting VALUES
(DEFAULT, @last_id_in_event_table, 'The usual', NULL);

SET @last_id_in_sasquatchsighting_table = LAST_INSERT_ID();



/* 
Group: Project Queries
Write EIGHT (8) queries for your database to reflect recreating reports, maps, 
alerts, charts, or other output based the original artifacts.The queries should
be represent a spread of different uses.These queries should be saved in a copy 
of the database with your database to be submitted.
Each query should be named based on what it should be able to reproduce from the 
original artifacts. Also, reference the page number from the original
artifact PDF that who data you are trying to create a query to reproduce. 
The output should be sorted in meaningful order to produce a readable list.
You should produce a query that closest meets that the respective request; however, your 
individual database structure may have limitations that prevent exact matches, 
so reasonably close representatives may be accepted. 
If your database does not contain any data related to the query, you may need to
modify your database to accomodate those queries.
*/

INSERT INTO Location VALUES
('????', 'BHL', 'ID', NULL, 'USA', NULL, NULL, NULL, NULL);

INSERT INTO Event VALUES
(DEFAULT, 1800, '2016-07-27 22:38', 'We saw a very large, long object with orangish lights on the bottom, moving over the tree tops. ((NUFORC Note: Space debris. PD))', '2016-08-02', NULL, (SELECT categoryCode FROM Category WHERE description = 'UFO'), NULL, NULL, 1);

SET @last_id_in_event_table = LAST_INSERT_ID();

INSERT INTO EventLocation VALUES
(@last_id_in_event_table, '????', 'BHL');

INSERT INTO UFOSighting VALUES
(DEFAULT, @last_id_in_event_table, 1, 'Rectangle', NULL, NULL, NULL);

SET @last_id_in_ufosighting_table = LAST_INSERT_ID();



INSERT INTO Location VALUES
('????', 'MTH', 'ID', NULL, 'USA', NULL, NULL, NULL, NULL);

INSERT INTO Event VALUES
(DEFAULT, 240, '2016-07-27 22:30', 'Two UFOs witnessed between Boise and Mountain Home. ((NUFORC Note: Chinese rocket re-entry. PD))', '2016-08-02', NULL, (SELECT categoryCode FROM Category WHERE description = 'UFO'), NULL, NULL, 1);

SET @last_id_in_event_table = LAST_INSERT_ID();

INSERT INTO EventLocation VALUES
(@last_id_in_event_table, '????', 'MTH');

INSERT INTO UFOSighting VALUES
(DEFAULT, @last_id_in_event_table, 1, 'Formation', NULL, NULL, NULL);

SET @last_id_in_ufosighting_table = LAST_INSERT_ID();



INSERT INTO Location VALUES
('????', 'DSM', 'ID', NULL, 'USA', NULL, NULL, NULL, NULL);

INSERT INTO Event VALUES
(DEFAULT, 45, '2016-07-27 22:30', 'Moving star. ((NUFORC Note: Chinese rocket re-entry?? PD))', '2016-08-02', NULL, (SELECT categoryCode FROM Category WHERE description = 'UFO'), NULL, NULL, 1);

SET @last_id_in_event_table = LAST_INSERT_ID();

INSERT INTO EventLocation VALUES
(@last_id_in_event_table, '????', 'DSM');

INSERT INTO UFOSighting VALUES
(DEFAULT, @last_id_in_event_table, 1, 'Light', NULL, NULL, NULL);

SET @last_id_in_ufosighting_table = LAST_INSERT_ID();



INSERT INTO Location VALUES
('????', 'NMP', 'ID', NULL, 'USA', NULL, NULL, NULL, NULL);

INSERT INTO Event VALUES
(DEFAULT, 300, '2016-07-27 05:10', 'Yellowish light moving through early morning sky - no sound, no strobes', '2016-08-02', NULL, (SELECT categoryCode FROM Category WHERE description = 'UFO'), NULL, NULL, 1);

SET @last_id_in_event_table = LAST_INSERT_ID();

INSERT INTO EventLocation VALUES
(@last_id_in_event_table, '????', 'NMP');

INSERT INTO UFOSighting VALUES
(DEFAULT, @last_id_in_event_table, 1, 'Light', NULL, NULL, NULL);

SET @last_id_in_ufosighting_table = LAST_INSERT_ID();



INSERT INTO Location VALUES
('????2', 'NMP', 'ID', NULL, 'USA', NULL, NULL, NULL, NULL);

INSERT INTO Event VALUES
(DEFAULT, 300, '2016-07-27 05:10', 'Yellowish light moving through early morning sky - no sound, no strobes', '2016-08-02', NULL, (SELECT categoryCode FROM Category WHERE description = 'UFO'), NULL, NULL, 1);

SET @last_id_in_event_table = LAST_INSERT_ID();

INSERT INTO EventLocation VALUES
(@last_id_in_event_table, '????', 'NMP');

INSERT INTO UFOSighting VALUES
(DEFAULT, @last_id_in_event_table, 1, 'Light', NULL, NULL, NULL);

SET @last_id_in_ufosighting_table = LAST_INSERT_ID();




/* Using Artifact from page 73 of the 2016-02-summer-artifacts-v1.1.pdf */

INSERT INTO Location VALUES
('????', 'KNA', 'ID', NULL, 'USA', NULL, NULL, NULL, NULL);

INSERT INTO Event VALUES
(DEFAULT, 1200, '2016-06-24 00:00', '10‐15 yellow orbs floatng upward, then east to west, before they descended and disappeared.', '2016-06-24', NULL, (SELECT categoryCode FROM Category WHERE description = 'UFO'), NULL, NULL, 1);

SET @last_id_in_event_table = LAST_INSERT_ID();

INSERT INTO EventLocation VALUES
(@last_id_in_event_table, '????', 'KNA');

INSERT INTO UFOSighting VALUES
(DEFAULT, @last_id_in_event_table, 1, 'Light', NULL, NULL, NULL);

SET @last_id_in_ufosighting_table = LAST_INSERT_ID();



INSERT INTO Location VALUES
('????', 'BIL', 'MT', NULL, 'USA', NULL, NULL, NULL, NULL);

INSERT INTO Event VALUES
(DEFAULT, 60, '2016-06-23 22:55', 'Yellowish/orange light observed by two people following a jet airplane.', '2016-06-24', NULL, (SELECT categoryCode FROM Category WHERE description = 'UFO'), NULL, NULL, 1);

SET @last_id_in_event_table = LAST_INSERT_ID();

INSERT INTO EventLocation VALUES
(@last_id_in_event_table, '????', 'BIL');

INSERT INTO UFOSighting VALUES
(DEFAULT, @last_id_in_event_table, 1, 'Light', NULL, NULL, NULL);

SET @last_id_in_ufosighting_table = LAST_INSERT_ID();



INSERT INTO Location VALUES
('????', 'THP', 'PA', NULL, 'USA', NULL, NULL, NULL, NULL);

INSERT INTO Event VALUES
(DEFAULT, 900, '2016-06-23 22:25', 'Looking up at the stars around 10:20 (EDT), when I observed what looked to be a shooĕng star.', '2016-06-24', NULL, (SELECT categoryCode FROM Category WHERE description = 'UFO'), NULL, NULL, 1);

SET @last_id_in_event_table = LAST_INSERT_ID();

INSERT INTO EventLocation VALUES
(@last_id_in_event_table, '????', 'THP');

INSERT INTO UFOSighting VALUES
(DEFAULT, @last_id_in_event_table, 1, 'Circle', NULL, NULL, NULL);

SET @last_id_in_ufosighting_table = LAST_INSERT_ID();



/* 
(PAGE 73 - From 2016-02-summer-artifacts-v1.1.pdf artifacts document)
NOTE: Not all entries have been inserted into this datebase yet, but will. - Reza

NAME: National UFO Reporting Center Monthly Report Index For 06/2016
*/
SELECT DATE_FORMAT(e.datetime, '%c/%d/%y %H:%i') AS 'Date / Time',
		c.name AS City,
        l.state AS State,
        ufos.shape AS Shape,
        e.duration AS Duration,
        e.summary AS Summary,
        DATE_FORMAT(e.reportedPostDate, '%c/%d/%y') AS Posted
FROM UFOSighting ufos JOIN Event e 
	USING (eventID) JOIN EventLocation el
    USING (eventID) JOIN Location l
    USING (streetAddress, city) JOIN City c
		ON l.city = c.cityCode
WHERE MONTH(e.datetime) = 6 AND YEAR(e.datetime) = 2016
ORDER BY e.datetime DESC;
        
        
/* NAME: How many UFO Sightings were there in the month of June of 2016*/
SELECT COUNT(*) AS 'Number of UFO Sightings in June of 2016'
FROM UFOSighting ufos JOIN Event e 
		ON ufos.eventID = e.eventID JOIN EventLocation el
		ON e.eventID = el.eventID JOIN Location l
		ON el.streetAddress = l.streetAddress AND
			el.city = l.city JOIN City c
		ON l.city = c.cityCode
WHERE MONTH(e.datetime) = 6 AND YEAR(e.datetime) = 2016;



/* NAME: How many UFO Sightings were there in total*/
SELECT COUNT(*) AS 'Total number of UFO Sightings'
FROM UFOSighting ufos JOIN Event e 
		ON ufos.eventID = e.eventID JOIN EventLocation el
		ON e.eventID = el.eventID JOIN Location l
		ON el.streetAddress = l.streetAddress AND
			el.city = l.city JOIN City c
		ON l.city = c.cityCode;



/* NAME: How many Ghost Sightings were there in total*/
SELECT COUNT(*) AS 'Total Number of Ghost Sightings in 2016'
FROM GhostSighting ghs JOIN Event e 
		ON ghs.eventID = e.eventID JOIN EventLocation el
		ON e.eventID = el.eventID JOIN Location l
		ON el.streetAddress = l.streetAddress AND
			el.city = l.city JOIN City c
		ON l.city = c.cityCode
WHERE YEAR(e.datetime) = 2016;



/* NAME:  Which Cities and States currently have reported Paranormal Sightings*/
SELECT c.name AS 'Name of City or State with Paranormal Sightings Reported'
FROM UFOSighting ufos JOIN Event e
	USING(eventID) JOIN EventLocation el
    USING(eventID) JOIN Location l
    ON el.streetAddress = l.streetAddress AND
		el.city = l.city JOIN City c
	ON l.city = c.cityCode
UNION
SELECT c.name
FROM GhostSighting ghs JOIN Event e
	USING(eventID) JOIN EventLocation el
	USING(eventID) JOIN Location l
    ON el.streetAddress = l.streetAddress AND
		el.city = l.city JOIN City c
	ON l.city = c.cityCode
UNION
SELECT c.name
FROM SasquatchSighting sas JOIN Event e
	USING(eventID) JOIN EventLocation el
	USING(eventID) JOIN Location l
    ON el.streetAddress = l.streetAddress AND
		el.city = l.city JOIN City c
	ON l.city = c.cityCode
UNION
SELECT s.name
FROM UFOSighting ufos JOIN Event e
	USING(eventID) JOIN EventLocation el
    USING(eventID) JOIN Location l
    ON el.streetAddress = l.streetAddress AND
		el.city = l.city JOIN State s
	ON l.state = s.statePostalCode
UNION
SELECT s.name
FROM GhostSighting ghs JOIN Event e
	USING(eventID) JOIN EventLocation el
	USING(eventID) JOIN Location l
    ON el.streetAddress = l.streetAddress AND
		el.city = l.city JOIN State s
	ON l.state = s.statePostalCode
UNION
SELECT s.name
FROM SasquatchSighting sas JOIN Event e
	USING(eventID) JOIN EventLocation el
	USING(eventID) JOIN Location l
    ON el.streetAddress = l.streetAddress AND
		el.city = l.city JOIN State s
	ON l.state = s.statePostalCode;
    



/*Display the name of all countries with Paranormal Sightings*/
/* NAME:  Which Cities and States currently have reported Paranormal Sightings*/
SELECT co.name AS 'All countries with Paranormal Sightings name'
FROM UFOSighting ufos JOIN Event e
	USING(eventID) JOIN EventLocation el
    USING(eventID) JOIN Location l
    ON el.streetAddress = l.streetAddress AND
		el.city = l.city JOIN Country co
	ON l.country = co.countryISOCode
UNION
SELECT co.name
FROM GhostSighting ghs JOIN Event e
	USING(eventID) JOIN EventLocation el
	USING(eventID) JOIN Location l
    ON el.streetAddress = l.streetAddress AND
		el.city = l.city JOIN Country co
	ON l.country = co.countryISOCode
UNION
SELECT co.name
FROM SasquatchSighting sas JOIN Event e
	USING(eventID) JOIN EventLocation el
	USING(eventID) JOIN Location l
    ON el.streetAddress = l.streetAddress AND
		el.city = l.city JOIN Country co
	ON l.country = co.countryISOCode;
    
    
    
/* Display all columns in the Person's table with the first name starts with the letter 'R' */
SELECT *
FROM Person
WHERE firstName LIKE 'R%';


/* Modify firstName and change it to 'Atefeh' where PersonID is equal to 3 */
UPDATE Person
SET firstName = 'Atefeh'
WHERE personID = 551342244;

