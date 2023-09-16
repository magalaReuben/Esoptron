import 'package:esoptron_salon/utils/enums/global_state.dart';

class AppState<T> {
  final Status status;
  final String errorMessage;
  final T? data;
  AppState({
    required this.status,
    this.errorMessage = '',
    this.data,
  });

  AppState copyWith({
    Status? status,
    String? errorMessage,
    T? data,
  }) {
    return AppState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      data: data ?? this.data,
    );
  }

  @override
  String toString() =>
      'GlobalState(status: $status, errorMessage: $errorMessage, data: $data)';
}
