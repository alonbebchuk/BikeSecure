namespace SDSApplication;

public partial class MoreInformationPage : ContentPage
{
	public MoreInformationPage()
	{
		InitializeComponent();
	}

    private async void TransactionClicked(object sender, EventArgs e)
    {
        await Navigation.PushAsync(new TransactionPage());
    }

    private async void CurrentParkingHistoryClicked(object sender, EventArgs e)
    {
        await Navigation.PushAsync(new CurrentParkingsPage());
    }

    private async void ParkingHistoryClicked(object sender, EventArgs e)
    {
        await Navigation.PushAsync(new ParkingsHistoryPage());
    }
}