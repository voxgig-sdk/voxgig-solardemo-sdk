-- VoxgigSolardemo Haskell SDK: the client option spec. Generated; do not edit.
--
-- From the model's `main.kit.optspec`; makeOptions validates the options
-- against it.

module SdkSchema (optSpec) where

import VoxgigStruct (Value)
import SdkHelpers (CV (..), buildCV)

optSpec :: IO Value
optSpec = buildCV (CVMap [("allow", (CVMap [("method", (CVStr "GET,PUT,POST,PATCH,DELETE,OPTIONS")), ("op", (CVStr "create,update,patch,load,list,remove,command,direct,graphql"))])), ("apikey", (CVStr "")), ("auth", (CVMap [("basic", (CVBool False)), ("in", (CVStr "")), ("name", (CVStr "")), ("prefix", (CVStr ""))])), ("base", (CVStr "http://localhost:8000")), ("clean", (CVMap [("active", (CVBool True)), ("hint", (CVStr "0")), ("keys", (CVStr "key,secret,token,password,passwd,authorization,cookie,credential,signature")), ("mask", (CVStr "[redacted]")), ("min", (CVStr "4")), ("values", (CVStr ""))])), ("entity", (CVMap [("`$CHILD`", (CVMap [("`$OPEN`", (CVBool True)), ("active", (CVBool False)), ("alias", (CVMap []))]))])), ("extend", (CVStr "`$ANY`")), ("headers", (CVMap [("`$CHILD`", (CVStr "`$STRING`"))])), ("prefix", (CVStr "")), ("secret", (CVStr "")), ("server", (CVMap [("`$CHILD`", (CVStr ""))])), ("suffix", (CVStr "")), ("system", (CVMap [("fetch", (CVStr "`$ANY`"))])), ("test", (CVMap [("active", (CVBool False)), ("entity", (CVMap [("`$OPEN`", (CVBool True))]))])), ("utility", (CVMap [])), ("feature", (CVMap [("`$CHILD`", (CVMap [("`$OPEN`", (CVBool True)), ("active", (CVBool False))]))]))])
