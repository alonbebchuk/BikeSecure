<SidebarFrame
  id="sidebarFrame1"
  marginType="normal"
  showFooter={true}
  showHeader={true}
  style={{ ordered: [{ background: "rgb(0, 28, 48)" }] }}
>
  <Header>
    <Text
      id="sidebarTitle"
      horizontalAlign="center"
      style={{ ordered: [{ color: "rgba(203, 237, 249, 1)" }] }}
      value="### **𝘽𝙞𝙠𝙚 𝙎𝙚𝙘𝙪𝙧𝙚** "
      verticalAlign="center"
    />
  </Header>
  <Body>
    <Navigation
      id="navigationOptions"
      altText="Smart Docking Station Management"
      itemMode="static"
      orientation="vertical"
      style={{ ordered: [] }}
    >
      <Option
        id="44a0c"
        icon="bold/travel-hotel-parking-sign-alternate"
        iconPosition="left"
        itemType="custom"
        label="Station & Lock Management"
      >
        <Event
          event="click"
          method="run"
          params={{
            ordered: [
              { src: "stationAndLockManagementContainer.scrollIntoView();\n" },
            ],
          }}
          pluginId=""
          type="script"
          waitMs="0"
          waitType="debounce"
        />
      </Option>
      <Option
        id="0e533"
        disabled={false}
        hidden={false}
        icon="bold/travel-map-location-pin-alternate"
        iconPosition="left"
        itemType="custom"
        label="Map View"
      >
        <Event
          event="click"
          method="run"
          params={{ ordered: [{ src: "mapViewContainer.scrollIntoView();" }] }}
          pluginId=""
          type="script"
          waitMs="0"
          waitType="debounce"
        />
      </Option>
      <Option
        id="ba7f5"
        disabled={false}
        hidden={false}
        icon="bold/interface-alert-information-circle-alternate"
        iconPosition="left"
        itemType="custom"
        label="Stations Overview"
      >
        <Event
          event="click"
          method="run"
          params={{
            ordered: [{ src: "stationsOverviewContainer.scrollIntoView();" }],
          }}
          pluginId=""
          type="script"
          waitMs="0"
          waitType="debounce"
        />
      </Option>
      <Option
        id="e593a"
        disabled={false}
        hidden={false}
        icon="bold/interface-lock"
        iconPosition="left"
        itemType="custom"
        label="Locks Overview"
      >
        <Event
          event="click"
          method="run"
          params={{
            ordered: [{ src: "locksOverviewContainer.scrollIntoView();" }],
          }}
          pluginId=""
          type="script"
          waitMs="0"
          waitType="debounce"
        />
      </Option>
      <Option
        id="a6637"
        icon="bold/interface-user-single"
        iconPosition="left"
        itemType="custom"
        label="Rentals"
      >
        <Event
          event="click"
          method="run"
          params={{ ordered: [{ src: "rentalsContainer.scrollIntoView();" }] }}
          pluginId=""
          type="script"
          waitMs="0"
          waitType="debounce"
        />
      </Option>
      <Event
        event="click"
        method="run"
        params={{
          ordered: [{ src: "revenueTrackingContainer.scrollIntoView();\n" }],
        }}
        pluginId=""
        targetId="34f69"
        type="script"
        waitMs="0"
        waitType="debounce"
      />
    </Navigation>
  </Body>
</SidebarFrame>
