<MobileApp>
  <Include src="./functions.rsx" />
  <TabScreen
    id="tabscreen"
    items={[
      {
        ordered: [
          { screen: "HomePage" },
          { detailScreen: "" },
          { icon: "bold/interface-home-1" },
          { title: "Home" },
        ],
      },
      {
        ordered: [
          { screen: "CurrentRentalsPage" },
          { title: "Current" },
          { icon: "bold/image-flash-1" },
        ],
      },
      {
        ordered: [
          { screen: "PastRentalsPage" },
          { title: "History" },
          { icon: "bold/interface-time-clock-circle-alternate" },
        ],
      },
      {
        ordered: [
          { screen: "StationsPage" },
          { detailScreen: "" },
          { title: null },
          { icon: "bold/interface-dashboard-layout-square" },
        ],
      },
    ]}
  />
  <Include src="./src/HomePage.rsx" />
  <Include src="./src/CurrentRentalsPage.rsx" />
  <Include src="./src/PastRentalsPage.rsx" />
  <Include src="./src/EndRentalPage.rsx" />
  <Include src="./src/StartRentalPage.rsx" />
  <Include src="./src/StationsPage.rsx" />
  <Include src="./src/RentalSummaryPage.rsx" />
  <Frame id="$main" type="main" />
</MobileApp>
