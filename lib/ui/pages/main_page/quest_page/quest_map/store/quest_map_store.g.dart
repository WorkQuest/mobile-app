// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quest_map_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$QuestMapStore on _QuestMapStore, Store {
  final _$infoPanelAtom = Atom(name: '_QuestMapStore.infoPanel');

  @override
  InfoPanel get infoPanel {
    _$infoPanelAtom.reportRead();
    return super.infoPanel;
  }

  @override
  set infoPanel(InfoPanel value) {
    _$infoPanelAtom.reportWrite(value, super.infoPanel, () {
      super.infoPanel = value;
    });
  }

  final _$selectQuestInfoAtom = Atom(name: '_QuestMapStore.selectQuestInfo');

  @override
  BaseQuestResponse? get selectQuestInfo {
    _$selectQuestInfoAtom.reportRead();
    return super.selectQuestInfo;
  }

  @override
  set selectQuestInfo(BaseQuestResponse? value) {
    _$selectQuestInfoAtom.reportWrite(value, super.selectQuestInfo, () {
      super.selectQuestInfo = value;
    });
  }

  final _$bufferQuestsAtom = Atom(name: '_QuestMapStore.bufferQuests');

  @override
  Map<String, BaseQuestResponse> get bufferQuests {
    _$bufferQuestsAtom.reportRead();
    return super.bufferQuests;
  }

  @override
  set bufferQuests(Map<String, BaseQuestResponse> value) {
    _$bufferQuestsAtom.reportWrite(value, super.bufferQuests, () {
      super.bufferQuests = value;
    });
  }

  final _$pointsAtom = Atom(name: '_QuestMapStore.points');

  @override
  List<QuestMapPoint> get points {
    _$pointsAtom.reportRead();
    return super.points;
  }

  @override
  set points(List<QuestMapPoint> value) {
    _$pointsAtom.reportWrite(value, super.points, () {
      super.points = value;
    });
  }

  final _$questsOnMapAtom = Atom(name: '_QuestMapStore.questsOnMap');

  @override
  ObservableList<BaseQuestResponse> get questsOnMap {
    _$questsOnMapAtom.reportRead();
    return super.questsOnMap;
  }

  @override
  set questsOnMap(ObservableList<BaseQuestResponse> value) {
    _$questsOnMapAtom.reportWrite(value, super.questsOnMap, () {
      super.questsOnMap = value;
    });
  }

  final _$workersOnMapAtom = Atom(name: '_QuestMapStore.workersOnMap');

  @override
  ObservableList<AssignedWorker> get workersOnMap {
    _$workersOnMapAtom.reportRead();
    return super.workersOnMap;
  }

  @override
  set workersOnMap(ObservableList<AssignedWorker> value) {
    _$workersOnMapAtom.reportWrite(value, super.workersOnMap, () {
      super.workersOnMap = value;
    });
  }

  final _$initialCameraPositionAtom =
      Atom(name: '_QuestMapStore.initialCameraPosition');

  @override
  CameraPosition? get initialCameraPosition {
    _$initialCameraPositionAtom.reportRead();
    return super.initialCameraPosition;
  }

  @override
  set initialCameraPosition(CameraPosition? value) {
    _$initialCameraPositionAtom.reportWrite(value, super.initialCameraPosition,
        () {
      super.initialCameraPosition = value;
    });
  }

  final _$locationPositionAtom = Atom(name: '_QuestMapStore.locationPosition');

  @override
  Position? get locationPosition {
    _$locationPositionAtom.reportRead();
    return super.locationPosition;
  }

  @override
  set locationPosition(Position? value) {
    _$locationPositionAtom.reportWrite(value, super.locationPosition, () {
      super.locationPosition = value;
    });
  }

  final _$markersAtom = Atom(name: '_QuestMapStore.markers');

  @override
  List<MapMarker> get markers {
    _$markersAtom.reportRead();
    return super.markers;
  }

  @override
  set markers(List<MapMarker> value) {
    _$markersAtom.reportWrite(value, super.markers, () {
      super.markers = value;
    });
  }

  final _$debounceAtom = Atom(name: '_QuestMapStore.debounce');

  @override
  Timer? get debounce {
    _$debounceAtom.reportRead();
    return super.debounce;
  }

  @override
  set debounce(Timer? value) {
    _$debounceAtom.reportWrite(value, super.debounce, () {
      super.debounce = value;
    });
  }

  final _$markerLoaderAtom = Atom(name: '_QuestMapStore.markerLoader');

  @override
  MarkerLoader? get markerLoader {
    _$markerLoaderAtom.reportRead();
    return super.markerLoader;
  }

  @override
  set markerLoader(MarkerLoader? value) {
    _$markerLoaderAtom.reportWrite(value, super.markerLoader, () {
      super.markerLoader = value;
    });
  }

  final _$addressAtom = Atom(name: '_QuestMapStore.address');

  @override
  String get address {
    _$addressAtom.reportRead();
    return super.address;
  }

  @override
  set address(String value) {
    _$addressAtom.reportWrite(value, super.address, () {
      super.address = value;
    });
  }

  final _$getPredictionAsyncAction =
      AsyncAction('_QuestMapStore.getPrediction');

  @override
  Future<Null> getPrediction(
      BuildContext context, GoogleMapController controller) {
    return _$getPredictionAsyncAction
        .run(() => super.getPrediction(context, controller));
  }

  final _$getQuestsOnMapAsyncAction =
      AsyncAction('_QuestMapStore.getQuestsOnMap');

  @override
  Future<dynamic> getQuestsOnMap(LatLngBounds bounds) {
    return _$getQuestsOnMapAsyncAction.run(() => super.getQuestsOnMap(bounds));
  }

  final _$onTabQuestAsyncAction = AsyncAction('_QuestMapStore.onTabQuest');

  @override
  Future onTabQuest(String id) {
    return _$onTabQuestAsyncAction.run(() => super.onTabQuest(id));
  }

  final _$_QuestMapStoreActionController =
      ActionController(name: '_QuestMapStore');

  @override
  dynamic onCloseQuest() {
    final _$actionInfo = _$_QuestMapStoreActionController.startAction(
        name: '_QuestMapStore.onCloseQuest');
    try {
      return super.onCloseQuest();
    } finally {
      _$_QuestMapStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic createMarkerLoader(BuildContext context) {
    final _$actionInfo = _$_QuestMapStoreActionController.startAction(
        name: '_QuestMapStore.createMarkerLoader');
    try {
      return super.createMarkerLoader(context);
    } finally {
      _$_QuestMapStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
infoPanel: ${infoPanel},
selectQuestInfo: ${selectQuestInfo},
bufferQuests: ${bufferQuests},
points: ${points},
questsOnMap: ${questsOnMap},
workersOnMap: ${workersOnMap},
initialCameraPosition: ${initialCameraPosition},
locationPosition: ${locationPosition},
markers: ${markers},
debounce: ${debounce},
markerLoader: ${markerLoader},
address: ${address}
    ''';
  }
}
