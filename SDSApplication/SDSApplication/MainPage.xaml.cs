using AndroidX.Lifecycle;
using SDSApplication.MSALClient;
using SDSApplication.ViewModel;

namespace SDSApplication;

public partial class MainPage : ContentPage
{
    private static readonly HttpClient client = new();
    //private readonly String apiBaseUrl = "https://azurefunctions.azurewebsites.net"; // Update
    private MapViewModel mapViewModel;

    public MainPage()
	{
		InitializeComponent();
	}

    private async void Scan_Lock_Clicked(object sender, EventArgs e)
    {
        await Navigation.PushAsync(new StartParkingPage());
    }

    private async void Scan_Barcode_Clicked(object sender, EventArgs e)
    {
        await Navigation.PushAsync(new BarcodeScanningPage());
    }

    private async void Map_Clicked(object sender, EventArgs e)
    {
        await Navigation.PushAsync(new Views.MapPage(mapViewModel));
    }

    private async void More_Information_Clicked(object sender, EventArgs e)
    {
        await Navigation.PushAsync(new MoreInformationPage());
    }
    private async void SignOutButton_Clicked(object sender, EventArgs e)
    {
        await PublicClientSingleton.Instance.SignOutAsync().ContinueWith((t) =>
        {
            return Task.CompletedTask;
        });

        await Shell.Current.GoToAsync("mainview");
    }

}

