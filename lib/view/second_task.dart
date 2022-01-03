import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:interview_jay/apis/get_api_call.dart';
import 'package:interview_jay/models/api_response_model.dart';

class SecondTask extends StatefulWidget {
  const SecondTask({Key? key}) : super(key: key);

  @override
  _SecondTaskState createState() => _SecondTaskState();
}

class _SecondTaskState extends State<SecondTask> {
  APICallController apiCallController = Get.put(APICallController());

  ScrollController? scrollController;
  RxInt page = 0.obs;

  @override
  void initState() {
    super.initState();
    apiCallController.callAPI();
    scrollController?.addListener(() {
      if (scrollController?.position.pixels ==
          scrollController?.position.maxScrollExtent) {
        page.value = apiCallController.responseModel.value.page! + 1;
        apiCallController.callAPI(page: page.value);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Second task"),
      ),
      body: Obx(
        () => apiCallController.isLoading.value
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : apiCallController.data.isEmpty
                ? const Center(
                    child: Text("No data found"),
                  )
                : ListView.separated(
                    controller: scrollController,
                    itemCount: apiCallController.data.length,
                    separatorBuilder: (context, index) {
                      return const Divider();
                    },
                    itemBuilder: (context, index) {
                      if (index == apiCallController.data.length &&
                          apiCallController.isBottomLoading.value) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(
                              apiCallController.data[index].avatar ?? ""),
                        ),
                        title: Text(
                          "${apiCallController.data[index].firstName ?? ""} ${apiCallController.data[index].lastName ?? ""}",
                        ),
                        subtitle: Text(
                          "${apiCallController.data[index].email ?? ""} ",
                        ),
                      );
                    },
                  ),
      ),
    );
  }
}
