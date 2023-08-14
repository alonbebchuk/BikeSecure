<Screen
  id="PastRentalsPage"
  events={[
    {
      ordered: [
        { event: "visible" },
        { type: "datasource" },
        { method: "trigger" },
        { pluginId: "GetPastRentals" },
        { targetId: null },
        { params: { ordered: [] } },
        { waitType: "debounce" },
        { waitMs: "0" },
        { enabled: "" },
      ],
    },
  ]}
  title="History"
>
  <CollectionView
    id="PastRentals"
    bodyByIndex=""
    data="{{ GetPastRentals.data }}"
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
End Time: {{ item.endTime }}
Duration: {{ item.durationDays }} {{item.durationHours}}
Hourly Rate: {{ item.hourlyRate }}
Total Cost: {{ item.cost }}"
    subtitleLengthByIndex="6"
    suffixIconByIndex="bold/interface-arrows-button-right"
    suffixTextByIndex="Button"
    suffixTypeByIndex="none"
    suffixValueByIndex="false"
    titleByIndex="{{ item.stationName }}, {{item.lockName}}"
  />
</Screen>
