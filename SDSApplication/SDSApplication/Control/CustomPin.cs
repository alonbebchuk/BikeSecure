using Microsoft.Maui.Controls.Maps;

// This control has a bindable property (used with data binding in XAML) ImageSource that allows us to choose any image source to store our pin icon
namespace SDSApplication.Control
{
    public class CustomPin : Pin
    {
        public static readonly BindableProperty ImageSourceProperty =
            BindableProperty.Create(nameof(ImageSource), typeof(ImageSource), typeof(CustomPin));

        public ImageSource? ImageSource
        {
            get => (ImageSource?)GetValue(ImageSourceProperty);
            set => SetValue(ImageSourceProperty, value);
        }

        // New properties
        public static readonly BindableProperty StatusProperty =
            BindableProperty.Create(nameof(Status), typeof(bool), typeof(CustomPin), false);

        public bool Status
        {
            get => (bool)GetValue(StatusProperty);
            set => SetValue(StatusProperty, value);
        }

        public static readonly BindableProperty DistanceProperty =
            BindableProperty.Create(nameof(Distance), typeof(double), typeof(CustomPin), default(double));

        public double Distance
        {
            get => (double)GetValue(DistanceProperty);
            set => SetValue(DistanceProperty, value);
        }
    }
}