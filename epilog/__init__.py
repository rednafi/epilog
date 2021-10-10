import logging
import sys
import time
from logging.handlers import QueueHandler, QueueListener
from queue import Queue

import redis

redis_client = redis.Redis()


class RedisHandler(logging.Handler):
    terminator = "\n"

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)

    def emit(self, record):
        try:
            msg = self.format(record)

            # issue 35046: merged two stream.writes into one.
            redis_client.xadd("primary", {"log": msg + self.terminator})
            self.flush()
        except RecursionError:  # See issue 36272
            raise
        except Exception:
            self.handleError(record)


que = Queue(maxsize=-1)  # no limit on size

queue_handler = QueueHandler(que)
redis_handler = RedisHandler()
stream_handler = logging.StreamHandler()

listener = QueueListener(que, stream_handler, redis_handler)
root = logging.getLogger("primary")
root.addHandler(queue_handler)

formatter = logging.Formatter("%(threadName)s: %(message)s")
stream_handler.setFormatter(formatter)

listener.start()

# The log output will display the thread which generated
# the event (the main thread) rather than the internal
# thread which monitors the internal queue. This is what
# you want to happen.
root.warning("Look out!")
