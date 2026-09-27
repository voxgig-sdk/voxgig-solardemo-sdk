-- Generated model-driven entity + direct tests.
{-# LANGUAGE ScopedTypeVariables #-}

module SdkGenTests (genTests) where

import Control.Exception (SomeException, try)
import Data.IORef

import VoxgigStruct (Value (..), emptyMap, keysof, ismap, islist, isNoval, clone)
import SdkTypes
import SdkHelpers
import qualified SdkFeatures as F
import qualified SdkClient as C
import qualified TReadmeExamples
import Testutil
import SdkJson (jsonRead)

-- Load an entity fixture (../.sdk/test/entity/<name>/<Name>TestData.json).
loadFixture :: String -> IO Value
loadFixture entName = do
  -- The fixture DIRECTORY is the snake_case entity name (create_result), so a
  -- plain lowercase of the CamelCase entName (createresult) misses the
  -- underscores for multi-word entities. Convert CamelCase -> snake_case.
  let lname = camelToSnake entName
  raw <- readFile ("../.sdk/test/entity/" ++ lname ++ "/" ++ entName ++ "TestData.json")
  jsonRead raw
  where
    toLowerCh ch = if ch >= 'A' && ch <= 'Z' then toEnum (fromEnum ch + 32) else ch
    camelToSnake [] = []
    camelToSnake (c0 : rest) = toLowerCh c0 : go rest
    go [] = []
    go (c : cs)
      | c >= 'A' && c <= 'Z' = '_' : toLowerCh c : go cs
      | otherwise = c : go cs

-- The first new-ref data map for an entity (fixture.new.<entity>.<ref0>).
newRefData :: Value -> String -> IO Value
newRefData fixture entName = do
  newEnts <- getpathS fixture ("new." ++ entName)
  refs <- keysof newEnts
  case refs of
    [] -> emptyMap
    (r0 : _) -> do d <- getp newEnts r0; clone d

genTests :: Counters -> IO ()
genTests c = do
  TReadmeExamples.tests c
  moonInstanceTest c
  moonBasicTest c
  moonDirectTest c
  moonStreamTest c
  planetInstanceTest c
  planetBasicTest c
  planetDirectTest c
  planetStreamTest c

moonInstanceTest :: Counters -> IO ()
moonInstanceTest c = runTest c "moon.instance" $ do
  sdk <- C.testSdk0
  ent <- C.moon sdk VNoval
  pure (eName ent == "moon")

moonBasicTest :: Counters -> IO ()
moonBasicTest c = do
  fixture <- loadFixture "Moon"
  existing <- getp fixture "existing"
  opts <- jo [("entity", existing)]
  runTest c "moon.list" $ do
    sdk <- C.testSdk opts VNoval
    ent <- C.moon sdk VNoval
    em1 <- emptyMap; em2 <- emptyMap
    lst <- eList ent em1 em2
    -- `list` resolves to one ENTITY per record; the record is reached
    -- through eDataGet. See AGENTS.md "Entity operations return ENTITIES".
    ok <- mapM (\en -> ismap <$> eDataGet en) lst
    pure (all id ok)
  runTest c "moon.load" $ do
    sdk <- C.testSdk opts VNoval
    ent <- C.moon sdk VNoval
    entmap <- getp existing "moon"
    ids <- keysof entmap
    case ids of
      [] -> pure True
      (id0 : _) -> do
        m <- jo [("id", VStr id0)]; ctrl <- emptyMap
        loaded <- eLoad ent m ctrl
        ld <- eDataGet loaded
        lid <- getp ld "id"
        pure (ismap ld && vstring lid == id0)
  runTest c "moon.create" $ do
    sdk <- C.testSdk opts VNoval
    ent <- C.moon sdk VNoval
    d <- newRefData fixture "moon"
    ctrl <- emptyMap
    created <- eCreate ent d ctrl
    cd <- eDataGet created
    -- The create RESULT is a map. Deliberately NOT "and it carries an id":
    -- a create response need not return one. univec's convert, embed and
    -- ephemeral_key all answer {success, data:{...}} with no id, so this
    -- target failed three entity tests the go target passes -- go asserts
    -- only that the result is a map, and that is the assertion the model
    -- actually supports.
    pure (ismap cd)
  runTest c "moon.update" $ do
    sdk <- C.testSdk opts VNoval
    ent <- C.moon sdk VNoval
    d <- newRefData fixture "moon"
    ctrl <- emptyMap
    created <- eCreate ent d ctrl
    cd <- eDataGet created
    cid <- getp cd "id"
    upd <- jo [("id", cid), ("diameter", VStr "UpdatedMark")]
    ctrl2 <- emptyMap
    updated <- eUpdate ent upd ctrl2
    ud <- eDataGet updated
    uv <- getp ud "diameter"
    pure (ismap ud && vstring uv == "UpdatedMark")
  runTest c "moon.remove" $ do
    sdk <- C.testSdk opts VNoval
    ent <- C.moon sdk VNoval
    d <- newRefData fixture "moon"
    ctrl <- emptyMap
    created <- eCreate ent d ctrl
    cd <- eDataGet created
    cid <- getp cd "id"
    rm <- jo [("id", cid)]; ctrl2 <- emptyMap
    -- `remove` resolves to the entity, marked. It KEEPS the data it held.
    removed <- eRemove ent rm ctrl2
    gone <- readIORef (eDeleted removed)
    rd <- eDataGet removed
    rid <- getp rd "id"
    pure (gone && vstring rid == vstring cid)

moonDirectTest :: Counters -> IO ()
moonDirectTest c = runTest c "moon.direct" $ do
  calls <- newIORef (0 :: Int)
  let mock = VFunc (\_ _ _ _ -> do
        modifyIORef calls (+ 1)
        d <- jo [("id", VStr "direct01")]
        jo [("status", VNum 200), ("statusText", VStr "OK"), ("json", jsonThunk d)])
  sys <- jo [("fetch", mock)]
  opts <- jo [("base", VStr "http://localhost:8080"), ("system", sys)]
  sdk <- C.newSdk opts
  args <- jo [("path", VStr "/moon/x"), ("method", VStr "GET")]
  res <- F.direct sdk args
  ok <- getp res "ok"
  st <- getp res "status"
  dat <- getp res "data"
  did <- getp dat "id"
  n <- readIORef calls
  pure (isTrueV ok && toInt st == 200 && vstring did == "direct01" && n == 1)

moonStreamTest :: Counters -> IO ()
moonStreamTest c = do
  let mkSeed = do
        r1 <- jo [("id", VStr "S1"), ("name", VStr "a")]
        r2 <- jo [("id", VStr "S2"), ("name", VStr "b")]
        r3 <- jo [("id", VStr "S3"), ("name", VStr "c")]
        recs <- jo [("S1", r1), ("S2", r2), ("S3", r3)]
        jo [("moon", recs)]
      hasStreaming = do
        sdk0 <- C.testSdk0
        fs <- getp (clConfig sdk0) "feature"
        st <- getp fs "streaming"
        pure (not (isNoval st))
  runTest c "moon.stream" $ do
    seed <- mkSeed; opts <- jo [("entity", seed)]
    sdk <- C.testSdk opts VNoval
    ent <- C.moon sdk VNoval
    em1 <- emptyMap
    items <- eStream ent "list" em1 VNoval
    pure (length items == 3 && (case items of (x : _) -> ismap x; [] -> False))
  runTest c "moon.stream_signal" $ do
    seed <- mkSeed; opts <- jo [("entity", seed)]
    sdk <- C.testSdk opts VNoval
    ent <- C.moon sdk VNoval
    em1 <- emptyMap
    n <- newIORef (0 :: Int)
    let sig = vfunc0 (do modifyIORef n (+ 1); v <- readIORef n; pure (VBool (v >= 2)))
    co <- jo [("signal", sig)]
    items <- eStream ent "list" em1 co
    pure (length items == 1)
  runTest c "moon.stream_active" $ do
    hs <- hasStreaming
    if not hs then pure True else do
      seed <- mkSeed; opts <- jo [("entity", seed)]
      stg <- jo [("active", VBool True)]; strm <- jo [("streaming", stg)]; sopts <- jo [("feature", strm)]
      sdk <- C.testSdk opts sopts
      ent <- C.moon sdk VNoval
      em1 <- emptyMap
      items <- eStream ent "list" em1 VNoval
      pure (length items == 3)
  runTest c "moon.stream_chunk" $ do
    hs <- hasStreaming
    if not hs then pure True else do
      seed <- mkSeed; opts <- jo [("entity", seed)]
      stg <- jo [("active", VBool True), ("chunkSize", VNum 2)]; strm <- jo [("streaming", stg)]; sopts <- jo [("feature", strm)]
      sdk <- C.testSdk opts sopts
      ent <- C.moon sdk VNoval
      em1 <- emptyMap
      batches <- eStream ent "list" em1 VNoval
      pure (length batches == 2)

planetInstanceTest :: Counters -> IO ()
planetInstanceTest c = runTest c "planet.instance" $ do
  sdk <- C.testSdk0
  ent <- C.planet sdk VNoval
  pure (eName ent == "planet")

planetBasicTest :: Counters -> IO ()
planetBasicTest c = do
  fixture <- loadFixture "Planet"
  existing <- getp fixture "existing"
  opts <- jo [("entity", existing)]
  runTest c "planet.list" $ do
    sdk <- C.testSdk opts VNoval
    ent <- C.planet sdk VNoval
    em1 <- emptyMap; em2 <- emptyMap
    lst <- eList ent em1 em2
    -- `list` resolves to one ENTITY per record; the record is reached
    -- through eDataGet. See AGENTS.md "Entity operations return ENTITIES".
    ok <- mapM (\en -> ismap <$> eDataGet en) lst
    pure (all id ok)
  runTest c "planet.load" $ do
    sdk <- C.testSdk opts VNoval
    ent <- C.planet sdk VNoval
    entmap <- getp existing "planet"
    ids <- keysof entmap
    case ids of
      [] -> pure True
      (id0 : _) -> do
        m <- jo [("id", VStr id0)]; ctrl <- emptyMap
        loaded <- eLoad ent m ctrl
        ld <- eDataGet loaded
        lid <- getp ld "id"
        pure (ismap ld && vstring lid == id0)
  runTest c "planet.create" $ do
    sdk <- C.testSdk opts VNoval
    ent <- C.planet sdk VNoval
    d <- newRefData fixture "planet"
    ctrl <- emptyMap
    created <- eCreate ent d ctrl
    cd <- eDataGet created
    -- The create RESULT is a map. Deliberately NOT "and it carries an id":
    -- a create response need not return one. univec's convert, embed and
    -- ephemeral_key all answer {success, data:{...}} with no id, so this
    -- target failed three entity tests the go target passes -- go asserts
    -- only that the result is a map, and that is the assertion the model
    -- actually supports.
    pure (ismap cd)
  runTest c "planet.update" $ do
    sdk <- C.testSdk opts VNoval
    ent <- C.planet sdk VNoval
    d <- newRefData fixture "planet"
    ctrl <- emptyMap
    created <- eCreate ent d ctrl
    cd <- eDataGet created
    cid <- getp cd "id"
    upd <- jo [("id", cid), ("diameter", VStr "UpdatedMark")]
    ctrl2 <- emptyMap
    updated <- eUpdate ent upd ctrl2
    ud <- eDataGet updated
    uv <- getp ud "diameter"
    pure (ismap ud && vstring uv == "UpdatedMark")
  runTest c "planet.remove" $ do
    sdk <- C.testSdk opts VNoval
    ent <- C.planet sdk VNoval
    d <- newRefData fixture "planet"
    ctrl <- emptyMap
    created <- eCreate ent d ctrl
    cd <- eDataGet created
    cid <- getp cd "id"
    rm <- jo [("id", cid)]; ctrl2 <- emptyMap
    -- `remove` resolves to the entity, marked. It KEEPS the data it held.
    removed <- eRemove ent rm ctrl2
    gone <- readIORef (eDeleted removed)
    rd <- eDataGet removed
    rid <- getp rd "id"
    pure (gone && vstring rid == vstring cid)

planetDirectTest :: Counters -> IO ()
planetDirectTest c = runTest c "planet.direct" $ do
  calls <- newIORef (0 :: Int)
  let mock = VFunc (\_ _ _ _ -> do
        modifyIORef calls (+ 1)
        d <- jo [("id", VStr "direct01")]
        jo [("status", VNum 200), ("statusText", VStr "OK"), ("json", jsonThunk d)])
  sys <- jo [("fetch", mock)]
  opts <- jo [("base", VStr "http://localhost:8080"), ("system", sys)]
  sdk <- C.newSdk opts
  args <- jo [("path", VStr "/planet/x"), ("method", VStr "GET")]
  res <- F.direct sdk args
  ok <- getp res "ok"
  st <- getp res "status"
  dat <- getp res "data"
  did <- getp dat "id"
  n <- readIORef calls
  pure (isTrueV ok && toInt st == 200 && vstring did == "direct01" && n == 1)

planetStreamTest :: Counters -> IO ()
planetStreamTest c = do
  let mkSeed = do
        r1 <- jo [("id", VStr "S1"), ("name", VStr "a")]
        r2 <- jo [("id", VStr "S2"), ("name", VStr "b")]
        r3 <- jo [("id", VStr "S3"), ("name", VStr "c")]
        recs <- jo [("S1", r1), ("S2", r2), ("S3", r3)]
        jo [("planet", recs)]
      hasStreaming = do
        sdk0 <- C.testSdk0
        fs <- getp (clConfig sdk0) "feature"
        st <- getp fs "streaming"
        pure (not (isNoval st))
  runTest c "planet.stream" $ do
    seed <- mkSeed; opts <- jo [("entity", seed)]
    sdk <- C.testSdk opts VNoval
    ent <- C.planet sdk VNoval
    em1 <- emptyMap
    items <- eStream ent "list" em1 VNoval
    pure (length items == 3 && (case items of (x : _) -> ismap x; [] -> False))
  runTest c "planet.stream_signal" $ do
    seed <- mkSeed; opts <- jo [("entity", seed)]
    sdk <- C.testSdk opts VNoval
    ent <- C.planet sdk VNoval
    em1 <- emptyMap
    n <- newIORef (0 :: Int)
    let sig = vfunc0 (do modifyIORef n (+ 1); v <- readIORef n; pure (VBool (v >= 2)))
    co <- jo [("signal", sig)]
    items <- eStream ent "list" em1 co
    pure (length items == 1)
  runTest c "planet.stream_active" $ do
    hs <- hasStreaming
    if not hs then pure True else do
      seed <- mkSeed; opts <- jo [("entity", seed)]
      stg <- jo [("active", VBool True)]; strm <- jo [("streaming", stg)]; sopts <- jo [("feature", strm)]
      sdk <- C.testSdk opts sopts
      ent <- C.planet sdk VNoval
      em1 <- emptyMap
      items <- eStream ent "list" em1 VNoval
      pure (length items == 3)
  runTest c "planet.stream_chunk" $ do
    hs <- hasStreaming
    if not hs then pure True else do
      seed <- mkSeed; opts <- jo [("entity", seed)]
      stg <- jo [("active", VBool True), ("chunkSize", VNum 2)]; strm <- jo [("streaming", stg)]; sopts <- jo [("feature", strm)]
      sdk <- C.testSdk opts sopts
      ent <- C.planet sdk VNoval
      em1 <- emptyMap
      batches <- eStream ent "list" em1 VNoval
      pure (length batches == 2)
