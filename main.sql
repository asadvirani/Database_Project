-------------------------------------------------------------
--MAIN FILE CONTAINING CREATION TABLE COMMAND
-- PLUS SOME VIEW AND INSERT PROCEDURES
-------------------------------------------------------------

create table Category(
Cat_id number generated always as identity primary key,
Cat char not null,
Discount int not null,
Description varchar(255) not null
);

insert into Category (cat,discount, description )values ( 'B', 0 , 'Bronze');
insert into Category (cat,discount, description) values ( 'S', 5 , 'Silver');
insert into Category (cat,discount, description) values ( 'G', 10 , 'Gold');
insert into Category (cat,discount, description) values ( 'P', 15 , 'Platinum');

select * from category;


create table Customer(
Cust_id number generated always as identity primary key,
Cust_Name varchar(255) not null,
Cust_Address  varchar(255) not null,

Cat_id int not null references Category(Cat_id)  );

create table Artist(
Art_id number generated always as identity primary key,
Art_Name varchar(255) not null,
Country  varchar(255) not null,
YearofBirth date not null,
YearofDeath  date ,
age int 
);


insert into Artist values (1, 'asad', 'pak' , to_date ('2001', 'YYYY'), to_date ('2100', 'YYYY'));
insert into Artist values (2, 'asad', 'pak' , to_date ('2001', 'YYYY'), null );



create table Owner(
Own_id number generated always as identity primary key,
Own_Name varchar(255) not null,
Own_Telephone  int not null,
Own_address varchar(255) not null,
Revenue int  );


create table Painting(
Paint_id number generated always as identity primary key,
Paint_Title varchar(255) not null,
Paint_Theme  varchar(255) not null,
Rental_price int not NULL,
returned char DEFAULT 'N' ,
resubmission char DEFAULT 'Y',
available char DEFAULT 'Y',
Paint_date date DEFAULT  sysdate,
CONSTRAINT ret  check (returned='Y' or returned='N'),
CONSTRAINT res  check (resubmission='Y' or resubmission='N' or resubmission='NA'),
CONSTRAINT ava  check (available='Y' or available='N'),

art_id int not null  references Artist(art_id),
own_id int not null  references Owner(own_id)
);

create table Hire(
Hire_id number generated always as identity primary key,
DateofHire date not null, 
DueDate date not null,
Hire_cost int,

paint_id int not null references Painting(paint_id),
cust_id int  not null references Customer(cust_id)
);

INSERT INTO Customer(Cust_Name,Cust_Address,Cat_id) VALUES ('Mariam','Maida Field',4);
INSERT INTO Customer(Cust_Name,Cust_Address,Cat_id) VALUES ('Bryce',' Hardy Branch',3);
INSERT INTO Customer(Cust_Name,Cust_Address,Cat_id) VALUES ('Peggie','Elliott Shoal',2);
INSERT INTO Customer(Cust_Name,Cust_Address,Cat_id) VALUES ('Amparo',' Leora Plains ',4);
INSERT INTO Customer(Cust_Name,Cust_Address,Cat_id) VALUES ('Sheridan','Quitzon Way',3);


--PROCEDURE to VIEW data in tabel Customer
create or replace procedure viewcust
is
cursor c1 is select * from Customer;
begin
for rec in c1
loop
dbms_output.put_line(rec.cust_id||'     '||rec.cust_name||'      '||rec.cust_address || '       ' || rec.Cat_id);
end loop;
end;
--test
execute viewcust();

--PROCEDURE to INSERT AND VIEW data in tabel Customer
create or replace procedure insertCust (Cust_Name varchar ,Cust_Address  varchar ,Cat_id int )
is
begin
insert into customer  (Cust_Name,Cust_Address ,Cat_id) values
(Cust_Name,Cust_Address ,Cat_id);
--calling the procedure to print the all the data when entering a new record
viewcust();
commit;
end;

--test
execute insertCust( 'ali ', '788', 3);

--PROCEDURE to VIEW data in table Category
create or replace procedure viewcat
is
cursor c1 is select * from Category;
begin
for rec in c1
loop
dbms_output.put_line(rec.cat_id||'       '||rec.cat||'         '||rec.discount || '       ' || rec.description);
end loop;
end;

--PROCEDURE to INSERT AND VIEW data in tabel Category
create or replace procedure insertCat (Cat char,Discount int, Description varchar )
is
begin
insert into category (Cat,Discount,Description) values
(Cat,Discount,Description);
viewcat;
commit;
end;

--PROCEDURE to VIEW data in table Artist
create or replace procedure viewart
is
cursor c1 is select * from artist;
begin
for rec in c1
loop
dbms_output.put_line(rec.art_id||'       '||rec.art_name||'         '||rec.country || '      ' || rec.yearofbirth|| '       ' || rec.yearofdeath
|| '         ' || rec.age);
end loop;
end;

