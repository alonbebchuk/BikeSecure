<Frame
  id="$header"
  _disclosedFields={{ array: ["primary-surface", "accent-background"] }}
  isHiddenOnDesktop={false}
  isHiddenOnMobile={false}
  paddingType="normal"
  sticky={true}
  style={{
    ordered: [
      { "primary-surface": "rgba(23, 107, 135, 0.3)" },
      { "primary-text": "" },
      { "accent-background": "" },
      { "border-color": "" },
      { "border-radius": "" },
      { "primary-background": "" },
    ],
  }}
  type="header"
>
  <Text
    id="websiteTitle"
    value="#### **𝙎𝙢𝙖𝙧𝙩 𝘿𝙤𝙘𝙠𝙞𝙣𝙜 𝙈𝙖𝙣𝙖𝙜𝙚𝙢𝙚𝙣𝙩**"
    verticalAlign="center"
  />
  <Avatar
    id="userDetails"
    fallback="{{ current_user.fullName }}"
    imageSize={24}
    label="{{ current_user.fullName }}"
    labelCaption="{{ current_user.email }}"
    src="{{ current_user.profilePhotoUrl }}"
    style={{ ordered: [{ background: "rgba(255, 255, 255, 1)" }] }}
  />
</Frame>
