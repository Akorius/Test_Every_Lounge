import 'failure_value.dart';

///The result of the login.
class AlfaIdResult {
  ///Login success.
  late final bool isSuccess;

  ///A set of tokens if successful.
  late final String tokenPayload;

  ///Message on failure.
  late final String message;

  ///Type of reason for failure.
  late final AlfaIdFailure failureValue;

  ///Success constructor.
  AlfaIdResult.success(this.tokenPayload) {
    isSuccess = true;
  }

  ///Failed result constructor.
  AlfaIdResult.failure(this.message, this.failureValue) {
    isSuccess = false;
  }

  @override
  String toString() {
    if (isSuccess) {
      return 'Result{isSuccess: $isSuccess, value: ${tokenPayload.toString()}';
    } else {
      return 'Result{isSuccess: $isSuccess, message: $message}';
    }
  }
}
