Portal Settings:
    SQL Database {
        Resource group: rg-SDS,
        Database name: SDS database,
        Server: {
            Name: sds-sql-server,
            Authentication method: Use SQL authentication,
            Server admin login: sds
            Password: Pa$$word
        },
        Workload environment: Development,
        Connectivity method: Public endpoint,
        Allow Azure services and resources to access this server: Yes,
        Add current client IP address: Yes
    }