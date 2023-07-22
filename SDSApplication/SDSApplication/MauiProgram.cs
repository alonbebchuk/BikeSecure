using BarcodeScanner.Mobile;
using CommunityToolkit.Maui;
using SDSApplication.ViewModels;
using SDSApplication.Services;
using SDSApplication.ViewModel;
using SDSApplication.Views;

namespace SDSApplication;

public static class MauiProgram
{
	public static MauiApp CreateMauiApp()
	{
		var builder = MauiApp.CreateBuilder();
		builder
			.UseMauiApp<App>()
            .ConfigureFonts(fonts =>
			{
				fonts.AddFont("OpenSans-Regular.ttf", "OpenSansRegular");
				fonts.AddFont("OpenSans-Semibold.ttf", "OpenSansSemibold");
			})
            .UseMauiCommunityToolkit()
            .UseMauiMaps()
            .ConfigureMauiHandlers(handlers =>
            {
                handlers.AddBarcodeScannerHandler();
				handlers.AddHandler<Microsoft.Maui.Controls.Maps.Map, CustomMapHandler>();
            });
        builder
            .RegisterAppServices()
            .RegisterViewModels()
            .RegisterViews();

        builder.Services.AddSingleton<BluetoothLEService>();
        
        builder.Services.AddSingleton<IConnectivity>(Connectivity.Current);
        builder.Services.AddSingleton<IGeolocation>(Geolocation.Default);
        builder.Services.AddSingleton<IMap>(Map.Default);
        
        builder.Services.AddSingleton<HomePageViewModel>();
        builder.Services.AddSingleton<HomePage>();

        builder.Services.AddSingleton<HeartRatePageViewModel>();
        builder.Services.AddSingleton<HeartRatePage>();

        return builder.Build();
	}

    public static MauiAppBuilder RegisterAppServices(this MauiAppBuilder builder)
    {
        return builder;
    }

    public static MauiAppBuilder RegisterViewModels(this MauiAppBuilder builder)
    {
        builder.Services.AddSingleton<MapViewModel>();
        return builder;
    }

    public static MauiAppBuilder RegisterViews(this MauiAppBuilder builder)
    {
        builder.Services.AddSingleton<MapPage>();
        return builder;
    }
}
