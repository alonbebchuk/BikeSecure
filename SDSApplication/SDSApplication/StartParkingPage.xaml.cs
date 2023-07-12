using Microsoft.Maui.Layouts;
using Newtonsoft.Json;
using System;
using System.Net.Http;
using System.Net.Http.Json;
using System.Net.Mime;
using System.Text;

namespace SDSApplication
{
    public partial class StartParkingPage : ContentPage
    {
        private static readonly HttpClient client = new HttpClient();
        private readonly string apiBaseUrl = "https://sdsbasicfunctions.azurewebsites.net"; // Update with your Azure Function base URL
        private readonly Guid lockId = new Guid("22222222-2222-2222-2222-222222222222");
        private readonly Guid userId = new Guid("11111111-1111-1111-1111-111111111111");
        private Guid processId;
        public StartParkingPage()
        {
            InitializeComponent();
        }

        private async void StartParkingButton_Clicked(object sender, EventArgs e)
        {
            var url = apiBaseUrl + "/api/TryStartParkingProcess";
            var request = new HttpRequestMessage
            {
                Method = HttpMethod.Get,
                RequestUri = new Uri(url),
                Content = JsonContent.Create(new { user_id = userId, lock_id = lockId }),
            };
            var response = await client.SendAsync(request).ConfigureAwait(false);
            response.EnsureSuccessStatusCode();
            var responseBody = await response.Content.ReadAsStringAsync().ConfigureAwait(false);
            var acquired = JsonConvert.DeserializeObject<bool>(responseBody);


            MainThread.BeginInvokeOnMainThread(async ()=>
            {
                if (acquired)
                {
                    await Navigation.PushAsync(new StopParkingPage());
                }
            });
            
        }
    }
}
