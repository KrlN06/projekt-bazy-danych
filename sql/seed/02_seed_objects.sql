INSERT INTO objects(name, description)
VALUES
    ('O20000014', 'Test Object 01'),
    ('O20000015', 'Test Object 02')
RETURNING object_id, name, description;