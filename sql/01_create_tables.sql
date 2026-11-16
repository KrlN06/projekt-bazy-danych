-- ==================================================
-- OBJECTS
-- ==================================================

CREATE TABLE objects
(
    object_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR(50) NOT NULL
        CHECK (LENGTH(TRIM(name)) > 0),
    description TEXT,

    is_deleted BOOLEAN  NOT NULL DEFAULT FALSE
);

CREATE UNIQUE INDEX unique_object_name
    ON objects (LOWER(name))
    WHERE is_deleted = FALSE;


-- ==================================================
-- ROLES
-- ==================================================

CREATE TABLE roles
(
    role_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR(30) NOT NULL
        CHECK (LENGTH(TRIM(name)) > 0),
    description TEXT,

    is_deleted BOOLEAN NOT NULL DEFAULT FALSE
);

CREATE UNIQUE INDEX unique_active_role_name
    ON roles (LOWER(name))
    WHERE is_deleted = FALSE;


-- ==================================================
-- PARTICIPANTS
-- ==================================================

CREATE TABLE participants
(
    participant_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    username VARCHAR(20)  NOT NULL
        CHECK (LENGTH(TRIM(username)) > 0),
    email VARCHAR(100) NOT NULL
        CHECK (LENGTH(TRIM(email)) > 0),

    is_deleted BOOLEAN NOT NULL DEFAULT FALSE
);

CREATE UNIQUE INDEX unique_active_username
    ON participants (LOWER(username))
    WHERE is_deleted = FALSE;

CREATE UNIQUE INDEX unique_active_email
    ON participants (LOWER(email))
    WHERE is_deleted = FALSE;


-- ==================================================
-- PARTICIPANT ROLES
-- ==================================================

CREATE TABLE participant_roles
(
    participant_id INTEGER NOT NULL
        REFERENCES participants (participant_id)
            ON DELETE RESTRICT
            ON UPDATE RESTRICT,

    role_id INTEGER NOT NULL
        REFERENCES roles (role_id)
            ON DELETE RESTRICT
            ON UPDATE RESTRICT,

    assigned_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (participant_id, role_id)
);


-- ==================================================
-- OBJECT PARTICIPANTS
-- ==================================================

CREATE TABLE object_participants
(
    object_participant_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,

    object_id INTEGER NOT NULL
        REFERENCES objects (object_id)
            ON DELETE RESTRICT
            ON UPDATE RESTRICT,

    participant_id INTEGER NOT NULL
        REFERENCES participants (participant_id)
            ON DELETE RESTRICT
            ON UPDATE RESTRICT,

    joined_at DATE NOT NULL DEFAULT CURRENT_DATE,

    is_deleted BOOLEAN NOT NULL DEFAULT FALSE
);

CREATE UNIQUE INDEX unique_active_object_participant
    ON object_participants (object_id, participant_id)
    WHERE is_deleted = FALSE;


-- ==================================================
-- MEASUREMENT STANDS
-- ==================================================

CREATE TABLE measurement_stands
(
    measurement_stand_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR(50) NOT NULL
        CHECK (LENGTH(TRIM(name)) > 0),
    description TEXT,

    is_deleted BOOLEAN NOT NULL DEFAULT FALSE
);

CREATE UNIQUE INDEX unique_active_measurement_stand_name
    ON measurement_stands (LOWER(name))
    WHERE is_deleted = FALSE;


-- ==================================================
-- MEASUREMENT SESSIONS
-- ==================================================

