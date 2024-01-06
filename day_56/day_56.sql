create table if not exists users
(
    id        uuid primary key,
    username  varchar(50)  not null unique,
    password  varchar(100) not null,
    full_name varchar(50)  not null,
    age       int default 0
)