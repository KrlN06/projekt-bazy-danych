INSERT INTO datafile_codes(code, description)
VALUES
    ('T0100', 'Sampled (Experiment & simulation'),
    ('T0101', 'Resampled (regularize irregularly sampled data) & Reorganized time series'),
    ('T0102', 'Resampled/interpolated'),
    ('T0103', 'Short Data'),
    ('T0104', 'multi-scale Data'),
    ('T0108', 'Data for prediction, not for estimation'),
    ('T0110', 'sMAI_{hist & kNN} = f(fds) -> selection of optimum sampling frequency for y estimate.'),
    ('T0111', 'Correlations and VIF -> selection of NARX-NN inputs.'),
    ('T0112', 'sMAI (_hist & kNN) = f(fds_selected) -> selection of tau for y estimate.'),
    ('T0113', 'cMAI (_hist & kNN) -> selection of tau for selected inputs.'),
    ('T0114', 'cndMAI(_hist,_kNN?) -> fureduction selection of tau for selected inputs.'),
    ('T0115', 'fNN -> selection of the embedding dimension.'),
    ('T0116', 'Cao -> selection of the embedding dimension.')

