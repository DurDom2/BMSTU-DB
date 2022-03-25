CREATE SCHEMA rk_03;

-- ������� 1. ������� � �� ������� � ��������������� �����:
create table rk_03.employee (
	id serial not null primary key,
	name varchar(20),
	birthdate date, 
	department varchar(20)
);

create table rk_03.shedule(
	id_employee int references rk_03.employee(id) not null,
	sdate date,
	day text,
	stime time,
	stype int
);

insert into rk_03.employee(name, birthdate, department) values
	('Rty Eva W', '22-08-1990', 'Backend'),	
	('Qwer Anna N', '23-04-1995', 'Manager'),
	('Qwer Artem Q', '13-05-1998', 'Frontend'),
	('Qaz Inna A', '20-02-1993', 'Manager'),
	('Qwer Anton Z', '13-07-1996', 'Backend'),
	('Tyui Oleg M', '12-04-1992', 'Backend');

insert into rk_03.shedule(id_employee, sdate, day, stime, stype) values
	(1, '14-12-2020', '�����������', '09:01', 1),
	(1, '14-12-2020', '�����������', '09:11', 2),
	(1, '14-12-2020', '�����������', '09:40', 1),
	(1, '14-12-2020', '�����������', '20:02', 2),

	(1, '14-12-2020', '�����������', '09:01', 1),
	(1, '14-12-2020', '�����������', '09:11', 2),
	(1, '14-12-2020', '�����������', '09:40', 1),
	(1, '14-12-2020', '�����������', '20:02', 2),

	(3, '14-12-2020', '�����������', '08:53', 1),
	(3, '14-12-2020', '�����������', '20:32', 2),

	(4, '14-12-2020', '�����������', '09:53', 1),
	(4, '14-12-2020', '�����������', '20:32', 2),

	(2, '16-12-2020', '�����', '09:01', 1),
	(2, '16-12-2020', '�����', '09:11', 2),
	(2, '16-12-2020', '�����', '09:40', 1),
	(2, '16-12-2020', '�����', '20:02', 2),

	(3, '16-12-2020', '�����', '09:01', 1),
	(3, '16-12-2020', '�����', '09:11', 2),
	(3, '16-12-2020', '�����', '09:50', 1),
	(3, '16-12-2020', '�����', '20:02', 2),

	(5, '17-12-2020', '�������', '08:41', 1),
	(5, '17-12-2020', '�������','20:31', 2),

	(6, '17-12-2020', '�������', '09:51', 1),
	(6, '17-12-2020', '�������', '20:31', 2);


-- �������� ��������� �������, ������������ ���������� ����������� � �������� �� 18 ��
-- 40, ���������� ����� 3� ���.
create or replace function rk_03.latters_count(late_date date) returns int as $$
	BEGIN
	RETURN(
		select count(*)
		from(select distinct id
				from rk_03.employee
				where extract(year from CURRENT_DATE) - extract(year from birthdate) between 18 and 40 and id in(
					select id_employee from(
						select id_employee, sdate, stype, count(*) from rk_03.shedule
							where sdate = late_date
							group by id_employee, sdate, stype
							having stype = 2 and count(*) > 3
						) as tmp0
					)
				) as tmp1
			);
	END;
$$ language plpgsql;

select * from rk_03.latters_count('14-12-2020')

-- ������� 2.1 ����� ��� ������, � ������� �������� ����� 10 �����������
select department from rk_03.employee
group by department
having count(id) > 10;

-- ������� 2.2 ����� �����������, ������� �� ������� � �������� ����� � ������� ����� �������� ���
select id from rk_03.employee
where id not in(
	select id_employee
	from (select id_employee, sdate, stype, count(*)
			from rk_03.shedule
			group by id_employee, sdate, stype
			having count(*) > 1 and stype=2
	) as tmp
);

-- 2.3 ����� ��� ������, � ������� ���� ����������, ���������� � ������������ ����. 
-- ���� ���������� � ����������
select distinct department 
from rk_03.employee
where id in 
(
	select id_employee
	from
	(
		select id_employee, min(stime)
		from rk_03.shedule
		where stype = 1 and sdate = '14-12-2020'
		group by id_employee
		having min(stime) > '09:00'
	) as tmp
);
