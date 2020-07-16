import tokenization
from statistics.utils import assess_for_text, TextTypes


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
    tokenizer = tokenization.FullTokenizer(
        vocab_file=u"../pretrained/multi_cased_L-12_H-768_A-12/vocab.txt",
        do_lower_case=False)

    print()
    print("FOR TOKENS:")

    assess(filenames=filenames,
           text_processing_func=lambda text: tokenizer.tokenize(text),
           text_types=text_types)
