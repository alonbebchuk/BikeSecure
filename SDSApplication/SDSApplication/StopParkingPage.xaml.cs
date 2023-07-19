using Newtonsoft.Json;
using System.Net.Http.Json;

namespace SDSApplication;

public partial class StopParkingPage : ContentPage
{
    private static readonly HttpClient client = new HttpClient();
    private readonly string apiBaseUrl = "https://sdsbasicfunctions.azurewebsites.net"; // Update with your Azure Function base URL
    private readonly Guid lockId = new Guid("22222222-2222-2222-2222-222222222222");
    private Guid processId;
    public StopParkingPage()
	{
		InitializeComponent();
	}

    private async void StopParkingButton_Clicked(object sender, EventArgs e)
    {
        var url = apiBaseUrl + "/api/ReleaseLockOwnership";
        var request = new HttpRequestMessage
        {
            Method = HttpMethod.Get,
            RequestUri = new Uri(url),
            Content = JsonContent.Create(new { id = lockId }),
        };
        var response = await client.SendAsync(request).ConfigureAwait(false);
        response.EnsureSuccessStatusCode();
        var responseBody = await response.Content.ReadAsStringAsync().ConfigureAwait(false);
        var acquired = JsonConvert.DeserializeObject<bool>(responseBody);


        MainThread.BeginInvokeOnMainThread(async () =>
        {
            if (acquired)
            {
                await Navigation.PushAsync(new NiceRidePage());
            }
        });
    }

    private void LockedButton_Clicked(object sender, EventArgs e)
    {
        changeLockState("Locked");
    }

    private void OpenButton_Clicked(object sender, EventArgs e)
    {
        changeLockState("Unlocked");
    }

    private async void changeLockState(string state)
    {
        var url = apiBaseUrl + "/api/ChangeLockState/" + state;
        var content = JsonContent.Create(new { id = lockId });
        var response = await client.PostAsync(url, content);
        var responseBody = await response.Content.ReadAsStringAsync().ConfigureAwait(false);
        //processId = JsonConvert.DeserializeObject<Guid>(responseBody);
    }

    private void SetLockButtonsEnabled(bool enabled)
    {
        lockedButton.IsEnabled = enabled;
        openButton.IsEnabled = enabled;

        if (enabled)
        {
            lockedButton.Opacity = 1;
            openButton.Opacity = 1;
        }
        else
        {
            lockedButton.Opacity = 0.1;
            openButton.Opacity = 0.1;
        }
    }
}