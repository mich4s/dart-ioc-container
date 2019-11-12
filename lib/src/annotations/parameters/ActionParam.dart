abstract class ActionParam {
  const ActionParam();

  dynamic perform({
    Map<String, String> routeParams,
    Map<String, dynamic> requestBody,
  });
}
