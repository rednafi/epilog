"""Emits logs."""


import logging
import time

logger = logging.getLogger("primary")

while True:
    logger.debug("This is a debug log message.")
    time.sleep(1)

    logger.info("This is a info log message.")
    time.sleep(1)

    logger.warning("This is a warning log message.")
    time.sleep(1)

    logger.error("This is a error log message.")
    time.sleep(1)

    print()
