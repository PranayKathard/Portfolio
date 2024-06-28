import 'package:flutter_bloc/flutter_bloc.dart';

class BottomNavigationCubit extends Cubit<int> {
  BottomNavigationCubit() : super(0);

  //Switch between overview page and about page
  void updateIndex(int index) => emit(index);
}