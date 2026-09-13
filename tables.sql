
CREATE TABLE customers (
    custid integer NOT NULL,
    first_name varchar(50) NOT NULL,
    last_name varchar(50) NOT NULL,
    email varchar(50) NOT NULL,
    phone bigint NOT NULL,
    address varchar(50) NOT NULL,
    city varchar(50) NOT NULL,
    state varchar(50) NOT NULL,
    postal_code integer NOT NULL
);

CREATE TABLE pizza_types (
    pizza_type_id varchar(50) NOT NULL,
    name varchar(50) NOT NULL,
    category varchar(50) NOT NULL,
    ingredients text NOT NULL
);

CREATE TABLE pizzas (
    pizza_id varchar(50) NOT NULL,
    pizza_type_id varchar(50) NOT NULL,
    size varchar(50) NOT NULL,
    price numeric(5,2) NOT NULL
);

CREATE TABLE orders (
    order_id integer NOT NULL,
    order_date date NOT NULL,
    order_time varchar(50) NOT NULL,
    custid integer NOT NULL,
    status varchar(50) NOT NULL
);



CREATE TABLE order_details (
    order_details_id integer NOT NULL,
    order_id integer NOT NULL,
    pizza_id varchar(50) NOT NULL,
    quantity integer NOT NULL
);


SELECT * from customers


