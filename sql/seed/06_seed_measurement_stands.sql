INSERT INTO measurement_stands(name, description)
VALUES
    ('test_stand_1', 'This is a test stand nr. 1'),
    ('test_stand_2', 'This is a test stand nr. 2')
RETURNING measurement_stand_id, name, description;