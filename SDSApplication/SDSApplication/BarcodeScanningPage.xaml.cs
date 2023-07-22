using BarcodeScanner.Mobile;

namespace SDSApplication;

public partial class BarcodeScanningPage : ContentPage
{
	public BarcodeScanningPage()
	{
		InitializeComponent();
        BarcodeScanner.Mobile.Methods.AskForRequiredPermission();
    }

    private void Camera_OnDetected(object sender, BarcodeScanner.Mobile.OnDetectedEventArg e)
    {
        List<BarcodeResult> obj = e.BarcodeResults;

        string result = string.Empty;
        for (int i = 0; i < obj.Count; i++)
        {
            result += $"Type: {obj[i].BarcodeType}, Value: {obj[i].DisplayValue}{Environment.NewLine}";
        }

        Dispatcher.Dispatch(async () =>
        {
            await DisplayAlert("Result", result, "OK");
            // If we will want to start scanning again - if the lock is unavailable for example
            Camera.IsScanning = true;
        });
    }
}