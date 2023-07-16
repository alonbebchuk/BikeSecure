using Newtonsoft.Json;
using System.Net.Http.Json;

namespace SDSApplication;

public partial class CurrentParkingsPage : ContentPage
{
    private static readonly HttpClient client = new();
    private readonly string apiBaseUrl = "https://azurefunctions.azurewebsites.net"; // Update
    private readonly Guid userId = new Guid("11111111-1111-1111-1111-111111111111");

    public CurrentParkingsPage()
	{
		InitializeComponent();
        LoadUserCurrentParking();
    }

    private async void LoadUserCurrentParking()
    {
        var currentParkings = await GetUserCurrentParkingsMock();
        listCurrentParkings.ItemsSource = currentParkings;
    }

    private async Task<List<CurrentParkingProcessItem>> GetUserCurrentParkings()
    {
        var url = apiBaseUrl + "/api/GetUserParkingProcessHistory/";
        var request = new HttpRequestMessage
        {
            Method = HttpMethod.Get,
            RequestUri = new Uri(url),
            Content = JsonContent.Create(new { user_id = userId }),
        };
        var response = await client.SendAsync(request).ConfigureAwait(false);
        response.EnsureSuccessStatusCode();
        var json = await response.Content.ReadAsStringAsync();
        var currentParkings = JsonConvert.DeserializeObject<List<CurrentParkingProcessItem>>(json);
        return currentParkings;
    }

    private async Task<List<CurrentParkingProcessItem>> GetUserCurrentParkingsMock()
    {
        var mockResponseContent = JsonConvert.SerializeObject(new List<CurrentParkingProcessItem>
            {
                new CurrentParkingProcessItem { lockId = new Guid("a6d8b7e2-834c-4f0e-9c48-13a3bcb1568f"), startTime = new DateTime(2023, 7, 10, 10, 30, 0), duration = 48 },
                new CurrentParkingProcessItem { lockId = new Guid("b0a9c5d3-132a-48f1-8d65-39c206c3656e"), startTime = new DateTime(2023, 7, 10, 15, 0, 0), duration = 1 },
                new CurrentParkingProcessItem { lockId = new Guid("e7d984f9-5d09-4165-a14c-650b4b9ae7db"), startTime = new DateTime(2023, 7, 10, 8, 15, 0), duration = 2 }
            });
        var currentParkings = JsonConvert.DeserializeObject<List<CurrentParkingProcessItem>>(mockResponseContent);
        return currentParkings;
    }
}