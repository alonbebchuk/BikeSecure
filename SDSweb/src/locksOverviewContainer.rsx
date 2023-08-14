<Container
  id="locksOverviewContainer"
  showBody={true}
  showHeader={true}
  style={{ ordered: [{ border: "rgba(199, 199, 199, 0)" }] }}
  styleContext={{ ordered: [] }}
>
  <Header>
    <Text
      id="locksOverviewTitle"
      value="#### 𝐋𝐨𝐜𝐤𝐬 𝐎𝐯𝐞𝐫𝐯𝐢𝐞𝐰"
      verticalAlign="center"
    />
  </Header>
  <View id="39a35" viewKey="View 1">
    <Select
      id="stationLocksSelect"
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
      values="{{ item.id }}"
    >
      <Event
        event="change"
        method="trigger"
        params={{ ordered: [] }}
        pluginId="getLocksOverview"
        type="datasource"
        waitMs="0"
        waitType="debounce"
      />
    </Select>
    <Table
      id="locksOverviewTable"
      cellSelection="none"
      changesetArray={[]}
      clearChangesetOnSave={true}
      data="{{ getLocksOverview.data }}"
      defaultSelectedRow={{ mode: "index", indexType: "display", index: 0 }}
      enableSaveActions={true}
      heightType="auto"
      primaryKeyColumnId="abc8b"
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
        id="abc8b"
        alignment="left"
        editable="false"
        format="string"
        hidden="true"
        key="lockId"
        label="Lock ID"
        placeholder="Enter value"
        position="center"
        size={272.9375}
      />
      <Column
        id="c5908"
        alignment="left"
        format="string"
        key="lockName"
        label="Lock name"
        placeholder="Enter value"
        position="left"
        size={154.921875}
      />
      <Column
        id="62cbc"
        alignment="center"
        format="boolean"
        formatOptions={{
          icon: '{{ { success:  "/icon:bold/interface-validation-check-circle"  }[item] }}',
        }}
        key="userId"
        label="In-Use"
        placeholder="Enter value"
        position="center"
        referenceId="In-Use"
        size={123}
      />
      <Column
        id="38be8"
        alignment="left"
        format="avatar"
        key="userId"
        label="User ID"
        placeholder="No user"
        position="center"
        size={478.234375}
        valueOverride="{{item == null?'-':item}}"
      />
      <Column
        id="f7a48"
        alignment="left"
        format="boolean"
        key="deleted"
        label="Deleted"
        placeholder="Enter value"
        position="center"
        size={100}
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
          pluginId="locksOverviewTable"
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
          pluginId="locksOverviewTable"
          type="widget"
          waitMs="0"
          waitType="debounce"
        />
      </ToolbarButton>
    </Table>
    <Text
      id="LocksOccupancyTitle"
      value="##### 𝐎𝐜𝐜𝐮𝐩𝐚𝐧𝐜𝐲 𝐨𝐟 𝐭𝐡𝐞 𝐥𝐨𝐜𝐤𝐬 𝐚𝐭 𝐭𝐡𝐞 𝐬𝐭𝐚𝐭𝐢𝐨𝐧:"
      verticalAlign="center"
    />
    <Text
      id="lockDistributionTitle"
      value="##### 𝐃𝐢𝐬𝐭𝐫𝐢𝐛𝐮𝐭𝐢𝐨𝐧 𝐨𝐟 𝐥𝐨𝐜𝐤𝐬 𝐛𝐞𝐭𝐰𝐞𝐞𝐧 𝐭𝐡𝐞 𝐬𝐭𝐚𝐭𝐢𝐨𝐧𝐬:"
      verticalAlign="center"
    />
    <ProgressBar id="progressBar1" label="" value="{{ locksOccupancy.data }}" />
    <PlotlyChart
      id="locksDivision"
      chartType="pie"
      dataseries={{
        ordered: [
          {
            4: {
              ordered: [
                { label: "lockCount" },
                {
                  datasource:
                    "{{formatDataAsObject(getStations.data)['lockCount']}}",
                },
                { chartType: "pie" },
                { aggregationType: "sum" },
                { color: null },
                {
                  colors: {
                    ordered: [
                      { 0: "#033663" },
                      { 1: "#247BC7" },
                      { 2: "#55A1E3" },
                      { 3: "#DAECFC" },
                      { 4: "#EECA86" },
                      { 5: "#E9AB11" },
                      { 6: "#D47E2F" },
                      { 7: "#C15627" },
                      { 8: "#224930" },
                      { 9: "#238146" },
                    ],
                  },
                },
                { visible: true },
                {
                  hovertemplate:
                    "<b>%{x}</b><br>%{fullData.name}: %{y}<extra></extra>",
                },
              ],
            },
          },
        ],
      }}
      datasourceDataType="array"
      datasourceInputMode="javascript"
      datasourceJS="{{getStations.data}}"
      isDataTemplateDirty={true}
      legendAlignment="left"
      marginType="normal"
      skipDatasourceUpdate={true}
      xAxis="{{formatDataAsObject(getStations.data).name}}"
      xAxisDropdown="name"
    />
    <Table
      id="locksOverviewStatisticsTable"
      cellSelection="none"
      changesetArray={[]}
      clearChangesetOnSave={true}
      data="{{ getStationsLocksAnalysis.data }}"
      defaultSelectedRow={{ mode: "index", indexType: "display", index: 0 }}
      enableSaveActions={true}
      heightType="auto"
      selectedDataIndexes={[]}
      selectedRowKeys={[]}
      selectedRows={[]}
      selectedSourceRows={[]}
      showBorder={true}
      showFooter={true}
      showHeader={true}
      sortArray={[]}
      templatePageSize={20}
    >
      <Column
        id="353d3"
        alignment="left"
        editable={false}
        format="string"
        key="Statistics"
        label="Category"
        placeholder="Enter value"
        position="center"
        size={184.1875}
      />
      <Column
        id="c672a"
        alignment="center"
        editableOptions={{ showStepper: true }}
        format="string"
        formatOptions={{ showSeparators: true, notation: "standard" }}
        key="col2"
        label="Value"
        placeholder="Enter value"
        position="center"
        size={46.375}
      />
    </Table>
  </View>
</Container>
