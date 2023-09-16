import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:esoptron_salon/models/api_request.dart';
import 'package:esoptron_salon/models/api_response.dart';
import 'package:esoptron_salon/repositories/upload_pic.dart';
import 'package:esoptron_salon/services/upload_pic.dart';
import 'package:esoptron_salon/states/global_state.dart';
import 'package:esoptron_salon/utils/enums/global_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final _uploadPicRepositoryProvider = Provider<UploadPicRepository>((ref) {
  return UploadPicService();
});

final uploadPicNotifierProvider =
    StateNotifierProvider<UploadPicNotifier, AppState<ApiResponseModel>>((ref) {
  return UploadPicNotifier(ref.watch(_uploadPicRepositoryProvider), ref);
});

class UploadPicNotifier extends StateNotifier<AppState<ApiResponseModel>> {
  final UploadPicRepository repository;
  StateNotifierProviderRef<UploadPicNotifier, AppState<ApiResponseModel>> ref;
  UploadPicNotifier(
    this.repository,
    this.ref,
  ) : super(AppState(status: Status.initial));

  uploadPic(FormData formdata) async {
    state = AppState(status: Status.loading);
    final data = await repository.uploadPic(formdata);
    log("Hello wrld-->$data");
    data.fold((l) => state = AppState(status: Status.error, errorMessage: l),
        (r) => state = AppState(status: Status.loaded, data: r));
  }
}
