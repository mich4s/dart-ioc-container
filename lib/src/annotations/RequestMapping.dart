class RequestMapping {
  final String method;
  final String url;

  const RequestMapping({this.method, this.url});
}

class GetMapping extends RequestMapping {
  final String url;

  const GetMapping({this.url}) : super(method: 'GET');
}
