-------------------------------------------------------------
--Generating report of Customers
-------------------------------------------------------------


create or replace procedure custreport(cid int)
is
cursor c1 is select  p.*, h.duedate, h.dateofhire from category cat inner join customer c on cat.cat_id=c.cat_id
 inner join Hire h on c.cust_id=h.cust_id inner join painting p on p.paint_id=h.paint_id where c.cust_id=cid ;
 cat category.cat%type; cname customer.cust_name%type; 
add customer.cust_address%type; 
d category.description%type; 
disc category.discount%type; 

 Begin
 select cust_address,cust_name into add, cname from customer where cust_id=cid;
 select ca.cat, ca.discount, ca.description into cat, disc, d from category ca inner join customer c on ca.cat_id=c.cat_id where  c.cust_id=cid;

        dbms_output.put_line('Customer No.' || ' ' || cid || '          ' ||'Customer Category' || '   ' || cat );
    dbms_output.put_line('Customer Name' || ' ' || cname || '       ' ||'Category Discription' || ' ' || d );
    dbms_output.put_line('Customer Address' || ' ' || add || '       ' ||'Customer Discount' || ' ' || disc );
    dbms_output.put_line( ' ============================================================  ');
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('Painting No Painting Title Painting Theme Date of Hire Due Date Returned');
    DBMS_OUTPUT.PUT_LINE('----------- -------------- -------------- ------------ -------- ---------');

 for rec in c1
--  dbms_output.put_line('the total records are  '|| c1%rowcount);
    loop
          DBMS_OUTPUT.PUT_LINE(RPAD(rec.paint_id,11) || ' ' || RPAD(rec.paint_title, 15) || RPAD(rec.paint_theme, 15)
          || RPAD(rec.dateofhire, 13) || RPAD(rec.duedate, 10) || RPAD(rec.available, 9)
          );
    end loop;
end;

execute custreport(3);
execute viewcust;
select * from customer;
select * from hire;


--Generating report of Artisst
create or replace procedure artreport(aid int)
is
cursor c2 is select  p.paint_id, p.paint_title, p.paint_theme, p.rental_price, o.own_id, o.own_name, o.own_telephone from artist a inner join painting p on p.art_id=a.art_id  inner join owner o on o.own_id=p.own_id
where a.art_id=aid;
  aname Artist.art_name%type; coun Artist.country%type; yob Artist.yearofbirth%type; yod Artist.yearofdeath%type; 

 Begin
 select art_name, country, yearofbirth, yearofdeath into aname, coun, yob, yod from artist where art_id=aid;

        dbms_output.put_line('Artist No.' || ' ' || aid || '          ' ||'Year of birh' || '   ' || yob );
    dbms_output.put_line('Artist Name' || ' ' || aname || '       ' ||'Year of Death' || ' ' || yod );
    dbms_output.put_line('Customer of birth' || ' ' || coun  );
    dbms_output.put_line( ' ============================================================  ');
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('Painting No Painting Title Painting Theme Rental price owner no owner name ownner tel');
    DBMS_OUTPUT.PUT_LINE('----------- -------------- -------------- ------------ -------- ---------- ----------');

 for rec in c2
--  dbms_output.put_line('the total records are  '|| c1%rowcount);
  loop
          DBMS_OUTPUT.PUT_LINE(RPAD(rec.paint_id,11) || ' ' || RPAD(rec.paint_title, 15) || RPAD(rec.paint_theme, 15)
          || RPAD(rec.rental_price, 13) || RPAD(rec.own_id, 10) || RPAD(rec.own_name, 12) || RPAD(rec.own_telephone, 10)
          );
    end loop;
end;

execute artreport(3);
execute viewcust;
select * from painting;
select * from artist;


--Generating report of Return to owner report
create or replace procedure rettowner(oid int)
is
cursor c2 is select  p.paint_id, p.paint_title, p.paint_date from painting p inner join owner o on o.own_id=p.own_id 
where o.own_id=oid and p.returned='Y';
  oname owner.own_name%type; oadd owner.own_address%type;

 Begin
 select own_name, own_address into oname, oadd from Owner where own_id=oid;

        dbms_output.put_line('Owner No.' || ' ' || oid || '          ' ||'Owner name' || '   ' || oname );
    dbms_output.put_line('                                             ' ||'Owner address' || ' ' || oadd );
    dbms_output.put_line( ' ============================================================  ');
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('Painting No Painting Title Return Date');
    DBMS_OUTPUT.PUT_LINE('----------- -------------- -----------');

 for rec in c2
--  dbms_output.put_line('the total records are  '|| c1%rowcount);
  loop
          DBMS_OUTPUT.PUT_LINE(RPAD(rec.paint_id,11) || ' ' || RPAD(rec.paint_title, 16) || RPAD(rec.paint_date, 11));
    end loop;
end;


execute rettowner(3);
execute viewcust;
select * from painting;
select * from artist;

