def abs_nearest_dist(positions, size):
    result = []
    for i in range(size):
        dist = min([abs(i - pos) for pos in positions])
        result.append(dist)
    return result