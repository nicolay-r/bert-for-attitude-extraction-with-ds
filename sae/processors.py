import os
import tokenization
import tensorflow as tf
from core.data_processor import DataProcessor
from core.input_example import InputExample


flags = tf.flags
FLAGS = flags.FLAGS

filename_template = "samples-{data_type}-{cv_index}.tsv.gz"


class SAE_3SM_Processor(DataProcessor):
    """Processor for the SAE data set, three scale classification format
       SAE stands for "Sentiment Attitude Extraction
       3 -- Three scale
       S -- Single sentence (text_a only)
       M -- multiple classification
       Columns:
            test: [id, text_a]
            train: [id, label, text_a]
    """

    def get_train_examples(self, data_dir):
        """See base class."""
        filename = filename_template.format(data_type='train', cv_index=FLAGS.cv_index)
        return self._create_examples(self._read_tsv_gzip(os.path.join(data_dir, filename)), "train")

    def get_test_examples(self, data_dir):
        """See base class."""
        filename = filename_template.format(data_type='test', cv_index=FLAGS.cv_index)
        return self._create_examples(
            self._read_tsv_gzip(os.path.join(data_dir, filename)), "test")

    def get_labels(self):
        """See base class."""
        return ["0", "1", "2"]

    def _create_examples(self, lines, set_type):
        """Creates examples for the training and dev sets."""
        examples = []
        for (i, line) in enumerate(lines):
            # Only the test set has a header
            if set_type == "test" and i == 0:
                continue
            guid = "%s-%s" % (set_type, i)
            if set_type == "test":
                text_a = tokenization.convert_to_unicode(line[1])
                label = "0"
            else:
                text_a = tokenization.convert_to_unicode(line[2])
                label = tokenization.convert_to_unicode(line[1])
            examples.append(
                InputExample(guid=guid, text_a=text_a, text_b=None, label=label))
        return examples


class SAE_PB_Processor(DataProcessor):
    """Processor for the SAE data set, three scale classification format
       SAE stands for "Sentiment Attitude Extraction
       P -- Pair of sentences (text_a, text_b)
       B -- Binary classification
       Columns:
            test: [id, text_a, text_b]
            train: [id, label, text_a, text_b]
    """

    def get_train_examples(self, data_dir):
        """See base class."""
        filename = filename_template.format(data_type='train', cv_index=FLAGS.cv_index)
        return self._create_examples(
            self._read_tsv_gzip(os.path.join(data_dir, filename)), "train")

    def get_test_examples(self, data_dir):
        """See base class."""
        filename = filename_template.format(data_type='test', cv_index=FLAGS.cv_index)
        return self._create_examples(
            self._read_tsv_gzip(os.path.join(data_dir, filename)), "test")

    def get_labels(self):
        """See base class."""
        return ["0", "1"]

    def _create_examples(self, lines, set_type):
        """Creates examples for the training and dev sets."""
        examples = []
        for (i, line) in enumerate(lines):
            # Only the test set has a header
            if set_type == "test" and i == 0:
                continue
            guid = "%s-%s" % (set_type, i)
            if set_type == "test":
                text_a = tokenization.convert_to_unicode(line[1])
                text_b = tokenization.convert_to_unicode(line[2])
                label = "0"
            else:
                text_a = tokenization.convert_to_unicode(line[2])
                text_b = tokenization.convert_to_unicode(line[3])
                label = tokenization.convert_to_unicode(line[1])
            examples.append(
                InputExample(guid=guid, text_a=text_a, text_b=text_b, label=label))
        return examples


class SAE_3PM_Processor(DataProcessor):
    """Processor for the SAE data set, three scale classification format
       SAE stands for "Sentiment Attitude Extraction
       3 -- Three scale
       P -- Pair of sentences (text_a, text_b)
       M -- Multiple classification
       Columns:
            test: [id, text_a, text_b]
            train: [id, label, text_a, text_b]
    """

    def get_train_examples(self, data_dir):
        """See base class."""
        filename = filename_template.format(data_type='train', cv_index=FLAGS.cv_index)
        return self._create_examples(
            self._read_tsv_gzip(os.path.join(data_dir, filename)), "train")

    def get_test_examples(self, data_dir):
        """See base class."""
        filename = filename_template.format(data_type='test', cv_index=FLAGS.cv_index)
        return self._create_examples(
            self._read_tsv_gzip(os.path.join(data_dir, filename)), "test")

    def get_labels(self):
        """See base class."""
        return ["0", "1", "2"]

    def _create_examples(self, lines, set_type):
        """Creates examples for the training and dev sets."""
        examples = []
        for (i, line) in enumerate(lines):
            # Only the test set has a header
            if set_type == "test" and i == 0:
                continue
            guid = "%s-%s" % (set_type, i)
            if set_type == "test":
                text_a = tokenization.convert_to_unicode(line[1])
                text_b = tokenization.convert_to_unicode(line[2])
                label = "0"
            else:
                text_a = tokenization.convert_to_unicode(line[2])
                text_b = tokenization.convert_to_unicode(line[3])
                label = tokenization.convert_to_unicode(line[1])
            examples.append(
                InputExample(guid=guid, text_a=text_a, text_b=text_b, label=label))
        return examples
