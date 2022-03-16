enum RequestMethod { get, post, put, delete }

abstract class ApiEndpoint {
  late String url;
  late RequestMethod method;
  late int statusCode;
}

class AuthEndpoint extends ApiEndpoint {
  String url = '/users/auth';
  RequestMethod method = RequestMethod.post;
  int statusCode = 200;
}

class AuthVerifyEndpoint extends ApiEndpoint {
  String url = '/users/auth/verify';
  RequestMethod method = RequestMethod.post;
  int statusCode = 200;
}
