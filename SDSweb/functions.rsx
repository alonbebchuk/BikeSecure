<GlobalFunctions>
  <Folder id="stationAndLockManagement">
    <RESTQuery
      id="addLock"
      body={
        '[{"key":"Stationid","value":"{{ stationManagementSelect.value }}"},{"key":"Name","value":"{{ lockNameInput.value }}"},{"key":"Mac","value":"{{ lockMacInput.value }}"}]'
      }
      bodyType="json"
      headers={'[{"key":"appUuid","value":"{{ retoolContext.appUuid }}"}]'}
      isMultiplayerEdited={false}
      query="https://bikesecure.azurewebsites.net/api/manage/locks/add"
      resourceName="REST-WithoutResource"
      resourceTypeOverride=""
      runWhenModelUpdates={false}
      type="POST"
    >
      <Event
        event="success"
        method="trigger"
        params={{ ordered: [] }}
        pluginId="getLocksOverview"
        type="datasource"
        waitMs="0"
        waitType="debounce"
      />
      <Event
        event="success"
        method="trigger"
        params={{ ordered: [] }}
        pluginId="getLocksByStation"
        type="datasource"
        waitMs="0"
        waitType="debounce"
      />
      <Event
        event="success"
        method="trigger"
        params={{ ordered: [] }}
        pluginId="getStations"
        type="datasource"
        waitMs="0"
        waitType="debounce"
      />
      <Event
        event="success"
        method="run"
        params={{
          ordered: [
            { src: "lockNameInput.clearValue();\nlockMacInput.clearValue();" },
          ],
        }}
        pluginId=""
        type="script"
        waitMs="0"
        waitType="debounce"
      />
    </RESTQuery>
    <JavascriptQuery
      id="getSelectedStationManager"
      query={include("./lib/getSelectedStationManager.js", "string")}
      resourceName="JavascriptQuery"
    />
    <RESTQuery
      id="deleteLock"
      body={'[{"key":"LockId","value":"{{ selectLockOptions.value }}"}]'}
      bodyType="json"
      headers={'[{"key":"appUuid","value":"{{ retoolContext.appUuid }}"}]'}
      isMultiplayerEdited={false}
      query="https://bikesecure.azurewebsites.net/api/manage/locks/delete"
      resourceName="REST-WithoutResource"
      runWhenModelUpdates={false}
      type="POST"
    >
      <Event
        event="success"
        method="trigger"
        params={{ ordered: [] }}
        pluginId="getStations"
        type="datasource"
        waitMs="0"
        waitType="debounce"
      />
      <Event
        event="success"
        method="trigger"
        params={{ ordered: [] }}
        pluginId="getLocksOverview"
        type="datasource"
        waitMs="0"
        waitType="debounce"
      />
      <Event
        event="success"
        method="trigger"
        params={{ ordered: [] }}
        pluginId="getLocksByStation"
        type="datasource"
        waitMs="0"
        waitType="debounce"
      />
      <Event
        event="success"
        method="run"
        params={{ ordered: [{ src: "selectLockOptions.clearValue();" }] }}
        pluginId=""
        type="script"
        waitMs="0"
        waitType="debounce"
      />
    </RESTQuery>
    <RESTQuery
      id="getLocksByStation"
      headers={'[{"key":"appUuid","value":"{{ retoolContext.appUuid }}"}]'}
      isMultiplayerEdited={false}
      query="https://bikesecure.azurewebsites.net/api/manage/locks/{{ stationManagementSelect.value}}"
      resourceName="REST-WithoutResource"
      resourceTypeOverride=""
      runWhenModelUpdates={false}
    />
    <RESTQuery
      id="setHourlyRate"
      body={
        '[{"key":"StationId","value":"{{ stationManagementSelect.value }}"},{"key":"HourlyRate","value":"{{ newHourlyRateInput.value }}"}]'
      }
      bodyType="json"
      headers={'[{"key":"appUuid","value":"{{ retoolContext.appUuid }}"}]'}
      isMultiplayerEdited={false}
      query="https://bikesecure.azurewebsites.net/api/manage/stations/update"
      resourceName="REST-WithoutResource"
      resourceTypeOverride=""
      runWhenModelUpdates={false}
      type="POST"
    >
      <Event
        event="success"
        method="trigger"
        params={{ ordered: [] }}
        pluginId="getStations"
        type="datasource"
        waitMs="0"
        waitType="debounce"
      />
      <Event
        event="success"
        method="run"
        params={{
          ordered: [
            {
              src: "CurrentHourlyRateForm.clearValue();\nnewHourlyRateInput.clearValue();\n",
            },
          ],
        }}
        pluginId=""
        type="script"
        waitMs="0"
        waitType="debounce"
      />
    </RESTQuery>
    <RESTQuery
      id="deleteStation"
      body={
        '[{"key":"StationId","value":"{{ stationManagementSelect.value }}"}]'
      }
      bodyType="json"
      headers={'[{"key":"appUuid","value":"{{ retoolContext.appUuid }}"}]'}
      query="https://bikesecure.azurewebsites.net/api/manage/stations/delete"
      resourceName="REST-WithoutResource"
      runWhenModelUpdates={false}
      type="POST"
    >
      <Event
        event="success"
        method="trigger"
        params={{ ordered: [] }}
        pluginId="getStations"
        type="datasource"
        waitMs="0"
        waitType="debounce"
      />
      <Event
        event="success"
        method="run"
        params={{ ordered: [{ src: "stationManagementSelect.clearValue();" }] }}
        pluginId=""
        type="script"
        waitMs="0"
        waitType="debounce"
      />
    </RESTQuery>
    <RESTQuery
      id="addStation"
      body={
        '[{"key":"Name","value":"{{ stationNameInput.value }}"},{"key":"HourlyRate","value":"{{ hourlyRateInput.value }}"},{"key":"Latitude","value":"{{ locationLatitudeInput.value }}"},{"key":"Longitude","value":"{{ locationLongitudeInput.value }}"},{"key":"Url","value":"{{ stationUrlInput.value }}"}]'
      }
      bodyType="json"
      headers={'[{"key":"appUuid","value":"{{ retoolContext.appUuid }}"}]'}
      query="https://bikesecure.azurewebsites.net/api/manage/stations/add"
      resourceName="REST-WithoutResource"
      runWhenModelUpdates={false}
      type="POST"
    >
      <Event
        event="success"
        method="trigger"
        params={{ ordered: [] }}
        pluginId="getStations"
        type="datasource"
        waitMs="0"
        waitType="debounce"
      />
      <Event
        event="success"
        method="run"
        params={{
          ordered: [
            {
              src: "stationNameInput.clearValue();\nstationUrlInput.clearValue();\nlocationLatitudeInput.clearValue();\nlocationLongitudeInput.clearValue();\nhourlyRateInput.clearValue();",
            },
          ],
        }}
        pluginId=""
        type="script"
        waitMs="0"
        waitType="debounce"
      />
    </RESTQuery>
  </Folder>
  <Folder id="mapView">
    <JavascriptQuery
      id="getCurrentLocation"
      isMultiplayerEdited={false}
      query={include("./lib/getCurrentLocation.js", "string")}
      resourceName="JavascriptQuery"
      runWhenPageLoads={true}
    />
    <JavascriptQuery
      id="getSelectedStation"
      isMultiplayerEdited={false}
      query={include("./lib/getSelectedStation.js", "string")}
      resourceName="JavascriptQuery"
    />
    <JavascriptQuery
      id="getStationsLocations"
      isMultiplayerEdited={false}
      query={include("./lib/getStationsLocations.js", "string")}
      resourceName="JavascriptQuery"
    />
    <JavascriptQuery
      id="linkCard"
      query={include("./lib/linkCard.js", "string")}
      resourceName="JavascriptQuery"
    />
  </Folder>
  <Folder id="stationsOverview">
    <RESTQuery
      id="getStations"
      headers={'[{"key":"appUuid","value":"{{ retoolContext.appUuid }}"}]'}
      isMultiplayerEdited={false}
      query="https://bikesecure.azurewebsites.net/api/manage/stations"
      resourceName="REST-WithoutResource"
      resourceTypeOverride=""
      runWhenModelUpdates={false}
      runWhenPageLoads={true}
      runWhenPageLoadsDelay="0"
      transformer=""
    >
      <Event
        event="success"
        method="trigger"
        params={{ ordered: [] }}
        pluginId="getSelectedStation"
        type="datasource"
        waitMs="0"
        waitType="debounce"
      />
      <Event
        event="success"
        method="trigger"
        params={{ ordered: [] }}
        pluginId="getSelectedStationManager"
        type="datasource"
        waitMs="0"
        waitType="debounce"
      />
      <Event
        event="success"
        method="trigger"
        params={{ ordered: [] }}
        pluginId="getStationsLocations"
        type="datasource"
        waitMs="0"
        waitType="debounce"
      />
    </RESTQuery>
  </Folder>
  <Folder id="locksOverview">
    <JavascriptQuery
      id="locksOccupancy"
      query={include("./lib/locksOccupancy.js", "string")}
      resourceName="JavascriptQuery"
    />
    <RESTQuery
      id="getLocksOverview"
      _additionalScope={[]}
      headers={'[{"key":"appUuid","value":"{{ retoolContext.appUuid }}"}]'}
      isMultiplayerEdited={false}
      query="https://bikesecure.azurewebsites.net/api/manage/locks/{{ stationLocksSelect.value}}"
      resourceName="REST-WithoutResource"
      resourceTypeOverride=""
      runWhenModelUpdates={false}
    >
      <Event
        event="success"
        method="trigger"
        params={{ ordered: [] }}
        pluginId="getStationsLocksAnalysis"
        type="datasource"
        waitMs="0"
        waitType="debounce"
      />
      <Event
        event="success"
        method="trigger"
        params={{ ordered: [] }}
        pluginId="locksOccupancy"
        type="datasource"
        waitMs="0"
        waitType="debounce"
      />
    </RESTQuery>
    <JavascriptQuery
      id="getStationsLocksAnalysis"
      isMultiplayerEdited={false}
      query={include("./lib/getStationsLocksAnalysis.js", "string")}
      resourceName="JavascriptQuery"
    />
  </Folder>
  <Folder id="rentals">
    <JavascriptQuery
      id="getStationIdByNameRentals"
      isMultiplayerEdited={false}
      query={include("./lib/getStationIdByNameRentals.js", "string")}
      resourceName="JavascriptQuery"
    >
      <Event
        event="success"
        method="trigger"
        params={{ ordered: [] }}
        pluginId="getCurrentRentals"
        type="datasource"
        waitMs="0"
        waitType="debounce"
      />
      <Event
        event="success"
        method="trigger"
        params={{ ordered: [] }}
        pluginId="getPastRentals"
        type="datasource"
        waitMs="0"
        waitType="debounce"
      />
    </JavascriptQuery>
    <RESTQuery
      id="getPastRentals"
      headers={'[{"key":"appUuid","value":"{{ retoolContext.appUuid }}"}]'}
      query="https://bikesecure.azurewebsites.net/api/manage/rentals/past/{{ getStationIdByNameRentals.data}}"
      resourceName="REST-WithoutResource"
      runWhenModelUpdates={false}
      transformer=""
    />
    <RESTQuery
      id="getCurrentRentals"
      headers={'[{"key":"appUuid","value":"{{ retoolContext.appUuid }}"}]'}
      isMultiplayerEdited={false}
      query="https://bikesecure.azurewebsites.net/api/manage/rentals/current/{{ getStationIdByNameRentals.data}}"
      resourceName="REST-WithoutResource"
      resourceTypeOverride=""
      runWhenModelUpdates={false}
      transformer=""
    />
  </Folder>
</GlobalFunctions>
