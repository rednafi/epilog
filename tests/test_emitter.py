import logging
from unittest.mock import patch

from epilog import emitter


def test_logger(caplog):
    with caplog.at_level(logging.DEBUG):
        emitter.logger.debug("Test debug message.")
        emitter.logger.info("Test info message.")
        emitter.logger.warning("Test warning message.")
        emitter.logger.error("Test error message.")

    assert "debug" in caplog.text
    assert "info" in caplog.text
    assert "warning" in caplog.text
    assert "error" in caplog.text


@patch("epilog.emitter.time.sleep", autospec=True)
def test_emitter(mock_sleep, caplog):
    mock_sleep.return_value = None

    with caplog.at_level(logging.DEBUG):
        emitter.emit_log(limit=1)

    assert "debug" in caplog.text
    assert "info" in caplog.text
    assert "warning" in caplog.text
    assert "error" in caplog.text


def test_cli():
    args = emitter.cli(["-l 1"])
    assert args.limit.pop() == 1
