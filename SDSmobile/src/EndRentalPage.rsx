<Screen
  id="EndRentalPage"
  events={[
    {
      ordered: [
        { event: "visible" },
        { type: "state" },
        { method: "setValue" },
        { pluginId: "RequestCode" },
        { targetId: null },
        { params: { ordered: [{ value: "0" }] } },
        { waitType: "debounce" },
        { waitMs: "0" },
      ],
    },
  ]}
  title="End Rental"
>
  <Heading
    id="CurrentRentalTitle"
    size="h2"
    style={{ ordered: [] }}
    textAlign="center"
    value="{{ Rental.value.stationName }}
{{ Rental.value.lockName }}"
  />
  <Heading
    id="CurrentRentalDetails"
    size="h3"
    textAlign="center"
    value="Start Time: {{ Rental.value.startTime }}
Current duration: {{ Rental.value.durationDays }} {{Rental.value.durationHours}}
Hourly Rate: {{ Rental.value.hourlyRate }}
Current Cost: {{ Rental.value.cost }}"
  />
  <Button
    id="DirectionsButton"
    iconBefore="bold/travel-map-navigation-arrow-1"
    size="large"
    text="Direction"
  >
    <Event
      event="click"
      method="openUrl"
      params={{
        ordered: [
          {
            url: "https://www.google.com/maps/dir/{{GetLocation.data.latitude}},{{GetLocation.data.longitude}}/{{Rental.value.latitude}},{{Rental.value.longitude}}/",
          },
        ],
      }}
      pluginId=""
      type="util"
      waitMs="0"
      waitType="debounce"
    />
  </Button>
  <Button
    id="EndRentalButton"
    iconBefore="bold/interface-unlock"
    size="large"
    text="End Rental"
  >
    <Event
      event="click"
      method="trigger"
      params={{ ordered: [] }}
      pluginId="RentalRequest"
      type="datasource"
      waitMs="0"
      waitType="debounce"
    />
  </Button>
</Screen>
