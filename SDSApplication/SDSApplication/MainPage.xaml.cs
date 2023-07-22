using AndroidX.Lifecycle;
using SDSApplication.MSALClient;
using SDSApplication.ViewModel;
using SDSApplication.ViewModels;

namespace SDSApplication;

public partial class MainPage : ContentPage
{
    private static readonly HttpClient client = new();
    //private readonly String apiBaseUrl = "https://azurefunctions.azurewebsites.net"; // Update
    readonly MapViewModel mapViewModel;

    public MainPage()
	{
		InitializeComponent();

        // Applications back-button override - logout alert (instead of moving page) : https://learn.microsoft.com/en-us/dotnet/maui/fundamentals/shell/navigation?view=net-maui-7.0#back-button-behavior
        Shell.SetBackButtonBehavior(this, new BackButtonBehavior
        {
            Command = new Command(OnLogout),
            IconOverride = "bye_icon.png"
        });
    }

    // Buttons
    private async void Scan_Lock_Clicked(object sender, EventArgs e)
    {
        await Navigation.PushAsync(new StartParkingPage());
    }

    private async void Scan_Barcode_Clicked(object sender, EventArgs e)
    {
        await Navigation.PushAsync(new BarcodeScanningPage());
    }

    private async void Scan_Bluetooth_Clicked(object sender, EventArgs e)
    {
        //await Navigation.PushAsync(new HomePage(homeViewModel));
        await Shell.Current.GoToAsync("//HomePage", true);
    }

    private async void Map_Clicked(object sender, EventArgs e)
    {
        await Navigation.PushAsync(new Views.MapPage(mapViewModel));
    }

    private async void CurrentParkingsClicked(object sender, EventArgs e)
    {
        await Navigation.PushAsync(new CurrentParkingsPage());
    }

    private async void ParkingHistoryClicked(object sender, EventArgs e)
    {
        await Navigation.PushAsync(new ParkingsHistoryPage());
    }
    private async void LogOutButton_Clicked(object sender, EventArgs e)
    {
        await PublicClientSingleton.Instance.SignOutAsync().ContinueWith((t) =>
        {
            return Task.CompletedTask;
        });

        await Shell.Current.GoToAsync("mainview");
    }
    private void ExitApplicationButton_Clicked(object sender, EventArgs e)
    {
        Application.Current.Quit(); ;
    }

    // Applications back-button override - logout alert
    private async void OnLogout()
    {
        bool logout = await DisplayAlert("Logout", "Do you want to log out?", "Yes", "No");

        if (logout)
        {
            await PublicClientSingleton.Instance.SignOutAsync().ContinueWith((t) =>
            {
                return Task.CompletedTask;
            });

            await Shell.Current.GoToAsync("mainview");
        }
    }

    // Androids back-button override - exit the app : https://github.com/dotnet/maui/issues/9804
    protected override bool OnBackButtonPressed()
    {
        Application.Current.Quit();
        return true;
    }
}

