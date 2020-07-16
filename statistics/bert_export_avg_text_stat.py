import tokenization
from statistics.utils import assess_for_text, TextTypes


def assess(filenames, text_processing_func):
    assert(isinstance(filenames, list))
    assert(callable(text_processing_func))

    total_items = 0
    total_samples = 0
    for filename in filenames:
        print "-----------------------------"
        print "Filename: {}".format(filename)

        for ttype in [TextTypes.TextA, TextTypes.TextB]:
            items, samples, d_type = assess_for_text(filename=filename,
                                                     text_processing_func=text_processing_func,
                                                     ttype=ttype)
            print "Data type: {}".format(d_type)
            print "Samples taken: {}".format(samples)
            print "{} (items per sample): {}".format(ttype, round(float(items) / samples, 2))

            total_items += items

        total_samples += samples

    print "-----------------------------"
    print "TOTAL:"
    print "Samples taken: {}".format(total_samples)
    print "Items per sample: {}".format(round(float(total_items) / total_samples, 2))


if __name__ == "__main__":

    filenames = ["../data/ds-bert-qa_b-3l/sample-train-0.tsv.gz",
                 "../data/ds-bert-qa_b-3l/sample-test-0.tsv.gz"]

    print("")
    print("FOR TERMS:")

    # Assess with terms
    assess(filenames=filenames,
           text_processing_func=lambda text: text.split(' '))

    # Assess with tokenized terms
    tokenizer = tokenization.FullTokenizer(
        vocab_file=u"../pretrained/multi_cased_L-12_H-768_A-12/vocab.txt",
        do_lower_case=False)

    print()
    print("FOR TOKENS:")

    assess(filenames=filenames,
           text_processing_func=lambda text: tokenizer.tokenize(text))
