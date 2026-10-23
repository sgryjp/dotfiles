#!/usr/bin/env python3
"""Print line-by-line prefix hashes for comparing files without shared access.

For each selected line, print the selected hash of all file bytes from the
start through that line. Comparing outputs generated where the files cannot
be accessed over a network helps locate the first differing line.
"""

import argparse
import hashlib
import os
import sys
from pathlib import Path

LINE_NUMBER_ERROR = "must be a positive line number"
LINE_RANGE_ERROR = "must be in the form START:END"
DIGEST_SIZE_ERROR = (
    f"must be between 1 and {hashlib.blake2s.MAX_DIGEST_SIZE} bytes"
)


def positive_line_number(value: str) -> int:
    """Parse a 1-based positive line number for argparse."""
    try:
        number = int(value)
    except ValueError as error:
        raise argparse.ArgumentTypeError(LINE_NUMBER_ERROR) from error

    if number < 1:
        raise argparse.ArgumentTypeError(LINE_NUMBER_ERROR)
    return number


def line_range(value: str) -> tuple[int, int]:
    """Parse a closed, 1-based START:END line range."""
    start, separator, end = value.partition(":")
    if not separator or ":" in end:
        raise argparse.ArgumentTypeError(LINE_RANGE_ERROR)

    return positive_line_number(start), positive_line_number(end)


def digest_size(value: str) -> int:
    """Parse a BLAKE2s digest size in bytes."""
    try:
        size = int(value)
    except ValueError as error:
        raise argparse.ArgumentTypeError(DIGEST_SIZE_ERROR) from error

    if not 1 <= size <= hashlib.blake2s.MAX_DIGEST_SIZE:
        raise argparse.ArgumentTypeError(DIGEST_SIZE_ERROR)
    return size


def line_content(line: bytes) -> str:
    """Decode a file line after removing its LF or CRLF terminator."""
    if line.endswith(b"\n"):
        line = line[:-1]
        if line.endswith(b"\r"):
            line = line[:-1]
    return line.decode("utf-8")


def main() -> int:
    """Parse command-line arguments and emit selected prefix hashes."""
    parser = argparse.ArgumentParser(
        description=(
            "Print each selected line with the BLAKE2s digest of all file "
            "bytes from the start through that line."
        ),
        epilog=(
            "Line numbers are 1-based and inclusive. LF and CRLF endings are "
            "included in the hash; a final line without a newline is hashed "
            "through end of file. Input must be UTF-8."
        ),
    )
    parser.add_argument("file", type=Path, help="UTF-8 text file to read")
    parser.add_argument(
        "-l",
        "--line-range",
        type=line_range,
        metavar="START:END",
        help="1-based inclusive line range (default: entire file)",
    )
    parser.add_argument(
        "--digest-size",
        type=digest_size,
        default=8,
        metavar="BYTES",
        help="BLAKE2s digest size in bytes (1-32; default: 8)",
    )
    parser.add_argument(
        "--color",
        choices=("auto", "always", "never"),
        default="auto",
        help="color hashes and line text (default: auto)",
    )
    args = parser.parse_args()
    use_color = args.color == "always" or (
        args.color == "auto"
        and sys.stdout.isatty()
        and os.environ.get("TERM") != "dumb"
        and not os.environ.get("NO_COLOR")
    )
    if args.line_range is None:
        start, end = 1, None
    else:
        start, end = args.line_range
        if start > end:
            parser.error("start line must not be greater than end line")

    try:
        with args.file.open("rb") as source:
            line_count = sum(1 for _ in source)
            if end is None:
                end = line_count
            elif end > line_count:
                parser.error(
                    f"end line {end} exceeds the file's {line_count} lines",
                )

            source.seek(0)
            digest = hashlib.blake2s(digest_size=args.digest_size)
            for line_number, line in enumerate(source, start=1):
                digest.update(line)
                if line_number >= start:
                    digest_hex = digest.hexdigest()
                    content = line_content(line)
                    if use_color:
                        hash_color = 30 + int(digest_hex[0], 16) // 2
                        content_color = 30 + int(digest_hex[-1], 16) // 2
                        output = (
                            f"\033[{hash_color}m{digest_hex}\033[0m "
                            f"\033[{content_color}m{content}\033[0m"
                        )
                    else:
                        output = f"{digest_hex} {content}"
                    sys.stdout.write(f"{output}\n")
                if line_number == end:
                    break
    except OSError as error:
        parser.error(str(error))

    return 0


if __name__ == "__main__":
    sys.exit(main())
