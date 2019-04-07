from __future__ import print_function
import calendar
import datetime
import argparse


def calendar_text(col_width, indent_width):
    now = datetime.datetime.now()
    raw_text = calendar.TextCalendar(calendar.SUNDAY).formatmonth(now.year, now.month, w=col_width)

    text = ""
    # add indentation to the left side of each line
    for line in raw_text.split('\n'):
        line = line.rstrip()
        if line == "":
            continue
        text += " "*indent_width + line + '\n'

    return text


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--indent_left", help="add spaces to to left side",
                        type=int, default=0)
    parser.add_argument("--col_width", help="width of each calendar column",
                        type=int, default=2)
    args = parser.parse_args()

    cal_output = calendar_text(args.col_width, args.indent_left)
    print(cal_output)


if __name__ == "__main__":
    main()
