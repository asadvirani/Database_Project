-------------------------------------------------------------------
--HIRE table func and trigger
-------------------------------------------------------------------

--Function returning a price after deducting discount from the rental price
create or replace function finalprice (cid number, pid number, doh date, dd date)
return float
is
disc category.discount%type;
cost int;
month int;
begin
select Category.discount into disc from Category inner join customer on Category.Cat_id=customer.Cat_id
where customer.cust_id=cid;

select rental_price into cost from painting where paint_id = pid;
dbms_output.put_line('discount is ' || disc ||  '%'|| ' cost is ' || cost);
    month := round(months_between(dd, doh), 0);
    dbms_output.put_line('months are '  || month);
 cost:= month*cost;
    dbms_output.put_line('total cost '  || cost);
return cost * ((100-disc)/100);

end;

DECLARE    
   n3 float;    
BEGIN    
   n3 := finalprice(1,11);    
   dbms_output.put_line('cost minus discount is: ' || n3);    
END;    



--this updating the revenue in the tabel owner whenever a entry is made in the hire table
Create or replace trigger updaterev
 after  insert  on hire
 For each row
 Enable
 Declare
 cost hire.hire_cost%type;
 pid int;
 oid int;
 
  Begin
 select :new.hire_cost, :new.paint_id into cost, pid from dual; --hire where hire_id=:new.hire_id;
 select own_id into oid from painting where paint_id=pid;
 cost := cost * 0.1;
 dbms_output.put_line('rev is ' || cost);
 
 update owner set revenue=COALESCE(revenue, 0) + cost where own_id=oid;
 dbms_output.put_line(' revenue updated succesfully ' );
End;



execute inserthire( to_date('1994','yyyy'), to_date('2002','yyyy'), 3,1);
select * from hire;

--this is being fired whenever an insertion is done on hire and it updated the hirecost by calling the function finalprice 
-- it also check if due date is greater than date of hire and raises exception
Create or replace trigger updatehirecost
 before insert on hire
 For each row
 Enable
 Declare
 pid int;
 n3 float;    
 dd hire.duedate%type;

    
  Begin
        select :new.duedate into dd from dual;
            if :new.dateofhire > dd then
                RAISE_APPLICATION_ERROR(-20000,'not possible as date is geater than due date');
            end if;    

    select :new.paint_id into pid from dual;
    update painting set available='N' where paint_id=pid;
    
    n3 := finalprice(:new.cust_id, :new.paint_id, :new.dateofhire, :new.duedate); 
    dbms_output.put_line(n3);
    :new.hire_cost:=n3;
 dbms_output.put_line(' hire cost updated succesfully ' || :new.hire_id );
End;

drop trigger updatehirecost;

execute inserthire( to_date('2002','yyyy'), to_date('2003','yyyy'), 3,3);
select * from hire;
select * from painting;
select * from owner;


