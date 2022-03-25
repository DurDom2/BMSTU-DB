CREATE SCHEMA lab_05;
-- 1)�� ������ ���� ������, ��������� � ������ ������������ ������, �������
-- ������ � XML (MSSQL) ��� JSON(Oracle, Postgres). 

copy (select to_json(study.establishments.*) from study.establishments)
to 'C:/123/establishments.json';

copy(select array_to_json(array_agg(row_to_json(t))) as "establishments"
    from study.establishments as t)
  to 'C:/123/establishments.json';

-- 2)��������� �������� � ���������� XML ��� JSON ����� � �������.
-- ��������� ������� ����� ���� ����������� ������ ��������������� �������
-- ���� ������, ��������� � ������ ������������ ������.
create temporary table json_import (values text);
copy json_import from 'C:/123/establishments.json';

create table lab_05.establishments_json(
    address varchar(20), 
    square integer CHECK(square >= 5000),
    id integer CHECK(id > 0) PRIMARY KEY
);

insert into lab_05.establishments_json("address", "square", "id")
select  j->>'address' as address,
CAST(j->>'square' as integer) as square,
CAST(j->>'id' as integer) as id
from   (
           select json_array_elements(replace(values,'\','\\')::json) as j 
           from   json_import
       ) a where j->'address' is not null;
      
select * from lab_05.establishments_json;


-- 3) ������� �������, � ������� ����� �������(-�) � ����� XML ��� JSON, ���
-- �������� ������� � ����� XML ��� JSON � ��� ������������ �������.
-- ��������� ������� ��������������� ������� � ������� ������ INSERT
-- ��� UPDATE. 

drop table lab_05.json_table;
create table lab_05.json_table(
    establishments_id serial primary key,
    address varchar(40) not null,
    json_column json
);

insert into lab_05.json_table(address, json_column) values 
    ('���', '{"age": 52, "name": "�������� �.�."}'::json),
    ('ʸ���', '{"age": 65, "name": "������� �.�."}'::json),
    ('������', '{"age": 48, "name": "����� �.�."}'::json);

select * from lab_05.json_table;

-- 4. ��������� ��������� ��������:
-- 1. ������� XML/JSON �������� �� XML/JSON ���������
-- 2. ������� �������� ���������� ����� ��� ��������� XML/JSON ���������
-- 3. ��������� �������� ������������� ���� ��� ��������
-- 4. �������� XML/JSON ��������
-- 5. ��������� XML/JSON �������� �� ��������� ����� �� �����

-- 1. ������� XML/JSON �������� �� XML/JSON ���������
--�������� ���� �������, ��� ��� ���������� �� A
drop table lab_05.json_import;
drop table lab_05.establishments_json_frg;

create temporary table json_import(values text);
copy json_import from 'C:/123/establishments.json';

create table lab_05.establishments_json_frg(
    address varchar(20), 
    square integer CHECK(square >= 5000),
    id integer CHECK(id > 0) PRIMARY KEY
);

insert into lab_05.establishments_json_frg("address", "square", "id")
select  j->>'address' as address,
CAST(j->>'square' as integer) as square,
CAST(j->>'id' as integer) as id
from(
           select json_array_elements(replace(values,'\','\\')::json) as j 
           from   json_import
    )      a where j->'address' is not null and j->>'address' like '�%';
      
select * from lab_05.establishments_json_frg;

-- 2. ������� �������� ���������� ����� ��� ��������� XML/JSON ���������
-- 3. ��������� �������� ������������� ���� ��� ��������
--��������� �� null 
-- ������ � ��������� c id 8
drop table lab_05.establishments_json_frg;
create table lab_05.establishments_json_frg(
    address varchar(20), 
    square integer CHECK(square >= 5000),
    id integer CHECK(id > 0) PRIMARY KEY
);

insert into lab_05.establishments_json_frg("address", "square", "id")
select  j->>'address' as address,
CAST(j->>'square' as integer) as square,
CAST(j->>'id' as integer) as id
from(
           select json_array_elements(replace(values,'\','\\')::json) as j 
           from   json_import
       ) a where j->'address' is not null and j->>'id' = '8';
      
select * from lab_05.establishments_json_frg;


-- 4. �������� XML/JSON ��������

drop table json_import;
drop table lab_05.establishments_json_frg;

create temporary table json_import(values text);
copy json_import from 'C:/123/establishments.json';

create table lab_05.establishments_json_frg(
    address varchar(20), 
    square integer CHECK(square >= 5000),
    id integer CHECK(id > 0) PRIMARY KEY
);

insert into lab_05.establishments_json_frg("address", "square", "id")
select  j->>'address' as address,
CAST(j->>'square' as integer) as square,
CAST(j->>'id' as integer) as id
from   (
           select json_array_elements(replace(values,'\','\\')::json) as j 
           from   json_import
       ) a where j->'address' is not null;
select * from lab_05.establishments_json_frg;
update lab_05.establishments_json_frg
set address = 'new_address'
where id = 1;

select * from lab_05.establishments_json_frg;
select * from lab_05.establishments_json_frg where id = 1;

copy(select array_to_json(array_agg(row_to_json(t))) as "establishments"
    from lab_05.establishments_json_frg as t)
  to 'C:/123/establishments.json';

-- 5. ��������� XML/JSON �������� �� ��������� ����� �� �����
drop table lab_05.json_table;
drop table lab_05.parsed;

create table lab_05.json_table(
    establishments_id serial primary key,
    address varchar(40) not null,
    json_column json
);

create table lab_05.parsed(
    establishments_id serial primary key,
    address varchar(40) not null,
    age int,
    test json
);

insert into lab_05.json_table(address, json_column) values 
    ('���', '[{"age": 52, "name": "�������� �.�."}]'::json),
    ('ʸ���', '[{"age": 65, "name": "������� �.�."}]'::json),
    ('������', '[{"age": 48, "name": "����� �.�."}]'::json);
   
select * from lab_05.json_table;


insert into lab_05.parsed (address, age, test)
select address, (j.items->>'age')::integer, items #- '{age}'
from lab_05.json_table, jsonb_array_elements(json_column::jsonb) j(items);
select * from lab_05.parsed;