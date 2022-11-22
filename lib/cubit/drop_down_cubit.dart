import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'drop_down_state.dart';

class DropDownCubit extends Cubit<DropDownInitial> {
  DropDownCubit() : super(DropDownInitial(value: "All"));

  change(textValue) {
    emit(DropDownInitial(value: state.value = textValue));
  }
}

class DropDownCubit1 extends Cubit<DropDownInitial1> {
  DropDownCubit1() : super(DropDownInitial1(textValue: "All"));

  change1(value) {
    emit(DropDownInitial1(textValue: state.textValue = value));
  }
}

class searchCubit2 extends Cubit<searchResult> {
  searchCubit2() : super(searchResult(search: true));

  change(value) {
    emit(searchResult(search: state.search = value));
  }
}
