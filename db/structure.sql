SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;


--
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


--
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;


--
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


SET search_path = public, pg_catalog;

--
-- Name: ip_version_type; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE ip_version_type AS ENUM (
    'ipv4',
    'ipv6',
    'onion'
);


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: alerts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE alerts (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    email text,
    node_id bigint,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: node_snapshots; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE node_snapshots (
    node_id uuid,
    snapshot_id uuid
);


--
-- Name: nodes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE nodes (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    port integer,
    version integer,
    user_agent text,
    services integer,
    height integer,
    "timestamp" timestamp without time zone,
    hostname text,
    city text,
    country text,
    latitude numeric(10,6),
    longitude numeric(10,6),
    timezone text,
    asn text,
    org text,
    ip inet,
    address text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    ip_version ip_version_type,
    country_friendly_name text,
    snapshot_at timestamp without time zone
);


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE schema_migrations (
    version character varying NOT NULL
);


--
-- Name: snapshots; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE snapshots (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    height integer,
    crawled_at timestamp without time zone,
    num_nodes integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: alerts alerts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY alerts
    ADD CONSTRAINT alerts_pkey PRIMARY KEY (id);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: nodes nodes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY nodes
    ADD CONSTRAINT nodes_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: snapshots snapshots_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY snapshots
    ADD CONSTRAINT snapshots_pkey PRIMARY KEY (id);


--
-- Name: index_alerts_on_node_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_alerts_on_node_id ON alerts USING btree (node_id);


--
-- Name: index_node_snapshots_on_node_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_node_snapshots_on_node_id ON node_snapshots USING btree (node_id);


--
-- Name: index_node_snapshots_on_snapshot_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_node_snapshots_on_snapshot_id ON node_snapshots USING btree (snapshot_id);


--
-- Name: index_nodes_on_country; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_nodes_on_country ON nodes USING btree (country);


--
-- Name: index_nodes_on_ip; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_nodes_on_ip ON nodes USING btree (ip);


--
-- Name: index_nodes_on_ip_version; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_nodes_on_ip_version ON nodes USING btree (ip_version);


--
-- Name: index_nodes_on_user_agent; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_nodes_on_user_agent ON nodes USING btree (user_agent);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO "schema_migrations" (version) VALUES
('20170701023529'),
('20170728190115'),
('20170804163629'),
('20170804225243'),
('20170804225416'),
('20170805015958'),
('20170807190544'),
('20170816172051'),
('20170821230824'),
('20170821231320'),
('20170821233344');


