import 'package:counter_bloc/models/contact_model.dart';
import 'package:dio/dio.dart';

class ContactRepository {
  Future<List<ContactModel>> findAll() async {
    final response = await Dio().get('http://192.168.1.138:8080/contacts');
    return response.data
        ?.map<ContactModel>((contact) => ContactModel.fromMap(contact))
        .toList();
  }

  Future<void> create(ContactModel model) async {
    await Dio()
        .post('http://192.168.1.138:8080/contacts', data: model.toJson());
  }

  Future<void> update(ContactModel model) async {
    await Dio().put('http://192.168.1.138:8080/contacts/${model.id}',
        data: model.toJson());
  }

  Future<void> delete(String id) async {
    await Dio().delete('http://192.168.1.138:8080/contacts/$id');
  }
}
