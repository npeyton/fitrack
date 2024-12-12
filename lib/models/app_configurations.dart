class AppConfigurations {
  AppConfigurations({
    required this.forceUpdate,
    required this.activeIosBuildNumbers,
    required this.activeAndroidBuildNumbers,
    this.testEmails,
  });

  final bool forceUpdate;
  final List<String> activeIosBuildNumbers;
  final List<String> activeAndroidBuildNumbers;
  final List<String>? testEmails;

  factory AppConfigurations.fromJson(Map<String, dynamic> json) {

    return AppConfigurations(
      forceUpdate: json['force_update'] == 0 ? false : true,
      activeIosBuildNumbers: json['ios_version'].split(","),
      activeAndroidBuildNumbers: json['android_version'].split(","),
      testEmails: json['test_emails']?.split(","),
    );
  }
}
