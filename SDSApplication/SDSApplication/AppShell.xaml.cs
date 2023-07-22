using SDSApplication.Views;

namespace SDSApplication;

public partial class AppShell : Shell
{
	public AppShell()
	{
		InitializeComponent();
        Routing.RegisterRoute("mainview", typeof(MainView));
        Routing.RegisterRoute("scopeview", typeof(ScopeView));
        Routing.RegisterRoute("mainpageview", typeof(MainPage));
        Routing.RegisterRoute(nameof(HomePage), typeof(HomePage));
        Routing.RegisterRoute(nameof(HeartRatePage), typeof(HeartRatePage));
    }
}
