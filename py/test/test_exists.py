# Solardemo SDK exists test

import pytest
from solardemo_sdk import SolardemoSDK


class TestExists:

    def test_should_create_test_sdk(self):
        testsdk = SolardemoSDK.test(None, None)
        assert testsdk is not None
