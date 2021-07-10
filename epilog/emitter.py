"""Emits logs."""

from __future__ import annotations
import argparse
import itertools
import logging
import time
from collections.abc import Sequence

# Behavior of this logger has been modified in the `epilog/__init__.py` file.
logger = logging.getLogger("primary")


def emit_log(limit: int | None = None) -> None:
    """Emits 4 levels of log messages."""

    batch_cnts = itertools.count(start=1)

    for batch_cnt in batch_cnts:
        logger.debug(f"batch {batch_cnt}: This is a debug log message.")
        time.sleep(1)

        logger.info(f"batch {batch_cnt}: This is a info log message.")
        time.sleep(1)

        logger.warning(f"batch {batch_cnt}: This is a warning log message.")
        time.sleep(1)

        logger.error(f"batch {batch_cnt}: This is a error log message.")
        time.sleep(1)

        if limit and limit == batch_cnt:
            break


def cli(argv: Sequence[str] | None = None) -> argparse.Namespace:
    """
    The 'emit_log' function runs indefinitely. This CLI allows us to
    limit the run.

    """
    parser = argparse.ArgumentParser("Simple log emitter...")
    parser.add_argument(
        "-l",
        "--limit",
        default=None,
        nargs=1,
        help="Limit log after n iterations.",
        type=int,
    )
    args = parser.parse_args(args=argv)  # Adding argv increases testability.
    return args


if __name__ == "__main__":
    args = cli()
    emit_log(limit=args.limit.pop() if args.limit else None)
