FROM mcr.microsoft.com/dotnet/sdk:5.0 as build
WORKDIR /source

# restores nuget packages
COPY src/AzureEventGridSimulator/*.csproj .
RUN dotnet restore

# copy source code
COPY src/AzureEventGridSimulator .

# builds the source code using the SDK
RUN dotnet publish -c release -o /app

# runs the deployable on a separate image
# that is shipped with the .NET Runtime
FROM mcr.microsoft.com/dotnet/aspnet:5.0
WORKDIR /app
COPY --from=build /app .

# if certificate is needed
#COPY aspnetapp.pfx .
#ENV ASPNETCORE_Kestrel__Certificates__Default__Password="<cryptic-password>"
#ENV ASPNETCORE_Kestrel__Certificates__Default__Path="/app/aspnetapp.pfx"
ENV ASPNETCORE_ENVIRONMENT=Development

ENTRYPOINT ["dotnet", "AzureEventGridSimulator.dll"]