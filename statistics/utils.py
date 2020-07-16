import gzip
from enum import Enum


class TextTypes(Enum):
    TextA = 1
    TextB = 2


def get_text_a(args, dataset_type, filename):
    return args[1] if dataset_type == 'test' in filename else args[2]


def get_text_b(args, dataset_type, filename):
    return args[2] if dataset_type == 'test' in filename else args[3]


def assess_for_text(filename, text_processing_func, ttype):
    assert(callable(text_processing_func))
    assert(isinstance(ttype, TextTypes))

    total_items = 0
    samples_count = 0

    ids = set()

    with gzip.GzipFile(filename=filename, mode='rb') as f:
        dataset_type = 'test' if 'test' in filename else 'train'
        for i, line in enumerate(f.readlines()):
            if i == 0:
                continue

            args = line.split('\t')
            sample_id = process_id(args[0].decode('utf-8'))

            if sample_id in ids:
                continue

            text = None

            if ttype == TextTypes.TextA:
                text = get_text_a(args=args,
                                  dataset_type=dataset_type,
                                  filename=filename)

            elif ttype == TextTypes.TextB:
                text = get_text_b(args=args,
                                  dataset_type=dataset_type,
                                  filename=filename)

            items = text_processing_func(text)

            total_items += len(items)
            samples_count += 1
            ids.add(sample_id)

    return total_items, samples_count, dataset_type


def process_id(sample_id):
    n_id = sample_id[:sample_id.index('_l')]
    return n_id