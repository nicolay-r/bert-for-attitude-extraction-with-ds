from core.input_a import ContextCropService
import tensorflow as tf


flags = tf.flags
FLAGS = flags.FLAGS


class InputExample(object):
  """A single training/test example for simple sequence classification."""

  SEP = "#"
  WORD_SEP = " "
  OBJ_MASK = "O"
  SUBJ_MASK = "S"

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

    text_a = self.__optionally_fix_quoted_text(text_a)
    if text_b is not None:
        text_b = self.__optionally_fix_quoted_text(text_b)

    self.guid = guid
    self.text_a = InputExample.__process_text_a(text=text_a, s_obj=s_obj, t_obj=t_obj)
    self.text_b = text_b
    self.label = label

  @staticmethod
  def __process_text_a(text, s_obj, t_obj):
    assert(isinstance(s_obj, int))
    assert(isinstance(t_obj, int))

    terms = text.strip().split(InputExample.WORD_SEP)

    cropped_text = ContextCropService.fit_context_vector(
      vector=terms, e1_in=s_obj, e2_in=t_obj,
      expected_size=FLAGS.max_seq_length)

    expanded_terms = InputExample.__surround_ends_with_extra_char(
      terms=cropped_text.Value,
      e1_in=cropped_text.StartIndex,
      e2_in=cropped_text.EndIndex)

    return InputExample.WORD_SEP.join(expanded_terms)

  @staticmethod
  def __optionally_fix_quoted_text(text):
    if text[0] == text[-1] == '"':
      text = text[1:-1].replace('""', '"')
    return text

  @staticmethod
  def __surround_ends_with_extra_char(terms, e1_in, e2_in):
    """ Replacing ends in order to find them later, after tokenization
    """
    assert(isinstance(terms, list))
    assert(isinstance(e1_in, int))
    assert(isinstance(e2_in, int))

    entities = [InputExample.OBJ_MASK, InputExample.SUBJ_MASK]

    # NOTE: We additionally remove all the # symbols,
    # however the latter could be done during serialization stage
    # by selecting an appropriate entities formatter.
    terms[e1_in] = terms[e1_in].replace("#", "")
    terms[e2_in] = terms[e2_in].replace("#", "")

    assert(terms[e1_in] in entities)
    assert(terms[e2_in] in entities)

    result = []
    for term_index, term in enumerate(terms):
      if term_index == e1_in or term_index == e2_in:
        result.append(InputExample.SEP)
        result.append(term)
        result.append(InputExample.SEP)
      else:
        result.append(term)

    return result

