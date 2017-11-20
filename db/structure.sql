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


SET search_path = public, pg_catalog;

--
-- Name: membership_role; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE membership_role AS ENUM (
    'guest',
    'viewer',
    'author',
    'editor',
    'admin',
    'owner'
);


--
-- Name: representation_status; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE representation_status AS ENUM (
    'ready_to_review',
    'approved',
    'not_approved'
);


--
-- Name: resource_type; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE resource_type AS ENUM (
    'collection',
    'dataset',
    'event',
    'image',
    'interactive_resource',
    'moving_image',
    'physical_object',
    'service',
    'software',
    'sound',
    'still_image',
    'text'
);


SET default_tablespace = '';

SET default_with_oids = false;

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
-- Name: assignments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE assignments (
    id integer NOT NULL,
    user_id integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    resource_id integer NOT NULL
);


--
-- Name: assignments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE assignments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: assignments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE assignments_id_seq OWNED BY assignments.id;


--
-- Name: audits; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE audits (
    id integer NOT NULL,
    auditable_id integer NOT NULL,
    auditable_type character varying NOT NULL,
    associated_id integer,
    associated_type character varying,
    user_id integer,
    user_type character varying,
    username character varying DEFAULT 'Unknown'::character varying NOT NULL,
    action character varying NOT NULL,
    audited_changes jsonb,
    version integer DEFAULT 0 NOT NULL,
    comment character varying,
    remote_address character varying,
    request_uuid character varying,
    created_at timestamp without time zone NOT NULL
);


--
-- Name: audits_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE audits_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: audits_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE audits_id_seq OWNED BY audits.id;


--
-- Name: descriptions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE descriptions (
    id integer NOT NULL,
    locale character varying DEFAULT 'en'::character varying,
    text text,
    status_id integer NOT NULL,
    image_id integer NOT NULL,
    metum_id integer NOT NULL,
    user_id integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    license character varying DEFAULT 'cc0-1.0'::character varying
);


--
-- Name: descriptions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE descriptions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: descriptions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE descriptions_id_seq OWNED BY descriptions.id;


