abstract class PlayerListingEvent {}

class CountrySelectedEvent extends PlayerListingEvent {
  final String countryId;

  CountrySelectedEvent(this.countryId);
}
