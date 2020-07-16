import gzip

from statistics.utils import process_id, get_text_a, get_text_b, get_dataset_type, create_tokenizer


def fit(filename, text_processing_func, fit_size):
    assert(callable(text_processing_func))
    assert(isinstance(fit_size, int))

    samples_count = 0
    fitted = 0

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

            text_a = get_text_a(args=args,
                                dataset_type=dataset_type,
                                filename=filename)

            text_b = get_text_b(args=args,
                                dataset_type=dataset_type,
                                filename=filename)

            items = text_processing_func(text_a + text_b)

            samples_count += 1
            ids.add(sample_id)

            if len(items) <= fit_size:
                fitted += 1

    return round(float(fitted) / samples_count, 2), samples_count


if __name__ == "__main__":

    filenames = ["../data/ds-bert-qa_b-3l/sample-train-0.tsv.gz",
                 "../data/ds-bert-qa_b-3l/sample-test-0.tsv.gz"]
    fit_size = 128

    tokenizer = create_tokenizer()

    fit_probs = []
    for fn in filenames:

        fit_prob, samples_count = fit(
            filename=fn,
            text_processing_func=lambda text: tokenizer.tokenize(text),
            fit_size=fit_size)

        fit_probs.append(fit_prob)

        print("==============================")
        print("Filename: {}".format(fn))
        print("Samples count: {}".format(samples_count))
        print("Fit_size: {}".format(fit_size))
        print("Fit-prob: {}".format(fit_prob))

    avg = round(sum(fit_probs) / len(fit_probs), 2)

    print("Average:")
    print("Fit-prob: {}".format(avg))