--
-- Name: endpoints; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE endpoints (
    id bigint NOT NULL,
    name character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: endpoints_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE endpoints_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: endpoints_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE endpoints_id_seq OWNED BY endpoints.id;


--
-- Name: images; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE images (
    id integer NOT NULL,
    path character varying,
    context_id integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    canonical_id character varying,
    assignments_count integer DEFAULT 0 NOT NULL,
    descriptions_count integer DEFAULT 0 NOT NULL,
    title text,
    priority boolean DEFAULT false NOT NULL,
    status_code integer DEFAULT 0 NOT NULL,
    old_page_urls text,
    organization_id bigint NOT NULL,
    page_urls text[] DEFAULT '{}'::text[] NOT NULL
);


--
-- Name: images_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE images_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: images_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE images_id_seq OWNED BY images.id;


--
-- Name: invitations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE invitations (
    id bigint NOT NULL,
    recipient_email character varying NOT NULL,
    token character varying NOT NULL,
    sender_user_id bigint NOT NULL,
    recipient_user_id bigint NOT NULL,
    organization_id bigint NOT NULL,
    redeemed_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    role membership_role DEFAULT 'viewer'::membership_role NOT NULL
);


--
-- Name: invitations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE invitations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: invitations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE invitations_id_seq OWNED BY invitations.id;


--
-- Name: licenses; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE licenses (
    id bigint NOT NULL,
    name character varying NOT NULL,
    title character varying NOT NULL,
    url character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: licenses_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE licenses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: licenses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE licenses_id_seq OWNED BY licenses.id;


--
-- Name: memberships; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE memberships (
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    organization_id bigint NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    role membership_role DEFAULT 'guest'::membership_role NOT NULL
);


--
-- Name: memberships_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE memberships_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: memberships_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE memberships_id_seq OWNED BY memberships.id;


--
-- Name: meta; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE meta (
    id integer NOT NULL,
    title character varying NOT NULL,
    instructions text DEFAULT ''::text NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    organization_id bigint NOT NULL
);


--
-- Name: meta_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE meta_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: meta_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE meta_id_seq OWNED BY meta.id;


--
-- Name: organizations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE organizations (
    id integer NOT NULL,
    title text NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: organizations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE organizations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: organizations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE organizations_id_seq OWNED BY organizations.id;


--
-- Name: representations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE representations (
    id bigint NOT NULL,
    resource_id bigint NOT NULL,
    text text,
    content_uri character varying,
    status representation_status DEFAULT 'ready_to_review'::representation_status NOT NULL,
    metum_id bigint NOT NULL,
    author_id bigint NOT NULL,
    content_type character varying DEFAULT 'text/plain'::character varying NOT NULL,
    language character varying NOT NULL,
    license_id bigint NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    notes text,
    endpoint_id bigint NOT NULL
);


--
-- Name: representations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE representations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: representations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE representations_id_seq OWNED BY representations.id;


--
-- Name: resource_groups; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE resource_groups (
    id integer NOT NULL,
    title character varying NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    organization_id integer NOT NULL
);


--
-- Name: resource_groups_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE resource_groups_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: resource_groups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE resource_groups_id_seq OWNED BY resource_groups.id;


--
-- Name: resource_links; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE resource_links (
    id bigint NOT NULL,
    subject_resource_id bigint NOT NULL,
    verb character varying NOT NULL,
    object_resource_id bigint NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: resource_links_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE resource_links_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: resource_links_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE resource_links_id_seq OWNED BY resource_links.id;


--
-- Name: resources; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE resources (
    id bigint NOT NULL,
    identifier character varying NOT NULL,
    title character varying DEFAULT 'Unknown'::character varying NOT NULL,
    resource_type resource_type NOT NULL,
    canonical_id character varying NOT NULL,
    source_uri character varying,
    resource_group_id bigint NOT NULL,
    organization_id bigint NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    representations_count integer DEFAULT 0 NOT NULL,
    priority_flag boolean DEFAULT false NOT NULL
);


--
-- Name: resources_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE resources_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: resources_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE resources_id_seq OWNED BY resources.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE schema_migrations (
    version character varying NOT NULL
);


--
-- Name: statuses; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE statuses (
    id integer NOT NULL,
    title character varying,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: statuses_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE statuses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: statuses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE statuses_id_seq OWNED BY statuses.id;


--
-- Name: taggings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE taggings (
    id integer NOT NULL,
    tag_id integer NOT NULL,
    taggable_id integer NOT NULL,
    taggable_type character varying NOT NULL,
    tagger_id integer NOT NULL,
    tagger_type character varying NOT NULL,
    context character varying(128),
    created_at timestamp without time zone
);


--
-- Name: taggings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE taggings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: taggings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE taggings_id_seq OWNED BY taggings.id;


--
-- Name: tags; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE tags (
    id integer NOT NULL,
    name character varying NOT NULL,
    taggings_count integer DEFAULT 0 NOT NULL
);


--
-- Name: tags_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE tags_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tags_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE tags_id_seq OWNED BY tags.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE users (
    id integer NOT NULL,
    email character varying DEFAULT ''::character varying NOT NULL,
    encrypted_password character varying DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying,
    reset_password_sent_at timestamp without time zone,
    remember_created_at timestamp without time zone,
    sign_in_count integer DEFAULT 0 NOT NULL,
    current_sign_in_at timestamp without time zone,
    last_sign_in_at timestamp without time zone,
    current_sign_in_ip character varying,
    last_sign_in_ip character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    first_name character varying,
    last_name character varying,
    authentication_token character varying NOT NULL,
    staff boolean DEFAULT false NOT NULL,
    failed_attempts integer DEFAULT 0 NOT NULL,
    unlock_token character varying,
    locked_at timestamp without time zone
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE users_id_seq OWNED BY users.id;


--
-- Name: assignments id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY assignments ALTER COLUMN id SET DEFAULT nextval('assignments_id_seq'::regclass);


--
-- Name: audits id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY audits ALTER COLUMN id SET DEFAULT nextval('audits_id_seq'::regclass);


--
-- Name: descriptions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY descriptions ALTER COLUMN id SET DEFAULT nextval('descriptions_id_seq'::regclass);


--
-- Name: endpoints id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY endpoints ALTER COLUMN id SET DEFAULT nextval('endpoints_id_seq'::regclass);


--
-- Name: images id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY images ALTER COLUMN id SET DEFAULT nextval('images_id_seq'::regclass);


--
-- Name: invitations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY invitations ALTER COLUMN id SET DEFAULT nextval('invitations_id_seq'::regclass);


--
-- Name: licenses id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY licenses ALTER COLUMN id SET DEFAULT nextval('licenses_id_seq'::regclass);


--
-- Name: memberships id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY memberships ALTER COLUMN id SET DEFAULT nextval('memberships_id_seq'::regclass);


--
-- Name: meta id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY meta ALTER COLUMN id SET DEFAULT nextval('meta_id_seq'::regclass);


--
-- Name: organizations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY organizations ALTER COLUMN id SET DEFAULT nextval('organizations_id_seq'::regclass);


--
-- Name: representations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY representations ALTER COLUMN id SET DEFAULT nextval('representations_id_seq'::regclass);


--
-- Name: resource_groups id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY resource_groups ALTER COLUMN id SET DEFAULT nextval('resource_groups_id_seq'::regclass);


--
-- Name: resource_links id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY resource_links ALTER COLUMN id SET DEFAULT nextval('resource_links_id_seq'::regclass);


--
-- Name: resources id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY resources ALTER COLUMN id SET DEFAULT nextval('resources_id_seq'::regclass);


--
-- Name: statuses id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY statuses ALTER COLUMN id SET DEFAULT nextval('statuses_id_seq'::regclass);


--
-- Name: taggings id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY taggings ALTER COLUMN id SET DEFAULT nextval('taggings_id_seq'::regclass);


--
-- Name: tags id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY tags ALTER COLUMN id SET DEFAULT nextval('tags_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: assignments assignments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY assignments
    ADD CONSTRAINT assignments_pkey PRIMARY KEY (id);


--
-- Name: audits audits_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY audits
    ADD CONSTRAINT audits_pkey PRIMARY KEY (id);


--
-- Name: descriptions descriptions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY descriptions
    ADD CONSTRAINT descriptions_pkey PRIMARY KEY (id);


--
-- Name: endpoints endpoints_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY endpoints
    ADD CONSTRAINT endpoints_pkey PRIMARY KEY (id);


--
-- Name: images images_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY images
    ADD CONSTRAINT images_pkey PRIMARY KEY (id);


--
-- Name: invitations invitations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY invitations
    ADD CONSTRAINT invitations_pkey PRIMARY KEY (id);


--
-- Name: licenses licenses_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY licenses
    ADD CONSTRAINT licenses_pkey PRIMARY KEY (id);


--
-- Name: memberships memberships_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY memberships
    ADD CONSTRAINT memberships_pkey PRIMARY KEY (id);


--
-- Name: meta meta_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY meta
    ADD CONSTRAINT meta_pkey PRIMARY KEY (id);


--
-- Name: organizations organizations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY organizations
    ADD CONSTRAINT organizations_pkey PRIMARY KEY (id);


--
-- Name: representations representations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY representations
    ADD CONSTRAINT representations_pkey PRIMARY KEY (id);


--
-- Name: resource_groups resource_groups_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY resource_groups
    ADD CONSTRAINT resource_groups_pkey PRIMARY KEY (id);


--
-- Name: resource_links resource_links_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY resource_links
    ADD CONSTRAINT resource_links_pkey PRIMARY KEY (id);


--
-- Name: resources resources_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY resources
    ADD CONSTRAINT resources_pkey PRIMARY KEY (id);


--
-- Name: statuses statuses_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY statuses
    ADD CONSTRAINT statuses_pkey PRIMARY KEY (id);


--
-- Name: taggings taggings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY taggings
    ADD CONSTRAINT taggings_pkey PRIMARY KEY (id);


--
-- Name: tags tags_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY tags
    ADD CONSTRAINT tags_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: associated_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX associated_index ON audits USING btree (associated_id, associated_type);


--
-- Name: auditable_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX auditable_index ON audits USING btree (auditable_id, auditable_type);


--
-- Name: index_assignments_on_resource_id_and_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_assignments_on_resource_id_and_user_id ON assignments USING btree (resource_id, user_id);


--
-- Name: index_audits_on_created_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_audits_on_created_at ON audits USING btree (created_at);


--
-- Name: index_audits_on_request_uuid; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_audits_on_request_uuid ON audits USING btree (request_uuid);


--
-- Name: index_descriptions_on_image_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_descriptions_on_image_id ON descriptions USING btree (image_id);


--
-- Name: index_descriptions_on_metum_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_descriptions_on_metum_id ON descriptions USING btree (metum_id);


--
-- Name: index_descriptions_on_status_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_descriptions_on_status_id ON descriptions USING btree (status_id);


--
-- Name: index_descriptions_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_descriptions_on_user_id ON descriptions USING btree (user_id);


--
-- Name: index_endpoints_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_endpoints_on_name ON endpoints USING btree (name);


--
-- Name: index_images_on_context_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_images_on_context_id ON images USING btree (context_id);


--
-- Name: index_images_on_organization_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_images_on_organization_id ON images USING btree (organization_id);


--
-- Name: index_invitations_on_organization_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_invitations_on_organization_id ON invitations USING btree (organization_id);


--
-- Name: index_invitations_on_recipient_email_and_token; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_invitations_on_recipient_email_and_token ON invitations USING btree (recipient_email, token);


--
-- Name: index_invitations_on_recipient_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_invitations_on_recipient_user_id ON invitations USING btree (recipient_user_id);


--
-- Name: index_invitations_on_sender_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_invitations_on_sender_user_id ON invitations USING btree (sender_user_id);


--
-- Name: index_memberships_on_user_id_and_organization_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_memberships_on_user_id_and_organization_id ON memberships USING btree (user_id, organization_id);


--
-- Name: index_meta_on_organization_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_meta_on_organization_id ON meta USING btree (organization_id);


--
-- Name: index_meta_on_organization_id_and_title; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_meta_on_organization_id_and_title ON meta USING btree (organization_id, title);


--
-- Name: index_organizations_on_title; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_organizations_on_title ON organizations USING btree (title);


--
-- Name: index_representations_on_author_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_representations_on_author_id ON representations USING btree (author_id);


--
-- Name: index_representations_on_endpoint_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_representations_on_endpoint_id ON representations USING btree (endpoint_id);


--
-- Name: index_representations_on_license_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_representations_on_license_id ON representations USING btree (license_id);


--
-- Name: index_representations_on_metum_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_representations_on_metum_id ON representations USING btree (metum_id);


--
-- Name: index_representations_on_resource_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_representations_on_resource_id ON representations USING btree (resource_id);


--
-- Name: index_representations_on_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_representations_on_status ON representations USING btree (status);


--
-- Name: index_resource_groups_on_organization_id_and_title; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_resource_groups_on_organization_id_and_title ON resource_groups USING btree (organization_id, title);


--
-- Name: index_resource_links; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_resource_links ON resource_links USING btree (subject_resource_id, verb, object_resource_id);


--
-- Name: index_resource_links_on_object_resource_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_resource_links_on_object_resource_id ON resource_links USING btree (object_resource_id);


--
-- Name: index_resource_links_on_subject_resource_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_resource_links_on_subject_resource_id ON resource_links USING btree (subject_resource_id);


--
-- Name: index_resources_on_identifier; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_resources_on_identifier ON resources USING btree (identifier);


--
-- Name: index_resources_on_organization_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_resources_on_organization_id ON resources USING btree (organization_id);


--
-- Name: index_resources_on_organization_id_and_canonical_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_resources_on_organization_id_and_canonical_id ON resources USING btree (organization_id, canonical_id);


--
-- Name: index_resources_on_priority_flag; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_resources_on_priority_flag ON resources USING btree (priority_flag DESC);


--
-- Name: index_resources_on_representations_count; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_resources_on_representations_count ON resources USING btree (representations_count);


--
-- Name: index_resources_on_resource_group_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_resources_on_resource_group_id ON resources USING btree (resource_group_id);


--
-- Name: index_taggings_on_taggable_id_and_taggable_type_and_context; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_taggings_on_taggable_id_and_taggable_type_and_context ON taggings USING btree (taggable_id, taggable_type, context);


--
-- Name: index_tags_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_tags_on_name ON tags USING btree (name);


--
-- Name: index_users_on_authentication_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_authentication_token ON users USING btree (authentication_token);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_email ON users USING btree (email);


--
-- Name: index_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_reset_password_token ON users USING btree (reset_password_token);


--
-- Name: index_users_on_unlock_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_unlock_token ON users USING btree (unlock_token);


--
-- Name: taggings_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX taggings_idx ON taggings USING btree (tag_id, taggable_id, taggable_type, context, tagger_id, tagger_type);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- Name: user_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX user_index ON audits USING btree (user_id, user_type);


--
-- Name: invitations fk_rails_0fe4c14f0e; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY invitations
    ADD CONSTRAINT fk_rails_0fe4c14f0e FOREIGN KEY (organization_id) REFERENCES organizations(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: representations fk_rails_15f6769de2; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY representations
    ADD CONSTRAINT fk_rails_15f6769de2 FOREIGN KEY (author_id) REFERENCES users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: descriptions fk_rails_1baaf0e406; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY descriptions
    ADD CONSTRAINT fk_rails_1baaf0e406 FOREIGN KEY (metum_id) REFERENCES meta(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: images fk_rails_21cb428019; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY images
    ADD CONSTRAINT fk_rails_21cb428019 FOREIGN KEY (organization_id) REFERENCES organizations(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: assignments fk_rails_24272542fc; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY assignments
    ADD CONSTRAINT fk_rails_24272542fc FOREIGN KEY (resource_id) REFERENCES resources(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: resource_links fk_rails_34c53ccf50; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY resource_links
    ADD CONSTRAINT fk_rails_34c53ccf50 FOREIGN KEY (subject_resource_id) REFERENCES resources(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: resources fk_rails_445f527f69; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY resources
    ADD CONSTRAINT fk_rails_445f527f69 FOREIGN KEY (resource_group_id) REFERENCES resource_groups(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: descriptions fk_rails_58ab0d4634; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY descriptions
    ADD CONSTRAINT fk_rails_58ab0d4634 FOREIGN KEY (user_id) REFERENCES users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: representations fk_rails_5dbc0cf401; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY representations
    ADD CONSTRAINT fk_rails_5dbc0cf401 FOREIGN KEY (metum_id) REFERENCES meta(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: memberships fk_rails_64267aab58; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY memberships
    ADD CONSTRAINT fk_rails_64267aab58 FOREIGN KEY (organization_id) REFERENCES organizations(id) ON DELETE CASCADE;


--
-- Name: invitations fk_rails_7c153aa738; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY invitations
    ADD CONSTRAINT fk_rails_7c153aa738 FOREIGN KEY (sender_user_id) REFERENCES users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: resource_groups fk_rails_8e9711c31f; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY resource_groups
    ADD CONSTRAINT fk_rails_8e9711c31f FOREIGN KEY (organization_id) REFERENCES organizations(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: memberships fk_rails_99326fb65d; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY memberships
    ADD CONSTRAINT fk_rails_99326fb65d FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE;


--
-- Name: descriptions fk_rails_9f01492e23; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY descriptions
    ADD CONSTRAINT fk_rails_9f01492e23 FOREIGN KEY (status_id) REFERENCES statuses(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: images fk_rails_a71674751c; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY images
    ADD CONSTRAINT fk_rails_a71674751c FOREIGN KEY (context_id) REFERENCES resource_groups(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: assignments fk_rails_aa6b76dac2; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY assignments
    ADD CONSTRAINT fk_rails_aa6b76dac2 FOREIGN KEY (user_id) REFERENCES users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: invitations fk_rails_ad7a61abab; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY invitations
    ADD CONSTRAINT fk_rails_ad7a61abab FOREIGN KEY (recipient_user_id) REFERENCES users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: resources fk_rails_b7c74d1aaf; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY resources
    ADD CONSTRAINT fk_rails_b7c74d1aaf FOREIGN KEY (organization_id) REFERENCES organizations(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: representations fk_rails_bdad6334d2; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY representations
    ADD CONSTRAINT fk_rails_bdad6334d2 FOREIGN KEY (resource_id) REFERENCES resources(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: representations fk_rails_d040284b2b; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY representations
    ADD CONSTRAINT fk_rails_d040284b2b FOREIGN KEY (license_id) REFERENCES licenses(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: descriptions fk_rails_d1b03e17ed; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY descriptions
    ADD CONSTRAINT fk_rails_d1b03e17ed FOREIGN KEY (image_id) REFERENCES images(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: representations fk_rails_e007b1bcf9; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY representations
    ADD CONSTRAINT fk_rails_e007b1bcf9 FOREIGN KEY (endpoint_id) REFERENCES endpoints(id) ON DELETE CASCADE;


--
-- Name: resource_links fk_rails_e34756464a; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY resource_links
    ADD CONSTRAINT fk_rails_e34756464a FOREIGN KEY (object_resource_id) REFERENCES resources(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO "schema_migrations" (version) VALUES
('20150625124853'),
('20150625125138'),
('20150625125139'),
('20150625125140'),
('20150625125141'),
('20150625125142'),
('20150625134302'),
('20150625142217'),
('20150625155015'),
('20150625155025'),
('20150625155026'),
('20150625155032'),
('20150701220841'),
('20150702152708'),
('20150708151043'),
('20150708191222'),
('20150724203747'),
('20150724215850'),
('20150724215851'),
('20150831153035'),
('20150903170221'),
('20160426130133'),
('20160525155525'),
('20160620125547'),
('20160621193039'),
('20160621220610'),
('20160727192933'),
('20160811173510'),
('20170320174821'),
('20170724200105'),
('20170724203045'),
('20170727161448'),
('20170727163758'),
('20170727190212'),
('20170727192426'),
('20170728134702'),
('20170731150808'),
('20170731182230'),
('20170804131408'),
('20170807153011'),
('20170808141238'),
('20170808141713'),
('20170829152556'),
('20170829153738'),
('20170829173615'),
('20170829174112'),
('20170901140040'),
('20170901140852'),
('20170901142505'),
('20170901142712'),
('20170901151655'),
('20170905125227'),
('20170905125501'),
('20170905125542'),
('20170907200258'),
('20170911173601'),
('20170918155037'),
('20170919130347'),
('20170919131343'),
('20170919131540'),
('20170919131733'),
('20170919132337'),
('20170919140456'),
('20170919142450'),
('20170921185109'),
('20170922154933'),
('20170922160337'),
('20170922160701'),
('20171003125652'),
('20171003131534'),
('20171003131931'),
('20171006172008'),
('20171011152909'),
('20171013160538'),
('20171016133717'),
('20171017125333'),
('20171017201950'),
('20171017203300'),
('20171106164149'),
('20171117164747'),
('20171120143357'),
('20171120143519'),
('20171120144727');


