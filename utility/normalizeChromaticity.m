function normalized=normalizeChromaticity(data)
normalized=data./repmat(sum(data, 2), 1, 3);
