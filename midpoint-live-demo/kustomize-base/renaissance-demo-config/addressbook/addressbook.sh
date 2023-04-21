#!/bin/bash
set -e

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL

--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: people; Type: TABLE; Schema: public; Owner: addressbook; Tablespace: 
--

CREATE TABLE people (
    first_name character varying(100),
    last_name character varying(100) NOT NULL,
    tel_number character varying(32),
    fax_number character varying(32),
    office_id character varying(32),
    floor integer,
    street_address character varying(100),
    city character varying(100),
    country character varying(100),
    postal_code character varying(16),
    validity boolean,
    created timestamp without time zone,
    modified timestamp without time zone,
    username character varying(64),
    password character varying(64)
);


ALTER TABLE public.people OWNER TO $POSTGRES_USER;

--
-- Data for Name: people; Type: TABLE DATA; Schema: public; Owner: addressbook
--

COPY people (first_name, last_name, tel_number, fax_number, office_id, floor, street_address, city, country, postal_code, validity, created, modified, username, password) FROM stdin;
Luca	Bartolomeo de Pacioli	\N	\N	\N	\N	\N	\N	\N	\N	true	\N	\N	paciolo	\N
\.


--
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM $POSTGRES_DB;
GRANT ALL ON SCHEMA public TO $POSTGRES_DB;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--


EOSQL

