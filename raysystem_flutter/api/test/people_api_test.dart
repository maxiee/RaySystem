import 'package:test/test.dart';
import 'package:openapi/openapi.dart';


/// tests for PeopleApi
void main() {
  final instance = Openapi().getPeopleApi();

  group(PeopleApi, () {
    // Create People Name
    //
    //Future<PeopleNameResponse> createPeopleNamePeoplePeopleIdNamesPost(int peopleId, PeopleNameCreate peopleNameCreate) async
    test('test createPeopleNamePeoplePeopleIdNamesPost', () async {
      // TODO
    });

    // Create People
    //
    //Future<PeopleResponse> createPeoplePeoplePost(PeopleCreate peopleCreate) async
    test('test createPeoplePeoplePost', () async {
      // TODO
    });

    // Delete People Name
    //
    //Future<bool> deletePeopleNamePeopleNamesNameIdDelete(int nameId) async
    test('test deletePeopleNamePeopleNamesNameIdDelete', () async {
      // TODO
    });

    // Delete People
    //
    //Future<bool> deletePeoplePeoplePeopleIdDelete(int peopleId) async
    test('test deletePeoplePeoplePeopleIdDelete', () async {
      // TODO
    });

    // Get People Names
    //
    //Future<BuiltList<PeopleNameResponse>> getPeopleNamesPeoplePeopleIdNamesGet(int peopleId) async
    test('test getPeopleNamesPeoplePeopleIdNamesGet', () async {
      // TODO
    });

    // Get People
    //
    //Future<PeopleResponse> getPeoplePeoplePeopleIdGet(int peopleId) async
    test('test getPeoplePeoplePeopleIdGet', () async {
      // TODO
    });

    // Update People Name
    //
    //Future<PeopleNameResponse> updatePeopleNamePeopleNamesNameIdPut(int nameId, PeopleNameCreate peopleNameCreate) async
    test('test updatePeopleNamePeopleNamesNameIdPut', () async {
      // TODO
    });

    // Update People
    //
    //Future<PeopleResponse> updatePeoplePeoplePeopleIdPut(int peopleId, PeopleUpdate peopleUpdate) async
    test('test updatePeoplePeoplePeopleIdPut', () async {
      // TODO
    });

  });
}
