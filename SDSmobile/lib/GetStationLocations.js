let stationLocations = GetStations.data.map((station) => {
  return {
    latitude: station.latitude,
    longitude: station.longitude
  };
});
return stationLocations;