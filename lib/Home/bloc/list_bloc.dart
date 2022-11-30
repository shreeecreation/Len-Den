import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'list_event.dart';
part 'list_state.dart';

class ListBloc extends Bloc<ListEvent, ListState> {
  ListBloc() : super(ListFetchingState()) {
    on<ListEvent>((event, emit) {});
    on<ListfetchingEvent>((event, emit) {
      emit(ListFetchingState());
    });
    on<ListfetchedEvent>((event, emit) {
      emit(ListFetchedState());
    });
  }
}
