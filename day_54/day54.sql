create database database_03_hongha;

create table if not exists customers
(
    id           varchar(50) primary key,
    name         varchar(50) not null,
    address      varchar(50),
    phone_number varchar(11)
);

create table if not exists rooms
(
    id             varchar(50) primary key,
    type           varchar(50),
    max_guest      int,
    price_per_hour money,
    description    text
);

create table if not exists reservations
(
    id          varchar(50) primary key,
    room_id     varchar(50)                                         not null,
    customer_id varchar(50)                                         not null,
    booked_at   date                                                not null,
    start_at    time                                                not null,
    end_at      time                                                not null,
    deposit     money,
    status      varchar(50) CHECK ( status in ('Da dat', 'Da huy')) not null,
    note        text,
    FOREIGN KEY (room_id) REFERENCES rooms (id),
    FOREIGN KEY (customer_id) REFERENCES customers (id)
);

create table if not exists additional_services
(
    id    varchar(50) primary key,
    name  varchar(50) not null,
    price money,
    unit  varchar(10) CHECK ( unit in ('lon', 'dia', 'cai', 'goi'))
);

create table if not exists reservation_details
(
    reservation_id        varchar(50),
    additional_service_id varchar(50),
    quantity              int not null,
    primary key (reservation_id, additional_service_id)
);

insert into rooms(id, type, max_guest, price_per_hour, description)
values ('P0001', 'loai 1', 20, 60000, ''),
       ('P0002', 'loai 1', 25, 80000, ''),
       ('P0003', 'loai 2', 15, 50000, ''),
       ('P0004', 'loai 3', 20, 50000, '');

insert into customers(id, name, address, phone_number)
values ('KH0001', 'Nguyen Van A', 'Hoa Xuan', '11111111111'),
       ('KH0002', 'Nguyen Van B', 'Hoa Ha', '11111111112'),
       ('KH0003', 'Phan Van A', 'Hoa Thu', '11111111113'),
       ('KH0004', 'Phan Van A', 'Hoa Dong', '11111111114');

insert into additional_services(id, name, price, unit)
values ('DV0001', 'Beer', 10000, 'lon'),
       ('DV0002', 'Juice', 20000, 'lon'),
       ('DV0003', 'Fruit', 35000, 'dia'),
       ('DV0004', 'Wet towel', 2000, 'cai');

insert into reservations(id, room_id, customer_id, booked_at, start_at, end_at, deposit, note, status)
values ('DP0001', 'P0001', 'KH0002', '26/03/2018', '11:00', '13:30', 100000, '', 'Da dat'),
       ('DP0002', 'P0001', 'KH0003', '27/03/2018', '17:15', '19:15', 50000, '', 'Da huy'),
       ('DP0003', 'P0002', 'KH0002', '26/03/2018', '20:30', '22:15', 100000, '', 'Da dat'),
       ('DP0004', 'P0003', 'KH0001', '01/04/2018', '19:30', '21:15', 200000, '', 'Da dat');

insert into reservation_details(reservation_id, additional_service_id, quantity)
values ('DP0001', 'DV0001', 20),
       ('DP0001', 'DV0003', 3),
       ('DP0001', 'DV0002', 10),
       ('DP0002', 'DV0002', 10),
       ('DP0002', 'DV0003', 1),
       ('DP0003', 'DV0003', 2),
       ('DP0003', 'DV0004', 10);

create function getHourDiff(time_interval interval)
    returns float
    language plpgsql
as
$$
begin
    return (extract(epoch from time_interval) / (60 * 60));
end;
$$;

select rs.id                                                     as reservation_id,
       rs.room_id,
       r.type                                                    as room_type,
       r.price_per_hour,
       c.name,
       rs.booked_at,
       (r.price_per_hour * getHourDiff(rs.end_at - rs.start_at)) as total_singing_fee,
       sum(rd.quantity * ads.price)                              as total_add_service_fee
from reservations rs
         left join customers c on c.id = rs.customer_id
         left join reservation_details rd on rs.id = rd.reservation_id
         left join rooms r on r.id = rs.room_id
         left join additional_services ads on rd.additional_service_id = ads.id
group by rs.id, rs.room_id, r.type, r.price_per_hour, c.name, rs.booked_at, total_singing_fee;

select c.id, c.name, c.address, c.phone_number
from customers c
where c.address = 'Hoa Xuan';

select *
from (select r.id, r.type, r.max_guest, r.price_per_hour, count(r.id) as book_number, rs.status as status
      from rooms r
               left join reservations rs on r.id = rs.room_id
      group by r.id, r.type, r.max_guest, r.price_per_hour, rs.status) as subquery
where book_number > 2
  and status = 'Da dat';