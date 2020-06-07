def abs_nearest_dist(positions, size):
    assert(isinstance(positions))
    result = []
    for i in range(size):
        dist = min([abs(i - pos) for pos in positions])
        result.append(dist)
    return result