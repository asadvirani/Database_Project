-------------------------------------------------------------
-- some general proceduare
-- TRiggers for the table paintings
-------------------------------------------------------------

create or replace procedure SearchByArtist (aname varchar)
is
cursor c1 is select p.* from painting p inner join artist a on a.art_id=p.art_id where a.art_name =aname;
begin
for rec in c1
loop
dbms_output.put_line('painting title is ' || rec.paint_title || ' paind id is ' || rec.paint_id);
end loop;
end;

execute SearchByArtist('Felicia');


create or replace procedure SearchByTheme (aname varchar)
is
cursor c1 is select * from painting   where paint_theme =aname;
begin
for rec in c1
loop
dbms_output.put_line('painting title is ' || rec.paint_title || ' paind id is ' || rec.paint_id);
end loop;
end;

execute SearchByTheme(' Animals');

create or replace procedure SetRental (price number, pid number)
is
begin
update Painting set rental_price =price where paint_id=pid;
dbms_output.put_line(' paind id is ' || pid || ' is updated');
end;

execute SetRental(2000,2);


--Trigger checking if a painting has not been isued since 6 months then the returned variable will be turned ON
Create or replace trigger returned
 after insert on Painting
 For each row
 Enable
 Declare
 cursor c1 is select h.* from Hire h inner join Painting p on h.paint_id= :new.paint_id;
 date Hire.dateofhire%type := :new.paint_date; 
 Begin
 for rec in c1
 loop
 if date < rec.dateofhire then 
 date:=rec.dateofhire;
 end if;
-- dbms_output.put_line(' Insertion done succesfully ');
end loop;
if round(months_between(sysdate, date), 0) > 6 then
    update painting set returned='Y', resubmission='N', paint_date=sysdate where paint_id= :new.paint_id;
end if;
End;


--Trigger checking if a painting has been in returned since 3 months then the resubmission variable will be turned ON
Create or replace trigger allowedresub
 after insert or update of resubmission on Painting
 For each row
 Enable
 Declare

 date Hire.dateofhire%type := :new.paint_date; 
 Begin
-- dbms_output.put_line(' Insertion done succesfully ');
if round(months_between(sysdate, date), 0) > 3 then
    update painting set resubmission='Y' where paint_id= :new.paint_id;
end if;
End;

 

