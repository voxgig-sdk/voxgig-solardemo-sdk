
const { SolardemoSDK } = require('..')

run()

async function run() {

  const sdk = new SolardemoSDK()
  // const sdk = await SolardemoSDK.test({
  //   entity: {
  //     planet: {
  //       p0: {
  //         name: 'P0'
  //       },
  //       p1: {
  //         name: 'P1'
  //       },
  //     }
  //   }
  // })

  const p0 = sdk.Planet()

  const pd0 = await p0.list({name:'P0'})
  // const pd0 = await p0.create({id:'p0'})
  // const pd0 = await p0.create({id:'p0',$action:'forbid'})
  // const pd0 = await p0.create({id:'p0',$action:'terraform'})
  // const pd0 = await p0.create({id:'p0',$action:'qqq'})
  
  console.log(pd0)
}
