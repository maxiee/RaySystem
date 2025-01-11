import 'package:test/test.dart';
import 'package:openapi/openapi.dart';

/// tests for DefaultApi
void main() {
  final instance = Openapi().getDefaultApi();

  group(DefaultApi, () {
    // Create Site
    //
    //Future<Site> createSiteSitesPost(SiteCreate siteCreate) async
    test('test createSiteSitesPost', () async {
      // TODO
    });

    // Delete Site
    //
    //Future<JsonObject> deleteSiteSitesSiteIdDelete(int siteId) async
    test('test deleteSiteSitesSiteIdDelete', () async {
      // TODO
    });

    // Read Site
    //
    //Future<Site> readSiteSitesSiteIdGet(int siteId) async
    test('test readSiteSitesSiteIdGet', () async {
      // TODO
    });

    // Read Sites
    //
    //Future<BuiltList<Site>> readSitesSitesGet({ int skip, int limit }) async
    test('test readSitesSitesGet', () async {
      // TODO
    });

    // Root
    //
    //Future<JsonObject> rootGet() async
    test('test rootGet', () async {
      // TODO
    });
  });
}
