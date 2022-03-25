CREATE SCHEMA study;

-- ������������ ������� "������� ���������"
CREATE TABLE study.establishments (
    id serial, -- ����������� ����
    address varchar(255), -- �����
    creation_date date, -- ���� ��������
    is_vaccination_point boolean, -- ������� ������ ����������
    square integer, -- ����������
    people_count integer -- ���������� �����
);

-- ������������ ������� "�������"
CREATE TABLE study.employee (
    id serial, -- ����������� ����
    first_name varchar (255),
    last_name varchar (255),
    middle_name varchar (255),
    birth_date date, -- ���� ��������
    position varchar (255) -- ���������
);

-- ������������ ������� "�������"
CREATE TABLE study.pupils (
    id serial, -- ����������� ����
    first_name varchar (255),
    last_name varchar (255),
    middle_name varchar (255),
    birth_date date, -- ���� ��������
    gender varchar (255), -- ���
    is_vaccinated boolean -- �������, ���� �� ��������
);

-- �������� ������� "�����"
CREATE TABLE study.school (
    establishments_id integer,
    employee_id integer,
    pupils_id integer,
    infected_amount numeric, -- ���-�� ����������
    is_necessarily boolean -- �������, ����������� �� ����������
);
