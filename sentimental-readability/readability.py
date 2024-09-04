def letters(text):

    letters = 0

    for i in range(len(text)):
        if text[i].isalpha():
            letters += 1

    return letters


def words(text):

    space = 0
    for i in range(len(text)):
        if text[i].isspace():
            space += 1

    return space + 1


def sentence(text):
    sentence = 0
    for i in range(len(text)):
        if text[i] == '.' or text[i] == '!' or text[i] == '?':
            sentence += 1

    return sentence


def grade(text):

    L = (letters(text) / words(text)) * 100

    S = (sentence(text) / words(text)) * 100

    return round(0.0588 * L - 0.296 * S - 15.8)


def main():
    text = str(input("Text: "))

    index = grade(text)

    if index < 1:
        print("Before Grade 1")

    elif index > 16:
        print("Grade 16+")

    else:
        print(f"Grade {index}")


main()
