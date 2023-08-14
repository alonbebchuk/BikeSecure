<App>
  <Include src="./functions.rsx" />
  <AppStyles id="$appStyles" css="" />
  <Include src="./header.rsx" />
  <Include src="./sidebar.rsx" />
  <Frame
    id="$main"
    _disclosedFields={{ array: [] }}
    isHiddenOnDesktop={false}
    isHiddenOnMobile={false}
    paddingType="normal"
    sticky={false}
    style={{ ordered: [{ canvas: "#ffffff" }] }}
    type="main"
  >
    <Container
      id="mapViewContainer"
      showBody={true}
      showHeader={true}
      style={{ ordered: [{ border: "rgba(199, 199, 199, 0)" }] }}
    >
      <Header>
        <Text
          id="mapViewContainerTitle"
          horizontalAlign="center"
          imageWidth="fill"
          style={{ ordered: [{ background: "rgba(0, 0, 0, 0)" }] }}
          value="#### 𝐌𝐚𝐩 𝐕𝐢𝐞𝐰"
          verticalAlign="center"
        />
      </Header>
      <View id="39a35" viewKey="View 1">
        <Map
          id="Map"
          latitude="{{ getCurrentLocation.data.latitude }}"
          longitude="{{ getCurrentLocation.data.longitude }}"
          marginType="normal"
          onPointSelected="getSelectedStation"
          points="{{ getStationsLocations.data }}"
          pointValue="🅿️"
          showCurrentLngLat={true}
          zoom="12"
        />
        <Container
          id="linkCard1"
          showBody={true}
          style={{
            ordered: [
              { border: "rgba(199, 199, 199, 0)" },
              { background: "rgba(100, 204, 197, 0.15)" },
            ],
          }}
        >
          <Text
            id="stationNameLinkCard"
            style={{
              ordered: [
                { color: "{{ linkCard1.hovered ? theme.primary : '' }}" },
              ],
            }}
            value="#### **{{ getSelectedStation.data.name }}**
"
            verticalAlign="center"
          />
          <Icon
            id="parkingIcon"
            horizontalAlign="right"
            icon="bold/travel-hotel-parking-sign-alternate"
            style={{ ordered: [{ background: "canvas" }] }}
            styleVariant="background"
          />
          <Text
            id="stationDetailsLinkCard"
            value="**Hourly Rate** (₪) **:** {{ getSelectedStation.data.hourlyRate }}
