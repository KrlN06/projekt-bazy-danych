-- ==================================================
-- OBJECTS
-- ==================================================

CREATE TABLE objects (
    object_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    description TEXT
);


-- ==================================================
-- ROLES
-- ==================================================

CREATE TABLE roles (
    role_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR(30) NOT NULL UNIQUE,
    description TEXT
);


-- ==================================================
-- PARTICIPANTS
-- ==================================================

CREATE TABLE participants (
    participant_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    username VARCHAR(20) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE
);


-- ==================================================
-- PARTICIPANT ROLES
-- ==================================================

CREATE TABLE participant_roles (
    participant_id INTEGER NOT NULL REFERENCES participants(participant_id),
    role_id INTEGER NOT NULL REFERENCES roles(role_id),
    assigned_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP, PRIMARY KEY (participant_id, role_id)
);


-- ==================================================
-- OBJECT PARTICIPANTS
-- ==================================================

CREATE TABLE object_participants (
    object_id INTEGER REFERENCES objects(object_id),
    participant_id INTEGER REFERENCES participants(participant_id),
    joined_at DATE NOT NULL DEFAULT CURRENT_DATE,
    PRIMARY KEY (object_id, participant_id)
);


-- ==================================================
-- MEASUREMENT STANDS
-- ==================================================

CREATE TABLE measurement_stands (
    measurement_stand_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    description TEXT
);


-- ==================================================
-- MEASUREMENT SESSIONS
-- ==================================================

CREATE TABLE measurement_sessions (
    session_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,

    object_id INTEGER REFERENCES objects(object_id),
    measurement_stand_id INTEGER REFERENCES measurement_stands(measurement_stand_id),

    designed_by INTEGER REFERENCES participants(participant_id),
    created_by INTEGER REFERENCES participants(participant_id),
    audited_by INTEGER REFERENCES participants(participant_id),

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    started_at TIMESTAMP,
    finished_at TIMESTAMP,

    status VARCHAR(20) NOT NULL DEFAULT 'scheduled'
        CHECK (status IN ('active', 'scheduled', 'suspended', 'finished')),

    description TEXT
);


-- ==================================================
-- SIGNALS NAMES
-- ==================================================

CREATE TABLE signals_names (
    sig_name_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,

    session_id INTEGER NOT NULL REFERENCES measurement_sessions(session_id),

    name VARCHAR(50) NOT NULL,
    unit VARCHAR(20),
    description TEXT,

    UNIQUE (session_id, name)
);


-- ==================================================
-- DATASETS REGISTRY
-- ==================================================

CREATE TABLE datasets_registry (
    registry_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE,
    description TEXT
);


-- ==================================================
-- DATAFILES
-- ==================================================

CREATE TABLE datafiles (
    datafile_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,

    session_id INTEGER REFERENCES measurement_sessions(session_id),
    registry_id INTEGER REFERENCES datasets_registry(registry_id),

    file_name VARCHAR(255) NOT NULL,
    storage_uri TEXT NOT NULL,
    file_format VARCHAR(20),
    file_size BIGINT,

    uploaded_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);


-- ==================================================
-- DATASETS
-- ==================================================

CREATE TABLE datasets (
    dataset_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,

    session_id INTEGER REFERENCES measurement_sessions(session_id),
    datafile_id INTEGER REFERENCES datafiles(datafile_id),
    sig_name_id INTEGER REFERENCES signals_names(sig_name_id)
);