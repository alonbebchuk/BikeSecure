using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Net.Http;
using System.Threading.Tasks;
using Microsoft.Maui.Controls;

namespace SDSApplication
{
    public partial class ParkingsHistoryPage : ContentPage
    {
        private static readonly HttpClient client = new();
        private readonly string apiBaseUrl = "https://azurefunctions.azurewebsites.net"; // Update

        public ParkingsHistoryPage()
        {
            InitializeComponent();
            LoadUserParkingHistory();
        }

        private async void LoadUserParkingHistory()
        {
            var parkingHistory = await GetUserParkingHistory();
            listParkingHistory.ItemsSource = parkingHistory;
        }   

        private async Task<List<ParkingProcessItem>> GetUserParkingHistory()
        {
            var userId = new Guid("dd540abf-a47f-4b61-ac9d-5bc562af4945");
            var url = apiBaseUrl + "/api/GetUserParkingProcessHistory/";
            var response = await client.GetAsync(url);
            response.EnsureSuccessStatusCode();
            var json = await response.Content.ReadAsStringAsync();
            var parkingHistory = JsonConvert.DeserializeObject<List<ParkingProcessItem>>(json);
            return parkingHistory;
        }
    }
}
