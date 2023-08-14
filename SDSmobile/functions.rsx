<GlobalFunctions>
  <Folder id="RentalQueries">
    <RESTQuery
      id="GetLock"
      enableTransformer={true}
      headers={
        '[{"key":"appUuid","value":"{{ AppUuid }}"},{"key":"sid","value":"{{ UserId }}"}]'
      }
      importedQueryInputs={{
        ordered: [
          { AppUuid: "{{ retoolContext.appUuid }}" },
          { UserId: "{{ current_user.sid }}" },
          { LockId: "{{ Rental.value.lockId }}" },
        ],
      }}
      isImported={true}
      playgroundQueryId={744861}
      playgroundQueryName="GetLock"
      playgroundQueryUuid="31edb286-6135-486e-a4da-f325c080e0c6"
      query="https://bikesecure.azurewebsites.net/api/locks/data/{{ LockId }}"
      resourceName="REST-WithoutResource"
      retoolVersion="3.7.0"
      runWhenModelUpdates={false}
      showLatestVersionUpdatedWarning={true}
      transformer="data.startTime = new Date(data.startTime).toLocaleString('en-US', { year: 'numeric', month: '2-digit', day: '2-digit', hour: '2-digit', minute: '2-digit', hour12: false })
data.endTime = new Date(data.endTime).toLocaleString('en-US', { year: 'numeric', month: '2-digit', day: '2-digit', hour: '2-digit', minute: '2-digit', hour12: false })

if (data.durationDays > 0) {
  data.durationDays = `${data.durationDays} day${data.durationDays === 1 ? '' : 's'}`
}
else {
  data.durationDays = ''
}

if (data.durationHours > 0) {
  data.durationHours = `${data.durationHours} hour${data.durationHours === 1 ? '' : 's'}`
}
else {
  data.durationHours = ''
}

if (data.durationDays == '' && data.durationHours == '') {
  data.durationDays = 'less than an hour'
}

if (data.durationDays !== '' && data.durationHours !== '') {
  data.durationDays = data.durationDays + ', '
}

data.hourlyRate += ' \u20AA'
data.cost += ' \u20AA'

