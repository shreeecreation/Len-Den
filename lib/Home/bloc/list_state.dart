part of 'list_bloc.dart';

abstract class ListState extends Equatable {
  const ListState();

  @override
  List<Object> get props => [];
}

class ListInitial extends ListState {}

class ListFetchingState extends ListState {}

class ListFetchedState extends ListState {}
