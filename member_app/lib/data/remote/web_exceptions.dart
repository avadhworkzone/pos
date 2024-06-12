class WebExceptions implements Exception {
  final _message;
  final _prefix;

  WebExceptions([this._message, this._prefix]);

  @override
  String toString() {
    return "$_prefix $_message";
  }
}

class FetchDataException extends WebExceptions {
  FetchDataException([message])
      : super(message, "Error During Communication: ");
}

class BadRequestException extends WebExceptions {
  BadRequestException([message]) : super(message);
}

class UnauthorisedException extends WebExceptions {
  UnauthorisedException([message]) : super(message, "Unauthorised: ");
}

class InvalidInputException extends WebExceptions {
  InvalidInputException([message]) : super(message, "Invalid Input: ");
}