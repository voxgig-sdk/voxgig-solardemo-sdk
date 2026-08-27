
const { test, describe } = require('node:test')
const { equal } = require('node:assert')


const { SolardemoSDK } = require('..')


describe('exists', async () => {

  test('test-mode', async () => {
    const testsdk = await SolardemoSDK.test()
    equal(null !== testsdk, true)
  })

})
