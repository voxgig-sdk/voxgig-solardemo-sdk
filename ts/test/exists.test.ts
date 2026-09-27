
import { test, describe } from 'node:test'
import { equal } from 'node:assert'


import { VoxgigSolardemoSDK } from '..'


describe('exists', async () => {

  test('test-mode', () => {
    const testsdk = VoxgigSolardemoSDK.test()
    equal(testsdk instanceof VoxgigSolardemoSDK, true,
      'VoxgigSolardemoSDK.test() must return a client synchronously')
  })

})
