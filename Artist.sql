-------------------------------------------------------------
--TRIGGERS ON THE TABLE ARTIST
-------------------------------------------------------------


--This is checking that year of death or year of birth is not greater than sysdate
--secondly it is also checking is date of death is greater than date of birth so will raise an exception
--finally it is also calculating the age whenever date of birth or date of death is being entered
create or replace trigger checkyearofdeath
before insert or update of yearofdeath, yearofbirth on Artist
for each row
enable 
declare
uage Artist.age%type;

yob Artist.YearofBirth%type;
begin
select :new.YearofBirth into yob from dual;
if :new.yearofdeath > sysdate then
    RAISE_APPLICATION_ERROR(-20000,'not possible as date is geate than sysdate');
elsif yob > sysdate
    then
    RAISE_APPLICATION_ERROR(-20000,'not possible as date is geate than sysdate');
end if;    
if inserting then
    if :new.yearofdeath is not null then
        if :new.yearofdeath < yob then
            RAISE_APPLICATION_ERROR(-20000,'not possible insertion');
            --dbms_output.put_line('not possible insertion');
        end if;
    end if;
elsif updating then        
    if :new.yearofdeath < yob then
        --update artist set yearofdeath=yearofdeath where art_id=:new.art_id;
        RAISE_APPLICATION_ERROR(-20000,'not possible update');
        --dbms_output.put_line('not possible update');
    end if;
end if;

if :new.yearofdeath is not null then
     uage := round(months_between(:new.yearofdeath, yob)/12, 0);
     dbms_output.put_line(' yod not null ' || uage || ' ' || :new.yearofdeath || ' ' || yob );
else
    uage := round(months_between(sysdate, yob)/12, 0);
    dbms_output.put_line(' yod null ' || uage);
 
 end if;
:new.age:=uage;


end;

select * from Artist;
drop table artist;

insert into Artist (Art_Name,Country,yearofbirth,Yearofdeath) values ( 'asad','pak', to_date ('2011', 'YYYY'), to_date ('2010', 'YYYY') );
update artist set yearofdeath =to_date ('2000', 'YYYY') where art_id=4;








