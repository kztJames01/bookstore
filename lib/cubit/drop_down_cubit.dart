import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'drop_down_state.dart';

class DropDownCubit extends Cubit<DropDownInitial> {
  DropDownCubit() : super(DropDownInitial(value: "All"));

  change(textValue) {
    emit(DropDownInitial(value: state.value = textValue));
  }
}
