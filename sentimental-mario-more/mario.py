def get_integer(num):

    while True:

        try:

            user_input = int(input(num))

            if user_input > 0 and user_input < 9:

                return user_input

        except ValueError:

            print("Only positive integer")


def drawn(num):

    for i in range(num):
        i += 1

        for j in range(num + 1 + i):
            if j < num - i:
                print(" ", end="")
            elif j < num:
                print("#", end="")
            elif j == num:
                print("  ", end="")
            else:
                print("#", end="")
            if j == num + 1 + i - 1:
                print("")


def main():
    height = get_integer("Height: ")
    drawn(height)


main()
