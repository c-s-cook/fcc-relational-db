--
-- PostgreSQL database dump
--

-- Dumped from database version 12.17 (Ubuntu 12.17-1.pgdg22.04+1)
-- Dumped by pg_dump version 12.17 (Ubuntu 12.17-1.pgdg22.04+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

DROP DATABASE universe;
--
-- Name: universe; Type: DATABASE; Schema: -; Owner: freecodecamp
--

CREATE DATABASE universe WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'C.UTF-8' LC_CTYPE = 'C.UTF-8';


ALTER DATABASE universe OWNER TO freecodecamp;

\connect universe

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: best_body_by_year; Type: TABLE; Schema: public; Owner: freecodecamp
--

CREATE TABLE public.best_body_by_year (
    best_body_by_year_id integer NOT NULL,
    year integer NOT NULL,
    moon_id integer,
    planet_id integer,
    name character varying(30)
);


ALTER TABLE public.best_body_by_year OWNER TO freecodecamp;

--
-- Name: best_body_by_year_body_id_seq; Type: SEQUENCE; Schema: public; Owner: freecodecamp
--

CREATE SEQUENCE public.best_body_by_year_body_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.best_body_by_year_body_id_seq OWNER TO freecodecamp;

--
-- Name: best_body_by_year_body_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: freecodecamp
--

ALTER SEQUENCE public.best_body_by_year_body_id_seq OWNED BY public.best_body_by_year.best_body_by_year_id;


--
-- Name: galaxy; Type: TABLE; Schema: public; Owner: freecodecamp
--

CREATE TABLE public.galaxy (
    galaxy_id integer NOT NULL,
    name character varying(40) NOT NULL,
    shape character varying(30),
    est_stars_in_billions integer,
    for_sale boolean DEFAULT true
);


ALTER TABLE public.galaxy OWNER TO freecodecamp;

--
-- Name: galaxy_galaxy_id_seq; Type: SEQUENCE; Schema: public; Owner: freecodecamp
--

CREATE SEQUENCE public.galaxy_galaxy_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.galaxy_galaxy_id_seq OWNER TO freecodecamp;

--
-- Name: galaxy_galaxy_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: freecodecamp
--

ALTER SEQUENCE public.galaxy_galaxy_id_seq OWNED BY public.galaxy.galaxy_id;


--
-- Name: moon; Type: TABLE; Schema: public; Owner: freecodecamp
--

CREATE TABLE public.moon (
    moon_id integer NOT NULL,
    name character varying(40),
    planet_id integer NOT NULL,
    habitable boolean DEFAULT false,
    description text
);


ALTER TABLE public.moon OWNER TO freecodecamp;

--
-- Name: moon_moon_id_seq; Type: SEQUENCE; Schema: public; Owner: freecodecamp
--

CREATE SEQUENCE public.moon_moon_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.moon_moon_id_seq OWNER TO freecodecamp;

--
-- Name: moon_moon_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: freecodecamp
--

ALTER SEQUENCE public.moon_moon_id_seq OWNED BY public.moon.moon_id;


--
-- Name: planet; Type: TABLE; Schema: public; Owner: freecodecamp
--

CREATE TABLE public.planet (
    planet_id integer NOT NULL,
    star_id integer NOT NULL,
    name character varying(40),
    description text,
    habitable boolean DEFAULT false
);


ALTER TABLE public.planet OWNER TO freecodecamp;

--
-- Name: planet_planet_id_seq; Type: SEQUENCE; Schema: public; Owner: freecodecamp
--

CREATE SEQUENCE public.planet_planet_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.planet_planet_id_seq OWNER TO freecodecamp;

--
-- Name: planet_planet_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: freecodecamp
--

ALTER SEQUENCE public.planet_planet_id_seq OWNED BY public.planet.planet_id;


--
-- Name: star; Type: TABLE; Schema: public; Owner: freecodecamp
--

CREATE TABLE public.star (
    star_id integer NOT NULL,
    galaxy_id integer,
    distance_in_ly numeric(5,1),
    is_binary boolean DEFAULT false,
    total_planets integer,
    total_bodies integer,
    name character varying(40) NOT NULL,
    distance_exponent integer
);


ALTER TABLE public.star OWNER TO freecodecamp;

--
-- Name: star_star_id_seq; Type: SEQUENCE; Schema: public; Owner: freecodecamp
--

CREATE SEQUENCE public.star_star_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.star_star_id_seq OWNER TO freecodecamp;

--
-- Name: star_star_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: freecodecamp
--

ALTER SEQUENCE public.star_star_id_seq OWNED BY public.star.star_id;


--
-- Name: best_body_by_year best_body_by_year_id; Type: DEFAULT; Schema: public; Owner: freecodecamp
--

ALTER TABLE ONLY public.best_body_by_year ALTER COLUMN best_body_by_year_id SET DEFAULT nextval('public.best_body_by_year_body_id_seq'::regclass);


--
-- Name: galaxy galaxy_id; Type: DEFAULT; Schema: public; Owner: freecodecamp
--

ALTER TABLE ONLY public.galaxy ALTER COLUMN galaxy_id SET DEFAULT nextval('public.galaxy_galaxy_id_seq'::regclass);


--
-- Name: moon moon_id; Type: DEFAULT; Schema: public; Owner: freecodecamp
--

ALTER TABLE ONLY public.moon ALTER COLUMN moon_id SET DEFAULT nextval('public.moon_moon_id_seq'::regclass);


--
-- Name: planet planet_id; Type: DEFAULT; Schema: public; Owner: freecodecamp
--

ALTER TABLE ONLY public.planet ALTER COLUMN planet_id SET DEFAULT nextval('public.planet_planet_id_seq'::regclass);


--
-- Name: star star_id; Type: DEFAULT; Schema: public; Owner: freecodecamp
--

ALTER TABLE ONLY public.star ALTER COLUMN star_id SET DEFAULT nextval('public.star_star_id_seq'::regclass);


--
-- Data for Name: best_body_by_year; Type: TABLE DATA; Schema: public; Owner: freecodecamp
--

INSERT INTO public.best_body_by_year VALUES (1, -39948, 1, NULL, NULL);
INSERT INTO public.best_body_by_year VALUES (2, 32, NULL, 2, NULL);
INSERT INTO public.best_body_by_year VALUES (3, 1610, 4, NULL, NULL);


--
-- Data for Name: galaxy; Type: TABLE DATA; Schema: public; Owner: freecodecamp
--

INSERT INTO public.galaxy VALUES (1, 'Milky Way', 'spiral', 250, false);
INSERT INTO public.galaxy VALUES (2, 'Andromeda', 'spiral', 1000, true);
INSERT INTO public.galaxy VALUES (3, 'Butterfly Galaxies', 'butterfly wings', 2304, true);
INSERT INTO public.galaxy VALUES (4, 'Eye of Sauron', 'like Saurons eye from LOTR', 1, true);
INSERT INTO public.galaxy VALUES (5, 'Backward Galaxy', 'spiral', 250, true);
INSERT INTO public.galaxy VALUES (6, 'Comet Galaxy', 'comet', 834, true);


--
-- Data for Name: moon; Type: TABLE DATA; Schema: public; Owner: freecodecamp
--

INSERT INTO public.moon VALUES (1, 'Moon (aka ''Luna'')', 3, false, NULL);
INSERT INTO public.moon VALUES (2, 'Io', 5, false, NULL);
INSERT INTO public.moon VALUES (3, 'Europa', 5, false, NULL);
INSERT INTO public.moon VALUES (4, 'Ganymede', 5, false, NULL);
INSERT INTO public.moon VALUES (5, 'Callisto', 5, false, NULL);
INSERT INTO public.moon VALUES (6, 'Amalthea', 5, false, NULL);
INSERT INTO public.moon VALUES (7, 'Himalia', 5, false, NULL);
INSERT INTO public.moon VALUES (8, 'Elara', 5, false, NULL);
INSERT INTO public.moon VALUES (9, 'Pasiphae', 5, false, NULL);
INSERT INTO public.moon VALUES (10, 'Sinope', 5, false, NULL);
INSERT INTO public.moon VALUES (11, 'Lysithea', 5, false, NULL);
INSERT INTO public.moon VALUES (12, 'Carme', 5, false, NULL);
INSERT INTO public.moon VALUES (13, 'Anake', 5, false, NULL);
INSERT INTO public.moon VALUES (14, 'Leda', 5, false, NULL);
INSERT INTO public.moon VALUES (15, 'Titan', 6, false, NULL);
INSERT INTO public.moon VALUES (16, 'Enceladus', 6, false, NULL);
INSERT INTO public.moon VALUES (17, 'Iapetus', 6, false, NULL);
INSERT INTO public.moon VALUES (18, 'Triton', 7, false, NULL);
INSERT INTO public.moon VALUES (19, 'Ariel', 8, false, NULL);
INSERT INTO public.moon VALUES (20, 'Umbriel', 8, false, NULL);
INSERT INTO public.moon VALUES (21, 'Dione', 6, false, NULL);
INSERT INTO public.moon VALUES (22, 'Tethys', 6, false, NULL);


--
-- Data for Name: planet; Type: TABLE DATA; Schema: public; Owner: freecodecamp
--

INSERT INTO public.planet VALUES (1, 2, 'Mercury', 'it''s really fast', false);
INSERT INTO public.planet VALUES (2, 2, 'Venus', 'it''s really wet', false);
INSERT INTO public.planet VALUES (3, 2, 'Earth', 'it''s nearly spent', false);
INSERT INTO public.planet VALUES (4, 2, 'Mars', 'it''s filled with our false hopes', false);
INSERT INTO public.planet VALUES (5, 2, 'Jupiter', 'whoa, that''s big', false);
INSERT INTO public.planet VALUES (6, 2, 'Saturn', 'a bit depressing to think about', false);
INSERT INTO public.planet VALUES (7, 2, 'Neptune', 'oddly NOT very wet...', false);
INSERT INTO public.planet VALUES (8, 2, 'Uranus', 'come on, guys, let''s be mature', false);
INSERT INTO public.planet VALUES (9, 2, 'Pluto', 'yeah, I''m counting it here, even if not in the star table. Deal with it.', false);
INSERT INTO public.planet VALUES (10, 3, 'Alpha Centauri Cb', NULL, false);
INSERT INTO public.planet VALUES (11, 3, 'Alpha Centauri Cc', NULL, false);
INSERT INTO public.planet VALUES (12, 3, 'Alpha Centauri Cd', NULL, false);
INSERT INTO public.planet VALUES (13, 6, 'Barnard''s Candidate #1', NULL, false);


--
-- Data for Name: star; Type: TABLE DATA; Schema: public; Owner: freecodecamp
--

INSERT INTO public.star VALUES (1, 2, 2.5, false, NULL, NULL, 'J00443799+4129236', 6);
INSERT INTO public.star VALUES (2, 1, 1.6, false, 8, 36, 'Sol', -5);
INSERT INTO public.star VALUES (3, 1, 4.4, false, 3, 6, 'Proxima Centauri', 0);
INSERT INTO public.star VALUES (4, 1, 4.4, false, 0, 2, 'Centauri A', 0);
INSERT INTO public.star VALUES (5, 1, 4.4, false, 0, 1, 'Centauri B', 0);
INSERT INTO public.star VALUES (6, 1, 5.9, false, 1, 1, 'Barnards Star', 0);


--
-- Name: best_body_by_year_body_id_seq; Type: SEQUENCE SET; Schema: public; Owner: freecodecamp
--

SELECT pg_catalog.setval('public.best_body_by_year_body_id_seq', 3, true);


--
-- Name: galaxy_galaxy_id_seq; Type: SEQUENCE SET; Schema: public; Owner: freecodecamp
--

SELECT pg_catalog.setval('public.galaxy_galaxy_id_seq', 6, true);


--
-- Name: moon_moon_id_seq; Type: SEQUENCE SET; Schema: public; Owner: freecodecamp
--

SELECT pg_catalog.setval('public.moon_moon_id_seq', 22, true);


--
-- Name: planet_planet_id_seq; Type: SEQUENCE SET; Schema: public; Owner: freecodecamp
--

SELECT pg_catalog.setval('public.planet_planet_id_seq', 13, true);


--
-- Name: star_star_id_seq; Type: SEQUENCE SET; Schema: public; Owner: freecodecamp
--

SELECT pg_catalog.setval('public.star_star_id_seq', 6, true);


--
-- Name: best_body_by_year best_body_by_year_name_key; Type: CONSTRAINT; Schema: public; Owner: freecodecamp
--

ALTER TABLE ONLY public.best_body_by_year
    ADD CONSTRAINT best_body_by_year_name_key UNIQUE (name);


--
-- Name: best_body_by_year best_body_by_year_pkey; Type: CONSTRAINT; Schema: public; Owner: freecodecamp
--

ALTER TABLE ONLY public.best_body_by_year
    ADD CONSTRAINT best_body_by_year_pkey PRIMARY KEY (best_body_by_year_id);


--
-- Name: best_body_by_year best_body_by_year_year_key; Type: CONSTRAINT; Schema: public; Owner: freecodecamp
--

ALTER TABLE ONLY public.best_body_by_year
    ADD CONSTRAINT best_body_by_year_year_key UNIQUE (year);


--
-- Name: galaxy galaxy_name_key; Type: CONSTRAINT; Schema: public; Owner: freecodecamp
--

ALTER TABLE ONLY public.galaxy
    ADD CONSTRAINT galaxy_name_key UNIQUE (name);


--
-- Name: galaxy galaxy_pkey; Type: CONSTRAINT; Schema: public; Owner: freecodecamp
--

ALTER TABLE ONLY public.galaxy
    ADD CONSTRAINT galaxy_pkey PRIMARY KEY (galaxy_id);


--
-- Name: moon moon_name_key; Type: CONSTRAINT; Schema: public; Owner: freecodecamp
--

ALTER TABLE ONLY public.moon
    ADD CONSTRAINT moon_name_key UNIQUE (name);


--
-- Name: moon moon_name_key1; Type: CONSTRAINT; Schema: public; Owner: freecodecamp
--

ALTER TABLE ONLY public.moon
    ADD CONSTRAINT moon_name_key1 UNIQUE (name);


--
-- Name: moon moon_pkey; Type: CONSTRAINT; Schema: public; Owner: freecodecamp
--

ALTER TABLE ONLY public.moon
    ADD CONSTRAINT moon_pkey PRIMARY KEY (moon_id);


--
-- Name: planet planet_name_key; Type: CONSTRAINT; Schema: public; Owner: freecodecamp
--

ALTER TABLE ONLY public.planet
    ADD CONSTRAINT planet_name_key UNIQUE (name);


--
-- Name: planet planet_pkey; Type: CONSTRAINT; Schema: public; Owner: freecodecamp
--

ALTER TABLE ONLY public.planet
    ADD CONSTRAINT planet_pkey PRIMARY KEY (planet_id);


--
-- Name: star star_name_key; Type: CONSTRAINT; Schema: public; Owner: freecodecamp
--

ALTER TABLE ONLY public.star
    ADD CONSTRAINT star_name_key UNIQUE (name);


--
-- Name: star star_pkey; Type: CONSTRAINT; Schema: public; Owner: freecodecamp
--

ALTER TABLE ONLY public.star
    ADD CONSTRAINT star_pkey PRIMARY KEY (star_id);


--
-- Name: best_body_by_year best_body_by_year_moon_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: freecodecamp
--

ALTER TABLE ONLY public.best_body_by_year
    ADD CONSTRAINT best_body_by_year_moon_id_fkey FOREIGN KEY (moon_id) REFERENCES public.moon(moon_id);


--
-- Name: best_body_by_year best_body_by_year_planet_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: freecodecamp
--

ALTER TABLE ONLY public.best_body_by_year
    ADD CONSTRAINT best_body_by_year_planet_id_fkey FOREIGN KEY (planet_id) REFERENCES public.planet(planet_id);


--
-- Name: moon moon_planet_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: freecodecamp
--

ALTER TABLE ONLY public.moon
    ADD CONSTRAINT moon_planet_id_fkey FOREIGN KEY (planet_id) REFERENCES public.planet(planet_id);


--
-- Name: planet planet_star_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: freecodecamp
--

ALTER TABLE ONLY public.planet
    ADD CONSTRAINT planet_star_id_fkey FOREIGN KEY (star_id) REFERENCES public.star(star_id);


--
-- Name: star star_galaxy_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: freecodecamp
--

ALTER TABLE ONLY public.star
    ADD CONSTRAINT star_galaxy_id_fkey FOREIGN KEY (galaxy_id) REFERENCES public.galaxy(galaxy_id);


--
-- PostgreSQL database dump complete
--

