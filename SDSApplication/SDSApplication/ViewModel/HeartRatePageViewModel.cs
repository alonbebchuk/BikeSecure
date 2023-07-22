using Microsoft.Maui.Controls;
using Org.Apache.Http.Authentication;
using SDSApplication.Uuids;
using SDSApplication.ViewModel;
using System.Text;

namespace SDSApplication.ViewModels;

public partial class HeartRatePageViewModel : BaseViewModel
{
    public BluetoothLEService BluetoothLEService { get; private set; }

    public IAsyncRelayCommand ConnectToDeviceCandidateAsyncCommand { get; }
    public IAsyncRelayCommand DisconnectFromDeviceAsyncCommand { get; }
    public IAsyncRelayCommand SendToDeviceAsyncCommand { get; }

    public IService HeartRateService { get; set; }
    public ICharacteristic HeartRateMeasurementCharacteristic { get; set; }
    public HeartRatePageViewModel(BluetoothLEService bluetoothLEService)
    {
        Title = $"Heart rate";

        BluetoothLEService = bluetoothLEService;

        ConnectToDeviceCandidateAsyncCommand = new AsyncRelayCommand(ConnectToDeviceCandidateAsync);

        DisconnectFromDeviceAsyncCommand = new AsyncRelayCommand(DisconnectFromDeviceAsync);

        SendToDeviceAsyncCommand = new AsyncRelayCommand<string>(SendToDeviceAsync);

    }

    [ObservableProperty]
    string heartRateValue;

    [ObservableProperty]
    DateTimeOffset timestamp;

    private async Task SendToDeviceAsync(string command)
    {
        if (IsBusy)
        {
            return;
        }
        if (BluetoothLEService.Device.State == DeviceState.Connected)
        {
            HeartRateService = await BluetoothLEService.Device.GetServiceAsync(UartGattUuids.UartGattServiceUuid);
            if (HeartRateService != null)
            {
                HeartRateMeasurementCharacteristic = await HeartRateService.GetCharacteristicAsync(UartGattUuids.UartGattCharacteristicSendId);
                if (HeartRateMeasurementCharacteristic != null)
                {
                    if (HeartRateMeasurementCharacteristic.CanWrite)
                    {
                        await HeartRateMeasurementCharacteristic.WriteAsync(Encoding.ASCII.GetBytes(command));
                    }
                }
            }
        }
    }
    private async Task ConnectToDeviceCandidateAsync()
    {
        if (IsBusy)
        {
            return;
        }

        if (BluetoothLEService.NewDeviceCandidateFromHomePage.Id.Equals(Guid.Empty))
        {
            #region read device id from storage
            var device_name = await SecureStorage.Default.GetAsync("device_name");
            var device_id = await SecureStorage.Default.GetAsync("device_id");
            if (!string.IsNullOrEmpty(device_id))
            {
                BluetoothLEService.NewDeviceCandidateFromHomePage.Name = device_name;
                BluetoothLEService.NewDeviceCandidateFromHomePage.Id = Guid.Parse(device_id);
            }
            #endregion read device id from storage
            else
            {
                await BluetoothLEService.ShowToastAsync($"Select a Bluetooth LE device first. Try again.");
                return;
            }
        }

        if (!BluetoothLEService.BluetoothLE.IsOn)
        {
            await Shell.Current.DisplayAlert($"Bluetooth is not on", $"Please turn Bluetooth on and try again.", "OK");
            return;
        }

        if (BluetoothLEService.Adapter.IsScanning)
        {
            await BluetoothLEService.ShowToastAsync($"Bluetooth adapter is scanning. Try again.");
            return;
        }

        try
        {
            IsBusy = true;

            if (BluetoothLEService.Device != null)
            {
                if (BluetoothLEService.Device.State == DeviceState.Connected)
                {
                    if (BluetoothLEService.Device.Id.Equals(BluetoothLEService.NewDeviceCandidateFromHomePage.Id))
                    {
                        await BluetoothLEService.ShowToastAsync($"{BluetoothLEService.Device.Name} is already connected.");
                        return;
                    }

                    if (BluetoothLEService.NewDeviceCandidateFromHomePage != null)
                    {
                        #region another device
                        if (!BluetoothLEService.Device.Id.Equals(BluetoothLEService.NewDeviceCandidateFromHomePage.Id))
                        {
                            Title = $"{BluetoothLEService.NewDeviceCandidateFromHomePage.Name}";
                            await DisconnectFromDeviceAsync();
                            await BluetoothLEService.ShowToastAsync($"{BluetoothLEService.Device.Name} has been disconnected.");
                        }
                        #endregion another device
                    }
                }
            }

            BluetoothLEService.Device = await BluetoothLEService.Adapter.ConnectToKnownDeviceAsync(BluetoothLEService.NewDeviceCandidateFromHomePage.Id);

            if (BluetoothLEService.Device.State == DeviceState.Connected)
            {
                HeartRateService = await BluetoothLEService.Device.GetServiceAsync(UartGattUuids.UartGattServiceUuid);
                if (HeartRateService != null)
                {
                    HeartRateMeasurementCharacteristic = await HeartRateService.GetCharacteristicAsync(UartGattUuids.UartGattCharacteristicReceiveId);
                    if (HeartRateMeasurementCharacteristic != null)
                    {
                        if (HeartRateMeasurementCharacteristic.CanUpdate)
                        {
                            Title = $"{BluetoothLEService.Device.Name}";

                            #region save device id to storage
                            await SecureStorage.Default.SetAsync("device_name", $"{BluetoothLEService.Device.Name}");
                            await SecureStorage.Default.SetAsync("device_id", $"{BluetoothLEService.Device.Id}");
                            #endregion save device id to storage

                            HeartRateMeasurementCharacteristic.ValueUpdated += HeartRateMeasurementCharacteristic_ValueUpdated;
                            await HeartRateMeasurementCharacteristic.StartUpdatesAsync();
                        }
                    }
                }
            }
        }
        catch (Exception ex)
        {
            Debug.WriteLine($"Unable to connect to {BluetoothLEService.NewDeviceCandidateFromHomePage.Name} {BluetoothLEService.NewDeviceCandidateFromHomePage.Id}: {ex.Message}.");
            await Shell.Current.DisplayAlert($"{BluetoothLEService.NewDeviceCandidateFromHomePage.Name}", $"Unable to connect to {BluetoothLEService.NewDeviceCandidateFromHomePage.Name}.", "OK");
        }
        finally
        {
            IsBusy = false;
        }
    }

