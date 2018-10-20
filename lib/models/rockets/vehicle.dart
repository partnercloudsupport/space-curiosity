import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../../util/url.dart';
import '../querry_model.dart';
import 'capsule_info.dart';
import 'roadster.dart';
import 'rocket_info.dart';
import 'ship_info.dart';

/// VEHICLE CLASS
/// Abstract class that represents a real vehicle used by SpaceX. It can be
/// a rocket or a capsule, because they have similar base characteristics.
abstract class Vehicle {
  final String id, name, type, description, url;
  final num height, diameter, mass;
  final bool active, reusable;
  final DateTime firstFlight;
  final List photos;

  Vehicle({
    this.id,
    this.name,
    this.type,
    this.description,
    this.url,
    this.height,
    this.diameter,
    this.mass,
    this.active,
    this.reusable,
    this.firstFlight,
    this.photos,
  });

  String get subtitle;

  String get getImageUrl => (Url.vehicleImage.containsKey(id))
      ? Url.vehicleImage[id]
      : Url.defaultImage;

  String get getHeight => '${NumberFormat.decimalPattern().format(height)} m';

  String get getDiameter =>
      '${NumberFormat.decimalPattern().format(diameter)} m';

  String get getMass => mass == null
      ? 'Unknown'
      : '${NumberFormat.decimalPattern().format(mass)} kg';

  String get getFirstFlight => DateFormat.yMMMM().format(firstFlight);

  String get firstLaunched {
    if (!DateTime.now().isAfter(firstFlight))
      return 'Scheduled to $getFirstFlight';
    else
      return 'First launched on $getFirstFlight';
  }
}

class VehiclesModel extends QuerryModel {
  List<String> imagesUrl = List();
  
  @override
  Future loadData() async {
    final rocketsResponse = await http.get(Url.rocketList);
    final capsulesResponse = await http.get(Url.capsuleList);
    final roadsterResponse = await http.get(Url.roadsterPage);
    final shipsResponse = await http.get(Url.shipsList);

    List rocketsJson = json.decode(rocketsResponse.body);
    List capsulesJson = json.decode(capsulesResponse.body);
    List shipsJson = json.decode(shipsResponse.body);

    list.clear();
    list.add(Roadster.fromJson(json.decode(roadsterResponse.body)));
    list.addAll(
        capsulesJson.map((capsule) => CapsuleInfo.fromJson(capsule)).toList());
    list.addAll(
        rocketsJson.map((rocket) => RocketInfo.fromJson(rocket)).toList());
    list.addAll(shipsJson.map((rocket) => ShipInfo.fromJson(rocket)).toList());

    imagesUrl.clear();
    imagesUrl.add('http://www.apimages.com/Images/Ap_Creative_Stock_Header.jpg');
    imagesUrl.add('https://images.pexels.com/photos/37547/suit-business-man-business-man-37547.jpeg?auto=compress&cs=tinysrgb&h=350');
    imagesUrl.add('https://i.kym-cdn.com/photos/images/original/001/316/888/f81.jpeg');

    loadingState(false);
  }

  String getImageUrl(index) => imagesUrl[index];

  int get getImagesCount => imagesUrl.length;
}
