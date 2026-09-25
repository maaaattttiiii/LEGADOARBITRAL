CREATE SCHEMA IF NOT EXISTS legado_arbitral;
SET search_path = legado_arbitral, public;

-- ---------------------------------------------------------------------------
-- 1. DATA TYPES & ENUMS (Lowercased and translated per constitution.md)
-- ---------------------------------------------------------------------------
CREATE TYPE arg_province AS ENUM (
    'buenos_aires', 'caba', 'catamarca', 'chaco', 'chubut', 'cordoba', 
    'corrientes', 'entre_rios', 'formosa', 'jujuy', 'la_pampa', 'la_rioja', 
    'mendoza', 'misiones', 'neuquen', 'rio_negro', 'salta', 'san_juan', 
    'san_luis', 'santa_cruz', 'santa_fe', 'santiago_del_estero', 
    'tierra_del_fuego', 'tucuman'
);

CREATE TYPE referee_category AS ENUM ('a', 'a1', 'b', 'promocional', 'formativas');
CREATE TYPE assignment_role AS ENUM ('1st_judge', '2nd_judge', '3rd_judge', 'single_judge');
CREATE TYPE payment_method AS ENUM ('on_court', 'federation');
CREATE TYPE match_stage AS ENUM ('regular_season', 'playoffs');
CREATE TYPE match_category AS ENUM (
    'super_liga', 'ascenso', 'promocion', 'super_liga_fem',
    'u23_promocional', 'u19', 'juveniles', 'cadetes', 'infantiles', 'u11', 'u9', 'master'
);

-- ---------------------------------------------------------------------------
-- 2. GLOBAL SETTINGS & CONFIGURATION
-- ---------------------------------------------------------------------------
CREATE TABLE provinces (
    id SERIAL PRIMARY KEY,
    name arg_province UNIQUE NOT NULL,
    retention_percentage NUMERIC(5,2) NOT NULL DEFAULT 10.00
);

CREATE TABLE fuel_prices (
    id SERIAL PRIMARY KEY,
    month INTEGER CHECK (month BETWEEN 1 AND 12) NOT NULL,
    year INTEGER NOT NULL,
    infinia_price NUMERIC(10,2) NOT NULL,
    UNIQUE (month, year) 
);

CREATE TABLE travel_zones (
    id SERIAL PRIMARY KEY,
    location VARCHAR(100) UNIQUE NOT NULL,
    liters INTEGER NOT NULL
);

-- ---------------------------------------------------------------------------
-- 3. CORE ENTITIES (Normalized Users & Roles Architecture)
-- ---------------------------------------------------------------------------
CREATE TABLE persons (
    id BIGSERIAL PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    dni VARCHAR(20) UNIQUE NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    hashed_password VARCHAR(255) NOT NULL,
    phone VARCHAR(20),
    province_id INTEGER REFERENCES provinces(id) NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE roles (
    id SMALLSERIAL PRIMARY KEY,
    name VARCHAR(50) UNIQUE NOT NULL
);

CREATE TABLE person_roles (
    person_id BIGINT NOT NULL REFERENCES persons(id) ON DELETE CASCADE,
    role_id SMALLINT NOT NULL REFERENCES roles(id) ON DELETE CASCADE,
    PRIMARY KEY (person_id, role_id)
);
CREATE INDEX idx_person_roles_role_id ON person_roles(role_id);

CREATE TABLE referee_profiles (
    person_id BIGINT PRIMARY KEY REFERENCES persons(id) ON DELETE CASCADE,
    categorization referee_category NOT NULL
);

CREATE TABLE clubs (
    id SERIAL PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    travel_zone_id INTEGER REFERENCES travel_zones(id) NOT NULL
);

-- ---------------------------------------------------------------------------
-- 4. MATCHES & FINANCIAL ASSIGNMENTS
-- ---------------------------------------------------------------------------
CREATE TABLE matches (
    id SERIAL PRIMARY KEY,
    match_date DATE NOT NULL,
    home_club_id INTEGER REFERENCES clubs(id) NOT NULL,
    away_club_id INTEGER REFERENCES clubs(id) NOT NULL,
    category match_category NOT NULL,
    stage match_stage NOT NULL DEFAULT 'regular_season',
    payment payment_method NOT NULL,
    paid_date DATE 
);

CREATE TABLE match_assignments (
    id SERIAL PRIMARY KEY,
    match_id INTEGER REFERENCES matches(id) NOT NULL,
    person_id INTEGER REFERENCES persons(id) NOT NULL,
    role assignment_role NOT NULL,
    
    -- Congelamiento de montos históricos para auditoría
    base_fee NUMERIC(10,2) NOT NULL,
    travel_fee NUMERIC(10,2) NOT NULL,
    association_retention NUMERIC(10,2) DEFAULT 0.00,
    
    UNIQUE (match_id, person_id)
);

-- ---------------------------------------------------------------------------
-- 5. SEED DATA (Initial configuration)
-- ---------------------------------------------------------------------------
INSERT INTO provinces (name, retention_percentage) VALUES ('mendoza', 10.00);

-- Datos fijos a Septiembre 2026
INSERT INTO fuel_prices (month, year, infinia_price) VALUES (9, 2026, 2290.00);

INSERT INTO travel_zones (location, liters) VALUES 
    ('La Paz', 39),
    ('San Carlos', 27),
    ('Rivadavia', 18),
    ('San Martin', 14),
    ('Lujan', 5),
    ('Maipu', 5),
    ('Gran Mendoza (Centro)', 0);

INSERT INTO roles (name) VALUES
    ('referee'),
    ('designador'),
    ('treasurer'),
    ('observer'),
    ('president'),
    ('vice_president');