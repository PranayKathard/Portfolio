import 'package:flutter_bloc/flutter_bloc.dart';

part 'filter_state.dart';

class FilterCubit extends Cubit<FilterState> {
  FilterCubit() : super(const FilterApplied(0, 1.0, 1.0));

  //When filter is applied emit new component values
  void changeFilter(int bit, double bed, double bath){
    emit(FilterApplied(bit, bed, bath));
  }
}
