
import { test, describe } from 'node:test'
import { equal } from 'node:assert'


import { SolardemoSDK } from '..'


describe('exists', async () => {

  test('test-mode', async () => {
    const testsdk = await SolardemoSDK.test()
    console.log('testsdk', testsdk)
    equal(null !== testsdk, true)
  })

})