**Free Locks:** {{ getSelectedStation.data.freeLockCount}}
**Locks In-Use:** {{getSelectedStation.data.ownedLockCount}}"
            verticalAlign="center"
          />
          <Text
            id="openDirectionsButton"
            horizontalAlign="center"
            style={{ ordered: [{ color: "rgba(18, 88, 149, 1)" }] }}
            value="**Open Directions ->**"
            verticalAlign="center"
          />
          <Event
            event="click"
            method="trigger"
            params={{ ordered: [] }}
            pluginId="linkCard"
            type="datasource"
            waitType="debounce"
          />
        </Container>
        <Button
          id="centerMapButton"
          style={{
            ordered: [
              { background: "rgba(100, 204, 197, 0.3)" },
              { border: "rgba(38, 38, 38, 0)" },
              { borderRadius: "5px" },
            ],
          }}
          styleVariant="outline"
          submitTargetId=""
          text="Center Map"
        >
          <Event
            event="click"
            method="setMapCenter"
            params={{
              ordered: [
                {
                  center:
                    "{\nlongitude: {{getCurrentLocation.data.longitude}},\nlatitude: {{ getCurrentLocation.data.latitude }} \n}",
                },
              ],
            }}
            pluginId="Map"
            type="widget"
            waitMs="0"
            waitType="debounce"
          />
        </Button>
      </View>
    </Container>
    <Include src="./src/stationAndLockManagementContainer.rsx" />
    <Divider id="divider1" />
    <Container
      id="stationsOverviewContainer"
      showBody={true}
      showHeader={true}
      style={{ ordered: [{ border: "rgba(199, 199, 199, 0)" }] }}
    >
      <Header>
        <Text
          id="stationsOverviewContainerTitle"
          style={{ ordered: [{ background: "rgba(100, 204, 197, 0)" }] }}
          value="#### 𝐒𝐭𝐚𝐭𝐢𝐨𝐧𝐬 𝐎𝐯𝐞𝐫𝐯𝐢𝐞𝐰"
          verticalAlign="center"
        />
      </Header>
      <View id="39a35" viewKey="View 1">
        <Table
          id="stationsOverviewTable"
          cellSelection="none"
          changesetArray={[]}
          clearChangesetOnSave={true}
          data="{{ getStations.data }}"
          defaultSelectedRow={{ mode: "index", indexType: "display", index: 0 }}
          enableSaveActions={true}
          overflowType="pagination"
          primaryKeyColumnId="bd871"
          selectedDataIndexes={[]}
          selectedRowKeys={[]}
          selectedRows={[]}
          selectedSourceRows={[]}
          showBorder={true}
          showFooter={true}
          showHeader={true}
          sortArray={[]}
          templatePageSize={20}
          toolbarPosition="bottom"
        >
          <Column
            id="bd871"
            alignment="right"
            editableOptions={{ showStepper: true }}
            format="decimal"
            formatOptions={{ showSeparators: true, notation: "standard" }}
            hidden="true"
            key="id"
            label="ID"
            placeholder="Enter value"
            position="center"
            size={31.546875}
          />
          <Column
            id="c65f4"
            alignment="left"
            format="string"
            key="name"
            label="Name"
            placeholder="Enter value"
            position="center"
            size={228.140625}
          />
          <Column
            id="d9bcf"
            alignment="center"
            editableOptions={{ showStepper: true }}
            format="currency"
            formatOptions={{
              currency: "ILS",
              currencySign: "standard",
              notation: "standard",
              showSeparators: true,
            }}
            key="hourlyRate"
            label="Hourly rate"
            placeholder="Enter value"
            position="center"
            size={180.4375}
          />
          <Column
            id="05d05"
            alignment="center"
            editableOptions={{ showStepper: true }}
            format="decimal"
            formatOptions={{ showSeparators: true, notation: "standard" }}
            key="lockCount"
            label="Lock count"
            placeholder="Enter value"
            position="center"
            size={128.234375}
          />
          <Column
            id="d46cc"
            alignment="center"
            editableOptions={{ showStepper: true }}
            format="decimal"
            formatOptions={{ showSeparators: true, notation: "standard" }}
            key="freeLockCount"
            label="Free lock count"
            placeholder="Enter value"
            position="center"
            size={118.1875}
          />
          <Column
            id="d1db5"
            alignment="center"
            cellTooltip="{{ item }}"
            cellTooltipMode="custom"
            editableOptions={{ showStepper: true }}
            format="decimal"
            formatOptions={{ showSeparators: true, notation: "standard" }}
            key="ownedLockCount"
            label="Owned lock count"
            placeholder="Enter value"
            position="center"
            size={119}
          />
          <Column
            id="bc417"
            alignment="right"
            editableOptions={{ showStepper: true }}
            format="decimal"
            formatOptions={{ showSeparators: true, notation: "standard" }}
            hidden="true"
            key="latitude"
            label="Latitude"
            placeholder="Enter value"
            position="center"
            size={100}
          />
          <Column
            id="90e40"
            alignment="right"
            editableOptions={{ showStepper: true }}
            format="decimal"
            formatOptions={{ showSeparators: true, notation: "standard" }}
            hidden="true"
            key="longitude"
            label="Longitude"
            placeholder="Enter value"
            position="center"
            size={100}
          />
          <Column
            id="8dc10"
            alignment="left"
            format="boolean"
            key="deleted"
            label="Deleted"
            placeholder="Enter value"
            position="center"
            size={100}
          />
          <Action
            id="2cc65"
            icon="bold/travel-map-navigation-arrow-south-east"
            label="Directions"
          >
            <Event
              event="clickAction"
              method="openUrl"
              params={{
                ordered: [
                  {
                    url: "https://www.google.com/maps/dir/{{ getCurrentLocation.data.latitude}},{{ getCurrentLocation.data.longitude}}/{{ stationsOverviewTable.selectedRow.latitude}},{{ stationsOverviewTable.selectedRow.longitude}}\n\n",
                  },
                ],
              }}
              pluginId=""
              type="util"
              waitMs="0"
              waitType="debounce"
            />
          </Action>
          <ToolbarButton
            id="1a"
            icon="bold/interface-text-formatting-filter-2"
            label="Filter"
            type="filter"
          />
          <ToolbarButton
            id="3c"
            icon="bold/interface-download-button-2"
            label="Download"
            type="custom"
          >
            <Event
              event="clickToolbar"
              method="exportData"
              pluginId="stationsOverviewTable"
              type="widget"
              waitMs="0"
              waitType="debounce"
            />
          </ToolbarButton>
          <ToolbarButton
            id="4d"
            icon="bold/interface-arrows-round-left"
            label="Refresh"
            type="custom"
          >
            <Event
              event="clickToolbar"
              method="refresh"
              pluginId="stationsOverviewTable"
              type="widget"
              waitMs="0"
              waitType="debounce"
            />
          </ToolbarButton>
        </Table>
      </View>
    </Container>
    <Divider id="divider2" />
    <Include src="./src/locksOverviewContainer.rsx" />
    <Divider id="divider3" />
    <Container
      id="rentalsContainer"
      showBody={true}
      showHeader={true}
      style={{ ordered: [{ border: "rgba(199, 199, 199, 0)" }] }}
      styleContext={{ ordered: [] }}
    >
      <Header>
        <Text
          id="rentalsContainerTitle"
          value="#### 𝐑𝐞𝐧𝐭𝐚𝐥𝐬"
          verticalAlign="center"
        />
      </Header>
      <View id="39a35" viewKey="View 1">
        <Select
          id="stationRentalsSelect"
          colorByIndex=""
          data="{{ getStations.data }}"
          disabledByIndex="{{ item.deleted }}"
          emptyMessage="No options"
          iconByIndex="bold/travel-hotel-parking-sign-alternate"
          label=""
          labels="{{ item.name }}"
          labelWidth="25"
          overlayMaxHeight={375}
          placeholder="Select a Station..."
          showClear={true}
          showSelectionIndicator={true}
          style={{ ordered: [{ borderRadius: "15px" }] }}
          value={'""'}
          values="{{ item.name }}"
        >
          <Event
            event="change"
            method="trigger"
            params={{ ordered: [] }}
            pluginId="getStationIdByNameRentals"
            type="datasource"
            waitMs="0"
            waitType="debounce"
          />
        </Select>
        <Container
          id="tabbedContainerCurrentOrAllRentals"
          currentViewKey="{{ self.viewKeys[0] }}"
          showBody={true}
          showHeader={true}
          style={{ ordered: [{ border: "rgb(199, 199, 199)" }] }}
          styleContext={{ ordered: [{ primary: "rgb(23, 107, 135)" }] }}
        >
          <Header>
            <Tabs
              id="currentRentalsTab"
              itemMode="static"
              navigateContainer={true}
              targetContainerId="tabbedContainerCurrentOrAllRentals"
              value="{{ self.values[0] }}"
            >
              <Option id="c814a" value="Tab 1" />
              <Option id="c0e8e" value="Tab 2" />
              <Option id="16847" value="Tab 3" />
            </Tabs>
          </Header>
          <View id="45d7d" label="Current Rentals" viewKey="Current Rentals">
            <Table
              id="currentRentalsTable"
              cellSelection="none"
              changesetArray={[]}
              clearChangesetOnSave={true}
              data="{{ getCurrentRentals.data }}"
              defaultSelectedRow={{
                mode: "index",
                indexType: "display",
                index: 0,
              }}
              enableSaveActions={true}
              overflowType="pagination"
              selectedDataIndexes={[]}
              selectedRowKeys={[]}
              selectedRows={[]}
              selectedSourceRows={[]}
              showBorder={true}
              showFooter={true}
              showHeader={true}
              sortArray={[]}
              templatePageSize={20}
              toolbarPosition="bottom"
            >
              <Column
                id="b3b0c"
                alignment="left"
                format="string"
                formatOptions={{ automaticColors: true }}
                key="stationName"
                label="Station name"
                placeholder="Enter value"
                position="center"
                size={164.28125}
                valueOverride="{{ _.startCase(item) }}"
              />
              <Column
                id="88559"
                alignment="left"
                format="string"
                key="lockName"
                label="Lock name"
                placeholder="Enter value"
                position="center"
                size={78.921875}
              />
              <Column
                id="ca9ae"
                alignment="left"
                format="avatar"
                key="userId"
                label="User ID"
                placeholder="No user"
                position="center"
                size={119.234375}
              />
              <Column
                id="23b7e"
                alignment="left"
                editableOptions={{ showStepper: true }}
                format="currency"
                formatOptions={{
                  currency: "ILS",
                  currencySign: "standard",
                  notation: "standard",
                  showSeparators: true,
                }}
                key="hourlyRate"
                label="Hourly rate"
                placeholder="Enter value"
                position="center"
                size={80.4375}
              />
              <Column
                id="17850"
                alignment="left"
                format="datetime"
                key="startTime"
                label="Start time"
                placeholder="Enter value"
                position="center"
                size={146.765625}
              />
              <Column
                id="4f058"
                alignment="center"
                editableOptions={{ showStepper: true }}
                format="decimal"
                formatOptions={{ showSeparators: true, notation: "standard" }}
                key="durationDays"
                label="Duration days"
                placeholder="Enter value"
                position="center"
                size={96.53125}
              />
              <Column
                id="48a56"
                alignment="center"
                editableOptions={{ showStepper: true }}
                format="decimal"
                formatOptions={{ showSeparators: true, notation: "standard" }}
                key="durationHours"
                label="Duration hours"
                placeholder="Enter value"
                position="center"
                size={112.109375}
              />
              <Column
                id="906d8"
                alignment="center"
                editableOptions={{ showStepper: true }}
                format="currency"
                formatOptions={{
                  currency: "ils",
                  currencySign: "standard",
                  notation: "standard",
                  showSeparators: true,
                }}
                key="cost"
                label="Cost"
                placeholder="Enter value"
                position="center"
                size={50.40625}
              />
              <ToolbarButton
                id="1a"
                icon="bold/interface-text-formatting-filter-2"
                label="Filter"
                type="filter"
              />
              <ToolbarButton
                id="3c"
                icon="bold/interface-download-button-2"
                label="Download"
                type="custom"
              >
                <Event
                  event="clickToolbar"
                  method="exportData"
                  pluginId="currentRentalsTable"
                  type="widget"
                  waitMs="0"
                  waitType="debounce"
                />
              </ToolbarButton>
              <ToolbarButton
                id="4d"
                icon="bold/interface-arrows-round-left"
                label="Refresh"
                type="custom"
              >
                <Event
                  event="clickToolbar"
                  method="refresh"
                  pluginId="currentRentalsTable"
                  type="widget"
                  waitMs="0"
                  waitType="debounce"
                />
              </ToolbarButton>
            </Table>
          </View>
          <View id="e791e" label="Past Rentals" viewKey="Past Rentals">
            <Table
              id="pastRentalsTable"
              cellSelection="none"
              changesetArray={[]}
              clearChangesetOnSave={true}
              data="{{ getPastRentals.data }}"
              defaultSelectedRow={{
                mode: "index",
                indexType: "display",
                index: 0,
              }}
              enableSaveActions={true}
              overflowType="pagination"
              selectedDataIndexes={[]}
              selectedRowKeys={[]}
              selectedRows={[]}
              selectedSourceRows={[]}
              showBorder={true}
              showFooter={true}
              showHeader={true}
              sortArray={[]}
              templatePageSize={20}
              toolbarPosition="bottom"
            >
              <Column
                id="0ebc6"
                alignment="left"
                format="string"
                key="stationName"
                label="Station name"
                placeholder="Enter value"
                position="center"
                size={146.609375}
              />
              <Column
                id="23964"
                alignment="left"
                format="string"
                key="lockName"
                label="Lock name"
                placeholder="Enter value"
                position="center"
                size={78.921875}
              />
              <Column
                id="7d655"
                alignment="left"
                format="avatar"
                key="userId"
                label="User ID"
                placeholder="No user"
                position="center"
                size={115.234375}
              />
              <Column
                id="fd6fa"
                alignment="center"
                editableOptions={{ showStepper: true }}
                format="currency"
                formatOptions={{
                  currency: "ILS",
                  currencySign: "standard",
                  notation: "standard",
                  showSeparators: true,
                }}
                key="hourlyRate"
                label="Hourly rate"
                placeholder="Enter value"
                position="center"
                size={80.4375}
              />
              <Column
                id="23e64"
                alignment="left"
                format="datetime"
                key="startTime"
                label="Start time"
                placeholder="Enter value"
                position="center"
                size={146.765625}
              />
              <Column
                id="519ed"
                alignment="left"
                format="datetime"
                key="endTime"
                label="End time"
                placeholder="Enter value"
                position="center"
                size={146.765625}
              />
              <Column
                id="fd1f6"
                alignment="center"
                editableOptions={{ showStepper: true }}
                format="decimal"
                formatOptions={{ showSeparators: true, notation: "standard" }}
                key="durationDays"
                label="Duration days"
                placeholder="Enter value"
                position="center"
                size={96.53125}
              />
              <Column
                id="7219e"
                alignment="center"
                editableOptions={{ showStepper: true }}
                format="decimal"
                formatOptions={{ showSeparators: true, notation: "standard" }}
                key="durationHours"
                label="Duration hours"
                placeholder="Enter value"
                position="center"
                size={110.109375}
              />
              <Column
                id="40bb7"
                alignment="right"
                editableOptions={{ showStepper: true }}
                format="currency"
                formatOptions={{
                  currency: "ILS",
                  currencySign: "standard",
                  notation: "standard",
                  showSeparators: true,
                }}
                key="cost"
                label="Cost"
                placeholder="Enter value"
                position="center"
                size={43.375}
              />
              <ToolbarButton
                id="1a"
                icon="bold/interface-text-formatting-filter-2"
                label="Filter"
                type="filter"
              />
              <ToolbarButton
                id="3c"
                icon="bold/interface-download-button-2"
                label="Download"
                type="custom"
              >
                <Event
                  event="clickToolbar"
                  method="exportData"
                  pluginId="pastRentalsTable"
                  type="widget"
                  waitMs="0"
                  waitType="debounce"
                />
              </ToolbarButton>
              <ToolbarButton
                id="4d"
                icon="bold/interface-arrows-round-left"
                label="Refresh"
                type="custom"
              >
                <Event
                  event="clickToolbar"
                  method="refresh"
                  pluginId="pastRentalsTable"
                  type="widget"
                  waitMs="0"
                  waitType="debounce"
                />
              </ToolbarButton>
            </Table>
          </View>
        </Container>
      </View>
    </Container>
  </Frame>
</App>
