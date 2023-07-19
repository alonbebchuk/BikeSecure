using Newtonsoft.Json;
using System.Net.Http.Json;

namespace SDSApplication;

public partial class TransactionPage : ContentPage
{
    private static readonly HttpClient client = new();
    private readonly string apiBaseUrl = "https://azurefunctions.azurewebsites.net"; // Update
    private readonly Guid userId = new Guid("11111111-1111-1111-1111-111111111111");

    public TransactionPage()
	{
		InitializeComponent();
        LoadUserTransactions();
    }

    private async void LoadUserTransactions()
    {
        var currentParkings = await GetUserTransactionsMock();
        listUserTransactions.ItemsSource = currentParkings;
    }

    private async Task<List<TransactionItem>> GetUserTransactions()
    {
        var url = apiBaseUrl + "/api/GetUserTransactions/";
        var request = new HttpRequestMessage
        {
            Method = HttpMethod.Get,
            RequestUri = new Uri(url),
            Content = JsonContent.Create(new { user_id = userId }),
        };
        var response = await client.SendAsync(request).ConfigureAwait(false);
        response.EnsureSuccessStatusCode();
        var json = await response.Content.ReadAsStringAsync();
        var userTransactions = JsonConvert.DeserializeObject<List<TransactionItem>>(json);
        return userTransactions;
    }

    private async Task<List<TransactionItem>> GetUserTransactionsMock()
    {
        var mockResponseContent = JsonConvert.SerializeObject(new List<TransactionItem>
            {
                new TransactionItem { id = 1, userId = new Guid("a6d8b7e2-834c-4f0e-9c48-13a3bcb1568f"), dateTime = new DateTime(2023, 7, 10, 10, 30, 0), amount = 100 },
                new TransactionItem { id = 2, userId = new Guid("b0a9c5d3-132a-48f1-8d65-39c206c3656e"), dateTime = new DateTime(2023, 7, 10, 15, 0, 0), amount = 20 },
                new TransactionItem { id = 3, userId = new Guid("e7d984f9-5d09-4165-a14c-650b4b9ae7db"), dateTime = new DateTime(2023, 7, 10, 8, 15, 0), amount = 10 }
            });
        var userTransactions = JsonConvert.DeserializeObject<List<TransactionItem>>(mockResponseContent);
        return userTransactions;
    }
}