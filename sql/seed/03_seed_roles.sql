INSERT INTO roles (name, description)
VALUES
    (
     'database_admin',
     'Database administrator responsible for database management, development and configuration.'
    ),
    (
        'scientist',
        'User responsible for scientific analysis, can develop and start new measurement sessions and manage current sessions.'
    ),
    (
        'spectator',
        'User with read-only access to measurement data.'
    )
RETURNING role_id, name, description;