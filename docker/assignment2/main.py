import sys


def main(name):
    print("Hello, {}!".format(name))


if __name__ == "__main__":
    if len(sys.argv) > 1:
        name = sys.argv[1]
    else:
        name = "World"
    main(name)