--PROCEDURE to INSERT AND VIEW data in table Artist
create or replace procedure insertArt (aname varchar, c varchar, yob date, yod date )
is
--aid Artist.art_id%type;
begin
insert into artist (art_name , country , yearofbirth , yearofdeath  ) values
(aname , c , yob , yod );
--select art_id into aid from artist where art_name=aname;
--setage(aid);
viewart();
commit;
end;

execute viewart;
execute insertart( 'saad ', 'pak', to_date('1996','YYYY'), null);
execute insertart( 'ali  ', 'pak', to_date('1990','YYYY'), null);
execute insertart( 'asad ', 'pak', to_date('2001','YYYY'), null);
execute insertart( 'danish ', 'pak', to_date('2002','YYYY'), null);
execute insertart( 'alina ', 'pak', to_date('1996','YYYY'), null);
--PROCEDURE to VIEW data in table Owner
create or replace procedure viewown
is
cursor c1 is select * from owner;
begin
for rec in c1
loop
dbms_output.put_line(rec.own_id||'       '||rec.own_name||'          '||rec.own_telephone || '       ' || rec.own_address|| '        ' || rec.revenue);
end loop;
end;


--PROCEDURE to INSERT AND VIEW data in table Owner
create or replace procedure insertOwner ( oname varchar , otel number, oadd varchar ,rev number )
is
begin
insert into owner (own_name, own_telephone, own_address, revenue) values
(oname, otel, oadd,rev);
viewown();
commit;
end;
execute viewown();
execute insertOwner('fizza', 234, 'Garden', 0);
execute insertOwner('humaira', 89898, 'clifton', 0);
execute insertOwner('gucci', 0990, 'baharia', 0);
execute insertOwner('maria', 1221, 'garden', 0);
execute insertOwner('sajjad', 9887, 'inara homes', 0);

--PROCEDURE to VIEW data in table Painting
create or replace procedure viewpaint
is
cursor c1 is select * from Painting;
begin
for rec in c1
loop
dbms_output.put_line(rec.paint_id||'        '||rec.paint_title||'        '||rec.paint_theme || '        ' || rec.rental_price|| '        ' 
|| rec.returned  || '       ' || rec.resubmission || '      ' || rec.available || '      ' || rec.paint_date || '       ' || rec.art_id || '         ' || rec.own_id   );
end loop;
end;
execute viewpaint;

--PROCEDURE to INSERT AND VIEW data in table painting
create or replace procedure insertPainting (pt varchar , pthe varchar , rp number, aid number, oid number)
is
begin
insert into painting (paint_title, paint_theme, rental_price, art_id, own_id) values
(pt, pthe, rp, aid, oid);
viewpaint;
commit;
end;

execute insertpainting('a123', 'animal', 10000, 1,3);
execute insertpainting('the great mys', 'landscape', 3000, 3,1);
execute insertpainting('lava', 'seascape', 1000, 3,2);
execute insertpainting('fire', 'naval', 10000, 4,3);
execute insertpainting('classroom', 'still?life', 2000, 5,3);

select * from painting;

--PROCEDURE to VIEW data in table Hire
create or replace procedure viewhire
is
cursor c1 is select * from hire;
begin
for rec in c1
loop
dbms_output.put_line(rec.hire_id||'      '||rec.dateofhire||'        '||rec.duedate || '        ' || rec.paint_id|| '        ' || rec.cust_id);
end loop;
end;

--PROCEDURE to INSERT AND VIEW data in table Hire
create or replace procedure insertHire ( doh date, dd date, pid number , cid number)
is
begin
insert into hire (dateofhire, duedate, paint_id, cust_id) values
( doh, dd, pid, cid);
viewhire;
commit;
end;

execute inserthire( to_date('1/1/2001','dd/mm/yyyy'), to_date('1/5/2001','dd/mm/yyyy') ,1,1);
execute inserthire( to_date('1/4/2001','dd/mm/yyyy'), to_date('1/8/2001','dd/mm/yyyy'),  2,1);
execute inserthire( to_date('1/10/2001','dd/mm/yyyy'), to_date('1/12/2001','dd/mm/yyyy'), 3,2);
execute inserthire( to_date('1/11/2001','dd/mm/yyyy'), to_date('1/1/2002','dd/mm/yyyy'), 4,3);
execute inserthire( to_date('1/12/2010','dd/mm/yyyy'), to_date('1/2/2011','dd/mm/yyyy'), 5,2);



select * from hire;
execute viewcust;

-- 
Create or replace trigger insertCust
 after insert or update on Customer
 For each row
 Enable
 Declare
 Begin
 if inserting then
 dbms_output.put_line(' Insertion done succesfully ');
 elsif updating then
  dbms_output.put_line(' Updation done succesfully ');
  end if;
End;

execute insertCust(32, 'Ali','777',2);











