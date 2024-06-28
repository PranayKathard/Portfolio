part of 'house_cubit.dart';

sealed class HouseState{
  const HouseState();
}

//Initial state of the list of houses
final class HouseInitial extends HouseState {}

//State while loading houses
final class HouseLoading extends HouseState {}

//State once the houses have loading
final class HouseLoaded extends HouseState {
  final List<House> houses;

  const HouseLoaded(this.houses);
}

//State after list of houses is searched through
class HouseSearched extends HouseState {
  final List<House> searchedHouses;

  const HouseSearched(this.searchedHouses);
}

//State after list of houses is filtered
class HouseFiltered extends HouseState {
  final List<House> filteredHouses;

  const HouseFiltered(this.filteredHouses);
}

//Error state in case there is an issue with loading the houses
class HouseError extends HouseState {
  final String message;

  const HouseError(this.message);
}
