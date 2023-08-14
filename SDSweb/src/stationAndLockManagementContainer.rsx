<Container
  id="stationAndLockManagementContainer"
  showBody={true}
  showHeader={true}
  style={{ ordered: [{ border: "rgba(199, 199, 199, 0)" }] }}
  styleContext={{ ordered: [] }}
>
  <Header>
    <Text
      id="stationAndLockManagementTitle"
      horizontalAlign="center"
      imageWidth="fill"
      style={{ ordered: [] }}
      value="#### 𝐒𝐭𝐚𝐭𝐢𝐨𝐧 𝐀𝐧𝐝 𝐋𝐨𝐜𝐤 𝐌𝐚𝐧𝐚𝐠𝐞𝐦𝐞𝐧𝐭"
      verticalAlign="center"
    />
  </Header>
  <View id="39a35" viewKey="View 1">
    <Modal
      id="addNewStationButton"
      _disclosedFields={{
        array: ["accent-background", "border-radius", "accent-foreground"],
      }}
      buttonText="Add new Station"
      closeOnOutsideClick={true}
      modalHeight="472px"
      modalHeightType="auto"
      style={{
        ordered: [
          { "border-color": "" },
          { "primary-surface": "" },
          { "accent-foreground": "" },
          { "primary-foreground": "" },
          { "accent-background": "rgba(4, 44, 79, 0.9)" },
          { "border-radius": "15px" },
          { "secondary-surface": "" },
          { "primary-text": "" },
          { "primary-background": "" },
        ],
      }}
    >
      <Form
        id="addNewStationForm"
        data={{ ordered: [] }}
        disableSubmit="{{ self.invalid }}"
        hidden=""
        hoistFetching={true}
        initialData=""
        resetAfterSubmit={true}
        showBody={true}
        showHeader={true}
        style={{
          ordered: [{ border: "surfacePrimary" }, { borderRadius: "8px" }],
        }}
        styleContext={{ ordered: [{ borderRadius: "8px" }] }}
      >
        <Header>
          <Text
            id="addNewStationFormTitle"
            _disclosedFields={["color"]}
            style={{ ordered: [{ color: "rgba(5, 5, 5, 1)" }] }}
            value="#### Add New Station"
            verticalAlign="center"
          />
          <TextInput
            id="stationNameInput"
            _disclosedFields={["required"]}
            label="Station Name"
            labelPosition="top"
            placeholder="Enter value"
            required={true}
            showClear={true}
          />
          <TextInput
            id="stationUrlInput"
            _disclosedFields={["required"]}
            customValidation={
              '{{ stationUrlInput.value.includes(" ") ? "Input cannot contain spaces." : "" }}'
            }
            label="Station Url"
            labelPosition="top"
            placeholder="Enter value"
            required={true}
            showClear={true}
          />
          <TextInput
            id="locationLatitudeInput"
            _disclosedFields={[
              "patternType",
              "iconBefore",
              "editIcon",
              "required",
            ]}
            iconBefore="bold/travel-map-location-pin"
            label="Location Latitude"
            labelPosition="top"
            placeholder="12.3456789 for example "
            required={true}
            showClear={true}
          />
          <TextInput
            id="locationLongitudeInput"
            iconBefore="bold/travel-map-location-pin"
            label="Location Longitude"
            labelPosition="top"
            placeholder="Enter value"
            required={true}
            showClear={true}
          />
          <NumberInput
            id="hourlyRateInput"
            currency="ILS"
            format="currency"
            inputValue={0}
            label="Hourly Rate"
            labelPosition="top"
            max="99.99"
            min="0"
            placeholder="Enter value"
            required={true}
            showClear={true}
            showSeparators={true}
            showStepper={true}
            value={0}
          />
        </Header>
        <Body>
          <Button
            id="submitNewStation"
            _disclosedFields={["background", "borderRadius", "border"]}
            iconBefore="bold/interface-add-circle"
            style={{
              ordered: [{ background: "success" }, { borderRadius: "8px" }],
            }}
            submitTargetId="addNewStationForm"
            text="Add Station"
          >
            <Event
              event="click"
              method="trigger"
              params={{ ordered: [] }}
              pluginId="addStation"
              type="datasource"
              waitMs="0"
              waitType="debounce"
            />
            <Event
              event="click"
              method="close"
              params={{ ordered: [] }}
              pluginId="addNewStationButton"
              type="widget"
              waitMs="0"
              waitType="debounce"
            />
          </Button>
        </Body>
      </Form>
    </Modal>
    <Select
      id="stationManagementSelect"
      data="{{ getStations.data }}"
      disabledByIndex="{{ item.deleted }}"
      emptyMessage="No options"
      hideLabel={false}
      iconByIndex="bold/travel-hotel-parking-sign-alternate"
      label=""
      labelPosition="top"
      labels="{{ item.name }}"
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
        pluginId="getLocksByStation"
        type="datasource"
        waitMs="0"
        waitType="debounce"
      />
      <Event
        event="change"
        method="trigger"
        params={{ ordered: [] }}
        pluginId="getSelectedStationManager"
        type="datasource"
        waitMs="0"
        waitType="debounce"
      />
    </Select>
    <Modal
      id="deployButton"
      _disclosedFields={{
        array: ["accent-background", "border-radius", "accent-foreground"],
      }}
      buttonText="Deploy"
      closeOnOutsideClick={true}
      modalHeight="472px"
      modalHeightType="auto"
      style={{
        ordered: [
          { "border-color": "" },
          { "primary-surface": "" },
          { "accent-foreground": "" },
          { "primary-foreground": "" },
          { "accent-background": "rgba(4, 44, 79, 0.9)" },
          { "border-radius": "15px" },
          { "secondary-surface": "" },
          { "primary-text": "" },
          { "primary-background": "" },
        ],
      }}
    >
      <Form
        id="addNewStationForm2"
        data={{ ordered: [] }}
        disableSubmit="{{ self.invalid }}"
        hidden=""
        hoistFetching={true}
        initialData=""
        resetAfterSubmit={true}
        showBody={true}
        showHeader={true}
        style={{
          ordered: [{ border: "surfacePrimary" }, { borderRadius: "8px" }],
        }}
        styleContext={{ ordered: [{ borderRadius: "8px" }] }}
      >
        <Header>
          <Text
            id="addNewStationFormTitle2"
            _disclosedFields={["color"]}
            horizontalAlign="center"
            style={{ ordered: [{ color: "rgba(5, 5, 5, 1)" }] }}
            value={
              '###### Complete the deployment process, by clicking the "Download" button'
            }
            verticalAlign="center"
          />
        </Header>
        <Body>
          <Table
            id="locksTechnicalDetailsTable2"
            cellSelection="none"
            clearChangesetOnSave={true}
            data="{{ getLocksByStation.data }}"
            defaultSelectedRow={{
              mode: "index",
              indexType: "display",
              index: 0,
            }}
            enableSaveActions={true}
            showBorder={true}
            showFooter={true}
            showHeader={true}
            toolbarPosition="bottom"
          >
            <Column
              id="81d4d"
              alignment="left"
              editable="false"
              format="string"
              key="lockId"
              label="lock_id"
              placeholder="Enter value"
              position="center"
              size={125.828125}
            />
            <Column
              id="e5f3c"
              alignment="left"
              format="string"
              key="lockMac"
              label="lock_mac"
              placeholder="Enter value"
              position="center"
              size={71.421875}
            />
            <Column
              id="e92cb"
              alignment="left"
              format="string"
              hidden="true"
              key="lockSecret"
              label="lock_secret"
              placeholder="Enter value"
              position="center"
              size={83.625}
            />
            <Action id="409ae" icon="bold/interface-login-key" label="Password">
              <Event
                event="clickAction"
                method="showNotification"
                params={{
                  ordered: [
                    {
                      options: {
                        ordered: [
                          { notificationType: "info" },
                          { title: "Locks Secret:" },
                          { description: "{{ currentRow.lockSecret }}" },
                        ],
                      },
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
                pluginId="locksTechnicalDetailsTable2"
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
                pluginId="locksTechnicalDetailsTable2"
                type="widget"
                waitMs="0"
                waitType="debounce"
              />
            </ToolbarButton>
          </Table>
          <Text
            id="text1"
            value="*Lock Secret by pressing the lock icon."
            verticalAlign="center"
          />
        </Body>
      </Form>
    </Modal>
    <Modal
      id="setHourlyRateButton"
      _disclosedFields={{
        array: ["accent-background", "border-radius", "accent-foreground"],
      }}
      buttonText="Set Hourly Rate"
      closeOnOutsideClick={true}
      events={[]}
      modalHeight="472px"
      modalHeightType="auto"
      style={{
        ordered: [
          { "border-color": "" },
          { "primary-surface": "" },
          { "accent-foreground": "" },
          { "primary-foreground": "" },
          { "accent-background": "rgba(4, 44, 79, 0.9)" },
          { "border-radius": "15px" },
          { "secondary-surface": "" },
          { "primary-text": "" },
          { "primary-background": "" },
        ],
      }}
    >
      <Form
        id="setHourlyRateForm"
        data={{ ordered: [] }}
        disableSubmit="{{ self.invalid }}"
        hidden="false"
        hoistFetching={true}
        initialData=""
        requireValidation={true}
        resetAfterSubmit={true}
        showBody={true}
        showHeader={true}
        style={{
          ordered: [{ border: "surfacePrimary" }, { borderRadius: "8px" }],
        }}
        styleContext={{ ordered: [{ borderRadius: "8px" }] }}
      >
        <Header>
          <Text
            id="setHourlyRateTitle"
            _disclosedFields={["color"]}
            style={{ ordered: [{ color: "rgba(0, 0, 0, 1)" }] }}
            value="#### Set Hourly Rate
**{{ getSelectedStationManager.data.name}}**"
            verticalAlign="center"
          />
        </Header>
        <Body>
          <Text
            id="CurrentHourlyRateForm"
            value="**Current Hourly Rate** (₪) **:** {{ getSelectedStationManager.data.hourlyRate}} "
            verticalAlign="center"
          />
          <NumberInput
            id="newHourlyRateInput"
            currency="ILS"
            decimalPlaces="2"
            format="currency"
            inputValue={0}
            label="New Hourly Rate:"
            max="99.99"
            min="0"
            placeholder="Enter value"
            required={true}
            showClear={true}
            showSeparators={true}
            showStepper={true}
            value={0}
          />
          <Button
            id="submitNewHourlyRate"
            disabled="{{ stationManagementSelect.value == null }}"
            iconBefore="bold/interface-validation-check-circle"
            style={{ ordered: [{ background: "success" }] }}
            styleVariant="solid"
            text="Submit Changes"
          >
            <Event
              event="click"
              method="trigger"
              params={{ ordered: [] }}
              pluginId="setHourlyRate"
              type="datasource"
              waitMs="0"
              waitType="debounce"
            />
            <Event
              event="click"
              method="close"
              params={{ ordered: [] }}
              pluginId="setHourlyRateButton"
              type="widget"
              waitMs="0"
              waitType="debounce"
            />
          </Button>
        </Body>
        <Event
          event="submit"
          method="run"
          params={{ ordered: [{ src: "close();" }] }}
          pluginId=""
          type="script"
          waitMs="0"
          waitType="debounce"
        />
      </Form>
    </Modal>
    <Modal
      id="getLocksStatusButton"
      _disclosedFields={{
        array: ["accent-background", "border-radius", "accent-foreground"],
      }}
      buttonText="Get Locks Status"
      closeOnOutsideClick={true}
      modalHeight="472px"
      modalHeightType="auto"
      style={{
        ordered: [
          { "border-color": "" },
          { "primary-surface": "" },
          { "accent-foreground": "" },
          { "primary-foreground": "" },
          { "accent-background": "rgba(4, 44, 79, 0.9)" },
          { "border-radius": "15px" },
          { "secondary-surface": "" },
          { "primary-text": "" },
          { "primary-background": "" },
        ],
      }}
    >
      <Form
        id="getLocksStatusForm"
        data={{ ordered: [] }}
        disableSubmit="{{ self.invalid }}"
        hidden=""
        hoistFetching={true}
        initialData=""
        requireValidation={true}
        resetAfterSubmit={true}
        showBody={true}
        showHeader={true}
        style={{
          ordered: [{ border: "surfacePrimary" }, { borderRadius: "8px" }],
        }}
        styleContext={{ ordered: [{ borderRadius: "8px" }] }}
      >
        <Header>
          <Text
            id="getLocksStatusTitle"
            _disclosedFields={["color"]}
            style={{ ordered: [{ color: "rgba(0, 0, 0, 1)" }] }}
            value="#### Get Locks Status"
            verticalAlign="center"
          />
        </Header>
        <Body>
          <Text
            id="getLocksStatusText"
            value="**Total Number Of Locks:** {{getSelectedStationManager.data.lockCount}}

**Number Of Locks In Use:** {{getSelectedStationManager.data.ownedLockCount}}

**Number Of Free Lock:** {{getSelectedStationManager.data.freeLockCount}}"
            verticalAlign="center"
          />
          <Button
            id="button1"
            disabled="{{ stationManagementSelect.value == null }}"
            styleVariant="solid"
            text="See Details"
          >
            <Event
              event="click"
              method="run"
              params={{
                ordered: [
                  {
                    src: "stationLocksSelect.setValue(stationManagementSelect.value);\ngetLocksOverview.trigger();\nlocksOverviewContainer.scrollIntoView();",
                  },
                ],
              }}
              pluginId=""
              type="script"
              waitMs="0"
              waitType="debounce"
            />
            <Event
              event="click"
              method="close"
              params={{ ordered: [] }}
              pluginId="getLocksStatusButton"
              type="widget"
              waitMs="0"
              waitType="debounce"
            />
          </Button>
        </Body>
        <Event
          event="submit"
          method=""
          params={{ ordered: [] }}
          pluginId=""
          type="datasource"
          waitMs="0"
          waitType="debounce"
        />
      </Form>
    </Modal>
    <Modal
      id="addLockButton"
      _disclosedFields={{
        array: ["accent-background", "border-radius", "accent-foreground"],
      }}
      buttonText="Add Lock"
      closeOnOutsideClick={true}
      modalHeight="472px"
      modalHeightType="auto"
      style={{
        ordered: [
          { "border-color": "" },
          { "primary-surface": "" },
          { "accent-foreground": "" },
          { "primary-foreground": "" },
          { "accent-background": "rgba(4, 44, 79, 0.9)" },
          { "border-radius": "15px" },
          { "secondary-surface": "" },
          { "primary-text": "" },
          { "primary-background": "" },
        ],
      }}
    >
      <Form
        id="addLockForm"
        data={{ ordered: [] }}
        disableSubmit="{{ self.invalid }}"
        hidden=""
        hoistFetching={true}
        initialData=""
        requireValidation={true}
        resetAfterSubmit={true}
        showBody={true}
        showHeader={true}
        style={{
          ordered: [{ border: "surfacePrimary" }, { borderRadius: "8px" }],
        }}
        styleContext={{ ordered: [{ borderRadius: "8px" }] }}
      >
        <Header>
          <Text
            id="addLockFormTitle"
            _disclosedFields={["color"]}
            style={{ ordered: [{ color: "rgba(0, 0, 0, 1)" }] }}
            value="#### Add Lock"
            verticalAlign="center"
          />
        </Header>
        <Body>
          <TextInput
            id="lockNameInput"
            hideLabel={false}
            label="Lock Name:"
            labelPosition="top"
            placeholder="Enter value"
            required={true}
          />
          <TextInput
            id="lockMacInput"
            hideLabel={false}
            label="Lock Mac:"
            labelPosition="top"
            placeholder="Enter value"
            required={true}
          />
          <Button
            id="submitNewLock"
            disabled="{{ stationManagementSelect.value == null }}"
            iconBefore="bold/interface-add-circle"
            style={{ ordered: [{ background: "success" }] }}
            styleVariant="solid"
            text="Add Lock"
          >
            <Event
              event="click"
              method="trigger"
              params={{ ordered: [] }}
              pluginId="addLock"
              type="datasource"
              waitMs="0"
              waitType="debounce"
            />
            <Event
              event="click"
              method="close"
              params={{ ordered: [] }}
              pluginId="addLockButton"
              type="widget"
              waitMs="0"
              waitType="debounce"
            />
          </Button>
        </Body>
        <Event
          event="submit"
          method=""
          params={{ ordered: [] }}
          pluginId=""
          type="datasource"
          waitMs="0"
          waitType="debounce"
        />
      </Form>
    </Modal>
    <Modal
      id="deleteLockButton"
      _disclosedFields={{
        array: ["accent-background", "border-radius", "accent-foreground"],
      }}
      buttonText="Delete Lock"
      closeOnOutsideClick={true}
      events={[
        {
          ordered: [
            { event: "open" },
            { type: "datasource" },
            { method: "trigger" },
            { pluginId: "getSelectedStationManager" },
            { targetId: null },
            { params: { ordered: [] } },
            { waitType: "debounce" },
            { waitMs: "0" },
          ],
        },
      ]}
      modalHeight="472px"
      modalHeightType="auto"
      style={{
        ordered: [
          { "border-color": "" },
          { "primary-surface": "" },
          { "accent-foreground": "" },
          { "primary-foreground": "" },
          { "accent-background": "rgba(4, 44, 79, 0.9)" },
          { "border-radius": "15px" },
          { "secondary-surface": "" },
          { "primary-text": "" },
          { "primary-background": "" },
        ],
      }}
    >
      <Form
        id="deleteLockForm"
        data={{ ordered: [] }}
        disableSubmit="{{ self.invalid }}"
        hidden=""
        hoistFetching={true}
        initialData=""
        requireValidation={true}
        resetAfterSubmit={true}
        showBody={true}
        showHeader={true}
        style={{
          ordered: [{ border: "surfacePrimary" }, { borderRadius: "8px" }],
        }}
        styleContext={{ ordered: [{ borderRadius: "8px" }] }}
      >
        <Header>
          <Text
            id="deleteLockFormTitle"
            _disclosedFields={["color"]}
            style={{ ordered: [{ color: "rgba(0, 0, 0, 1)" }] }}
            value="#### Delete Lock"
            verticalAlign="center"
          />
        </Header>
        <Body>
          <Select
            id="selectLockOptions"
            data="{{ getLocksByStation.data }}"
            disabledByIndex="{{ item.deleted }}"
            emptyMessage="No options"
            hideLabel={false}
            label="Select Lock:"
            labelPosition="top"
            labels="{{ item.lockName }}"
            overlayMaxHeight={375}
            placeholder="Select an option"
            showClear={true}
            showSelectionIndicator={true}
            style={{ ordered: [{ borderRadius: "15px" }] }}
            value={'""'}
            values="{{ item.lockId }}"
          />
          <Button
            id="submitLockDeletion"
            disabled="{{ stationManagementSelect.value == null }}"
            iconBefore="bold/interface-delete-circle"
            style={{ ordered: [{ background: "danger" }] }}
            styleVariant="solid"
            text="Delete Lock"
          >
            <Event
              event="click"
              method="trigger"
              params={{ ordered: [] }}
              pluginId="deleteLock"
              type="datasource"
              waitMs="0"
              waitType="debounce"
            />
            <Event
              event="click"
              method="close"
              params={{ ordered: [] }}
              pluginId="deleteLockButton"
              type="widget"
              waitMs="0"
              waitType="debounce"
            />
          </Button>
        </Body>
        <Event
          event="submit"
          method=""
          params={{ ordered: [] }}
          pluginId=""
          type="datasource"
          waitMs="0"
          waitType="debounce"
        />
      </Form>
    </Modal>
    <Modal
      id="deleteStationButton"
      _disclosedFields={{
        array: ["accent-background", "border-radius", "accent-foreground"],
      }}
      buttonText="Delete Station"
      closeOnOutsideClick={true}
      events={[
        {
          ordered: [
            { event: "open" },
            { type: "datasource" },
            { method: "trigger" },
            { pluginId: "getSelectedStation" },
            { targetId: null },
            { params: { ordered: [] } },
            { waitType: "debounce" },
            { waitMs: "0" },
          ],
        },
      ]}
      modalHeight="472px"
      modalHeightType="auto"
      style={{
        ordered: [
          { "border-color": "" },
          { "primary-surface": "" },
          { "accent-foreground": "" },
          { "primary-foreground": "" },
          { "accent-background": "rgba(4, 44, 79, 0.9)" },
          { "border-radius": "15px" },
          { "secondary-surface": "" },
          { "primary-text": "" },
          { "primary-background": "" },
        ],
      }}
    >
      <Form
        id="deleteStationForm"
        data={{ ordered: [] }}
        disableSubmit="{{ self.invalid }}"
        hidden=""
        hoistFetching={true}
        initialData=""
        requireValidation={true}
        resetAfterSubmit={true}
        showBody={true}
        showHeader={true}
        style={{
          ordered: [{ border: "surfacePrimary" }, { borderRadius: "8px" }],
        }}
        styleContext={{ ordered: [{ borderRadius: "8px" }] }}
      >
        <Header>
          <Text
            id="deleteStationFormTitle"
            _disclosedFields={["color"]}
            style={{ ordered: [{ color: "rgba(0, 0, 0, 1)" }] }}
            value="#### Delete Station"
            verticalAlign="center"
          />
        </Header>
        <Body>
          <Button
            id="submitStationDeletion"
            _disclosedFields={["background", "borderRadius", "border"]}
            disabled="{{ stationManagementSelect.value == null }}"
            iconBefore="bold/interface-delete-circle"
            style={{
              ordered: [{ background: "danger" }, { borderRadius: "8px" }],
            }}
            submitTargetId="deleteStationForm"
            text="Delete Station"
          >
            <Event
              event="click"
              method="trigger"
              params={{ ordered: [] }}
              pluginId="deleteStation"
              type="datasource"
              waitMs="0"
              waitType="debounce"
            />
            <Event
              event="click"
              method="showNotification"
              params={{
                ordered: [
                  {
                    options: {
                      ordered: [
                        { notificationType: "info" },
                        { title: "Pay Attention" },
                        {
                          description:
                            "The station deletion process will only occur once all ongoing rentals have concluded, and all associated locks will be removed.",
                        },
                      ],
                    },
                  },
                ],
              }}
              pluginId=""
              type="util"
              waitMs="0"
              waitType="debounce"
            />
            <Event
              event="click"
              method="close"
              params={{ ordered: [] }}
              pluginId="deleteStationButton"
              type="widget"
              waitMs="0"
              waitType="debounce"
            />
          </Button>
        </Body>
        <Event
          event="submit"
          method=""
          params={{ ordered: [] }}
          pluginId=""
          type="datasource"
          waitMs="0"
          waitType="debounce"
        />
      </Form>
    </Modal>
  </View>
</Container>
