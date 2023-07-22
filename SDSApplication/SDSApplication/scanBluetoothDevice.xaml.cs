using Plugin.BLE;
using Plugin.BLE.Abstractions;
using Plugin.BLE.Abstractions.Contracts;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Threading.Tasks;
using Microsoft.Maui.ApplicationModel;
using Android.Content;
using Android.Locations;

namespace SDSApplication;

public partial class scanBluetoothDevice : ContentPage
{
	public scanBluetoothDevice()
	{
		InitializeComponent();
        _bluetoothAdapter = CrossBluetoothLE.Current.Adapter;
        _bluetoothAdapter.DeviceDiscovered += (sender, foundBleDevice) =>
        {
            if (foundBleDevice.Device != null && !string.IsNullOrEmpty(foundBleDevice.Device.Name))
                _gattDevices.Add(foundBleDevice.Device);
        };
    }
    private readonly IAdapter _bluetoothAdapter;
    private List<IDevice> _gattDevices = new List<IDevice>();

    private async Task<bool> PermissionsGrantedAsync()
    {
        bool locationServices = IsLocationServiceEnabled();
        //PermissionStatus bluetoothStatus = await CheckBluetoothPermissions();
        var locationPermissionStatus = await Permissions.CheckStatusAsync<Permissions.LocationAlways>();

        if (locationPermissionStatus != PermissionStatus.Granted)
        {
            var status = await Permissions.RequestAsync<Permissions.LocationAlways>();
            return status == PermissionStatus.Granted;
        }
        return true;
    }

/*    private async Task<PermissionStatus> CheckBluetoothPermissions()
    {
        PermissionStatus bluetoothStatus = PermissionStatus.Granted;

        if (DeviceInfo.Platform == DevicePlatform.Android)
        {
            if (DeviceInfo.Version.Major >= 12)
            {
                bluetoothStatus = await CheckPermissions<BluetoothPermissions>();
            }
            else
            {
                bluetoothStatus = await CheckPermissions<Permissions.LocationWhenInUse>();
            }
        }

        return bluetoothStatus;
    }*/
    private bool IsLocationServiceEnabled()
    {
        LocationManager locationManager = (LocationManager)Android.App.Application.Context.GetSystemService(Context.LocationService);
        return locationManager.IsProviderEnabled(LocationManager.GpsProvider);
    }

        private async void ScanButton_Clicked(object sender, EventArgs e)
    {
        IsBusyIndicator.IsVisible = IsBusyIndicator.IsRunning = !(ScanButton.IsEnabled = false);
        foundBleDevicesListView.ItemsSource = null;

        if (!await PermissionsGrantedAsync())
        {
            await DisplayAlert("Permission required", "Application needs location permission", "OK");
            IsBusyIndicator.IsVisible = IsBusyIndicator.IsRunning = !(ScanButton.IsEnabled = true);
            return;
        }

        _gattDevices.Clear();

        foreach (var device in _bluetoothAdapter.ConnectedDevices)
            _gattDevices.Add(device);

        await _bluetoothAdapter.StartScanningForDevicesAsync();

        foundBleDevicesListView.ItemsSource = _gattDevices.ToArray();
        IsBusyIndicator.IsVisible = IsBusyIndicator.IsRunning = !(ScanButton.IsEnabled = true);
    }

    private async void FoundBluetoothDevicesListView_ItemTapped(object sender, ItemTappedEventArgs e)
    {
        IsBusyIndicator.IsVisible = IsBusyIndicator.IsRunning = !(ScanButton.IsEnabled = false);
        IDevice selectedItem = e.Item as IDevice;

        if (selectedItem.State == DeviceState.Connected)
        {
            await Navigation.PushAsync(new BluetoothDataPage(selectedItem));
        }
        else
        {
            try
            {
                var connectParameters = new ConnectParameters(false, true);
                await _bluetoothAdapter.ConnectToDeviceAsync(selectedItem, connectParameters);
                await Navigation.PushAsync(new BluetoothDataPage(selectedItem));
            }
            catch
            {
                await DisplayAlert("Error connecting", $"Error connecting to BLE device: {selectedItem.Name ?? "N/A"}", "Retry");
            }
        }

        IsBusyIndicator.IsVisible = IsBusyIndicator.IsRunning = !(ScanButton.IsEnabled = true);
    }
}