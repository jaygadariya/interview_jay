import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;
import 'package:interview_jay/models/api_response_model.dart';

class APICallController extends GetxController {
  RxBool isLoading = true.obs, isBottomLoading = false.obs;

  RxList<Data> data = <Data>[].obs;

  Rx<ApiResponseModel> responseModel = ApiResponseModel().obs;

  callAPI({int? page = 1}) async {
    isLoading.value = true;
    if (page! > 1) {
      isBottomLoading.value = true;
    }
    try {
      dio.Response res =
          await dio.Dio().get("https://reqres.in/api/users?page=$page");
      responseModel.value = ApiResponseModel.fromJson(res.data);
      data.addAll(responseModel.value.data!.toList());
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      isLoading.value = false;
      isBottomLoading.value = true;
    }
  }
}
