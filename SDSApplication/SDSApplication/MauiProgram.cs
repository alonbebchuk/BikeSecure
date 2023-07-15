using BarcodeScanner.Mobile;

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
			.UseMauiMaps()
            .ConfigureMauiHandlers(handlers =>
            {
                // Add the handlers
                handlers.AddBarcodeScannerHandler();
            });

		return builder.Build();
	}
}
