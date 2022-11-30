part of 'list_bloc.dart';

abstract class ListEvent extends Equatable {
  const ListEvent();

  @override
  List<Object> get props => [];
}

class ListfetchingEvent extends ListEvent {}

class ListfetchedEvent extends ListEvent {}
