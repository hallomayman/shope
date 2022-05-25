class ChangeModel{
  late bool status;
  late String message;

  ChangeModel.fromJson(Map<String, dynamic> json){
    status = json['status'];
    message = json['message'];
  }
}