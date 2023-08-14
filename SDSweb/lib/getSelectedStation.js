if (Map.selectedPoint) 
{
  const selected = getStations.data.filter((station) => station.latitude == Map.selectedPoint.latitude && station.longitude == Map.selectedPoint.longitude)[0];
  if (selected) 
  {
    return selected;
  }
}
else{
  return {
      "id": -1,
      "name": "No Selected Station",
      "hourlyRate": "No Selected Station",
      "latitude": "No Selected Station",
      "longitude": "No Selected Station",
      "lockCount": "No Selected Station",
      "freeLockCount": 0,
      "ownedLockCount": 0,
      "deleted": true
  }
}