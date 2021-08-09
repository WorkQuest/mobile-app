// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quest_map_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$QuestMapStore on _QuestMapStore, Store {
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

  final _$markersAtom = Atom(name: '_QuestMapStore.markers');

  @override
  List<Marker> get markers {
    _$markersAtom.reportRead();
    return super.markers;
  }

  @override
  set markers(List<Marker> value) {
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

  final _$iconsMarkerAtom = Atom(name: '_QuestMapStore.iconsMarker');

  @override
  List<BitmapDescriptor> get iconsMarker {
    _$iconsMarkerAtom.reportRead();
    return super.iconsMarker;
  }

  @override
  set iconsMarker(List<BitmapDescriptor> value) {
    _$iconsMarkerAtom.reportWrite(value, super.iconsMarker, () {
      super.iconsMarker = value;
    });
  }

  final _$getQuestsAsyncAction = AsyncAction('_QuestMapStore.getQuests');

  @override
  Future<dynamic> getQuests(LatLngBounds bounds) {
    return _$getQuestsAsyncAction.run(() => super.getQuests(bounds));
  }

  final _$loadIconsAsyncAction = AsyncAction('_QuestMapStore.loadIcons');

  @override
  Future loadIcons(BuildContext context) {
    return _$loadIconsAsyncAction.run(() => super.loadIcons(context));
  }

  @override
  String toString() {
    return '''
points: ${points},
markers: ${markers},
debounce: ${debounce},
iconsMarker: ${iconsMarker}
    ''';
  }
}