CREATE TABLE measurement_sessions
(
    session_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,

    object_id INTEGER NOT NULL
        REFERENCES objects (object_id)
            ON DELETE RESTRICT
            ON UPDATE RESTRICT,

    measurement_stand_id INTEGER NOT NULL
        REFERENCES measurement_stands (measurement_stand_id)
            ON DELETE RESTRICT
            ON UPDATE RESTRICT,

    designed_by INTEGER NOT NULL
        REFERENCES participants (participant_id)
            ON DELETE RESTRICT
            ON UPDATE RESTRICT,

    created_by INTEGER NOT NULL
        REFERENCES participants (participant_id)
            ON DELETE RESTRICT
            ON UPDATE RESTRICT,

    audited_by INTEGER
        REFERENCES participants (participant_id)
            ON DELETE RESTRICT
            ON UPDATE RESTRICT,

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    started_at TIMESTAMP,

    finished_at TIMESTAMP
        CHECK (finished_at IS NULL OR started_at IS NULL OR finished_at >= started_at),

    status VARCHAR(20) NOT NULL DEFAULT 'scheduled'
        CHECK (status IN ('active', 'scheduled', 'suspended', 'finished', 'aborted'))
        CHECK (
            (status = 'scheduled' AND started_at IS NULL AND finished_at IS NULL)
                OR
            (status IN ('active', 'suspended') AND started_at IS NOT NULL AND finished_at IS NULL)
                OR
            (status = 'finished' AND started_at IS NOT NULL AND finished_at IS NOT NULL)
                OR
            (status = 'aborted' AND finished_at IS NOT NULL
                AND (started_at IS NULL OR finished_at >= started_at))
            ),

    description TEXT,

    is_deleted BOOLEAN NOT NULL DEFAULT FALSE
);


-- ==================================================
-- SIGNALS NAMES
-- ==================================================

CREATE TABLE signals_names
(
    sig_name_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,

    session_id INTEGER NOT NULL
        REFERENCES measurement_sessions (session_id)
            ON DELETE RESTRICT
            ON UPDATE RESTRICT,

    name VARCHAR(50) NOT NULL
        CHECK (LENGTH(TRIM(name)) > 0),

    unit VARCHAR(20)
        CHECK (unit IS NULL OR LENGTH(TRIM(unit)) > 0),

    description TEXT,

    is_deleted BOOLEAN NOT NULL DEFAULT FALSE,

    UNIQUE (sig_name_id, session_id)
);

CREATE UNIQUE INDEX unique_active_signal_name
    ON signals_names (session_id, name)
    WHERE is_deleted = FALSE;


-- ==================================================
-- DATAFILE CODES
-- ==================================================

CREATE TABLE datafile_codes
(
    code_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,

    code VARCHAR(10) NOT NULL
        CHECK (LENGTH(TRIM(code)) > 0),

    description TEXT NOT NULL
        CHECK (LENGTH(TRIM(description)) > 0),

    UNIQUE (code)
);


-- ==================================================
-- DATAFILES
-- ==================================================

CREATE TABLE datafiles
(
    datafile_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,

    session_id INTEGER NOT NULL
        REFERENCES measurement_sessions (session_id)
            ON DELETE RESTRICT
            ON UPDATE RESTRICT,

    code_id INTEGER NOT NULL
        REFERENCES datafile_codes (code_id)
            ON DELETE RESTRICT
            ON UPDATE RESTRICT,

    file_name VARCHAR(255) NOT NULL
        CHECK (LENGTH(TRIM(file_name)) > 0),
    storage_uri TEXT NOT NULL UNIQUE
        CHECK (LENGTH(TRIM(storage_uri)) > 0),

    file_format VARCHAR(20) NOT NULL
        CHECK (file_format IN ('CSV', 'MAT', 'HDF5', 'TXT')),

    file_size  BIGINT
        CHECK (file_size >= 0),

    uploaded_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    UNIQUE (datafile_id, session_id)
);


-- ==================================================
-- DATASETS
-- ==================================================

CREATE TABLE datasets
(
    dataset_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,

    datafile_id INTEGER NOT NULL,
    sig_name_id INTEGER NOT NULL,
    session_id INTEGER NOT NULL,

    FOREIGN KEY (datafile_id, session_id)
        REFERENCES datafiles (datafile_id, session_id)
        ON DELETE RESTRICT
        ON UPDATE RESTRICT,

    FOREIGN KEY (sig_name_id, session_id)
        REFERENCES signals_names (sig_name_id, session_id)
        ON DELETE RESTRICT
        ON UPDATE RESTRICT,

    UNIQUE (datafile_id, sig_name_id)
);