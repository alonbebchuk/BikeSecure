<Screen
  id="RentalSummaryPage"
  events={[
    {
      ordered: [
        { event: "visible" },
        { type: "util" },
        { method: "showNotification" },
        { pluginId: "" },
        { targetId: null },
        {
          params: {
            ordered: [
              {
                options: {
                  ordered: [
                    { notificationType: "info" },
                    { title: "Station Unlocked" },
                    { description: "DON'T FORGET TO TAKE YOUR BIKE" },
                  ],
                },
              },
            ],
          },
        },
        { waitType: "debounce" },
        { waitMs: "0" },
      ],
    },
  ]}
  headerLeftActions={[
    {
      ordered: [
        { type: "text" },
        { value: "" },
        {
          event: {
            ordered: [
              { event: "click" },
              { method: "trigger" },
              { pluginId: "" },
              { type: "datasource" },
              { waitMs: 0 },
              { waitType: "debounce" },
            ],
          },
        },
      ],
    },
  ]}
  headerRightActions={[
    {
      ordered: [
        { type: "text" },
        { value: "Done" },
        {
          event: {
            ordered: [
              { event: "click" },
              { method: "navigateTo" },
              { pluginId: "" },
              { type: "navigator" },
              { waitMs: 0 },
              { waitType: "debounce" },
              { params: { ordered: [{ screenPluginId: "HomePage" }] } },
            ],
          },
        },
      ],
    },
  ]}
  title="Rental Summary"
>
  <Heading
    id="PastRentalTitle"
    size="h2"
    textAlign="center"
    value="{{ Rental.value.stationName}}
{{ Rental.value.lockName }}"
  />
  <Heading
    id="PastRentalDetails"
    size="h3"
    textAlign="center"
    value="Start Time: {{ Rental.value.startTime }}
End Time: {{ Rental.value.endTime }}
Duration: {{ Rental.value.durationDays }} {{Rental.value.durationHours}}
Hourly Rate: {{ Rental.value.hourlyRate }}
Total Cost: {{ Rental.value.cost }}"
  />
</Screen>
