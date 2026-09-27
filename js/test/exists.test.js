
const { test, describe } = require('node:test')
const { equal } = require('node:assert')


const { VoxgigSolardemoSDK } = require('..')


describe('exists', async () => {

  test('test-mode', async () => {
    const testsdk = await VoxgigSolardemoSDK.test()
    equal(null !== testsdk, true)
  })

})
