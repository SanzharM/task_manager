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

class VoiceAuthenticationLoginEndPoint extends ApiEndpoint {
  String url = '/users/voice/login?phone={phone}';
  RequestMethod method = RequestMethod.post;
  int statusCode = 200;
}

class VoiceAuthenticationRegistrationEndPoint extends ApiEndpoint {
  String url = '/users/voice/register?phone={phone}';
  RequestMethod method = RequestMethod.post;
  int statusCode = 200;
}

class GetCompanyByCodeEndPoint extends ApiEndpoint {
  String url = '/company/?company_code={code}';
  RequestMethod method = RequestMethod.get;
  int statusCode = 200;
}

class GetBoardsEndpoint extends ApiEndpoint {
  String url = '/boards/';
  RequestMethod method = RequestMethod.get;
  int statusCode = 200;
}

class EditBoardEndpoint extends ApiEndpoint {
  String url = '/boards/';
  RequestMethod method = RequestMethod.put;
  int statusCode = 200;
}

class CreateBoardEndpoint extends ApiEndpoint {
  String url = '/boards/';
  RequestMethod method = RequestMethod.post;
  int statusCode = 200;
}

class DeleteBoardEndpoint extends ApiEndpoint {
  String url = '/boards/';
  RequestMethod method = RequestMethod.delete;
  int statusCode = 200;
}

class GetTasksEndpoint extends ApiEndpoint {
  String url = '/tasks/';
  RequestMethod method = RequestMethod.get;
  int statusCode = 200;
}

class CreateTaskEndpoint extends ApiEndpoint {
  String url = '/tasks/';
  RequestMethod method = RequestMethod.post;
  int statusCode = 200;
}

class DeleteTaskEndpoint extends ApiEndpoint {
  String url = '/tasks/';
  RequestMethod method = RequestMethod.delete;
  int statusCode = 200;
}

class EditTaskEndpoint extends ApiEndpoint {
  String url = '/tasks/';
  RequestMethod method = RequestMethod.put;
  int statusCode = 200;
}

class GetCompanyUsers extends ApiEndpoint {
  String url = '/users/all';
  RequestMethod method = RequestMethod.get;
  int statusCode = 200;
}
