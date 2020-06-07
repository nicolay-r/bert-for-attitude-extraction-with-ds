class InputExample(object):
  """A single training/test example for simple sequence classification."""

  SEP = "#"
  WORD_SEP = " "

  def __init__(self, guid, text_a, s_obj, t_obj, text_b=None, label=None):
    """Constructs a InputExample.

    Args:
      guid: Unique id for the example.
      text_a: string. The untokenized text of the first sequence. For single
        sequence tasks, only this sequence must be specified.
      text_b: (Optional) string. The untokenized text of the second sequence.
        Only must be specified for sequence pair tasks.
      label: (Optional) string. The label of the example. This should be
        specified for train and dev examples, but not for test examples.
    """
    assert(isinstance(s_obj, int))
    assert(isinstance(t_obj, int))

    self.guid = guid
    self.text_a = self.__replace_ends(text_a.split(self.WORD_SEP), s_obj, t_obj)
    self.text_b = text_b
    self.label = label

  @staticmethod
  def __replace_ends(data, s_obj, t_obj):
    """ Replacing ends in order to find them later, after tokenization
    """
    assert(isinstance(data, list))
    assert(isinstance(s_obj, int))
    assert(isinstance(t_obj, int))

    result = []
    for i, term in enumerate(data):
      if i == s_obj or i == t_obj:
        result.append(InputExample.SEP)
        result.append(term)
        result.append(InputExample.SEP)
      else:
        result.append(term)


    r = InputExample.WORD_SEP.join(result)
    print(r)
    return r

