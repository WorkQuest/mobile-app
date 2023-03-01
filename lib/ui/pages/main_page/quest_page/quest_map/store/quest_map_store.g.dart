// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quest_map_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$QuestMapStore on _QuestMapStore, Store {
  final _$isWorkerAtom = Atom(name: '_QuestMapStore.isWorker');

  @override
  bool? get isWorker {
    _$isWorkerAtom.reportRead();
    return super.isWorker;
  }

  @override
  set isWorker(bool? value) {
    _$isWorkerAtom.reportWrite(value, super.isWorker, () {
      super.isWorker = value;
    });
  }

  final _$hideInfoAtom = Atom(name: '_QuestMapStore.hideInfo');

  @override
  bool get hideInfo {
    _$hideInfoAtom.reportRead();
    return super.hideInfo;
  }

  @override
  set hideInfo(bool value) {
    _$hideInfoAtom.reportWrite(value, super.hideInfo, () {
      super.hideInfo = value;
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

  final _$markersAtom = Atom(name: '_QuestMapStore.markers');

  @override
  ObservableSet<Marker> get markers {
    _$markersAtom.reportRead();
    return super.markers;
  }

  @override
  set markers(ObservableSet<Marker> value) {
    _$markersAtom.reportWrite(value, super.markers, () {
      super.markers = value;
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

  final _$_QuestMapStoreActionController =
      ActionController(name: '_QuestMapStore');

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
isWorker: ${isWorker},
hideInfo: ${hideInfo},
address: ${address},
debounce: ${debounce},
markerLoader: ${markerLoader},
locationPosition: ${locationPosition},
initialCameraPosition: ${initialCameraPosition},
bufferQuests: ${bufferQuests},
markers: ${markers}
    ''';
  }
}