    private void HeartRateMeasurementCharacteristic_ValueUpdated(object sender, CharacteristicUpdatedEventArgs e)
    {
        var bytes = e.Characteristic.Value;
        HeartRateValue = Encoding.ASCII.GetString(bytes);
        Timestamp = DateTimeOffset.Now.LocalDateTime;
    }

    private async Task DisconnectFromDeviceAsync()
    {
        if (IsBusy)
        {
            return;
        }

        if (BluetoothLEService.Device == null)
        {
            await BluetoothLEService.ShowToastAsync($"Nothing to do.");
            return;
        }

        if (!BluetoothLEService.BluetoothLE.IsOn)
        {
            await Shell.Current.DisplayAlert($"Bluetooth is not on", $"Please turn Bluetooth on and try again.", "OK");
            return;
        }

        if (BluetoothLEService.Adapter.IsScanning)
        {
            await BluetoothLEService.ShowToastAsync($"Bluetooth adapter is scanning. Try again.");
            return;
        }

        if (BluetoothLEService.Device.State == DeviceState.Disconnected)
        {
            await BluetoothLEService.ShowToastAsync($"{BluetoothLEService.Device.Name} is already disconnected.");
            return;
        }

        try
        {
            IsBusy = true;

            await HeartRateMeasurementCharacteristic.StopUpdatesAsync();

            await BluetoothLEService.Adapter.DisconnectDeviceAsync(BluetoothLEService.Device);

            HeartRateMeasurementCharacteristic.ValueUpdated -= HeartRateMeasurementCharacteristic_ValueUpdated;
        }
        catch (Exception ex)
        {
            Debug.WriteLine($"Unable to disconnect from {BluetoothLEService.Device.Name} {BluetoothLEService.Device.Id}: {ex.Message}.");
            await Shell.Current.DisplayAlert($"{BluetoothLEService.Device.Name}", $"Unable to disconnect from {BluetoothLEService.Device.Name}.", "OK");
        }
        finally
        {
            Title = "Heart rate";
            HeartRateValue = "no value";
            Timestamp = DateTimeOffset.MinValue;
            IsBusy = false;
            BluetoothLEService.Device?.Dispose();
            BluetoothLEService.Device = null;
            await Shell.Current.GoToAsync("//HomePage", true);
        }
    }
}
