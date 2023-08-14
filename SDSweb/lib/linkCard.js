if (getSelectedStation.data.id > 0) {
  utils.openUrl(`https://www.google.com/maps/dir/${getCurrentLocation.data.latitude},${getCurrentLocation.data.longitude}/${Map.selectedPoint.latitude},${Map.selectedPoint.longitude}/`);
} else {
  utils.showNotification({title: 'No Selected Station', description: 'Please select a station in order to proceed with navigation.', notificationType: 'info'});
}