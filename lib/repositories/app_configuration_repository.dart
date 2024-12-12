

import '../models/app_configurations.dart';

class AppConfigurationsRepository {



  Future<AppConfigurations?> retrieve() async {
    AppConfigurations? appConfig;

    appConfig = AppConfigurations(forceUpdate: false, activeIosBuildNumbers: ["1"], activeAndroidBuildNumbers: ['1']);


    return appConfig;
  }
}
