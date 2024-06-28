import 'package:dtt_assessment/logic/service.dart';
import 'package:dtt_assessment/object/house.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'house_state.dart';

class HouseCubit extends Cubit<HouseState> {
  HouseCubit() : super(HouseInitial());

  List<House> allHouses = [];

  //Retrieve all houses
  Future<void> fetchHouses() async {
    try {
      emit(HouseLoading());
      // Fetch the houses
      allHouses = await getHouses();
      emit(HouseLoaded(allHouses));
    } catch (e) {
      //Catch errors and put house cubit in error state
      emit(const HouseError('Failed to fetch houses'));
    }
  }

  //Filter based on search bar
  void searchHouses(String query) {
    if (query.isEmpty) {
      emit(HouseLoaded(allHouses));
    } else {
      //Get all the houses WHERE the city/zip matches search query
      final searchedHouses = allHouses.where((house) =>
      (house.zip.toLowerCase().contains(query.toLowerCase())) ||
          (house.city.toLowerCase().contains(query.toLowerCase()))).toList();
      emit(HouseSearched(searchedHouses));
    }
  }

  //Filter based on filter values
  void filterHouses(int sortPrice, double bedSlider, double bathSlider){
    //This line makes sure that we are working with the full list of houses every time filter is applied.
    //toList() is used to equate filteredHouses to allHouses value instead of memory location
    List<House> filteredHouses = allHouses.toList();

    //Price section
    if(sortPrice == 0){
      //Sort price lowest to highest
      filteredHouses.sort((a, b) => double.parse(a.price).compareTo(double.parse(b.price)));
    }
    else if(sortPrice == 1){
      //Sort price highest to lowest
      filteredHouses.sort((a, b) => double.parse(a.price).compareTo(double.parse(b.price)));
      filteredHouses = filteredHouses.reversed.toList();
    }

    //Beds and baths section
    //Remove houses that do not fit the filter requirements from list
    filteredHouses.removeWhere((h) => double.parse(h.bedrooms) < bedSlider);
    filteredHouses.removeWhere((h) => double.parse(h.bathrooms) < bathSlider);

    emit(HouseFiltered(filteredHouses));
  }
}
