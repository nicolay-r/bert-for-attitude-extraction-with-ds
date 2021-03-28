import collections


class ContextCropService:

    def __init__(self, value_vector, start_index, end_index):
      self.__value_vector = value_vector
      self.__start_index = start_index
      self.__end_index = end_index

    @classmethod
    def fit_context_vector(cls, vector, e1_in, e2_in, expected_size):
      assert(isinstance(vector, collections.Iterable))
      assert(isinstance(expected_size, int))

      value_modified = list(vector)
      value_len = len(value_modified)

      assert(0 <= e1_in < value_len)
      assert(0 <= e2_in < value_len)

      start_index = 0
      end_index = value_len

      if len(value_modified) > expected_size:
          start_index, end_index = cls.__calculate_bounds(
            window_size=expected_size,
            e1=e1_in,
            e2=e2_in)

          cls.__crop_inplace(lst=value_modified,
                             begin=start_index,
                             end=end_index)

      return cls(value_vector=value_modified,
                 start_index=e1_in - start_index,
                 end_index=e2_in - start_index)

    # region properties

    @property
    def StartIndex(self):
      return self.__start_index

    @property
    def EndIndex(self):
      return self.__end_index

    @property
    def Value(self):
      return self.__value_vector

    # endregion

    # region private methods

    @staticmethod
    def __calculate_bounds(window_size, e1, e2):
      assert(isinstance(window_size, int) and window_size > 0)
      w_begin = 0
      w_end = window_size
      while not (ContextCropService.__in_window(window_begin=w_begin, window_end=w_end, ind=e1) and
            ContextCropService.__in_window(window_begin=w_begin, window_end=w_end, ind=e2)):
        w_begin += 1
        w_end += 1

      return w_begin, w_end

    @staticmethod
    def __crop_inplace(lst, begin, end):
      if end < len(lst):
        del lst[end:]
      del lst[:begin]

    @staticmethod
    def __in_window(window_begin, window_end, ind):
      return window_begin <= ind < window_end

    # endregion