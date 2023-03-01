import 'package:app/constants.dart';
import 'package:app/model/profile_response/profile_me_response.dart';
import 'package:app/model/quests_models/base_quest_response.dart';
import 'package:app/utils/marker_loader_for_map.dart';
import 'package:google_maps_cluster_manager/google_maps_cluster_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapConstants {
  static const List<double> level = const [1, 4.25, 6.75, 8.25, 11.5, 14.5, 16.0, 16.5, 20.0];
  static const double extraPercent = 0.5;
  static const double stopClusteringZoom = 25.0;
}

class MapUtils {
  static ClusterManager<ClusterItem> initClusterManager({
    required List<BaseQuestResponse> questsOnMap,
    required List<ProfileMeResponse> workersOnMap,
    required Function(Set<Marker>) updateMarkers,
    required Function(Cluster) onTapMarker,
    required MarkerLoader? markerLoader,
    required bool? isWorker,
  }) {
    if (isWorker!)
      return ClusterManager<BaseQuestResponse>(
        questsOnMap,
        updateMarkers,
        markerBuilder: (cluster) async {
          return Marker(
            markerId: MarkerId(cluster.getId()),
            position: cluster.location,
            onTap: () => onTapMarker(cluster),
            icon: cluster.isMultiple
                ? await MarkerLoader.getClusterMarkerBitmap(cluster.count.toString())
                : markerLoader!.icons[cluster.items.toList()[0].priority],
          );
        },
        levels: MapConstants.level,
        extraPercent: MapConstants.extraPercent,
        stopClusteringZoom: MapConstants.stopClusteringZoom,
      );
    return ClusterManager<ProfileMeResponse>(
      workersOnMap,
      updateMarkers,
      markerBuilder: (cluster) async {
        return Marker(
          markerId: MarkerId(cluster.getId()),
          position: cluster.location,
          onTap: () => onTapMarker(cluster),
          icon: cluster.isMultiple
              ? await MarkerLoader.getClusterMarkerBitmap(cluster.count.toString())
              : await MarkerLoader.getMarkerImageFromUrl(
                  cluster.items.toList()[0].avatar?.url ?? Constants.defaultImageNetwork,
                  Constants.workerRatingTag[cluster.items.toList()[0].ratingStatistic?.status]?.color,
                ),
        );
      },
      levels: MapConstants.level,
      extraPercent: MapConstants.extraPercent,
      stopClusteringZoom: MapConstants.stopClusteringZoom,
    );
  }
}