return data"
    >
      <Event
        event="success"
        method="setValue"
        params={{ ordered: [{ value: "{{ GetLock.data }}" }] }}
        pluginId="Rental"
        type="state"
        waitMs="0"
        waitType="debounce"
      />
    </RESTQuery>
    <RESTQuery
      id="GetCurrentRentals"
      enableTransformer={true}
      headers={
        '[{"key":"appUuid","value":"{{ retoolContext.appUuid }}"},{"key":"sid","value":"{{ current_user.sid }}"}]'
      }
      isMultiplayerEdited={false}
      query="https://bikesecure.azurewebsites.net/api/rentals/current"
      resourceName="REST-WithoutResource"
      runWhenModelUpdates={false}
      transformer="return data.sort((x,y) => Date.parse(y.startTime) - Date.parse(x.startTime)).map((rental) => {
  rental.startTime = new Date(rental.startTime).toLocaleString('en-US', { year: 'numeric', month: '2-digit', day: '2-digit', hour: '2-digit', minute: '2-digit', hour12: false })
  rental.endTime = new Date(rental.endTime).toLocaleString('en-US', { year: 'numeric', month: '2-digit', day: '2-digit', hour: '2-digit', minute: '2-digit', hour12: false })

  if (rental.durationDays > 0) {
    rental.durationDays = `${rental.durationDays} day${rental.durationDays === 1 ? '' : 's'}`
  }
  else {
    rental.durationDays = ''
  }

  if (rental.durationHours > 0) {
    rental.durationHours = `${rental.durationHours} hour${rental.durationHours === 1 ? '' : 's'}`
  }
  else {
    rental.durationHours = ''
  }

  if (rental.durationDays == '' && rental.durationHours == '') {
    rental.durationDays = 'less than an hour'
  }

  if (rental.durationDays !== '' && rental.durationHours !== '') {
    rental.durationDays = rental.durationDays + ','
  }

  rental.hourlyRate += ' \u20AA'
  rental.cost += ' \u20AA'
  return rental
})"
    />
    <RESTQuery
      id="GetPastRentals"
      enableTransformer={true}
      headers={
        '[{"key":"appUuid","value":"{{ retoolContext.appUuid }}"},{"key":"sid","value":"{{ current_user.sid }}"}]'
      }
      query="https://bikesecure.azurewebsites.net/api/rentals/past"
      resourceName="REST-WithoutResource"
      runWhenModelUpdates={false}
      transformer="return data.sort((x,y) => Date.parse(y.endTime) - Date.parse(x.endTime)).map((rental) => {
  rental.startTime = new Date(rental.startTime).toLocaleString('en-US', { year: 'numeric', month: '2-digit', day: '2-digit', hour: '2-digit', minute: '2-digit', hour12: false })
  rental.endTime = new Date(rental.endTime).toLocaleString('en-US', { year: 'numeric', month: '2-digit', day: '2-digit', hour: '2-digit', minute: '2-digit', hour12: false })

  if (rental.durationDays > 0) {
    rental.durationDays = `${rental.durationDays} day${rental.durationDays === 1 ? '' : 's'}`
  }
  else {
    rental.durationDays = ''
  }

  if (rental.durationHours > 0) {
    rental.durationHours = `${rental.durationHours} hour${rental.durationHours === 1 ? '' : 's'}`
  }
  else {
    rental.durationHours = ''
  }

  if (rental.durationDays == '' && rental.durationHours == '') {
    rental.durationDays = 'less than an hour'
  }

  if (rental.durationDays !== '' && rental.durationHours !== '') {
    rental.durationDays = rental.durationDays + ', '
  }

  rental.hourlyRate += ' \u20AA'
  rental.cost += ' \u20AA'
  return rental
})"
    />
  </Folder>
  <Folder id="RentalActions">
    <RESTQuery
      id="HandleLockScan"
      enableTransformer={true}
      headers={
        '[{"key":"appUuid","value":"{{ AppUuid }}"},{"key":"sid","value":"{{ UserId }}"}]'
      }
      importedQueryInputs={{
        ordered: [
          { AppUuid: "{{ retoolContext.appUuid }}" },
          { UserId: "{{ current_user.sid }}" },
          { LockId: "{{ Scanner.data }}" },
        ],
      }}
      isImported={true}
      playgroundQueryId={744861}
      playgroundQueryName="GetLock"
      playgroundQueryUuid="31edb286-6135-486e-a4da-f325c080e0c6"
      query="https://bikesecure.azurewebsites.net/api/locks/data/{{ LockId }}"
      resourceName="REST-WithoutResource"
      retoolVersion="3.7.0"
      runWhenModelUpdates={false}
      showLatestVersionUpdatedWarning={true}
      transformer="data.startTime = new Date(data.startTime).toLocaleString('en-US', { year: 'numeric', month: '2-digit', day: '2-digit', hour: '2-digit', minute: '2-digit', hour12: false })
data.endTime = new Date(data.endTime).toLocaleString('en-US', { year: 'numeric', month: '2-digit', day: '2-digit', hour: '2-digit', minute: '2-digit', hour12: false })

if (data.durationDays > 0) {
  data.durationDays = `${data.durationDays} day${data.durationDays === 1 ? '' : 's'}`
}
else {
  data.durationDays = ''
}

if (data.durationHours > 0) {
  data.durationHours = `${data.durationHours} hour${data.durationHours === 1 ? '' : 's'}`
}
else {
  data.durationHours = ''
}

if (data.durationDays == '' && data.durationHours == '') {
  data.durationDays = 'less than an hour'
}

if (data.durationDays !== '' && data.durationHours !== '') {
  data.durationDays = data.durationDays + ', '
}

data.hourlyRate += ' \u20AA'
data.cost += ' \u20AA'

