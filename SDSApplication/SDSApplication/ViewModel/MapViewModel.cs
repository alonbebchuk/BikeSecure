using CommunityToolkit.Mvvm.ComponentModel;
using CommunityToolkit.Mvvm.Input;
using SDSApplication.Control;
using Microsoft.Maui.Controls.Maps;
using System.Collections.ObjectModel;

namespace SDSApplication.ViewModel
{
    public partial class MapViewModel : BaseViewModel
    {

        //public ObservableCollection<CustomPin> CustomPins { get; } = new();

        private ObservableCollection<CustomPin> customPins;
        public ObservableCollection<CustomPin> CustomPins
        {
            get => customPins;
            set => SetProperty(ref customPins, value, nameof(CustomPins));
        }

        private bool isSearchBarActive;

        public bool IsSearchBarActive
        {
            get => isSearchBarActive;
            set => SetProperty(ref isSearchBarActive, value);
        }


        //[RelayCommand]
        //async Task CreatePinAsync(string url)
        //{
        //    var location = await Geolocation.GetLastKnownLocationAsync();

        //    location ??= await Geolocation.Default.GetLocationAsync(new GeolocationRequest
        //    {
        //        DesiredAccuracy = GeolocationAccuracy.Best,
        //        Timeout = TimeSpan.FromSeconds(30)
        //    });

        //    var pin = new CustomPin
        //    {
        //        Label = "Me",
        //        Location = location,
        //        Type = PinType.Place,
        //        ImageSource = ImageSource.FromFile("pin.png")

        //    };

        //    CustomPins.Add(pin);
        //}

    }

}
