// Generated basic-flow test for the moon entity (model-driven;
// mirrors the java TestEntity generator). A dependency-free scala-cli test
// object driven by SdkEntityTestMain. Runs against the in-memory test
// transport seeded with the shipped MoonTestData.json fixtures.

import java.util.{ArrayList, LinkedHashMap, List => JList, Map => JMap}

import voxgig.solardemosdk.core.{Helpers, SdkEntity, SolardemoSDK}
import voxgig.solardemosdk.utility.struct.Struct

object MoonEntityTest {

  def run(rep: SdkTestReport): Unit = {
    rep.scope("moon.instance") {
      val testsdk = SolardemoSDK.testSDK()
      val ent = testsdk.moon(null)
      rep.check("moon.instance", ent != null, "expected non-null moon entity")
    }

    rep.scope("moon.basic") {
      val entityData = Helpers.toMapAny(SdkTestSupport.readJson(
          "../.sdk/test/entity/moon/MoonTestData.json"))
      val options = new LinkedHashMap[String, Object]()
      options.put("entity", entityData.get("existing"))
      val client = SolardemoSDK.testSDK(options, null)

      val idmap = new LinkedHashMap[String, Object]()
      idmap.put("moon01", "MOON01")
      idmap.put("moon02", "MOON02")
      idmap.put("moon03", "MOON03")
      idmap.put("planet01", "PLANET01")
      idmap.put("planet02", "PLANET02")
      idmap.put("planet03", "PLANET03")
      idmap.put("planet_id", "PLANET01")
      val now = System.currentTimeMillis()

      // CREATE
      val moonRef01Ent = client.moon(null)
      var moonRef01Data = Helpers.toMapAny(Struct.getprop(
          Struct.getpath(entityData, "new.moon"), "moon_ref01"))
      moonRef01Data.put("planet_id", idmap.get("planet01"))
      val moonRef01DataResult = moonRef01Ent.create(moonRef01Data, null)
      moonRef01Data = Helpers.toMapAny(moonRef01DataResult match { case e: SdkEntity => e.data(); case o => o })
      rep.check("moon.create.map", moonRef01Data != null, "expected create result to be a map")
      rep.check("moon.create.id", moonRef01Data != null && moonRef01Data.get("id") != null, "expected created entity to have an id")

      // LIST
      val moonRef01Match = new LinkedHashMap[String, Object]()
      moonRef01Match.put("planet_id", idmap.get("planet01"))
      val moonRef01ListResult = moonRef01Ent.list(moonRef01Match, null)
      rep.check("moon.list.islist", moonRef01ListResult.isInstanceOf[JList[?]], "expected list result to be an array, got " + moonRef01ListResult)
      val moonRef01List = moonRef01ListResult.asInstanceOf[JList[Object]]
      val moonRef01ListFound = Struct.select(
          SdkTestSupport.entityListToData(moonRef01List), SdkTestSupport.om("id" -> moonRef01Data.get("id")))
      rep.check("moon.list.exists", !Struct.isempty(moonRef01ListFound), "expected to find created entity in list")

      // UPDATE
      val moonRef01DataUp0Up = new LinkedHashMap[String, Object]()
      moonRef01DataUp0Up.put("id", moonRef01Data.get("id"))
      moonRef01DataUp0Up.put("planet_id", idmap.get("planet_id"))
      val moonRef01MarkdefUp0Name = "kind"
      val moonRef01MarkdefUp0Value = "Mark01-moon_ref01_" + now
      moonRef01DataUp0Up.put(moonRef01MarkdefUp0Name, moonRef01MarkdefUp0Value)
      val moonRef01ResdataUp0Result = moonRef01Ent.update(moonRef01DataUp0Up, null)
      val moonRef01ResdataUp0 = Helpers.toMapAny(moonRef01ResdataUp0Result match { case e: SdkEntity => e.data(); case o => o })
      rep.check("moon.update.map", moonRef01ResdataUp0 != null, "expected update result to be a map")
      rep.eq("moon.update.id", moonRef01DataUp0Up.get("id"), moonRef01ResdataUp0.get("id"))
      rep.eq("moon.update.mark", moonRef01MarkdefUp0Value, moonRef01ResdataUp0.get(moonRef01MarkdefUp0Name))

      // LOAD
      val moonRef01MatchDt0 = new LinkedHashMap[String, Object]()
      moonRef01MatchDt0.put("id", moonRef01Data.get("id"))
      val moonRef01DataDt0Loaded = moonRef01Ent.load(moonRef01MatchDt0, null)
      val moonRef01DataDt0LoadResult = Helpers.toMapAny(moonRef01DataDt0Loaded match { case e: SdkEntity => e.data(); case o => o })
      rep.check("moon.load.map", moonRef01DataDt0LoadResult != null, "expected load result to be a map")
      rep.eq("moon.load.id", moonRef01Data.get("id"), moonRef01DataDt0LoadResult.get("id"))

      // REMOVE
      val moonRef01MatchRm0 = new LinkedHashMap[String, Object]()
      moonRef01MatchRm0.put("id", moonRef01Data.get("id"))
      moonRef01Ent.remove(moonRef01MatchRm0, null)

      // LIST
      val moonRef01MatchRt0 = new LinkedHashMap[String, Object]()
      moonRef01MatchRt0.put("planet_id", idmap.get("planet01"))
      val moonRef01ListRt0Result = moonRef01Ent.list(moonRef01MatchRt0, null)
      rep.check("moon.list.islist", moonRef01ListRt0Result.isInstanceOf[JList[?]], "expected list result to be an array, got " + moonRef01ListRt0Result)
      val moonRef01ListRt0 = moonRef01ListRt0Result.asInstanceOf[JList[Object]]
      val moonRef01ListRt0NotFound = Struct.select(
          SdkTestSupport.entityListToData(moonRef01ListRt0), SdkTestSupport.om("id" -> moonRef01Data.get("id")))
      rep.check("moon.list.notexists", Struct.isempty(moonRef01ListRt0NotFound), "expected removed entity to not be in list")
    }
  }
}
