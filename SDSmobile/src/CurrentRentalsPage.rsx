<Screen
  id="CurrentRentalsPage"
  events={[
    {
      ordered: [
        { event: "visible" },
        { type: "datasource" },
        { method: "trigger" },
        { pluginId: "GetCurrentRentals" },
        { targetId: null },
        { params: { ordered: [] } },
        { waitType: "debounce" },
        { waitMs: "0" },
      ],
    },
  ]}
  title="Current"
>
  <CollectionView
    id="CurrentRentals"
    bodyByIndex=""
    cardSize="half"
    cardStyle="elevated"
    data="{{ GetCurrentRentals.data }}"
    hidden=""
    prefixIconByIndex="bold/interface-user-single"
    prefixIconColorByIndex=""
    prefixImageFitByIndex="cover"
    prefixImageShapeByIndex="square"
    prefixImageSizeByIndex="1 to 1"
    prefixImageSourceByIndex=""
    prefixTypeByIndex="none"
    showSeparator={true}
    subtitleByIndex="Start Time: {{ item.startTime }}
Current duration: {{ item.durationDays }} {{item.durationHours}}
Hourly Rate: {{ item.hourlyRate }}
Current Cost: {{ item.cost }}"
    subtitleLengthByIndex="5"
    suffixIconByIndex="bold/interface-arrows-button-right"
    suffixTextByIndex=""
    suffixTypeByIndex="text+icon"
    suffixValueByIndex="false"
    titleByIndex="{{ item.stationName }}, {{item.lockName}}"
  >
    <Event
      event="press"
      method="setValue"
      params={{ ordered: [{ value: "{{ item }}" }] }}
      pluginId="Rental"
      type="state"
      waitMs="0"
      waitType="debounce"
    />
    <Event
      event="press"
      method="navigateTo"
      params={{ ordered: [{ screenPluginId: "EndRentalPage" }] }}
      pluginId=""
      type="navigator"
      waitMs="0"
      waitType="debounce"
    />
  </CollectionView>
</Screen>
