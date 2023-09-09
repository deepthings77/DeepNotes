//login exceptions
class UserNotFoundAuthException implements Exception{}
class WrongPasswordAuthException implements Exception{}

// register exceptions

class WeakPasswordAuthException implements Exception{}

class EmailAlreadyInUseAuthException implements Exception{}

class InvalidEamilAuthException implements Exception{}

//Generic Exception

class GenericAuthException implements Exception{}

class UsernotLoggedInAuthException implements Exception{}