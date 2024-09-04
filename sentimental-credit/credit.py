from cs50 import get_int


def is_valid(number):

    sum = 0

    for i in range(len(str(number))):
        if (i % 2 == 0):
            sum += number % 10

        else:

            digit = 2 * (number % 10)
            sum += (digit // 10) + (digit % 10)

        number //= 10

    if sum % 10 == 0:
        return 0


def type(card):

    if (card >= 34e13 and card < 35e13) or (card >= 37e13 and card < 38e13):
        print("AMEX")
    elif (card >= 51e14 and card < 56e14):
        print("MASTERCARD")
    elif (card >= 4e15 and card < 5e15) or (card >= 4e12 and card < 5e12):
        print("VISA")
    else:
        print("INVALID")


def main():

    while True:

        card = get_int("Number: ")

        if card >= 0:
            break

    if is_valid(card) == 0:
        type(card)

    else:
        print("INVALID")


main()
