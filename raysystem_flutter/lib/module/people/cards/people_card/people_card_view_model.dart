import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:openapi/openapi.dart' as openapi;
import 'package:raysystem_flutter/api/api.dart';

class PeopleCardViewModel extends ChangeNotifier {
  final int? peopleId;

  PeopleCardViewModel({this.peopleId}) {
    _initialize();
  }

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _isSaving = false;
  bool _isEditMode = false;

  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController avatarController = TextEditingController();
  final TextEditingController birthDateController = TextEditingController();

  openapi.PeopleResponse? _peopleData;
  DateTime? _birthDate;
  List<openapi.PeopleNameResponse> _peopleNames = [];

  // Getters
  bool get isLoading => _isLoading;
  bool get isSaving => _isSaving;
  bool get isEditMode => _isEditMode;
  openapi.PeopleResponse? get peopleData => _peopleData;
  List<openapi.PeopleNameResponse> get peopleNames => _peopleNames;
  String? successMessage;
  String? errorMessage;

  void _initialize() {
    if (peopleId != null) {
      loadPeopleData();
      loadPeopleNames();
    } else {
      _isEditMode = true;
      _peopleNames = [];
      notifyListeners();
    }
  }

  @override
  void dispose() {
    descriptionController.dispose();
    avatarController.dispose();
    birthDateController.dispose();
    super.dispose();
  }

  void setEditMode(bool editMode) {
    _isEditMode = editMode;
    notifyListeners();
  }

  Future<void> loadPeopleData() async {
    if (peopleId == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      final response = await peopleApi.getPeoplePeoplePeopleIdGet(
        peopleId: peopleId!,
      );
      _peopleData = response.data;
      descriptionController.text = _peopleData?.description ?? '';
      avatarController.text = _peopleData?.avatar ?? '';

      if (_peopleData?.birthDate != null) {
        _birthDate = DateTime.tryParse(_peopleData!.birthDate!);
        if (_birthDate != null) {
          birthDateController.text =
              DateFormat('yyyy-MM-dd').format(_birthDate!);
        }
      }
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      errorMessage = '加载人物信息失败: ${e.toString()}';
      notifyListeners();
    }
  }

  Future<void> loadPeopleNames() async {
    if (peopleId == null) return;
    try {
      final response = await peopleApi.getPeopleNamesPeoplePeopleIdNamesGet(
          peopleId: peopleId!);
      _peopleNames = response.data?.toList() ?? [];
      notifyListeners();
    } catch (e) {
      _peopleNames = [];
      errorMessage = '加载人名失败: ${e.toString()}';
      notifyListeners();
    }
  }

  Future<void> savePeople() async {
    if (!formKey.currentState!.validate()) return;

    _isSaving = true;
    notifyListeners();

    try {
      if (peopleId == null) {
        final peopleCreate = openapi.PeopleCreate((b) => b
          ..description = descriptionController.text.isNotEmpty
              ? descriptionController.text
              : null
          ..avatar =
              avatarController.text.isNotEmpty ? avatarController.text : null
          ..birthDate = birthDateController.text.isNotEmpty
              ? birthDateController.text
              : null);

        final response = await peopleApi.createPeoplePeoplePost(
          peopleCreate: peopleCreate,
        );
        _peopleData = response.data;
        // After creating, we might want to update the peopleId for subsequent operations if the UI stays on the same "card"
        // For now, we assume the card might be replaced or re-initialized with the new ID.
        successMessage = '人物创建成功';
      } else {
        final peopleUpdate = openapi.PeopleUpdate((b) => b
          ..description = descriptionController.text.isNotEmpty
              ? descriptionController.text
              : null
          ..avatar =
              avatarController.text.isNotEmpty ? avatarController.text : null
          ..birthDate = birthDateController.text.isNotEmpty
              ? birthDateController.text
              : null);

        final response = await peopleApi.updatePeoplePeoplePeopleIdPut(
          peopleId: peopleId!,
          peopleUpdate: peopleUpdate,
        );
        _peopleData = response.data;
        successMessage = '人物信息更新成功';
      }
      _isSaving = false;
      _isEditMode = false;
      notifyListeners();
    } catch (e) {
      _isSaving = false;
      errorMessage = '保存失败: ${e.toString()}';
      notifyListeners();
    }
  }

  void selectDate(DateTime? date) {
    if (date != null) {
      _birthDate = date;
      birthDateController.text = DateFormat('yyyy-MM-dd').format(date);
      notifyListeners();
    }
  }

  Future<void> createPeopleName(String name) async {
    if (peopleId == null) {
      errorMessage = '请先保存人物基础信息，之后才能添加姓名。';
      notifyListeners();
      return;
    }
    try {
      await peopleApi.createPeopleNamePeoplePeopleIdNamesPost(
        peopleId: peopleId!,
        peopleNameCreate: openapi.PeopleNameCreate((b) => b..name = name),
      );
      await loadPeopleNames(); // Reload names
      successMessage = '添加人名成功';
      notifyListeners();
    } catch (e) {
      errorMessage = '添加人名失败: ${e.toString()}';
      notifyListeners();
    }
  }

  Future<void> updatePeopleName(int nameId, String name) async {
    try {
      await peopleApi.updatePeopleNamePeopleNamesNameIdPut(
        nameId: nameId,
        peopleNameCreate: openapi.PeopleNameCreate((b) => b..name = name),
      );
      await loadPeopleNames(); // Reload names
      successMessage = '人名已更新';
      notifyListeners();
    } catch (e) {
      errorMessage = '更新人名失败: ${e.toString()}';
      notifyListeners();
    }
  }

  Future<void> deletePeopleName(int nameId) async {
    try {
      await peopleApi.deletePeopleNamePeopleNamesNameIdDelete(nameId: nameId);
      await loadPeopleNames(); // Reload names
      successMessage = '人名已删除';
      notifyListeners();
    } catch (e) {
      errorMessage = '删除人名失败: ${e.toString()}';
      notifyListeners();
    }
  }

  // Helper to clear messages after they are shown
  void clearMessages() {
    successMessage = null;
    errorMessage = null;
    // No need to notifyListeners here as it's usually called after UI has reacted
  }
}
