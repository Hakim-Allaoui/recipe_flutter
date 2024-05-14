enum Status { LOADING, COMPLETED, ERROR }

class ApiResponse<T> {
  Status status;
  late T data;
  String message;

  ApiResponse.loading(this.message) : status = Status.LOADING;

  ApiResponse.completed(this.data) : status = Status.COMPLETED, message = "";

  ApiResponse.error(this.message) : status = Status.ERROR;
}