part of 'filter_cubit.dart';

sealed class FilterState {
  const FilterState();
}

final class FilterApplied extends FilterState {
  //Components values (radio list and sliders)
  final int sortBit;
  final double beds;
  final double baths;

  const FilterApplied(this.sortBit,this.beds,this.baths);
}

