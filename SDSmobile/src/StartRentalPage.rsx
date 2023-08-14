<Screen
  id="StartRentalPage"
  events={[
    {
      ordered: [
        { event: "visible" },
        { type: "state" },
        { method: "setValue" },
        { pluginId: "RequestCode" },
        { targetId: null },
        { params: { ordered: [{ value: "1" }] } },
        { waitType: "debounce" },
        { waitMs: "0" },
      ],
    },
  ]}
  title="Start Rental"
>
  <Heading
    id="NewRentalTitle"
    size="h2"
    style={{ ordered: [] }}
    textAlign="center"
    value="{{ Rental.value.stationName }}
{{ Rental.value.lockName}}"
  />
  <Heading
    id="NewRentalDetails"
    size="h3"
    textAlign="center"
    value="Hourly Rate: {{ Rental.value.hourlyRate }}"
  />
  <Button
    id="StartRentalButton"
    iconBefore="bold/interface-lock"
    size="large"
    text="Start Rental"
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
