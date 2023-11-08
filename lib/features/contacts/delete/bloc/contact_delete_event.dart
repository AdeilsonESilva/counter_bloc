part of 'contact_delete_bloc.dart';

@freezed
class ContactDeleteEvent with _$ContactDeleteEvent {
  const factory ContactDeleteEvent.delete({required int id}) = _Delete;
}
