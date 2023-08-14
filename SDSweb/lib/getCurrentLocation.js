let currentPosition = await utils.getCurrentPosition();
let currentLocation = {
  latitude: currentPosition.coords.latitude,
  longitude: currentPosition.coords.longitude
};
return currentLocation;