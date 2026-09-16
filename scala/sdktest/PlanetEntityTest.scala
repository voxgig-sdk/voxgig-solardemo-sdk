// Generated basic-flow test for the planet entity (model-driven;
// mirrors the java TestEntity generator). A dependency-free scala-cli test
// object driven by SdkEntityTestMain. Runs against the in-memory test
// transport seeded with the shipped PlanetTestData.json fixtures.

import java.util.{ArrayList, LinkedHashMap, List => JList, Map => JMap}

import voxgig.solardemosdk.core.{Helpers, SdkEntity, SolardemoSDK}
import voxgig.solardemosdk.utility.struct.Struct

object PlanetEntityTest {

  def run(rep: SdkTestReport): Unit = {
    rep.scope("planet.instance") {
      val testsdk = SolardemoSDK.testSDK()
      val ent = testsdk.planet(null)
      rep.check("planet.instance", ent != null, "expected non-null planet entity")
    }

    rep.scope("planet.basic") {
      val entityData = Helpers.toMapAny(SdkTestSupport.readJson(
          "../.sdk/test/entity/planet/PlanetTestData.json"))
      val options = new LinkedHashMap[String, Object]()
      options.put("entity", entityData.get("existing"))
      val client = SolardemoSDK.testSDK(options, null)

      val idmap = new LinkedHashMap[String, Object]()
      idmap.put("planet01", "PLANET01")
      idmap.put("planet02", "PLANET02")
      idmap.put("planet03", "PLANET03")
      val now = System.currentTimeMillis()

      // CREATE
      val planetRef01Ent = client.planet(null)
      var planetRef01Data = Helpers.toMapAny(Struct.getprop(
          Struct.getpath(entityData, "new.planet"), "planet_ref01"))
      val planetRef01DataResult = planetRef01Ent.create(planetRef01Data, null)
      planetRef01Data = Helpers.toMapAny(planetRef01DataResult match { case e: SdkEntity => e.data(); case o => o })
      rep.check("planet.create.map", planetRef01Data != null, "expected create result to be a map")
      rep.check("planet.create.id", planetRef01Data != null && planetRef01Data.get("id") != null, "expected created entity to have an id")

      // LIST
      val planetRef01Match = new LinkedHashMap[String, Object]()
      val planetRef01ListResult = planetRef01Ent.list(planetRef01Match, null)
      rep.check("planet.list.islist", planetRef01ListResult.isInstanceOf[JList[?]], "expected list result to be an array, got " + planetRef01ListResult)
      val planetRef01List = planetRef01ListResult.asInstanceOf[JList[Object]]
      val planetRef01ListFound = Struct.select(
          SdkTestSupport.entityListToData(planetRef01List), SdkTestSupport.om("id" -> planetRef01Data.get("id")))
      rep.check("planet.list.exists", !Struct.isempty(planetRef01ListFound), "expected to find created entity in list")

      // UPDATE
      val planetRef01DataUp0Up = new LinkedHashMap[String, Object]()
      planetRef01DataUp0Up.put("id", planetRef01Data.get("id"))
      val planetRef01MarkdefUp0Name = "kind"
      val planetRef01MarkdefUp0Value = "Mark01-planet_ref01_" + now
      planetRef01DataUp0Up.put(planetRef01MarkdefUp0Name, planetRef01MarkdefUp0Value)
      val planetRef01ResdataUp0Result = planetRef01Ent.update(planetRef01DataUp0Up, null)
      val planetRef01ResdataUp0 = Helpers.toMapAny(planetRef01ResdataUp0Result match { case e: SdkEntity => e.data(); case o => o })
      rep.check("planet.update.map", planetRef01ResdataUp0 != null, "expected update result to be a map")
      rep.eq("planet.update.id", planetRef01DataUp0Up.get("id"), planetRef01ResdataUp0.get("id"))
      rep.eq("planet.update.mark", planetRef01MarkdefUp0Value, planetRef01ResdataUp0.get(planetRef01MarkdefUp0Name))

      // LOAD
      val planetRef01MatchDt0 = new LinkedHashMap[String, Object]()
      planetRef01MatchDt0.put("id", planetRef01Data.get("id"))
      val planetRef01DataDt0Loaded = planetRef01Ent.load(planetRef01MatchDt0, null)
      val planetRef01DataDt0LoadResult = Helpers.toMapAny(planetRef01DataDt0Loaded match { case e: SdkEntity => e.data(); case o => o })
      rep.check("planet.load.map", planetRef01DataDt0LoadResult != null, "expected load result to be a map")
      rep.eq("planet.load.id", planetRef01Data.get("id"), planetRef01DataDt0LoadResult.get("id"))

      // REMOVE
      val planetRef01MatchRm0 = new LinkedHashMap[String, Object]()
      planetRef01MatchRm0.put("id", planetRef01Data.get("id"))
      planetRef01Ent.remove(planetRef01MatchRm0, null)

      // LIST
      val planetRef01MatchRt0 = new LinkedHashMap[String, Object]()
      val planetRef01ListRt0Result = planetRef01Ent.list(planetRef01MatchRt0, null)
      rep.check("planet.list.islist", planetRef01ListRt0Result.isInstanceOf[JList[?]], "expected list result to be an array, got " + planetRef01ListRt0Result)
      val planetRef01ListRt0 = planetRef01ListRt0Result.asInstanceOf[JList[Object]]
      val planetRef01ListRt0NotFound = Struct.select(
          SdkTestSupport.entityListToData(planetRef01ListRt0), SdkTestSupport.om("id" -> planetRef01Data.get("id")))
      rep.check("planet.list.notexists", Struct.isempty(planetRef01ListRt0NotFound), "expected removed entity to not be in list")
    }
  }
}
