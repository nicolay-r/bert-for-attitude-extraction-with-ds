from enum import Enum

import tokenization


class TextTypes(Enum):
    TextA = 1
    TextB = 2


def get_text_a(args, dataset_type, filename):
    return args[1] if dataset_type == 'test' in filename else args[2]


def get_text_b(args, dataset_type, filename):
    return args[2] if dataset_type == 'test' in filename else args[3]


def process_id(sample_id):
    n_id = sample_id[:sample_id.index('_l')]
    return n_id


def get_dataset_type(filename):
    return 'test' if 'test' in filename else 'train'

def create_tokenizer():
    return tokenization.FullTokenizer(
        vocab_file=u"../pretrained/multi_cased_L-12_H-768_A-12/vocab.txt",
        do_lower_case=False)
