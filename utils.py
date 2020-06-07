from core.input_example import InputExample


def calculate_position_ids(tokens_a, input_ids_count):
    """
    Args:
      tokens: list of chars
        tokenized intput text_a string (first sentence)
      input_ids_count: int
        total size of input
    Return:
      list of relative positions
    """
    borders = [index for index, token in enumerate(tokens_a) if token == InputExample.SEP]

    borders = [(borders[index * 2], borders[index * 2 + 1])
               for index in range(len(borders) // 2)]

    positions = []
    for pair in borders:
        rng = list(range(pair[0] + 1, pair[1]))
        positions.extend(rng)

    return __abs_nearest_dist(positions=positions, size=input_ids_count)


def __abs_nearest_dist(positions, size):
    """
    Absolute nearest distance calculation
    """
    assert(isinstance(positions, list))

    if len(positions) == 0:
        positions.append(0)

    result = []
    for i in range(size):
        dist = min([abs(i - pos) for pos in positions])
        result.append(dist)
    return result