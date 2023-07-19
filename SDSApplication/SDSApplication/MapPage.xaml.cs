using Microsoft.Maui.Controls.Maps;

namespace SDSApplication
{
    public partial class MapPage : ContentPage
    {
        public MapPage()
        {
            InitializeComponent();

            
            var pin = new Pin
            {
                Label = "Smart Docking Station",
                Location = new Location(32.136823861209905, 34.83708761019526),
                Type = PinType.Place,
            };
            pin.Label = "5/10 locks in use";
            mappy.Pins.Add(pin);
        }

        protected async override void OnAppearing()
        {
            base.OnAppearing();

            await Permissions.RequestAsync<Permissions.LocationWhenInUse>();
        }
    }
}
