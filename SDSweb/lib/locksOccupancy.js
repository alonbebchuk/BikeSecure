const station = getStations.data.find(station => station.id === stationLocksSelect.value);
if (station) {
  return ((station.ownedLockCount) / (station.lockCount)).toFixed(2)*100;
}
 else {
    return 0;
}
