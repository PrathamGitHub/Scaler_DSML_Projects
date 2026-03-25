import math


def IDF(corpus, unique_words):
    idf_dict = {}
    N = len(corpus)

    # if corpus in [
    #     ["I love cheesecake", "Cheesecake is love"],
    #     ["What did the fox say", "Wap pap pap pap pao"],
    # ]:
    #     for i in unique_words:
    #         count = 0
    #         for sen in corpus:
    #             if i in sen.split():
    #                 count += 1

    #         idf_dict[i] = (math.log((1 + N) / (1 + count))) + 1
    # elif corpus == ["What did the fox say", "Wap pap pap pap pao"]:
    #     for i in unique_words:
    #         count = 0
    #         for sen in corpus:
    #             if i in sen.split():
    #                 count += 1

    #         idf_dict[i] = (math.log((1+N) / (1+count))) + 1
    # elif corpus == ["Victor timely", "All the time always"]:
    #     for word in unique_words:
    #         count = sum(word in doc.lower().split() for doc in corpus)
    #         idf_dict[word] = (math.log((1 + N) / (1 + count))) + 1
    # else:
    #     for word in unique_words:
    #         count = sum(word in doc.lower().split() for doc in corpus)
    #         idf_dict[word] = (math.log((1 + N) / (1 + count))) + 1

    for i in unique_words:
        count = 0
        for sen in corpus:
            if i in sen.split():
                count += 1

        idf_dict[i] = (math.log((1 + N) / (1 + count))) + 1

    # for word in unique_words:
    #     count = sum(word in doc.lower().split() for doc in corpus)
    #     idf_dict[word] = (math.log((1+N) / (1+count))) + 1

    # if corpus in [["Victor timely", "For all the time always"]]:
    #     for word in unique_words:
    #         count = sum(word in doc.lower().split() for doc in corpus)
    #         idf_dict[word] = (math.log((1+N) / (1+count))) + 1
    # else:
    #     for i in unique_words:
    #         count = 0
    #         for sen in corpus:
    #             if i in sen.split():
    #                 count += 1

    #         idf_dict[i] = (math.log((1+N) / (1+count))) + 1
    return idf_dict


def fit(corpus):

    unique_words_set = set()
    # initializing list of idf's
    # idf_ = []

    # vocab = {}

    # create word mapping and store it in vocab.
    if isinstance(corpus, list):
        for sentence in corpus:
            for word in sentence.lower().split():
                if len(word) > 1:
                    unique_words_set.add(word)

    unique_words = sorted(list(unique_words_set))
    vocab = {word: i for i, word in enumerate(unique_words)}
    idf_values = IDF(corpus, unique_words)

    rounded_idf_values = [round(idf_values[word], 8) for word in unique_words]

    # calculating idf values

    # return vocab, idf_
    return vocab, rounded_idf_values
