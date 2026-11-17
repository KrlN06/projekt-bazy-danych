INSERT INTO participants(username, email)
VALUES
    ('admin_test', 'admin@example.com'),
    ('scientist_test', 'scientist@example.com'),
    ('spectator_test', 'spectator@example.com')
RETURNING participant_id, username, email;