--
-- PostgreSQL database dump
--

-- Dumped from database version 9.5.14
-- Dumped by pg_dump version 9.5.14

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: combo_price; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.combo_price (
    id bigint NOT NULL,
    op_id integer,
    item_id integer,
    price numeric,
    inserted_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    combo_id integer
);


ALTER TABLE public.combo_price OWNER TO postgres;

--
-- Name: combo_price_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.combo_price_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.combo_price_id_seq OWNER TO postgres;

--
-- Name: combo_price_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.combo_price_id_seq OWNED BY public.combo_price.id;


--
-- Name: combos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.combos (
    id bigint NOT NULL,
    combo_id integer,
    item_id integer,
    category character varying(255),
    category_limit integer,
    inserted_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE public.combos OWNER TO postgres;

--
-- Name: combos_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.combos_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.combos_id_seq OWNER TO postgres;

--
-- Name: combos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.combos_id_seq OWNED BY public.combos.id;


--
-- Name: discounts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.discounts (
    id bigint NOT NULL,
    name character varying(255),
    description character varying(255),
    category character varying(255),
    disc_type character varying(255),
    amount double precision,
    requirements bytea,
    targets bytea,
    inserted_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    organization_id integer
);


ALTER TABLE public.discounts OWNER TO postgres;

--
-- Name: discounts_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.discounts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.discounts_id_seq OWNER TO postgres;

--
-- Name: discounts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.discounts_id_seq OWNED BY public.discounts.id;


--
-- Name: item_price; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.item_price (
    id bigint NOT NULL,
    op_id integer,
    item_id integer,
    price numeric,
    inserted_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE public.item_price OWNER TO postgres;

--
-- Name: item_price_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.item_price_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.item_price_id_seq OWNER TO postgres;

--
-- Name: item_price_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.item_price_id_seq OWNED BY public.item_price.id;


--
-- Name: items; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.items (
    id bigint NOT NULL,
    name character varying(255),
    img_url character varying(255),
    code character varying(255),
    "desc" character varying(255),
    customizations bytea,
    inserted_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    category character varying(255),
    is_combo boolean,
    organization_id integer
);


ALTER TABLE public.items OWNER TO postgres;

--
-- Name: items_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.items_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.items_id_seq OWNER TO postgres;

--
-- Name: items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.items_id_seq OWNED BY public.items.id;


--
-- Name: organization_price; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.organization_price (
    id bigint NOT NULL,
    organization_id integer,
    name character varying(255),
    inserted_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE public.organization_price OWNER TO postgres;

--
-- Name: organization_price_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.organization_price_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.organization_price_id_seq OWNER TO postgres;

--
-- Name: organization_price_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.organization_price_id_seq OWNED BY public.organization_price.id;


--
-- Name: organizations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.organizations (
    id bigint NOT NULL,
    name character varying(255),
    address character varying(255),
    inserted_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    categories character varying(255),
    payments character varying(255)
);


ALTER TABLE public.organizations OWNER TO postgres;

--
-- Name: organizations_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.organizations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.organizations_id_seq OWNER TO postgres;

--
-- Name: organizations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.organizations_id_seq OWNED BY public.organizations.id;


--
-- Name: printers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.printers (
    id bigint NOT NULL,
    name character varying(255),
    ip_address character varying(255),
    port_no character varying(255),
    organization_id integer,
    inserted_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE public.printers OWNER TO postgres;

--
-- Name: printers_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.printers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.printers_id_seq OWNER TO postgres;

--
-- Name: printers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.printers_id_seq OWNED BY public.printers.id;


--
-- Name: rest_discounts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.rest_discounts (
    id bigint NOT NULL,
    rest_id integer,
    discount_id integer
);


ALTER TABLE public.rest_discounts OWNER TO postgres;

--
-- Name: rest_discounts_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.rest_discounts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.rest_discounts_id_seq OWNER TO postgres;

--
-- Name: rest_discounts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.rest_discounts_id_seq OWNED BY public.rest_discounts.id;


--
-- Name: rest_item_printer; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.rest_item_printer (
    id bigint NOT NULL,
    rest_id integer,
    item_id integer,
    printer_id integer,
    inserted_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE public.rest_item_printer OWNER TO postgres;

--
-- Name: rest_item_printer_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.rest_item_printer_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.rest_item_printer_id_seq OWNER TO postgres;

--
-- Name: rest_item_printer_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.rest_item_printer_id_seq OWNED BY public.rest_item_printer.id;


--
-- Name: restaurants; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.restaurants (
    id bigint NOT NULL,
    name character varying(255),
    code character varying(255),
    key character varying(255),
    address character varying(255),
    tax_id character varying(255),
    reg_id character varying(255),
    tax_code character varying(255),
    inserted_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    tax_perc numeric,
    serv numeric,
    organization_id integer,
    op_id integer
);


ALTER TABLE public.restaurants OWNER TO postgres;

--
-- Name: restaurants_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.restaurants_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.restaurants_id_seq OWNER TO postgres;

--
-- Name: restaurants_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.restaurants_id_seq OWNED BY public.restaurants.id;


--
-- Name: sales; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sales (
    id bigint NOT NULL,
    salesid character varying(255),
    pax integer,
    tbl_no character varying(255),
    sub_total numeric,
    tax numeric,
    service_charge numeric,
    rounding numeric,
    grand_total numeric,
    salesdate date,
    salesdatetime timestamp without time zone,
    invoiceno character varying(255),
    staffid character varying(255),
    transaction_type character varying(255),
    discount_name character varying(255),
    discounted_amount numeric,
    discount_description character varying(255),
    inserted_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    organization_id integer,
    rest_name character varying(255)
);


ALTER TABLE public.sales OWNER TO postgres;

--
-- Name: sales_details; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sales_details (
    id bigint NOT NULL,
    salesid character varying(255),
    order_id character varying(255),
    table_id character varying(255),
    itemname character varying(255),
    unit_price numeric,
    qty integer,
    sub_total numeric,
    inserted_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE public.sales_details OWNER TO postgres;

--
-- Name: sales_details_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.sales_details_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.sales_details_id_seq OWNER TO postgres;

--
-- Name: sales_details_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.sales_details_id_seq OWNED BY public.sales_details.id;


--
-- Name: sales_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.sales_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.sales_id_seq OWNER TO postgres;

--
-- Name: sales_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.sales_id_seq OWNED BY public.sales.id;


--
-- Name: sales_payments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sales_payments (
    id bigint NOT NULL,
    salesid character varying(255),
    order_id character varying(255),
    payment_type character varying(255),
    sub_total numeric,
    gst_charge numeric,
    service_charge numeric,
    rounding numeric,
    grand_total numeric,
    cash numeric,
    changes numeric,
    salesdate character varying(255),
    salesdatetime character varying(255),
    inserted_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE public.sales_payments OWNER TO postgres;

--
-- Name: sales_payments_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.sales_payments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.sales_payments_id_seq OWNER TO postgres;

--
-- Name: sales_payments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.sales_payments_id_seq OWNED BY public.sales_payments.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.schema_migrations (
    version bigint NOT NULL,
    inserted_at timestamp without time zone
);


ALTER TABLE public.schema_migrations OWNER TO postgres;

--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id bigint NOT NULL,
    username character varying(255),
    password character varying(255),
    crypted_password character varying(255),
    email character varying(255),
    inserted_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    user_type character varying(255),
    pin character varying(255),
    organization_id integer
);


ALTER TABLE public.users OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.users_id_seq OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.combo_price ALTER COLUMN id SET DEFAULT nextval('public.combo_price_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.combos ALTER COLUMN id SET DEFAULT nextval('public.combos_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.discounts ALTER COLUMN id SET DEFAULT nextval('public.discounts_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.item_price ALTER COLUMN id SET DEFAULT nextval('public.item_price_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.items ALTER COLUMN id SET DEFAULT nextval('public.items_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.organization_price ALTER COLUMN id SET DEFAULT nextval('public.organization_price_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.organizations ALTER COLUMN id SET DEFAULT nextval('public.organizations_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.printers ALTER COLUMN id SET DEFAULT nextval('public.printers_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rest_discounts ALTER COLUMN id SET DEFAULT nextval('public.rest_discounts_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rest_item_printer ALTER COLUMN id SET DEFAULT nextval('public.rest_item_printer_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.restaurants ALTER COLUMN id SET DEFAULT nextval('public.restaurants_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sales ALTER COLUMN id SET DEFAULT nextval('public.sales_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sales_details ALTER COLUMN id SET DEFAULT nextval('public.sales_details_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sales_payments ALTER COLUMN id SET DEFAULT nextval('public.sales_payments_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Data for Name: combo_price; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.combo_price (id, op_id, item_id, price, inserted_at, updated_at, combo_id) FROM stdin;
1	1	1	0	2019-01-31 10:40:12.114972	2019-01-31 10:40:12.114981	4
3	1	5	0	2019-01-31 10:40:12.118776	2019-01-31 10:40:12.118795	4
2	1	3	1.2	2019-01-31 10:40:12.116783	2019-01-31 10:45:51.916425	4
4	1	6	1	2019-01-31 10:45:51.918083	2019-01-31 10:45:51.918089	4
5	2	7	0	2019-02-14 04:29:24.620289	2019-02-14 04:29:24.620294	11
6	2	8	0	2019-02-14 04:29:24.62712	2019-02-14 04:29:24.627125	11
7	2	9	0	2019-02-14 04:29:24.628388	2019-02-14 04:29:24.628394	11
8	3	7	0	2019-02-15 03:36:41.094128	2019-02-15 03:36:41.094135	11
9	3	8	0	2019-02-15 03:36:41.095348	2019-02-15 03:36:41.095355	11
10	3	9	0	2019-02-15 03:36:41.096645	2019-02-15 03:36:41.096652	11
11	3	13	0	2019-02-15 03:41:24.239113	2019-02-15 03:41:24.239119	12
12	3	7	0	2019-02-15 03:41:24.240032	2019-02-15 03:41:24.240038	12
13	3	9	0	2019-02-15 03:41:24.240933	2019-02-15 03:41:24.240938	12
\.


--
-- Name: combo_price_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.combo_price_id_seq', 13, true);


--
-- Data for Name: combos; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.combos (id, combo_id, item_id, category, category_limit, inserted_at, updated_at) FROM stdin;
1	4	5	Rice	1	2019-01-31 10:36:40.233685	2019-01-31 10:36:40.233695
6	4	1	Chicken	2	2019-02-01 07:00:43.274639	2019-02-01 07:00:43.274674
8	4	6	Chicken	2	2019-02-01 07:01:04.606323	2019-02-01 07:01:04.606333
9	4	3	Chicken	2	2019-02-01 07:01:13.081851	2019-02-01 07:01:13.081861
10	11	7	Chicken	2	2019-02-14 04:28:28.473979	2019-02-14 04:28:28.473989
11	11	8	Chicken	2	2019-02-14 04:29:06.690202	2019-02-14 04:29:06.690212
12	11	9	Rice	1	2019-02-14 04:29:14.240071	2019-02-14 04:29:14.240081
13	12	9	Rice	1	2019-02-15 03:40:16.71088	2019-02-15 03:40:16.710889
14	12	7	Chicken	2	2019-02-15 03:40:26.272708	2019-02-15 03:40:26.272717
15	12	13	Chicken	2	2019-02-15 03:40:33.516651	2019-02-15 03:40:33.516661
\.


--
-- Name: combos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.combos_id_seq', 15, true);


--
-- Data for Name: discounts; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.discounts (id, name, description, category, disc_type, amount, requirements, targets, inserted_at, updated_at, organization_id) FROM stdin;
1	Staff Meals	50% discount for all meals for staff.	Staff	percentage	50	\N	\N	2019-02-11 09:54:42.037692	2019-02-11 09:54:42.037706	1
2	On the house	100% Free by manager	Staff	percentage	100	\N	\N	2019-02-11 09:54:56.673373	2019-02-11 09:54:56.673383	1
3	Throwback Tuesday	RM 2 off on single bill	Weekly	cash	2	\N	\N	2019-02-13 01:21:18.488181	2019-02-13 01:21:18.488191	1
4	Chic Pop Promo	Free 3 satay ayam req 1 Rice Combo	Weekly	item	100	\\x5269636520436f6d626f	\\x5361746179204179616d2c5361746179204179616d2c5361746179204179616d	2019-02-13 01:25:46.866504	2019-02-13 04:13:41.552288	1
5	On the house	100% Free by manager	Staff	percentage	100	\N	\N	2019-02-14 04:08:25.036256	2019-02-14 04:08:25.036268	2
6	Chic Pop Promo	Free 3 satay ayam on condition having 1 Maggi Goreng	Weekly	item	100	\\x4d6167676920476f72656e67	\\x5361746179204179616d2c5361746179204179616d2c5361746179204179616d	2019-02-14 04:08:58.891212	2019-02-14 04:08:58.891224	2
7	Throwback Tuesday	RM 2 off on single bill	Weekly	cash	2	\N	\N	2019-02-14 04:09:25.118977	2019-02-14 04:09:25.118986	2
\.


--
-- Name: discounts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.discounts_id_seq', 7, true);


--
-- Data for Name: item_price; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.item_price (id, op_id, item_id, price, inserted_at, updated_at) FROM stdin;
1	1	1	1.1	2019-01-31 08:33:48.855625	2019-01-31 08:33:48.855637
2	1	2	1.2	2019-01-31 08:33:48.8575	2019-01-31 08:33:48.857508
3	1	3	5.4	2019-01-31 08:33:48.85937	2019-01-31 08:33:48.859376
5	1	5	1.0	2019-01-31 10:40:12.105812	2019-01-31 10:40:12.105819
6	1	6	5.2	2019-01-31 10:44:37.361932	2019-01-31 10:44:37.361942
4	1	4	8.9	2019-01-31 10:40:12.100378	2019-01-31 10:45:51.91431
7	2	10	5	2019-02-14 04:29:24.612849	2019-02-14 04:29:24.612859
8	2	11	7	2019-02-14 04:29:24.614528	2019-02-14 04:29:24.614541
9	2	7	2	2019-02-14 04:29:24.616247	2019-02-14 04:29:24.616254
10	2	8	5	2019-02-14 04:29:24.617535	2019-02-14 04:29:24.617541
11	2	9	2	2019-02-14 04:29:24.618927	2019-02-14 04:29:24.618933
12	3	10	6	2019-02-15 03:36:41.079582	2019-02-15 03:36:41.079593
14	3	7	2	2019-02-15 03:36:41.088782	2019-02-15 03:36:41.088791
15	3	8	6	2019-02-15 03:36:41.090855	2019-02-15 03:36:41.090864
16	3	9	2.5	2019-02-15 03:36:41.092366	2019-02-15 03:36:41.092375
13	3	11	0	2019-02-15 03:36:41.081599	2019-02-15 03:41:24.232027
17	3	12	12	2019-02-15 03:41:24.23351	2019-02-15 03:41:24.233516
18	3	13	2	2019-02-15 03:41:24.234663	2019-02-15 03:41:24.234669
\.


--
-- Name: item_price_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.item_price_id_seq', 18, true);


--
-- Data for Name: items; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.items (id, name, img_url, code, "desc", customizations, inserted_at, updated_at, category, is_combo, organization_id) FROM stdin;
1	Satay Ayam	1_statyatam.jpg	001	Succulent chicken strips	\N	2019-01-31 08:32:18.73906	2019-01-31 08:32:18.739072	Main Course	f	1
2	Satay Daging	1_sataydaging.jpg	002	Succulent beef strips	\N	2019-01-31 08:32:41.059633	2019-01-31 08:32:41.059644	Main Course	f	1
3	Ayam Masak Merah	1_mmerah.jpg	AY01	Chicken cooked with red sauce.	\\x6c6573732073706963792c6c657373206f6e696f6e2c6d6f726520737069637928312e30292c6d6f7265206f6e696f6e28302e3529	2019-01-31 08:33:31.482092	2019-01-31 08:33:31.482104	Chicken	f	1
4	Rice Combo	1_nasi.jpeg	RC01	Afternoon lunch with your favourite chicken with Asian staple food.	\N	2019-01-31 09:12:36.788289	2019-01-31 10:39:12.082433	 Combo	t	1
6	Ayam Percik	1_percik.jpeg	AY02	Pepper grilled chicken fillet.	\N	2019-01-31 10:44:21.684061	2019-01-31 10:44:21.684072	Chicken	f	1
5	White Rice白饭	1_rice.jpeg	R01	Asian staple food.	\N	2019-01-31 10:36:19.8273	2019-02-11 07:12:19.92063	Rice	f	1
7	Satay Ayam	2_statyatam.jpg	001	Succulent chicken strips	\N	2019-02-14 03:50:42.873184	2019-02-14 03:50:42.873195	main course	f	2
8	Ayam Masak Merah	2_mmerah.jpg	AY01	Chicken cooked with red sauce.	\\x6c657373206f6e696f6e2c6d6f7265206f6e696f6e28312e3030292c6c6573732073706963792c6d6f726520737069637928302e3530292c657874726120737069637928312e303029	2019-02-14 03:52:53.598516	2019-02-14 03:52:53.598529	chicken	f	2
9	White Rice白饭	2_rice.jpeg	RC01	Asian staple food.	\N	2019-02-14 03:53:22.173472	2019-02-14 03:53:22.173485	rice	f	2
10	Maggi Goreng	2_featured_image.jpg	RC02	Asian snack food.	\N	2019-02-14 03:53:22.275032	2019-02-14 04:02:33.507793	rice	f	2
11	Ayam Set Lunch	2_nasi.jpeg	CR01	Afternoon lunch with your favourite chicken with Asian staple food.	\N	2019-02-14 04:17:43.994769	2019-02-14 04:17:43.994798	combo	t	2
12	Daging Set Lunch	2_kerbu.jpg	RC02	Afternoon lunch with your favourite chicken with Asian staple food with beef.	\N	2019-02-15 03:39:11.003949	2019-02-15 03:39:11.003961	combo	t	2
13	Satay Daging	2_sataydaging.jpg	002	Succulent beef strips	\N	2019-02-15 03:40:02.050452	2019-02-15 03:40:02.050462	main course	f	2
\.


--
-- Name: items_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.items_id_seq', 13, true);


--
-- Data for Name: organization_price; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.organization_price (id, organization_id, name, inserted_at, updated_at) FROM stdin;
1	1	Klang Valley Pricing	2019-01-31 08:30:48.952859	2019-01-31 08:30:48.95287
2	2	2019 KL Pricing	2019-02-14 04:00:28.548571	2019-02-14 04:00:28.548581
3	2	2019 East Malaysia Pricing	2019-02-14 09:37:49.623348	2019-02-14 09:37:49.623359
\.


--
-- Name: organization_price_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.organization_price_id_seq', 3, true);


--
-- Data for Name: organizations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.organizations (id, name, address, inserted_at, updated_at, categories, payments) FROM stdin;
1	Resertech	Serdang	2019-01-31 07:53:45.965845	2019-01-31 08:27:15.699363	Main Course,Rice,Chicken,Default, Combo	Cash,Credit Card
2	Demo Company	KL	2019-02-14 03:31:27.228653	2019-02-14 03:31:27.228666	main course,rice,chicken,combo	cash
\.


--
-- Name: organizations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.organizations_id_seq', 2, true);


--
-- Data for Name: printers; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.printers (id, name, ip_address, port_no, organization_id, inserted_at, updated_at) FROM stdin;
1	Main Kitchen Printer	10.239.30.114	9100	1	2019-02-13 08:02:17.251986	2019-02-13 08:02:17.251999
2	Receipt Printer	10.239.30.114	9100	1	2019-02-13 08:02:26.040202	2019-02-13 08:02:26.040212
3	Receipt Printer	10.239.30.114	9100	2	2019-02-14 04:11:30.795343	2019-02-14 04:11:30.795356
\.


--
-- Name: printers_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.printers_id_seq', 3, true);


--
-- Data for Name: rest_discounts; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.rest_discounts (id, rest_id, discount_id) FROM stdin;
1	1	1
2	1	2
3	1	3
4	1	4
5	2	5
6	2	7
7	2	6
\.


--
-- Name: rest_discounts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.rest_discounts_id_seq', 7, true);


--
-- Data for Name: rest_item_printer; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.rest_item_printer (id, rest_id, item_id, printer_id, inserted_at, updated_at) FROM stdin;
1	1	\N	1	2019-02-13 08:02:37.660303	2019-02-13 08:02:37.660313
2	1	\N	2	2019-02-13 08:02:37.675267	2019-02-13 08:02:37.675275
3	1	2	1	2019-02-13 08:02:47.110831	2019-02-13 08:02:47.110841
4	1	1	1	2019-02-13 08:02:47.115476	2019-02-13 08:02:47.115482
5	1	3	1	2019-02-13 08:02:49.723708	2019-02-13 08:02:49.723721
6	1	6	1	2019-02-13 08:02:51.332281	2019-02-13 08:02:51.332291
7	1	4	1	2019-02-13 08:02:53.46436	2019-02-13 08:02:53.46437
8	1	5	1	2019-02-13 08:02:58.35922	2019-02-13 08:02:58.359229
9	2	\N	3	2019-02-14 04:11:40.794636	2019-02-14 04:11:40.794646
10	2	7	3	2019-02-14 04:12:06.818947	2019-02-14 04:12:06.818958
11	2	8	3	2019-02-14 04:12:08.450321	2019-02-14 04:12:08.450331
12	2	9	3	2019-02-14 04:12:10.336996	2019-02-14 04:12:10.337042
13	2	10	3	2019-02-14 04:12:11.831784	2019-02-14 04:12:11.831794
\.


--
-- Name: rest_item_printer_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.rest_item_printer_id_seq', 13, true);


--
-- Data for Name: restaurants; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.restaurants (id, name, code, key, address, tax_id, reg_id, tax_code, inserted_at, updated_at, tax_perc, serv, organization_id, op_id) FROM stdin;
1	Serdang	sr	damien2018	Serdang	GST000100	A00100	SER	2019-01-31 08:30:59.315847	2019-01-31 08:30:59.315858	0.06	0.1	1	1
2	KL	kl	jason1234	KL	SER	B100001	T100002	2019-02-14 04:01:13.376789	2019-02-14 09:38:08.125505	0.06	0.10	2	3
\.


--
-- Name: restaurants_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.restaurants_id_seq', 2, true);


--
-- Data for Name: sales; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.sales (id, salesid, pax, tbl_no, sub_total, tax, service_charge, rounding, grand_total, salesdate, salesdatetime, invoiceno, staffid, transaction_type, discount_name, discounted_amount, discount_description, inserted_at, updated_at, organization_id, rest_name) FROM stdin;
3	sr1549958474412	0	t1	9.9	0.59	0.99	-0.02	10.30	2019-02-12	2019-02-12 16:00:17.560145	sr1549958474412	0	DINE-IN	n/a	0.0	n/a	2019-02-12 08:01:16.57508	2019-02-12 08:01:16.57509	\N	\N
4	sr1549958560553	0	t1	19.8	1.19	1.98	-0.02	20.40	2019-02-12	2019-02-12 16:02:26.582063	sr1549958560553	0	DINE-IN	n/a	0.0	n/a	2019-02-12 08:02:42.643939	2019-02-12 08:02:42.64395	\N	\N
5	sr1549959148100	0	t1	10.4	0.62	1.04	-0.05	20.60	2019-02-12	2019-02-12 16:10:37.771606	sr1549959148100	0	DINE-IN	Staff Meals	10.4	50% discount for all meals for staff.	2019-02-12 08:12:30.204087	2019-02-12 08:12:30.204096	\N	\N
6	sr1550020467107	0	T2	17.0	1.02	1.70	-0.02	19.70	2019-02-13	2019-02-13 09:14:16.383564	sr1550020467107	0	DINE-IN	n/a	0.0	n/a	2019-02-13 01:14:28.08561	2019-02-13 01:14:28.085622	1	Serdang
7	sr1550020469546	0	T1	3.5	0.21	0.35	0.04	4.10	2019-02-13	2019-02-13 09:10:53.093018	sr1550020469546	0	DINE-IN	n/a	0.0	n/a	2019-02-13 01:14:30.532771	2019-02-13 01:14:30.532781	1	Serdang
8	sr1550021969838	0	T2	4.6	0.28	0.46	-0.04	5.30	2019-02-13	2019-02-13 09:26:26.946616	sr1550021969838	0	DINE-IN	n/a	0.0	n/a	2019-02-13 01:39:30.887948	2019-02-13 01:39:30.887958	1	Serdang
9	sr1550026806038	0	t1	0.0	0.00	0.00	0.00	11.60	2019-02-13	2019-02-13 10:36:23.379447	sr1550026806038	0	DINE-IN	Chic Pop Promo	10.0	Free 3 satay ayam	2019-02-13 03:00:07.165209	2019-02-13 03:00:07.165219	1	Serdang
12	sr1550028534623	0	t1	2.30	0.14	0.23	0.03	2.70	2019-02-13	2019-02-13 11:28:47.410823	sr1550028534623	0	DINE-IN	n/a	0.0	n/a	2019-02-13 03:28:55.740957	2019-02-13 03:28:55.74097	1	Serdang
13	sr1550028648355	0	t1	6.90	0.41	0.69	0.00	8.00	2019-02-13	2019-02-13 11:29:09.719399	sr1550028648355	0	DINE-IN	Chic Pop Promo	0.00	Free 3 satay ayam	2019-02-13 03:30:49.717472	2019-02-13 03:30:49.717483	1	Serdang
14	sr1550028848689	0	t1	2.40	0.14	0.24	0.02	2.80	2019-02-13	2019-02-13 11:32:32.856885	sr1550028848689	0	DINE-IN	Chic Pop Promo	3.30	Free 3 satay ayam	2019-02-13 03:34:09.869842	2019-02-13 03:34:09.869851	1	Serdang
15	sr1550028907569	0	t1	7.90	0.47	0.79	0.04	9.20	2019-02-13	2019-02-13 11:34:42.816633	sr1550028907569	0	DINE-IN	Throwback Tuesday	2.00	RM 2 off on single bill	2019-02-13 03:35:08.691861	2019-02-13 03:35:08.691871	1	Serdang
16	sr1550029549801	0	t1	14.50	0.87	1.45	-0.02	16.80	2019-02-13	2019-02-13 11:37:05.045958	sr1550029549801	0	DINE-IN	n/a	0.0	n/a	2019-02-13 03:45:51.470676	2019-02-13 03:45:51.470687	1	Serdang
17	sr1550029621428	0	t1	11.30	0.68	1.13	-0.01	13.10	2019-02-13	2019-02-13 11:45:50.736896	sr1550029621428	0	DINE-IN	Chic Pop Promo	3.30	Free 3 satay ayam	2019-02-13 03:47:02.532515	2019-02-13 03:47:02.532524	1	Serdang
18	sr1550031171406	0	t1	14.70	0.88	1.47	0.05	17.10	2019-02-13	2019-02-13 11:47:02.509981	sr1550031171406	0	DINE-IN	Chic Pop Promo	3.30	Free 3 satay ayam on condition having 1 Rice Combo	2019-02-13 04:12:52.681959	2019-02-13 04:12:52.681969	1	Serdang
19	sr1550031282222	0	t1	12.30	0.74	1.23	0.03	14.30	2019-02-13	2019-02-13 12:13:54.164318	sr1550031282222	0	DINE-IN	Chic Pop Promo	3.30	Free 3 satay ayam req 1 Rice Combo	2019-02-13 04:14:43.36699	2019-02-13 04:14:43.366999	1	Serdang
20	sr1550034509503	0	t1	2.30	0.14	0.23	0.03	2.70	2019-02-13	2019-02-13 12:15:04.466743	sr1550034509503	0	DINE-IN	n/a	0.0	n/a	2019-02-13 05:08:30.763391	2019-02-13 05:08:30.763404	1	Serdang
21	sr1550034554115	0	t1	2.70	0.16	0.27	-0.03	3.10	2019-02-13	2019-02-13 13:08:32.930081	sr1550034554115	0	DINE-IN	Throwback Tuesday	2.00	RM 2 off on single bill	2019-02-13 05:09:15.332668	2019-02-13 05:09:15.332677	1	Serdang
22	sr1550034722115	0	t1	4.70	0.28	0.47	0.05	5.50	2019-02-13	2019-02-13 13:11:36.331742	sr1550034722115	0	DINE-IN	n/a	0.0	n/a	2019-02-13 05:12:03.288081	2019-02-13 05:12:03.288091	1	Serdang
23	sr1550034726312	0	t2	12.00	0.72	1.20	-0.02	13.90	2019-02-13	2019-02-13 13:11:43.342538	sr1550034726312	0	DINE-IN	n/a	0.0	n/a	2019-02-13 05:12:07.525579	2019-02-13 05:12:07.525588	1	Serdang
24	sr1550034733133	0	t3	2.70	0.16	0.27	-0.03	3.10	2019-02-13	2019-02-13 13:11:39.359083	sr1550034733133	0	DINE-IN	Throwback Tuesday	2.00	RM 2 off on single bill	2019-02-13 05:12:14.311147	2019-02-13 05:12:14.311156	1	Serdang
25	sr1550034737691	0	t4	6.40	0.38	0.64	-0.02	7.40	2019-02-13	2019-02-13 13:11:52.519487	sr1550034737691	0	DINE-IN	n/a	0.0	n/a	2019-02-13 05:12:19.646168	2019-02-13 05:12:19.646178	1	Serdang
26	sr1550035295019	0	t2	4.60	0.28	0.46	-0.04	5.30	2019-02-13	2019-02-13 13:21:28.492822	sr1550035295019	0	DINE-IN	n/a	0.0	n/a	2019-02-13 05:21:36.269167	2019-02-13 05:21:36.269176	1	Serdang
27	sr1550035371129	0	t2	15.30	0.92	1.53	-0.05	17.70	2019-02-13	2019-02-13 13:21:43.642092	sr1550035371129	0	DINE-IN	n/a	0.0	n/a	2019-02-13 05:22:52.378974	2019-02-13 05:22:52.378984	1	Serdang
28	sr1550035489117	0	t1	16.00	0.96	1.60	0.04	18.60	2019-02-13	2019-02-13 13:24:06.142609	sr1550035489117	0	DINE-IN	n/a	0.0	n/a	2019-02-13 05:24:50.343131	2019-02-13 05:24:50.343141	1	Serdang
29	sr1550035594966	0	t2	16.80	1.01	1.68	0.01	19.50	2019-02-13	2019-02-13 13:26:18.415421	sr1550035594966	0	DINE-IN	n/a	0.0	n/a	2019-02-13 05:26:36.179562	2019-02-13 05:26:36.179572	1	Serdang
30	sr1550045046795	0	t1	1.50	0.09	0.15	-0.04	1.70	2019-02-13	2019-02-13 16:03:46.639881	sr1550045046795	0	DINE-IN	Throwback Tuesday	2.00	RM 2 off on single bill	2019-02-13 08:04:08.162205	2019-02-13 08:04:08.162214	1	Serdang
31	sr1550046667852	0	t1	7.50	0.45	0.75	0.00	8.70	2019-02-13	2019-02-13 16:27:06.634217	sr1550046667852	0	DINE-IN	n/a	0.0	n/a	2019-02-13 08:31:08.651641	2019-02-13 08:31:08.651652	1	Serdang
32	sr1550047029482	0	t1	3.85	0.23	0.39	0.03	4.50	2019-02-13	2019-02-13 16:36:43.566683	sr1550047029482	0	DINE-IN	Staff Meals	3.85	50% discount for all meals for staff.	2019-02-13 08:37:11.08449	2019-02-13 08:37:11.0845	1	Serdang
33	sr1550047605356	0	t1	6.70	0.40	0.67	0.03	7.80	2019-02-13	2019-02-13 16:44:35.810537	sr1550047605356	0	DINE-IN	n/a	0.0	n/a	2019-02-13 08:46:46.779102	2019-02-13 08:46:46.779112	1	Serdang
34	sr1550047646049	0	t1	4.90	0.29	0.49	0.02	5.70	2019-02-13	2019-02-13 16:46:55.59067	sr1550047646049	0	DINE-IN	Throwback Tuesday	2.00	RM 2 off on single bill	2019-02-13 08:47:27.458956	2019-02-13 08:47:27.458965	1	Serdang
35	sr1550050343506	0	one	1.20	0.07	0.12	0.01	1.40	2019-02-13	2019-02-13 17:31:57.771138	sr1550050343506	0	DINE-IN	n/a	0.0	n/a	2019-02-13 09:32:23.458262	2019-02-13 09:32:23.458272	1	Serdang
36	kl1550132899912	0	t1	7.00	0.42	0.70	-0.02	8.10	2019-02-14	2019-02-14 12:11:03.956032	kl1550132899912	0	DINE-IN	n/a	0.0	n/a	2019-02-14 08:28:21.315598	2019-02-14 08:28:21.315611	2	KL
37	kl1550132976581	0	t1	7.00	0.42	0.70	-0.02	8.10	2019-02-14	2019-02-14 16:29:24.630256	kl1550132976581	0	DINE-IN	n/a	0.0	n/a	2019-02-14 08:29:37.527349	2019-02-14 08:29:37.527358	2	KL
38	kl1550133070068	0	t1	22.50	1.35	2.25	0.00	26.10	2019-02-14	2019-02-14 16:29:38.396018	kl1550133070068	0	DINE-IN	n/a	0.0	n/a	2019-02-14 08:31:10.934998	2019-02-14 08:31:10.935009	2	KL
39	kl1550134307343	0	t1	4.00	0.24	0.40	-0.04	4.60	2019-02-14	2019-02-14 16:32:53.542718	kl1550134307343	0	DINE-IN	Throwback Tuesday	2.00	RM 2 off on single bill	2019-02-14 08:51:48.199206	2019-02-14 08:51:48.199217	2	KL
40	kl1550134412842	0	t1	5.00	0.30	0.50	0.00	5.80	2019-02-14	2019-02-14 16:53:13.169253	kl1550134412842	0	DINE-IN	Throwback Tuesday	2.00	RM 2 off on single bill	2019-02-14 08:53:33.662258	2019-02-14 08:53:33.662268	2	KL
41	kl1550135623626	0	t1	7.00	0.42	0.70	-0.02	8.10	2019-02-14	2019-02-14 17:13:27.899816	kl1550135623626	0	DINE-IN	n/a	0.0	n/a	2019-02-14 09:13:44.351519	2019-02-14 09:13:44.351528	2	KL
42	kl1550136515145	0	t1	7.00	0.42	0.70	-0.02	8.10	2019-02-14	2019-02-14 17:27:55.362736	kl1550136515145	0	DINE-IN	Chic Pop Promo	6.00	Free 3 satay ayam on condition having 1 Maggi Goreng	2019-02-14 09:28:36.219752	2019-02-14 09:28:36.219762	2	KL
43	kl1550136875359	0	t1	7.00	0.42	0.70	-0.02	8.10	2019-02-14	2019-02-14 17:33:37.131978	kl1550136875359	0	DINE-IN	n/a	0.0	n/a	2019-02-14 09:34:36.205293	2019-02-14 09:34:36.205302	2	KL
44	sr1550139096217	0	t1	5.80	0.35	0.58	-0.03	6.70	2019-02-13	2019-02-13 16:40:01.658545	sr1550139096217	0	DINE-IN	n/a	0.0	n/a	2019-02-14 10:11:37.437741	2019-02-14 10:11:37.43775	1	Serdang
45	sr1550139158204	0	t1	2.30	0.14	0.23	0.03	2.70	2019-02-14	2019-02-14 18:12:33.214702	sr1550139158204	0	DINE-IN	n/a	0.0	n/a	2019-02-14 10:12:39.318526	2019-02-14 10:12:39.318538	1	Serdang
46	sr1550139184402	0	t1	2.30	0.14	0.23	0.03	2.70	2019-02-14	2019-02-14 18:12:54.497075	sr1550139184402	0	DINE-IN	n/a	0.0	n/a	2019-02-14 10:13:05.505271	2019-02-14 10:13:05.505282	1	Serdang
47	sr1550139222276	0	t1	2.30	0.14	0.23	0.03	2.70	2019-02-14	2019-02-14 18:13:34.374058	sr1550139222276	0	DINE-IN	n/a	0.0	n/a	2019-02-14 10:13:43.376985	2019-02-14 10:13:43.376997	1	Serdang
48	sr1550139342677	0	t1	7.50	0.45	0.75	0.00	8.70	2019-02-14	2019-02-14 18:14:30.354474	sr1550139342677	0	DINE-IN	n/a	0.0	n/a	2019-02-14 10:15:43.839406	2019-02-14 10:15:43.839416	1	Serdang
49	sr1550139374820	0	t1	3.40	0.20	0.34	-0.04	3.90	2019-02-14	2019-02-14 18:16:07.156492	sr1550139374820	0	DINE-IN	n/a	0.0	n/a	2019-02-14 10:16:15.93115	2019-02-14 10:16:15.93116	1	Serdang
50	sr1550139429741	0	t1	7.30	0.44	0.73	0.03	8.50	2019-02-14	2019-02-14 18:16:59.783572	sr1550139429741	0	DINE-IN	n/a	0.0	n/a	2019-02-14 10:17:10.887485	2019-02-14 10:17:10.887495	1	Serdang
51	sr1550139579280	0	t1	12.90	0.77	1.29	0.04	15.00	2019-02-14	2019-02-14 18:19:29.171518	sr1550139579280	0	DINE-IN	n/a	0.0	n/a	2019-02-14 10:19:40.403392	2019-02-14 10:19:40.403402	1	Serdang
52	sr1550139600583	0	t1	11.00	0.66	1.10	0.04	12.80	2019-02-14	2019-02-14 18:19:42.879826	sr1550139600583	0	DINE-IN	Chic Pop Promo	3.30	Free 3 satay ayam req 1 Rice Combo	2019-02-14 10:20:01.696194	2019-02-14 10:20:01.696203	1	Serdang
53	sr1550139702416	0	t1	2.60	0.16	0.26	-0.02	3.00	2019-02-14	2019-02-14 18:21:33.587487	sr1550139702416	0	DINE-IN	Throwback Tuesday	2.00	RM 2 off on single bill	2019-02-14 10:21:43.574362	2019-02-14 10:21:43.574371	1	Serdang
54	sr1550139784910	0	t1	5.0	0.3	0.5	0.0	5.8	2019-02-14	2019-02-14 18:22:54.549667	sr1550139784910	0	DINE-IN	Staff Meals	5.00	50% discount for all meals for staff.	2019-02-14 10:23:06.117038	2019-02-14 10:23:06.117048	1	Serdang
55	kl1550140077117	0	t1	10.0	0.6	1.0	0.0	11.6	2019-02-14	2019-02-14 17:45:43.583333	kl1550140077117	0	DINE-IN	Throwback Tuesday	2.00	RM 2 off on single bill	2019-02-14 10:27:58.796666	2019-02-14 10:27:58.796675	2	KL
56	kl1550196491564	0	t1	7.0	0.42	0.7	-0.02	8.1	2019-02-15	2019-02-15 10:08:01.539739	kl1550196491564	0	DINE-IN	n/a	0.0	n/a	2019-02-15 02:08:13.147119	2019-02-15 02:08:13.14713	2	KL
57	kl1550202264424	0	2	0.0	0.0	0.0	0.0	0.0	2019-02-14	2019-02-14 22:43:05.612262	kl1550202264424	0	DINE-IN	On the house	12.00	100% Free by manager	2019-02-15 03:44:24.54446	2019-02-15 03:44:24.544471	2	KL
58	kl1550202341491	0	1	4.0	0.24	0.4	-0.04	4.6	2019-02-14	2019-02-14 22:31:32.79189	kl1550202341491	0	DINE-IN	Throwback Tuesday	2.00	RM 2 off on single bill	2019-02-15 03:45:41.622191	2019-02-15 03:45:41.6222	2	KL
59	kl1550202368429	0	1	8.5	0.51	0.85	0.04	9.9	2019-02-14	2019-02-14 22:45:46.0401	kl1550202368429	0	DINE-IN	n/a	0.0	n/a	2019-02-15 03:46:08.504817	2019-02-15 03:46:08.504825	2	KL
60	kl1550202460722	0	1	8.5	0.51	0.85	0.04	9.9	2019-02-14	2019-02-14 22:46:41.068881	kl1550202460722	0	DINE-IN	n/a	0.0	n/a	2019-02-15 03:47:40.752329	2019-02-15 03:47:40.752338	2	KL
61	kl1550202862203	0	1	19.0	1.14	1.9	-0.04	22.0	2019-02-14	2019-02-14 22:51:46.478029	kl1550202862203	0	DINE-IN	Throwback Tuesday	2.00	RM 2 off on single bill	2019-02-15 03:54:22.282446	2019-02-15 03:54:22.282455	2	KL
62	kl1550203038856	0	1	19.0	1.14	1.9	-0.04	22.0	2019-02-14	2019-02-14 22:55:42.007473	kl1550203038856	0	DINE-IN	Throwback Tuesday	2.00	RM 2 off on single bill	2019-02-15 03:57:18.922065	2019-02-15 03:57:18.922075	2	KL
\.


--
-- Data for Name: sales_details; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.sales_details (id, salesid, order_id, table_id, itemname, unit_price, qty, sub_total, inserted_at, updated_at) FROM stdin;
1	sr1549957905805	4	1	Satay Ayam	1.1	1	1.1	2019-02-12 07:51:47.991854	2019-02-12 07:51:47.991863
2	sr1549957905805	4	1	Satay Ayam	1.1	1	1.1	2019-02-12 07:51:48.000913	2019-02-12 07:51:48.000922
3	sr1549957905805	4	1	Satay Daging	1.2	1	1.2	2019-02-12 07:51:48.003083	2019-02-12 07:51:48.003091
4	sr1549958027073	5	1	Satay Ayam	1.1	1	1.1	2019-02-12 07:53:49.142641	2019-02-12 07:53:49.142649
5	sr1549958027073	5	1	Satay Ayam	1.1	1	1.1	2019-02-12 07:53:49.144876	2019-02-12 07:53:49.144885
6	sr1549958027073	5	1	Satay Daging	1.2	1	1.2	2019-02-12 07:53:49.146697	2019-02-12 07:53:49.146704
7	sr1549958027073	5	1	Satay Daging	1.2	1	1.2	2019-02-12 07:53:49.14834	2019-02-12 07:53:49.148346
8	sr1549958365419	6	1	Satay Daging	1.2	1	1.2	2019-02-12 07:59:27.496981	2019-02-12 07:59:27.496989
9	sr1549958365419	6	1	Satay Daging	1.2	1	1.2	2019-02-12 07:59:27.498701	2019-02-12 07:59:27.498709
10	sr1549958365419	6	1	Satay Daging	1.2	1	1.2	2019-02-12 07:59:27.50059	2019-02-12 07:59:27.500597
11	sr1549958365419	6	1	Satay Ayam	1.1	1	1.1	2019-02-12 07:59:27.502237	2019-02-12 07:59:27.502243
12	sr1549958365419	6	1	Satay Ayam	1.1	1	1.1	2019-02-12 07:59:27.503862	2019-02-12 07:59:27.503871
13	sr1549958365419	6	1	Ayam Percik	5.2	1	5.2	2019-02-12 07:59:27.505579	2019-02-12 07:59:27.505585
14	sr1549958365419	6	1	Ayam Percik	5.2	1	5.2	2019-02-12 07:59:27.50731	2019-02-12 07:59:27.507317
15	sr1549958365419	6	1	Ayam Masak Merah	5.4	1	5.4	2019-02-12 07:59:27.508993	2019-02-12 07:59:27.509
16	sr1549958365419	6	1	Ayam Masak Merah	5.4	1	5.4	2019-02-12 07:59:27.510803	2019-02-12 07:59:27.510809
17	sr1549958365419	6	1	Ayam Masak Merah	5.4	1	5.4	2019-02-12 07:59:27.512209	2019-02-12 07:59:27.512215
18	sr1549958474412	7	1	Rice Combo	8.9	1	8.9	2019-02-12 08:01:16.577355	2019-02-12 08:01:16.577363
19	sr1549958560553	8	1	Satay Ayam	1.1	1	1.1	2019-02-12 08:02:42.646195	2019-02-12 08:02:42.646204
20	sr1549958560553	8	1	Satay Daging	1.2	1	1.2	2019-02-12 08:02:42.648153	2019-02-12 08:02:42.648161
21	sr1549958560553	8	1	Ayam Masak Merah	5.4	1	5.4	2019-02-12 08:02:42.649788	2019-02-12 08:02:42.649796
22	sr1549958560553	8	1	Rice Combo	8.9	1	8.9	2019-02-12 08:02:42.656233	2019-02-12 08:02:42.656241
23	sr1549959148100	9	1	Rice Combo	8.9	1	8.9	2019-02-12 08:12:30.208288	2019-02-12 08:12:30.208297
24	sr1549959148100	9	1	Rice Combo	8.9	1	8.9	2019-02-12 08:12:30.224822	2019-02-12 08:12:30.224831
25	sr1550020467107	2	2	Ayam Masak Merah	5.4	1	5.4	2019-02-13 01:14:28.092559	2019-02-13 01:14:28.092567
26	sr1550020467107	2	2	Ayam Percik	5.2	1	5.2	2019-02-13 01:14:28.094484	2019-02-13 01:14:28.094492
27	sr1550020467107	2	2	Ayam Masak Merah	5.4	1	5.4	2019-02-13 01:14:28.096261	2019-02-13 01:14:28.096269
28	sr1550020469546	1	1	Satay Ayam	1.1	1	1.1	2019-02-13 01:14:30.535691	2019-02-13 01:14:30.535701
29	sr1550020469546	1	1	Satay Daging	1.2	1	1.2	2019-02-13 01:14:30.537981	2019-02-13 01:14:30.537991
30	sr1550020469546	1	1	Satay Daging	1.2	1	1.2	2019-02-13 01:14:30.539893	2019-02-13 01:14:30.5399
31	sr1550021969838	3	2	Satay Daging	1.2	1	1.2	2019-02-13 01:39:30.890368	2019-02-13 01:39:30.890377
32	sr1550021969838	3	2	Satay Daging	1.2	1	1.2	2019-02-13 01:39:30.892887	2019-02-13 01:39:30.892897
33	sr1550021969838	3	2	Satay Ayam	1.1	1	1.1	2019-02-13 01:39:30.895003	2019-02-13 01:39:30.895013
34	sr1550021969838	3	2	Satay Ayam	1.1	1	1.1	2019-02-13 01:39:30.896722	2019-02-13 01:39:30.89673
35	sr1550026806038	1	1	Satay Ayam	1.1	1	1.1	2019-02-13 03:00:07.197646	2019-02-13 03:00:07.197656
36	sr1550026806038	1	1	Satay Ayam	1.1	1	1.1	2019-02-13 03:00:07.201717	2019-02-13 03:00:07.201726
37	sr1550026806038	1	1	Satay Daging	1.2	1	1.2	2019-02-13 03:00:07.203749	2019-02-13 03:00:07.203757
38	sr1550026806038	1	1	Satay Daging	1.2	1	1.2	2019-02-13 03:00:07.205777	2019-02-13 03:00:07.205784
39	sr1550026806038	1	1	Ayam Masak Merah	5.4	1	5.4	2019-02-13 03:00:07.207456	2019-02-13 03:00:07.207464
40	sr1550028324793	2	1	Satay Ayam	1.1	1	1.1	2019-02-13 03:25:25.937036	2019-02-13 03:25:25.937042
41	sr1550028324793	2	1	Satay Ayam	1.1	1	1.1	2019-02-13 03:25:25.946593	2019-02-13 03:25:25.946601
42	sr1550028324793	2	1	Satay Daging	1.2	1	1.2	2019-02-13 03:25:25.948281	2019-02-13 03:25:25.948289
43	sr1550028324793	2	1	Satay Daging	1.2	1	1.2	2019-02-13 03:25:25.950109	2019-02-13 03:25:25.950117
44	sr1550028324793	2	1	Satay Ayam	1.1	1	1.1	2019-02-13 03:25:25.952153	2019-02-13 03:25:25.952159
45	sr1550028447226	3	1	Satay Ayam	1.1	1	1.1	2019-02-13 03:27:28.807556	2019-02-13 03:27:28.807564
46	sr1550028447226	3	1	Satay Daging	1.2	1	1.2	2019-02-13 03:27:28.820832	2019-02-13 03:27:28.82084
47	sr1550028447226	3	1	Satay Daging	1.2	1	1.2	2019-02-13 03:27:28.822561	2019-02-13 03:27:28.822572
48	sr1550028447226	3	1	Satay Ayam	1.1	1	1.1	2019-02-13 03:27:28.825021	2019-02-13 03:27:28.825029
49	sr1550028534623	4	1	Satay Ayam	1.1	1	1.1	2019-02-13 03:28:55.743474	2019-02-13 03:28:55.743484
50	sr1550028534623	4	1	Satay Daging	1.2	1	1.2	2019-02-13 03:28:55.745406	2019-02-13 03:28:55.745413
51	sr1550028648355	5	1	Satay Ayam	1.1	1	1.1	2019-02-13 03:30:49.720878	2019-02-13 03:30:49.720885
52	sr1550028648355	5	1	Satay Ayam	1.1	1	1.1	2019-02-13 03:30:49.736532	2019-02-13 03:30:49.736543
53	sr1550028648355	5	1	Satay Ayam	1.1	1	1.1	2019-02-13 03:30:49.738448	2019-02-13 03:30:49.738457
54	sr1550028648355	5	1	Satay Daging	1.2	1	1.2	2019-02-13 03:30:49.740191	2019-02-13 03:30:49.740199
55	sr1550028648355	5	1	Satay Daging	1.2	1	1.2	2019-02-13 03:30:49.741721	2019-02-13 03:30:49.741728
56	sr1550028648355	5	1	Satay Daging	1.2	1	1.2	2019-02-13 03:30:49.743589	2019-02-13 03:30:49.743596
57	sr1550028848689	6	1	Satay Ayam	1.1	1	1.1	2019-02-13 03:34:09.871834	2019-02-13 03:34:09.87184
58	sr1550028848689	6	1	Satay Ayam	1.1	1	1.1	2019-02-13 03:34:09.873599	2019-02-13 03:34:09.873606
59	sr1550028848689	6	1	Satay Ayam	1.1	1	1.1	2019-02-13 03:34:09.875146	2019-02-13 03:34:09.875152
60	sr1550028848689	6	1	Satay Daging	1.2	1	1.2	2019-02-13 03:34:09.876853	2019-02-13 03:34:09.876861
61	sr1550028848689	6	1	Satay Daging	1.2	1	1.2	2019-02-13 03:34:09.878415	2019-02-13 03:34:09.878421
62	sr1550028907569	7	1	Rice Combo	8.9	1	8.9	2019-02-13 03:35:08.693673	2019-02-13 03:35:08.69368
63	sr1550029549801	8	1	Satay Ayam	1.1	1	1.1	2019-02-13 03:45:51.476883	2019-02-13 03:45:51.476893
64	sr1550029549801	8	1	Satay Ayam	1.1	1	1.1	2019-02-13 03:45:51.491191	2019-02-13 03:45:51.491201
65	sr1550029549801	8	1	Satay Daging	1.2	1	1.2	2019-02-13 03:45:51.493217	2019-02-13 03:45:51.493228
66	sr1550029549801	8	1	Satay Daging	1.2	1	1.2	2019-02-13 03:45:51.495837	2019-02-13 03:45:51.495845
67	sr1550029549801	8	1	Rice Combo	8.9	1	8.9	2019-02-13 03:45:51.497469	2019-02-13 03:45:51.497477
68	sr1550029621428	9	1	Satay Ayam	1.1	1	1.1	2019-02-13 03:47:02.534709	2019-02-13 03:47:02.534715
69	sr1550029621428	9	1	Satay Daging	1.2	1	1.2	2019-02-13 03:47:02.536513	2019-02-13 03:47:02.53652
70	sr1550029621428	9	1	Rice Combo	8.9	1	8.9	2019-02-13 03:47:02.537948	2019-02-13 03:47:02.537954
71	sr1550029621428	9	1	Satay Ayam	1.1	1	1.1	2019-02-13 03:47:02.539419	2019-02-13 03:47:02.539424
72	sr1550029621428	9	1	Satay Ayam	1.1	1	1.1	2019-02-13 03:47:02.540957	2019-02-13 03:47:02.540963
73	sr1550031171406	10	1	Satay Ayam	1.1	1	1.1	2019-02-13 04:12:52.684059	2019-02-13 04:12:52.684067
74	sr1550031171406	10	1	Satay Ayam	1.1	1	1.1	2019-02-13 04:12:52.686278	2019-02-13 04:12:52.686287
75	sr1550031171406	10	1	Satay Ayam	1.1	1	1.1	2019-02-13 04:12:52.687862	2019-02-13 04:12:52.687872
76	sr1550031171406	10	1	Satay Daging	1.2	1	1.2	2019-02-13 04:12:52.689501	2019-02-13 04:12:52.689507
83	sr1550031282222	11	1	Satay Daging	1.2	1	1.2	2019-02-13 04:14:43.372415	2019-02-13 04:14:43.372421
89	sr1550034554115	13	1	Satay Ayam	1.1	1	1.1	2019-02-13 05:09:15.335072	2019-02-13 05:09:15.33508
107	sr1550035295019	18	2	Satay Ayam	1.1	1	1.1	2019-02-13 05:21:36.291218	2019-02-13 05:21:36.291224
77	sr1550031171406	10	1	Satay Daging	1.2	1	1.2	2019-02-13 04:12:52.710629	2019-02-13 04:12:52.710637
84	sr1550031282222	11	1	Satay Ayam	1.1	1	1.1	2019-02-13 04:14:43.373835	2019-02-13 04:14:43.37384
90	sr1550034554115	13	1	Satay Daging	1.2	1	1.2	2019-02-13 05:09:15.336779	2019-02-13 05:09:15.336787
93	sr1550034722115	14	1	Satay Ayam	1.1	1	1.1	2019-02-13 05:12:03.309148	2019-02-13 05:12:03.309158
108	sr1550035295019	18	2	Satay Daging	1.2	1	1.2	2019-02-13 05:21:36.29295	2019-02-13 05:21:36.292955
78	sr1550031171406	10	1	Satay Daging	1.2	1	1.2	2019-02-13 04:12:52.712607	2019-02-13 04:12:52.712615
85	sr1550031282222	11	1	Satay Ayam	1.1	1	1.1	2019-02-13 04:14:43.375739	2019-02-13 04:14:43.375745
87	sr1550034509503	12	1	Satay Ayam	1.1	1	1.1	2019-02-13 05:08:30.77338	2019-02-13 05:08:30.773387
91	sr1550034554115	13	1	Satay Daging	1.2	1	1.2	2019-02-13 05:09:15.338647	2019-02-13 05:09:15.338654
94	sr1550034722115	14	1	Satay Daging	1.2	1	1.2	2019-02-13 05:12:03.310965	2019-02-13 05:12:03.310973
109	sr1550035295019	18	2	Satay Daging	1.2	1	1.2	2019-02-13 05:21:36.294375	2019-02-13 05:21:36.29438
79	sr1550031171406	10	1	Satay Daging	1.2	1	1.2	2019-02-13 04:12:52.748696	2019-02-13 04:12:52.748709
80	sr1550031171406	10	1	Rice Combo	8.9	1	8.9	2019-02-13 04:12:52.750651	2019-02-13 04:12:52.750659
86	sr1550031282222	11	1	Rice Combo	8.9	1	8.9	2019-02-13 04:14:43.377123	2019-02-13 04:14:43.377129
88	sr1550034509503	12	1	Satay Daging	1.2	1	1.2	2019-02-13 05:08:30.774723	2019-02-13 05:08:30.77473
92	sr1550034554115	13	1	Satay Daging	1.2	1	1.2	2019-02-13 05:09:15.340418	2019-02-13 05:09:15.340425
95	sr1550034722115	14	1	Satay Daging	1.2	1	1.2	2019-02-13 05:12:03.312426	2019-02-13 05:12:03.312433
96	sr1550034722115	14	1	Satay Daging	1.2	1	1.2	2019-02-13 05:12:03.313973	2019-02-13 05:12:03.31398
104	sr1550034737691	17	4	White Rice白饭	1.0	1	1.0	2019-02-13 05:12:19.648031	2019-02-13 05:12:19.648037
81	sr1550031282222	11	1	Satay Ayam	1.1	1	1.1	2019-02-13 04:14:43.369059	2019-02-13 04:14:43.369067
98	sr1550034726312	16	2	Satay Daging	1.2	1	1.2	2019-02-13 05:12:07.529465	2019-02-13 05:12:07.529473
112	sr1550035489117	20	1	Ayam Masak Merah	5.4	1	5.4	2019-02-13 05:24:50.344904	2019-02-13 05:24:50.34491
82	sr1550031282222	11	1	Satay Daging	1.2	1	1.2	2019-02-13 04:14:43.370739	2019-02-13 04:14:43.370745
99	sr1550034726312	16	2	Ayam Masak Merah	5.4	1	5.4	2019-02-13 05:12:07.531148	2019-02-13 05:12:07.531154
106	sr1550035295019	18	2	Satay Ayam	1.1	1	1.1	2019-02-13 05:21:36.289448	2019-02-13 05:21:36.289456
113	sr1550035489117	20	1	Rice Combo	8.9	1	8.9	2019-02-13 05:24:50.346249	2019-02-13 05:24:50.346254
97	sr1550034726312	16	2	Ayam Masak Merah	5.4	1	5.4	2019-02-13 05:12:07.527728	2019-02-13 05:12:07.527736
100	sr1550034733133	15	3	Satay Daging	1.2	1	1.2	2019-02-13 05:12:14.313445	2019-02-13 05:12:14.313451
110	sr1550035371129	19	2	Ayam Masak Merah	5.4	1	5.4	2019-02-13 05:22:52.38122	2019-02-13 05:22:52.381229
101	sr1550034733133	15	3	Satay Daging	1.2	1	1.2	2019-02-13 05:12:14.314991	2019-02-13 05:12:14.314997
111	sr1550035371129	19	2	Rice Combo	8.9	1	8.9	2019-02-13 05:22:52.383425	2019-02-13 05:22:52.383432
102	sr1550034733133	15	3	Satay Daging	1.2	1	1.2	2019-02-13 05:12:14.3166	2019-02-13 05:12:14.316605
103	sr1550034733133	15	3	Satay Ayam	1.1	1	1.1	2019-02-13 05:12:14.31813	2019-02-13 05:12:14.318135
105	sr1550034737691	17	4	Ayam Masak Merah	5.4	1	5.4	2019-02-13 05:12:19.649839	2019-02-13 05:12:19.649845
114	sr1550035594966	21	2	Ayam Masak Merah	5.4	1	5.4	2019-02-13 05:26:36.181714	2019-02-13 05:26:36.18172
115	sr1550035594966	21	2	Rice Combo	8.9	1	8.9	2019-02-13 05:26:36.183805	2019-02-13 05:26:36.18381
116	sr1550045046795	22	1	Satay Ayam	1.1	1	1.1	2019-02-13 08:04:08.176919	2019-02-13 08:04:08.176928
117	sr1550045046795	22	1	Satay Daging	1.2	1	1.2	2019-02-13 08:04:08.178849	2019-02-13 08:04:08.178858
118	sr1550045046795	22	1	Satay Daging	1.2	1	1.2	2019-02-13 08:04:08.180892	2019-02-13 08:04:08.1809
119	sr1550046667852	1	1	Satay Ayam	1.1	1	1.1	2019-02-13 08:31:08.666272	2019-02-13 08:31:08.666282
120	sr1550046667852	1	1	Satay Daging	1.2	1	1.2	2019-02-13 08:31:08.683503	2019-02-13 08:31:08.683512
121	sr1550046667852	1	1	Ayam Percik	5.2	1	5.2	2019-02-13 08:31:08.685693	2019-02-13 08:31:08.685699
122	sr1550047029482	2	1	Satay Ayam	1.1	1	1.1	2019-02-13 08:37:11.086861	2019-02-13 08:37:11.086867
123	sr1550047029482	2	1	Satay Daging	1.2	1	1.2	2019-02-13 08:37:11.101169	2019-02-13 08:37:11.101179
124	sr1550047029482	2	1	Ayam Masak Merah	5.4	1	5.4	2019-02-13 08:37:11.103589	2019-02-13 08:37:11.103596
125	sr1550047605356	1	1	Satay Ayam	1.1	1	1.1	2019-02-13 08:46:46.783893	2019-02-13 08:46:46.783901
126	sr1550047605356	1	1	Satay Ayam	1.1	1	1.1	2019-02-13 08:46:46.811933	2019-02-13 08:46:46.811942
127	sr1550047605356	1	1	Satay Ayam	1.1	1	1.1	2019-02-13 08:46:46.814384	2019-02-13 08:46:46.814391
128	sr1550047605356	1	1	Satay Ayam	1.1	1	1.1	2019-02-13 08:46:46.816129	2019-02-13 08:46:46.816135
129	sr1550047605356	1	1	Satay Ayam	1.1	1	1.1	2019-02-13 08:46:46.817995	2019-02-13 08:46:46.818
130	sr1550047605356	1	1	Satay Daging	1.2	1	1.2	2019-02-13 08:46:46.819666	2019-02-13 08:46:46.819673
131	sr1550047646049	2	1	Satay Ayam	1.1	1	1.1	2019-02-13 08:47:27.477694	2019-02-13 08:47:27.477702
132	sr1550047646049	2	1	Satay Ayam	1.1	1	1.1	2019-02-13 08:47:27.481841	2019-02-13 08:47:27.48185
133	sr1550047646049	2	1	Satay Ayam	1.1	1	1.1	2019-02-13 08:47:27.48344	2019-02-13 08:47:27.483446
134	sr1550047646049	2	1	Satay Daging	1.2	1	1.2	2019-02-13 08:47:27.491601	2019-02-13 08:47:27.491607
135	sr1550047646049	2	1	Satay Daging	1.2	1	1.2	2019-02-13 08:47:27.494498	2019-02-13 08:47:27.494504
136	sr1550047646049	2	1	Satay Daging	1.2	1	1.2	2019-02-13 08:47:27.506192	2019-02-13 08:47:27.506199
137	sr1550050343506	1	1	Satay Daging	1.2	1	1.2	2019-02-13 09:32:23.460618	2019-02-13 09:32:23.460624
138	kl1550132899912	1	1	Maggi Goreng	5.0	1	5.0	2019-02-14 08:28:21.335162	2019-02-14 08:28:21.335171
139	kl1550132899912	1	1	White Rice白饭	2.0	1	2.0	2019-02-14 08:28:21.337813	2019-02-14 08:28:21.337821
140	kl1550132976581	2	1	Ayam Set Lunch	7.0	1	7.0	2019-02-14 08:29:37.529908	2019-02-14 08:29:37.529915
141	kl1550133070068	3	1	Ayam Masak Merah	5.0	1	5.0	2019-02-14 08:31:10.937916	2019-02-14 08:31:10.937924
142	kl1550133070068	3	1	Ayam Masak Merah	5.0	1	5.0	2019-02-14 08:31:10.94031	2019-02-14 08:31:10.940321
143	kl1550133070068	3	1	Ayam Set Lunch	7.0	1	7.0	2019-02-14 08:31:10.942241	2019-02-14 08:31:10.942249
144	kl1550133070068	3	1	White Rice白饭	2.0	1	2.0	2019-02-14 08:31:10.944089	2019-02-14 08:31:10.944096
145	kl1550133070068	3	1	White Rice白饭	2.0	1	2.0	2019-02-14 08:31:10.945808	2019-02-14 08:31:10.945815
146	kl1550134307343	4	1	Ayam Masak Merah	5.0	1	5.0	2019-02-14 08:51:48.250317	2019-02-14 08:51:48.250329
147	kl1550134412842	5	1	Maggi Goreng	5.0	1	5.0	2019-02-14 08:53:33.664454	2019-02-14 08:53:33.664469
148	kl1550134412842	5	1	White Rice白饭	2.0	1	2.0	2019-02-14 08:53:33.666651	2019-02-14 08:53:33.666659
149	kl1550135623626	6	1	Ayam Set Lunch	7.0	1	7.0	2019-02-14 09:13:44.353645	2019-02-14 09:13:44.353651
150	kl1550136515145	7	1	Maggi Goreng	5.0	1	5.0	2019-02-14 09:28:36.225421	2019-02-14 09:28:36.225431
151	kl1550136515145	7	1	Satay Ayam	2.0	1	2.0	2019-02-14 09:28:36.227194	2019-02-14 09:28:36.227203
152	kl1550136515145	7	1	Satay Ayam	2.0	1	2.0	2019-02-14 09:28:36.229146	2019-02-14 09:28:36.229154
153	kl1550136515145	7	1	Satay Ayam	2.0	1	2.0	2019-02-14 09:28:36.231045	2019-02-14 09:28:36.231053
154	kl1550136515145	7	1	Satay Ayam	2.0	1	2.0	2019-02-14 09:28:36.23284	2019-02-14 09:28:36.232847
155	kl1550136875359	8	1	Ayam Set Lunch	7.0	1	7.0	2019-02-14 09:34:36.207818	2019-02-14 09:34:36.207856
156	sr1550139096217	1	1	Satay Ayam	1.1	1	1.1	2019-02-14 10:11:37.453161	2019-02-14 10:11:37.453169
157	sr1550139096217	1	1	Satay Daging	1.2	1	1.2	2019-02-14 10:11:37.455253	2019-02-14 10:11:37.455263
158	sr1550139096217	1	1	Satay Daging	1.2	1	1.2	2019-02-14 10:11:37.457206	2019-02-14 10:11:37.457214
159	sr1550139096217	1	1	Satay Ayam	1.1	1	1.1	2019-02-14 10:11:37.458941	2019-02-14 10:11:37.458949
160	sr1550139096217	1	1	Satay Daging	1.2	1	1.2	2019-02-14 10:11:37.460691	2019-02-14 10:11:37.460699
161	sr1550139158204	2	1	Satay Ayam	1.1	1	1.1	2019-02-14 10:12:39.321105	2019-02-14 10:12:39.321113
162	sr1550139158204	2	1	Satay Daging	1.2	1	1.2	2019-02-14 10:12:39.322657	2019-02-14 10:12:39.322664
163	sr1550139184402	3	1	Satay Ayam	1.1	1	1.1	2019-02-14 10:13:05.507473	2019-02-14 10:13:05.507481
164	sr1550139184402	3	1	Satay Daging	1.2	1	1.2	2019-02-14 10:13:05.508991	2019-02-14 10:13:05.509
165	sr1550139222276	4	1	Satay Ayam	1.1	1	1.1	2019-02-14 10:13:43.393848	2019-02-14 10:13:43.393858
166	sr1550139222276	4	1	Satay Daging	1.2	1	1.2	2019-02-14 10:13:43.395319	2019-02-14 10:13:43.395325
167	sr1550139342677	5	1	Satay Ayam	1.1	1	1.1	2019-02-14 10:15:43.841902	2019-02-14 10:15:43.84191
168	sr1550139342677	5	1	Satay Daging	1.2	1	1.2	2019-02-14 10:15:43.844263	2019-02-14 10:15:43.844272
169	sr1550139342677	5	1	Ayam Percik	5.2	1	5.2	2019-02-14 10:15:43.846092	2019-02-14 10:15:43.846097
170	sr1550139374820	6	1	Satay Daging	1.2	1	1.2	2019-02-14 10:16:15.937246	2019-02-14 10:16:15.937254
171	sr1550139374820	6	1	Satay Ayam	1.1	1	1.1	2019-02-14 10:16:15.971942	2019-02-14 10:16:15.971951
172	sr1550139374820	6	1	Satay Ayam	1.1	1	1.1	2019-02-14 10:16:15.973877	2019-02-14 10:16:15.973885
173	sr1550139429741	7	1	Satay Ayam	1.1	1	1.1	2019-02-14 10:17:10.892588	2019-02-14 10:17:10.892611
174	sr1550139429741	7	1	Ayam Percik	5.2	1	5.2	2019-02-14 10:17:10.894532	2019-02-14 10:17:10.894539
175	sr1550139429741	7	1	White Rice白饭	1.0	1	1.0	2019-02-14 10:17:10.896286	2019-02-14 10:17:10.896291
176	sr1550139579280	8	1	Satay Ayam	1.1	1	1.1	2019-02-14 10:19:40.40573	2019-02-14 10:19:40.405739
177	sr1550139579280	8	1	Satay Daging	1.2	1	1.2	2019-02-14 10:19:40.407467	2019-02-14 10:19:40.407474
178	sr1550139579280	8	1	Ayam Percik	5.2	1	5.2	2019-02-14 10:19:40.409362	2019-02-14 10:19:40.409371
179	sr1550139579280	8	1	Ayam Masak Merah	5.4	1	5.4	2019-02-14 10:19:40.411054	2019-02-14 10:19:40.411061
180	sr1550139600583	9	1	Rice Combo	8.9	1	8.9	2019-02-14 10:20:01.700519	2019-02-14 10:20:01.700528
181	sr1550139600583	9	1	Satay Ayam	1.1	1	1.1	2019-02-14 10:20:01.702454	2019-02-14 10:20:01.702462
182	sr1550139600583	9	1	Satay Ayam	1.1	1	1.1	2019-02-14 10:20:01.704138	2019-02-14 10:20:01.704145
183	sr1550139600583	9	1	Satay Ayam	1.1	1	1.1	2019-02-14 10:20:01.705742	2019-02-14 10:20:01.705749
184	sr1550139600583	9	1	Satay Ayam	1.1	1	1.1	2019-02-14 10:20:01.70738	2019-02-14 10:20:01.707388
185	sr1550139702416	10	1	Satay Ayam	1.1	1	1.1	2019-02-14 10:21:43.582992	2019-02-14 10:21:43.583003
186	sr1550139702416	10	1	Satay Ayam	1.1	1	1.1	2019-02-14 10:21:43.600171	2019-02-14 10:21:43.600179
187	sr1550139702416	10	1	Satay Daging	1.2	1	1.2	2019-02-14 10:21:43.601864	2019-02-14 10:21:43.601871
188	sr1550139702416	10	1	Satay Daging	1.2	1	1.2	2019-02-14 10:21:43.603671	2019-02-14 10:21:43.603677
209	kl1550202862203	5	1	Satay Daging	2.0	1	2.0	2019-02-15 03:54:22.296348	2019-02-15 03:54:22.296354
212	kl1550203038856	6	1	White Rice白饭	2.5	1	2.5	2019-02-15 03:57:18.958424	2019-02-15 03:57:18.958435
189	sr1550139784910	11	1	Satay Ayam	1.1	1	1.1	2019-02-14 10:23:06.119288	2019-02-14 10:23:06.119299
196	kl1550140077117	9	1	Maggi Goreng	5.0	1	5.0	2019-02-14 10:27:58.829662	2019-02-14 10:27:58.82967
190	sr1550139784910	11	1	Satay Ayam	1.1	1	1.1	2019-02-14 10:23:06.121125	2019-02-14 10:23:06.121133
201	kl1550202341491	1	1	Ayam Set Lunch	12.0	1	12.0	2019-02-15 03:45:41.626292	2019-02-15 03:45:41.626299
207	kl1550202862203	5	1	White Rice白饭	2.5	1	2.5	2019-02-15 03:54:22.292378	2019-02-15 03:54:22.292386
191	sr1550139784910	11	1	Satay Daging	1.2	1	1.2	2019-02-14 10:23:06.164003	2019-02-14 10:23:06.164012
192	sr1550139784910	11	1	Satay Daging	1.2	1	1.2	2019-02-14 10:23:06.165962	2019-02-14 10:23:06.165971
193	sr1550139784910	11	1	Ayam Masak Merah	5.4	1	5.4	2019-02-14 10:23:06.168291	2019-02-14 10:23:06.168299
194	kl1550140077117	9	1	White Rice白饭	2.0	1	2.0	2019-02-14 10:27:58.824832	2019-02-14 10:27:58.824845
198	kl1550196491564	10	1	White Rice白饭	2.0	1	2.0	2019-02-15 02:08:13.151384	2019-02-15 02:08:13.15139
202	kl1550202368429	3	1	Maggi Goreng	6.0	1	6.0	2019-02-15 03:46:08.507369	2019-02-15 03:46:08.507378
208	kl1550202862203	5	1	Satay Ayam	2.0	1	2.0	2019-02-15 03:54:22.294613	2019-02-15 03:54:22.29462
211	kl1550203038856	6	1	Maggi Goreng	6.0	1	6.0	2019-02-15 03:57:18.956107	2019-02-15 03:57:18.956117
213	kl1550203038856	6	1	Satay Ayam	2.0	1	2.0	2019-02-15 03:57:18.960361	2019-02-15 03:57:18.960369
215	kl1550203038856	6	1	Ayam Masak Merah	6.0	1	6.0	2019-02-15 03:57:18.968467	2019-02-15 03:57:18.968475
195	kl1550140077117	9	1	Maggi Goreng	5.0	1	5.0	2019-02-14 10:27:58.827727	2019-02-14 10:27:58.827735
197	kl1550196491564	10	1	Maggi Goreng	5.0	1	5.0	2019-02-15 02:08:13.149325	2019-02-15 02:08:13.149331
206	kl1550202862203	5	1	Maggi Goreng	6.0	1	6.0	2019-02-15 03:54:22.290477	2019-02-15 03:54:22.290486
199	kl1550202264424	2	2	Daging Set Lunch	12.0	1	12.0	2019-02-15 03:44:24.560024	2019-02-15 03:44:24.560032
200	kl1550202341491	1	1	Maggi Goreng	6.0	1	6.0	2019-02-15 03:45:41.62467	2019-02-15 03:45:41.62468
203	kl1550202368429	3	1	White Rice白饭	2.5	1	2.5	2019-02-15 03:46:08.509069	2019-02-15 03:46:08.509074
204	kl1550202460722	4	1	Maggi Goreng	6.0	1	6.0	2019-02-15 03:47:40.768717	2019-02-15 03:47:40.768725
205	kl1550202460722	4	1	White Rice白饭	2.5	1	2.5	2019-02-15 03:47:40.770888	2019-02-15 03:47:40.770896
210	kl1550202862203	5	1	Ayam Masak Merah	6.0	1	6.0	2019-02-15 03:54:22.298475	2019-02-15 03:54:22.298481
214	kl1550203038856	6	1	Satay Daging	2.0	1	2.0	2019-02-15 03:57:18.96205	2019-02-15 03:57:18.962061
\.


--
-- Name: sales_details_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.sales_details_id_seq', 215, true);


--
-- Name: sales_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.sales_id_seq', 62, true);


--
-- Data for Name: sales_payments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.sales_payments (id, salesid, order_id, payment_type, sub_total, gst_charge, service_charge, rounding, grand_total, cash, changes, salesdate, salesdatetime, inserted_at, updated_at) FROM stdin;
1	sr1549957905805	4	cash	3.4000000000000004	0.2	0.34	-0.04400000000000004	3.9	4.0	0.10000000000000009	2019-02-12	2019-02-12 15:51:45.796816	2019-02-12 07:51:48.006844	2019-02-12 07:51:48.006854
2	sr1549958027073	5	cash	4.6000000000000005	0.28	0.46	-0.036000000000000476	5.3	6.0	0.7000000000000002	2019-02-12	2019-02-12 15:53:47.035677	2019-02-12 07:53:49.151746	2019-02-12 07:53:49.151767
3	sr1549958365419	6	cash	32.4	1.94	3.24	0.016000000000005343	37.6	40.0	2.3999999999999986	2019-02-12	2019-02-12 15:59:25.385996	2019-02-12 07:59:27.515965	2019-02-12 07:59:27.515972
4	sr1549958474412	7	cash	9.9	0.59	0.99	-0.02	10.3	12.0	1.6999999999999993	2019-02-12	2019-02-12 16:01:14.347422	2019-02-12 08:01:16.580654	2019-02-12 08:01:16.580662
5	sr1549958560553	8	cash	19.8	1.19	1.98	-0.02	20.4	24.0	3.60	2019-02-12	2019-02-12 16:02:40.522712	2019-02-12 08:02:42.659406	2019-02-12 08:02:42.659414
6	sr1549959148100	9	cash	10.4	0.62	1.04	-0.05	20.6	14.0	-6.60	2019-02-12	2019-02-12 16:12:28.093470	2019-02-12 08:12:30.228041	2019-02-12 08:12:30.22805
7	sr1550020467107	2	cash	17.0	1.02	1.7	-0.02	19.7	20.0	0.30	2019-02-13	2019-02-13 09:14:27.078547	2019-02-13 01:14:28.098976	2019-02-13 01:14:28.098983
8	sr1550020469546	1	cash	3.5	0.21	0.35	0.04	4.1	5.0	0.90	2019-02-13	2019-02-13 09:14:29.539040	2019-02-13 01:14:30.542691	2019-02-13 01:14:30.542697
9	sr1550021969838	3	cash	4.6	0.28	0.46	-0.04	5.3	5.0	-0.30	2019-02-13	2019-02-13 09:39:29.830824	2019-02-13 01:39:30.900133	2019-02-13 01:39:30.900141
10	sr1550026806038	1	cash	0.0	0.0	0.0	0.0	11.6	10.0	-1.60	2019-02-13	2019-02-13 11:00:06.008153	2019-02-13 03:00:07.210303	2019-02-13 03:00:07.21031
11	sr1550028324793	2	cash	5.700000000000001	0.342	0.5700000000000002	-0.012000000000001343	6.6	10.0	3.40	2019-02-13	2019-02-13 11:25:24.719975	2019-02-13 03:25:25.954466	2019-02-13 03:25:25.954472
12	sr1550028447226	3	cash	4.6	0.27599999999999997	0.45999999999999996	-0.03599999999999959	5.3	6.0	0.70	2019-02-13	2019-02-13 11:27:27.173040	2019-02-13 03:27:28.828597	2019-02-13 03:27:28.828604
13	sr1550028534623	4	cash	2.3	0.14	0.23	0.03	2.7	4.0	1.30	2019-02-13	2019-02-13 11:28:54.590820	2019-02-13 03:28:55.748409	2019-02-13 03:28:55.748416
14	sr1550028648355	5	cash	6.9	0.41	0.69	0.0	8.0	5.0	-3.00	2019-02-13	2019-02-13 11:30:48.349782	2019-02-13 03:30:49.746714	2019-02-13 03:30:49.746721
15	sr1550028848689	6	cash	2.4	0.14	0.24	0.02	2.8	3.0	0.20	2019-02-13	2019-02-13 11:34:08.640530	2019-02-13 03:34:09.88133	2019-02-13 03:34:09.881339
16	sr1550028907569	7	cash	7.9	0.47	0.79	0.04	9.2	10.0	0.80	2019-02-13	2019-02-13 11:35:07.564963	2019-02-13 03:35:08.6966	2019-02-13 03:35:08.696611
17	sr1550029549801	8	cash	14.5	0.87	1.45	-0.02	16.8	18.0	1.20	2019-02-13	2019-02-13 11:45:49.771108	2019-02-13 03:45:51.500337	2019-02-13 03:45:51.500344
18	sr1550029621428	9	cash	11.3	0.68	1.13	-0.01	13.1	15.0	1.90	2019-02-13	2019-02-13 11:47:01.403991	2019-02-13 03:47:02.54351	2019-02-13 03:47:02.543515
19	sr1550031171406	10	cash	14.7	0.88	1.47	0.05	17.1	20.0	2.90	2019-02-13	2019-02-13 12:12:51.382089	2019-02-13 04:12:52.754035	2019-02-13 04:12:52.754043
20	sr1550031282222	11	cash	12.3	0.74	1.23	0.03	14.3	15.0	0.70	2019-02-13	2019-02-13 12:14:42.187690	2019-02-13 04:14:43.379626	2019-02-13 04:14:43.379632
21	sr1550034509503	12	cash	2.3	0.14	0.23	0.03	2.7	3.0	0.30	2019-02-13	2019-02-13 13:08:29.469039	2019-02-13 05:08:30.777372	2019-02-13 05:08:30.777378
22	sr1550034554115	13	cash	2.7	0.16	0.27	-0.03	3.1	4.0	0.90	2019-02-13	2019-02-13 13:09:14.073403	2019-02-13 05:09:15.34292	2019-02-13 05:09:15.342927
23	sr1550034722115	14	cash	4.7	0.28	0.47	0.05	5.5	6.0	0.50	2019-02-13	2019-02-13 13:12:02.079166	2019-02-13 05:12:03.316807	2019-02-13 05:12:03.316813
24	sr1550034726312	16	cash	12.0	0.72	1.2	-0.02	13.9	14.0	0.10	2019-02-13	2019-02-13 13:12:06.306715	2019-02-13 05:12:07.533891	2019-02-13 05:12:07.533898
25	sr1550034733133	15	cash	2.7	0.16	0.27	-0.03	3.1	5.0	1.90	2019-02-13	2019-02-13 13:12:13.106224	2019-02-13 05:12:14.321362	2019-02-13 05:12:14.321367
26	sr1550034737691	17	cash	6.4	0.38	0.64	-0.02	7.4	8.0	0.60	2019-02-13	2019-02-13 13:12:17.648509	2019-02-13 05:12:19.65265	2019-02-13 05:12:19.652655
27	sr1550035295019	18	cash	4.6	0.28	0.46	-0.04	5.3	6.0	0.70	2019-02-13	2019-02-13 13:21:34.986244	2019-02-13 05:21:36.297391	2019-02-13 05:21:36.297396
28	sr1550035371129	19	cash	15.3	0.92	1.53	-0.05	17.7	20.0	2.30	2019-02-13	2019-02-13 13:22:51.070183	2019-02-13 05:22:52.386489	2019-02-13 05:22:52.386495
29	sr1550035489117	20	cash	16.0	0.96	1.6	0.04	18.6	20.0	1.40	2019-02-13	2019-02-13 13:24:22.223638	2019-02-13 05:24:50.348912	2019-02-13 05:24:50.348917
30	sr1550035489117	20	cash	16.0	0.96	1.6	0.04	18.6	20.0	1.40	2019-02-13	2019-02-13 13:24:49.059326	2019-02-13 05:24:50.351726	2019-02-13 05:24:50.351733
31	sr1550035594966	21	cash	16.8	1.01	1.68	0.01	19.5	20.0	0.50	2019-02-13	2019-02-13 13:26:34.932298	2019-02-13 05:26:36.187	2019-02-13 05:26:36.187006
32	sr1550045046795	22	cash	1.5	0.09	0.15	-0.04	1.7	2.0	0.30	2019-02-13	2019-02-13 16:04:06.767758	2019-02-13 08:04:08.184212	2019-02-13 08:04:08.18422
33	sr1550046667852	1	cash	7.5	0.45	0.75	0.0	8.7	9.0	0.30	2019-02-13	2019-02-13 16:31:07.809859	2019-02-13 08:31:08.688799	2019-02-13 08:31:08.688807
34	sr1550047029482	2	cash	3.85	0.23	0.39	0.03	4.5	5.0	0.50	2019-02-13	2019-02-13 16:37:09.442699	2019-02-13 08:37:11.106737	2019-02-13 08:37:11.106743
35	sr1550047605356	1	cash	6.7	0.4	0.67	0.03	7.8	8.0	0.20	2019-02-13	2019-02-13 16:46:45.282429	2019-02-13 08:46:46.822534	2019-02-13 08:46:46.822539
36	sr1550047646049	2	cash	4.9	0.29	0.49	0.02	5.7	6.0	0.30	2019-02-13	2019-02-13 16:47:25.990289	2019-02-13 08:47:27.509104	2019-02-13 08:47:27.509111
37	sr1550050343506	1	cash	1.2	0.07	0.12	0.01	1.4	2.0	0.60	2019-02-13	2019-02-13 17:32:23.454350	2019-02-13 09:32:23.497625	2019-02-13 09:32:23.497635
38	kl1550132899912	1	cash	7.0	0.42	0.7	-0.02	8.1	10.0	1.90	2019-02-14	2019-02-14 16:28:19.752908	2019-02-14 08:28:21.341842	2019-02-14 08:28:21.34185
39	kl1550132976581	2	cash	7.0	0.42	0.7	-0.02	8.1	10.0	1.90	2019-02-14	2019-02-14 16:29:36.526364	2019-02-14 08:29:37.533321	2019-02-14 08:29:37.533327
40	kl1550133070068	3	cash	22.5	1.35	2.25	0.0	26.1	28.0	1.90	2019-02-14	2019-02-14 16:31:10.027215	2019-02-14 08:31:10.953555	2019-02-14 08:31:10.953563
41	kl1550134307343	4	cash	4.0	0.24	0.4	-0.04	4.6	5.0	0.40	2019-02-14	2019-02-14 16:51:47.299952	2019-02-14 08:51:48.257731	2019-02-14 08:51:48.25774
42	kl1550134412842	5	cash	5.0	0.3	0.5	0.0	5.8	6.0	0.20	2019-02-14	2019-02-14 16:53:32.803468	2019-02-14 08:53:33.669552	2019-02-14 08:53:33.669559
43	kl1550135623626	6	cash	7.0	0.42	0.7	-0.02	8.1	10.0	1.90	2019-02-14	2019-02-14 17:13:43.577106	2019-02-14 09:13:44.362144	2019-02-14 09:13:44.362153
44	kl1550136515145	7	cash	7.0	0.42	0.7	-0.02	8.1	10.0	1.90	2019-02-14	2019-02-14 17:28:35.103755	2019-02-14 09:28:36.236074	2019-02-14 09:28:36.23608
45	kl1550136875359	8	cash	7.0	0.42	0.7	-0.02	8.1	10.0	1.90	2019-02-14	2019-02-14 17:34:35.321283	2019-02-14 09:34:36.223054	2019-02-14 09:34:36.223062
46	sr1550139096217	1	cash	3.5	0.21	0.35	0.04	4.1	5.0	0.90	2019-02-14	2019-02-14 18:10:27.869026	2019-02-14 10:11:37.463443	2019-02-14 10:11:37.46345
47	sr1550139096217	1	cash	5.8	0.35	0.58	-0.03	6.7	9.0	2.30	2019-02-14	2019-02-14 18:11:36.182434	2019-02-14 10:11:37.466825	2019-02-14 10:11:37.466835
48	sr1550139158204	2	cash	2.3	0.14	0.23	0.03	2.7	5.0	2.30	2019-02-14	2019-02-14 18:12:38.179021	2019-02-14 10:12:39.325389	2019-02-14 10:12:39.325397
49	sr1550139184402	3	cash	2.3	0.14	0.23	0.03	2.7	5.0	2.30	2019-02-14	2019-02-14 18:13:04.371560	2019-02-14 10:13:05.512175	2019-02-14 10:13:05.512185
50	sr1550139222276	4	cash	2.3	0.14	0.23	0.03	2.7	5.0	2.30	2019-02-14	2019-02-14 18:13:42.244980	2019-02-14 10:13:43.39808	2019-02-14 10:13:43.398088
51	sr1550139342677	5	cash	7.5	0.45	0.75	0.0	8.7	9.0	0.30	2019-02-14	2019-02-14 18:15:42.640037	2019-02-14 10:15:43.848799	2019-02-14 10:15:43.848806
52	sr1550139374820	6	cash	3.4	0.2	0.34	-0.04	3.9	5.0	1.10	2019-02-14	2019-02-14 18:16:14.788156	2019-02-14 10:16:15.97655	2019-02-14 10:16:15.976555
53	sr1550139429741	7	cash	7.3	0.44	0.73	0.03	8.5	9.0	0.50	2019-02-14	2019-02-14 18:17:09.732532	2019-02-14 10:17:10.89926	2019-02-14 10:17:10.899266
54	sr1550139579280	8	cash	12.9	0.77	1.29	0.04	15.0	15.0	0.00	2019-02-14	2019-02-14 18:19:39.252040	2019-02-14 10:19:40.414234	2019-02-14 10:19:40.414242
55	sr1550139600583	9	cash	11.0	0.66	1.1	0.04	12.8	15.0	2.20	2019-02-14	2019-02-14 18:20:00.549396	2019-02-14 10:20:01.710271	2019-02-14 10:20:01.710278
56	sr1550139702416	10	cash	2.6	0.16	0.26	-0.02	3.0	3.0	0.00	2019-02-14	2019-02-14 18:21:42.384903	2019-02-14 10:21:43.606566	2019-02-14 10:21:43.606571
57	sr1550139784910	11	cash	5.0	0.3	0.5	0.0	5.8	6.0	0.20	2019-02-14	2019-02-14 18:23:04.742336	2019-02-14 10:23:06.172283	2019-02-14 10:23:06.172291
58	kl1550140077117	9	cash	10.0	0.6	1.0	0.0	11.6	12.0	0.40	2019-02-14	2019-02-14 18:27:57.076997	2019-02-14 10:27:58.832696	2019-02-14 10:27:58.832704
59	kl1550196491564	10	cash	7.0	0.42	0.7	-0.02	8.1	10.0	1.90	2019-02-15	2019-02-15 10:08:11.523272	2019-02-15 02:08:13.15421	2019-02-15 02:08:13.154217
60	kl1550202264424	2	cash	0.0	0.0	0.0	0.0	0.0	0.0	0.00	2019-02-14	2019-02-14 22:44:24.382853	2019-02-15 03:44:24.563348	2019-02-15 03:44:24.563357
61	kl1550202341491	1	cash	4.0	0.24	0.4	-0.04	4.6	4.6	0.00	2019-02-14	2019-02-14 22:45:41.457880	2019-02-15 03:45:41.62887	2019-02-15 03:45:41.628876
62	kl1550202368429	3	cash	8.5	0.51	0.85	0.04	9.9	20.0	10.10	2019-02-14	2019-02-14 22:46:08.395284	2019-02-15 03:46:08.511943	2019-02-15 03:46:08.51195
63	kl1550202460722	4	cash	8.5	0.51	0.85	0.04	9.9	50.0	40.10	2019-02-14	2019-02-14 22:47:40.683681	2019-02-15 03:47:40.77405	2019-02-15 03:47:40.774058
64	kl1550202862203	5	cash	19.0	1.14	1.9	-0.04	22.0	25.0	3.00	2019-02-14	2019-02-14 22:54:22.162380	2019-02-15 03:54:22.301724	2019-02-15 03:54:22.30173
65	kl1550203038856	6	cash	19.0	1.14	1.9	-0.04	22.0	100.0	78.00	2019-02-14	2019-02-14 22:57:18.563221	2019-02-15 03:57:18.9721	2019-02-15 03:57:18.972107
\.


--
-- Name: sales_payments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.sales_payments_id_seq', 65, true);


--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.schema_migrations (version, inserted_at) FROM stdin;
20190130011635	2019-01-31 07:53:16.901892
20190130011723	2019-01-31 07:53:16.92787
20190130011931	2019-01-31 07:53:16.946735
20190130034449	2019-01-31 07:53:16.96115
20190130035353	2019-01-31 07:53:16.975841
20190130041210	2019-01-31 07:53:16.993573
20190130041919	2019-01-31 07:53:17.011248
20190130042327	2019-01-31 07:53:17.026996
20190130044237	2019-01-31 07:53:17.040825
20190130044702	2019-01-31 07:53:17.056475
20190130045755	2019-01-31 07:53:17.07014
20190130061743	2019-01-31 07:53:17.084049
20190130064127	2019-01-31 07:53:17.100497
20190130073134	2019-01-31 07:53:17.130401
20190130075737	2019-01-31 07:53:17.153053
20190130080840	2019-01-31 07:53:17.168742
20190131032735	2019-01-31 07:53:17.193864
20190131032833	2019-01-31 07:53:17.215442
20190131095553	2019-01-31 10:34:43.031634
20190211082127	2019-02-11 09:53:59.877405
20190211082208	2019-02-11 09:53:59.906429
20190211085548	2019-02-11 09:53:59.926846
20190212065803	2019-02-12 07:24:53.666843
20190212065950	2019-02-12 07:24:53.704818
20190212081527	2019-02-13 01:12:52.463992
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, username, password, crypted_password, email, inserted_at, updated_at, user_type, pin, organization_id) FROM stdin;
2	Summer	\N	$2b$12$psvg35gZCPEQEgyAkjj.M.h5DFv4m6UO/7.sdABJCsagdHzzbApga	\N	2019-01-31 08:26:06.89649	2019-01-31 08:26:06.896503	Staff	1233	1
1	admin	\N	$2b$12$/XLsPadIRKmy/8DJ4u.dYeagkdO7VosG8GkOC8IBnJGMeNH2HROXi	\N	2019-01-31 07:53:51.606488	2019-02-14 03:10:14.464191	Admin	1233	1
3	jason	\N	$2b$12$Ul3OW4bPiUKvg7EXubs4q.ZXfoC2fTGfuGQ3LAqBCZXf3iMv3bJIG	\N	2019-02-14 03:31:59.092595	2019-02-14 03:49:47.61691	Admin	1233	2
4	Damien	\N	$2b$12$GsmkTa4zln4sckBLpXWByuhEYbZKsyu1pLphDxDy0PjC0J2ZRRIKC	\N	2019-02-14 04:09:46.675166	2019-02-14 04:09:46.675179	Staff	1233	2
\.


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_id_seq', 4, true);


--
-- Name: combo_price_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.combo_price
    ADD CONSTRAINT combo_price_pkey PRIMARY KEY (id);


--
-- Name: combos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.combos
    ADD CONSTRAINT combos_pkey PRIMARY KEY (id);


--
-- Name: discounts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.discounts
    ADD CONSTRAINT discounts_pkey PRIMARY KEY (id);


--
-- Name: item_price_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.item_price
    ADD CONSTRAINT item_price_pkey PRIMARY KEY (id);


--
-- Name: items_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.items
    ADD CONSTRAINT items_pkey PRIMARY KEY (id);


--
-- Name: organization_price_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.organization_price
    ADD CONSTRAINT organization_price_pkey PRIMARY KEY (id);


--
-- Name: organizations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.organizations
    ADD CONSTRAINT organizations_pkey PRIMARY KEY (id);


--
-- Name: printers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.printers
    ADD CONSTRAINT printers_pkey PRIMARY KEY (id);


--
-- Name: rest_discounts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rest_discounts
    ADD CONSTRAINT rest_discounts_pkey PRIMARY KEY (id);


--
-- Name: rest_item_printer_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rest_item_printer
    ADD CONSTRAINT rest_item_printer_pkey PRIMARY KEY (id);


--
-- Name: restaurants_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.restaurants
    ADD CONSTRAINT restaurants_pkey PRIMARY KEY (id);


--
-- Name: sales_details_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sales_details
    ADD CONSTRAINT sales_details_pkey PRIMARY KEY (id);


--
-- Name: sales_payments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sales_payments
    ADD CONSTRAINT sales_payments_pkey PRIMARY KEY (id);


--
-- Name: sales_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sales
    ADD CONSTRAINT sales_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: sales_details_salesid_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX sales_details_salesid_index ON public.sales_details USING btree (salesid);


--
-- Name: sales_organization_id_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX sales_organization_id_index ON public.sales USING btree (organization_id);


--
-- Name: sales_payments_salesid_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX sales_payments_salesid_index ON public.sales_payments USING btree (salesid);


--
-- Name: sales_rest_name_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX sales_rest_name_index ON public.sales USING btree (rest_name);


--
-- Name: sales_salesdate_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX sales_salesdate_index ON public.sales USING btree (salesdate);


--
-- Name: sales_salesid_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX sales_salesid_index ON public.sales USING btree (salesid);


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

