<Screen
  id="StationsPage"
  events={[
    {
      ordered: [
        { event: "visible" },
        { type: "datasource" },
        { method: "trigger" },
        { pluginId: "ClearStationsPage" },
        { targetId: null },
        { params: { ordered: [] } },
        { waitType: "debounce" },
        { waitMs: "0" },
      ],
    },
  ]}
  headerRightActions={[
    {
      ordered: [
        { type: "icon" },
        { value: "bold/interface-text-formatting-eraser-alternate" },
        {
          event: {
            ordered: [
              { event: "click" },
              { method: "trigger" },
              { pluginId: "ClearStationsPage" },
              { type: "datasource" },
              { waitMs: 0 },
              { waitType: "debounce" },
            ],
          },
        },
      ],
    },
  ]}
  title="Stations"
>
  <TextArea
    id="SearchStation"
    iconBefore="bold/interface-search"
    label={null}
    minLines={1}
    placeholder="Search..."
  >
    <Event
      event="change"
      method="trigger"
      params={{ ordered: [] }}
      pluginId="GetMatchingStations"
      type="datasource"
      waitMs="0"
      waitType="debounce"
    />
  </TextArea>
  <CollectionView
    id="Stations"
    bodyByIndex=""
    data="{{ GetMatchingStations.data }}"
    hidden=""
    prefixIconByIndex="bold/interface-user-single"
    prefixIconColorByIndex=""
    prefixImageFitByIndex="cover"
    prefixImageShapeByIndex="square"
    prefixImageSizeByIndex="1 to 1"
    prefixImageSourceByIndex=""
    prefixTypeByIndex="none"
    showSeparator={true}
    subtitleByIndex="Distance: {{ item.distance }}
Hourly Rate: {{ item.hourlyRate }}
Available Locks: {{ item.freeLockCount }}
Owned Locks: {{ item.ownedLockCount }}"
    subtitleLengthByIndex="4"
    suffixIconByIndex="bold/interface-arrows-button-right"
    suffixTextByIndex="Directions"
    suffixTypeByIndex="button"
    suffixValueByIndex="false"
    titleByIndex="{{ item.name }}"
  >
    <Event
      event="buttonPress"
      method="openUrl"
      params={{
        ordered: [
          {
            url: "{{ `https://www.google.com/maps/dir/?api=1&destination=${item.latitude},${item.longitude}` }}",
          },
        ],
      }}
      pluginId=""
      type="util"
      waitMs="0"
      waitType="debounce"
    />
  </CollectionView>
</Screen>
