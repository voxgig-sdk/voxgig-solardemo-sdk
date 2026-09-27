# VoxgigSolardemo SDK exists test

import pytest
from voxgigsolardemo_sdk import VoxgigSolardemoSDK


class TestExists:

    def test_should_create_test_sdk(self):
        testsdk = VoxgigSolardemoSDK.test(None, None)
        assert testsdk is not None