return data"
    >
      <Event
        enabled=""
        event="success"
        method="setValue"
        params={{ ordered: [{ value: "{{ HandleLockScan.data }}" }] }}
        pluginId="Rental"
        type="state"
        waitMs="0"
        waitType="debounce"
      />
      <Event
        enabled="{{ HandleLockScan.data.lockStatus == -1 }}"
        event="success"
        method="navigateTo"
        params={{ ordered: [{ screenPluginId: "HomePage" }] }}
        pluginId=""
        type="navigator"
        waitMs="0"
        waitType="debounce"
      />
      <Event
        enabled="{{ HandleLockScan.data.lockStatus == -1 }}"
        event="success"
        method="open"
        params={{
          ordered: [
            { title: "Lock Unavailable" },
            { description: "try a different lock" },
            {
              actionItems: [
                {
                  ordered: [
                    { label: "OK" },
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
              ],
            },
          ],
        }}
        pluginId=""
        type="alert"
        waitMs="0"
        waitType="debounce"
      />
      <Event
        enabled="{{ HandleLockScan.data.lockStatus == 0 }}"
        event="success"
        method="navigateTo"
        params={{ ordered: [{ screenPluginId: "StartRentalPage" }] }}
        pluginId=""
        type="navigator"
        waitMs="0"
        waitType="debounce"
      />
      <Event
        enabled="{{ HandleLockScan.data.lockStatus == 1 }}"
        event="success"
        method="navigateTo"
        params={{ ordered: [{ screenPluginId: "EndRentalPage" }] }}
        pluginId=""
        type="navigator"
        waitMs="0"
        waitType="debounce"
      />
    </RESTQuery>
    <RESTQuery
      id="RentalRequest"
      body={
        '[{"key":"LockId","value":"{{ LockId }}"},{"key":"RequestCode","value":"{{ RequestCode }}"}]'
      }
      bodyType="json"
      headers={
        '[{"key":"appUuid","value":"{{ AppUuid }}"},{"key":"sid","value":"{{ UserId }}"}]'
      }
      importedQueryInputs={{
        ordered: [
          { LockId: "{{ Rental.value.lockId }}" },
          { RequestCode: "{{ RequestCode.value }}" },
          { AppUuid: "{{ retoolContext.appUuid }}" },
          { UserId: "{{ current_user.sid }}" },
        ],
      }}
      isImported={true}
      playgroundQueryId={743218}
      playgroundQueryName="SignRentalRequest"
      playgroundQueryUuid="a3b183fb-56ef-4f3a-9a8b-00b8e61a46ab"
      query="https://bikesecure.azurewebsites.net/api/rentals/action"
      resourceName="REST-WithoutResource"
      runWhenModelUpdates={false}
      showLatestVersionUpdatedWarning={true}
      type="POST"
    >
      <Event
        enabled="{{ RentalRequest.data.url.startsWith('https')}}"
        event="success"
        method="trigger"
        params={{ ordered: [] }}
        pluginId="SDSGateway"
        type="datasource"
        waitMs="0"
        waitType="debounce"
      />
      <Event
        enabled="{{ RequestCode.value == 1 }}"
        event="success"
        method="trigger"
        params={{ ordered: [] }}
        pluginId="GetLock"
        type="datasource"
        waitMs="0"
        waitType="debounce"
      />
      <Event
        enabled="{{ RequestCode.value == 1 }}"
        event="success"
        method="navigateTo"
        params={{ ordered: [{ screenPluginId: "EndRentalPage" }] }}
        pluginId=""
        type="navigator"
        waitMs="0"
        waitType="debounce"
      />
      <Event
        enabled="{{ RequestCode.value == 0 }}"
        event="success"
        method="navigateTo"
        params={{ ordered: [{ screenPluginId: "RentalSummaryPage" }] }}
        pluginId=""
        type="navigator"
        waitMs="0"
        waitType="debounce"
      />
    </RESTQuery>
    <RESTQuery
      id="SDSGateway"
      body="{{ RentalRequest.data }}"
      bodyType="raw"
      headers={'[{"key":"Content-Type","value":"application/json"}]'}
      isMultiplayerEdited={false}
      query="{{ RentalRequest.data.url }}"
      resourceName="REST-WithoutResource"
      resourceTypeOverride=""
      runWhenModelUpdates={false}
      type="POST"
    />
  </Folder>
  <Folder id="TemporaryData">
    <State id="LockId" value="" />
    <State id="Rental" />
    <State id="RequestCode" />
  </Folder>
  <Folder id="MapQueries">
    <JavascriptQuery
      id="GetLocation"
      query={include("./lib/GetLocation.js", "string")}
      resourceName="JavascriptQuery"
    >
      <Event
        event="success"
        method="trigger"
        params={{ ordered: [] }}
        pluginId="GetStations"
        type="datasource"
        waitMs="0"
        waitType="debounce"
      />
    </JavascriptQuery>
    <RESTQuery
      id="GetStations"
      enableTransformer={true}
      headers={
        '[{"key":"appUuid","value":"{{ retoolContext.appUuid }}"},{"key":"sid","value":"{{ current_user.sid }}"}]'
      }
      query="https://bikesecure.azurewebsites.net/api/stations"
      resourceName="REST-WithoutResource"
      resourceTypeOverride=""
      runWhenModelUpdates={false}
      transformer="function haversineDistance(lat1, lon1, lat2, lon2) {
  const R = 6371e3;
  const p1 = lat1 * Math.PI/180;
  const p2 = lat2 * Math.PI/180;
  const deltaLon = lon2 - lon1;
  const deltaLambda = (deltaLon * Math.PI) / 180;
  const d = Math.acos(
    Math.sin(p1) * Math.sin(p2) + Math.cos(p1) * Math.cos(p2) * Math.cos(deltaLambda),
  ) * R;
  return (d / 1000).toFixed(2);
}

return data.map((station) => {
  station.distance = haversineDistance({{ GetLocation.data.latitude }}, {{ GetLocation.data.longitude }}, station.latitude, station.longitude);
  return station;
}).sort((x,y) => x.distance - y.distance).map((station) => {
  station.hourlyRate += ' \u20AA';
  station.distance += ' km';
  return station;
})"
    >
      <Event
        event="success"
        method="trigger"
        params={{ ordered: [] }}
        pluginId="GetStationLocations"
        type="datasource"
        waitMs="0"
        waitType="debounce"
      />
    </RESTQuery>
    <JavascriptQuery
      id="GetStationLocations"
      query={include("./lib/GetStationLocations.js", "string")}
      resourceName="JavascriptQuery"
    />
    <JavascriptQuery
      id="GetSelectedStation"
      query={include("./lib/GetSelectedStation.js", "string")}
      resourceName="JavascriptQuery"
    >
      <Event
        enabled=""
        event="success"
        method="trigger"
        params={{ ordered: [] }}
        pluginId="GetDirections"
        type="datasource"
        waitMs="0"
        waitType="debounce"
      />
    </JavascriptQuery>
    <JavascriptQuery
      id="GetDirections"
      query={include("./lib/GetDirections.js", "string")}
      resourceName="JavascriptQuery"
    >
      <Event
        enabled=""
        event="success"
        method="open"
        params={{
          ordered: [
            { title: "{{ GetSelectedStation.data.name }}" },
            {
              description:
                "Distance: {{ GetSelectedStation.data.distance }}\nHourly Rate: {{ GetSelectedStation.data.hourlyRate }}\nAvailable Locks: {{ GetSelectedStation.data.freeLockCount }}\nOwned Locks: {{ GetSelectedStation.data.ownedLockCount }}",
            },
            {
              actionItems: [
                {
                  ordered: [
                    { label: "Directions" },
                    {
                      event: {
                        ordered: [
                          { event: "click" },
                          { method: "openUrl" },
                          { pluginId: "" },
                          { type: "util" },
                          { waitMs: 0 },
                          { waitType: "debounce" },
                          {
                            params: {
                              ordered: [{ url: "{{ GetDirections.data }}" }],
                            },
                          },
                        ],
                      },
                    },
                  ],
                },
                {
                  ordered: [
                    { label: "Close" },
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
              ],
            },
          ],
        }}
        pluginId=""
        type="alert"
        waitMs="0"
        waitType="debounce"
      />
    </JavascriptQuery>
    <JavascriptQuery
      id="GetMatchingStations"
      query={include("./lib/GetMatchingStations.js", "string")}
      resourceName="JavascriptQuery"
    />
    <JavascriptQuery
      id="ClearStationsPage"
      query={include("./lib/ClearStationsPage.js", "string")}
      resourceName="JavascriptQuery"
    >
      <Event
        event="success"
        method="trigger"
        params={{ ordered: [] }}
        pluginId="GetMatchingStations"
        type="datasource"
        waitMs="0"
        waitType="debounce"
      />
    </JavascriptQuery>
  </Folder>
</GlobalFunctions>
