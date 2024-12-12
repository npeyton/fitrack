
class Config {
  static Config? _instance;

  static Config get instance {
    _instance ??= Config._internal();
    return _instance!;
  }

  Config._internal();

  // void initialize(Flavor flavor) {
  //   _flavor = flavor;
  //   _useLocalApiEndpoint = false;
  //
  //   if (_useLocalApiEndpoint) {
  //     _apiEndpoint = "http://";
  //   } else if (_flavor == Flavor.development) {
  //     _apiEndpoint = "https://";
  //   } else {
  //     _apiEndpoint = "https://";
  //   }
  //
  //   _googleMapsAndroidApiKey = "";
  //   _googleMapsIosApiKey = "";
  // }

  late bool _useLocalApiEndpoint;
  //late Flavor _flavor;
  late String _apiEndpoint;
  late String _googleMapsAndroidApiKey;
  late String _googleMapsIosApiKey;

  String get apiEndpoint => _apiEndpoint;

  String get googleMapsAndroidApiKey => _googleMapsAndroidApiKey;

  String get googleMapsIosApiKey => _googleMapsIosApiKey;
}
