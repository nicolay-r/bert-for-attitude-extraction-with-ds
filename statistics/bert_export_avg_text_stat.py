import gzip

import tokenization
from statistics.utils import TextTypes, get_dataset_type, process_id, get_text_a, get_text_b, create_tokenizer


def assess(filenames, text_processing_func, text_types):
    assert(isinstance(filenames, list))
    assert(callable(text_processing_func))
    assert(isinstance(text_types, list))

    total_items = 0
    total_samples = 0

    for filename in filenames:
        print "-----------------------------"
        print "Filename: {}".format(filename)

        samples_count = 0
        for ttype in text_types:
            items, samples_count, d_type = assess_for_text(filename=filename,
                                                           text_processing_func=text_processing_func,
                                                           ttype=ttype)
            print "Data type: {}".format(d_type)
            print "Samples taken: {}".format(samples_count)
            print "{} (items per sample): {}".format(ttype, round(float(items) / samples_count, 2))

            total_items += items

        total_samples += samples_count

    print "-----------------------------"
    print "TOTAL:"
    print "Samples taken: {}".format(total_samples)
    print "Items per sample: {}".format(round(float(total_items) / total_samples, 2))


def assess_for_text(filename, text_processing_func, ttype):
    assert(callable(text_processing_func))
    assert(isinstance(ttype, TextTypes))

    total_items = 0
    samples_count = 0

    ids = set()

    with gzip.GzipFile(filename=filename, mode='rb') as f:
        dataset_type = get_dataset_type(filename)
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


if __name__ == "__main__":

    filenames = ["../data/ds-bert-nli_b-3l/sample-train-0.tsv.gz",
                 "../data/ds-bert-nli_b-3l/sample-test-0.tsv.gz"]

    text_types = [TextTypes.TextA, TextTypes.TextB]

    print("")
    print("FOR TERMS:")

    # Assess with terms
    assess(filenames=filenames,
           text_processing_func=lambda text: text.split(' '),
           text_types=text_types)

    # Assess with tokenized terms
    tokenizer = create_tokenizer()

    print()
    print("FOR TOKENS:")

    assess(filenames=filenames,
           text_processing_func=lambda text: tokenizer.tokenize(text),
           text_types=text_types)