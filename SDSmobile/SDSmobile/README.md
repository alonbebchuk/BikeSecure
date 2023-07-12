Portal Settings:
	[https://www.youtube.com/watch?v=QO8XKsJ51Gc&t=1215s]
	1)
	Azure AD B2C Tenant {
		Organization name: SDS,
		Initial domain name: smartdockingstation,
		Resource group: rg-SDS
	}

	2)
	Azure AD B2C: Identity provider {
		Local account: Email
	}

	Azure AD B2C: User flow {
		Name: signupsignin,
		Local accounts: Email signup
	}

	3)
	Azure AD B2C: App registration {
		Name: SDS mobile app
		Supported account types: Accounts in any identity provider or organizational directory	
	}

	SDS mobile app: Authentication {
		Platform: Mobile and desktop applications
		Redirect URI: msal{ClientID}://auth,
		Allow public client flows: Yes
	}

	[https://www.youtube.com/watch?v=uST0CyqRIHA&t=24s]
	4)
	Function App {
		Resource group: rg-SDS,
		Function App name: smartdockingstation,
		Runtime stack: .NET,
		Storage account: sds0storage0account
	}

	5)
	Api Management Service {
		Resource group: rg-SDS,
		Resource name: smartdockingstation
		Organization name: SDS,
		Administrator email: alon.bebchuk@gmail.com
	}

	Api Management Service: APIs {
		Function App: smartdockingstation
	}

	smartdockingstation API: Settings {
		Subscription required: No
	}

	6)
	App Registration {
		Name: SDS api
		Supported account types: Accounts in any identity provider or organizational directory	
	}

	SDS api: Expose an API {
		Application ID URI: https://smartdockingstation.onmicrosoft.com/api,
		Scopes: [{
			Scope name: Read,
			Admin consent display name: Read api,
			Admin consent description: Read api
		}, {
			Scope name: Write,
			Admin consent display name: Write api,
			Admin consent description: Write api
		}]
	}

	SDS mobile app: API permissions {
		My APIs: SDS api,
		Delegated permissions: Read, Write
	}

	SDS mobile app: API permissions: Grant admin consent for SDS mobile app

	7)
	smartdockingstation API: All operations: Policies {
		In line 15 Paste: """
			<validate-jwt header-name="Authorization">
				<openid-config url="{B2C_1_signupsignin: Run user flow: Click url: Url}" />
				<audiences>
					<audience>{SDS api: Client Id}</audience>
				</audiences>
				<issuers>
					<issuer>{B2C_1_signupsignin: Run user flow: Click url: issuer}</issuer>
				</issuers>
			</validate-jwt>
		"""
	}

Code Settings:
	1)
	appsettings.json {
		TenantId: SDS Directory ID,
		ClientId: SDS mobile app Client ID
	}

	2)
	MsalActivity.cs {
		DataScheme: "msal{SDS mobile app Client ID}"
	}

	3)
	AndroidManifest.xml {
		android:scheme: "msal{SDS mobile app Client ID}"
	}
	