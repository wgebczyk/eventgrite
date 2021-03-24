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

USER ContainerAdministrator
# if certificate is needed
#COPY YOUR_KEY_HERE.pfx .
#ENV ASPNETCORE_Kestrel__Certificates__Default__Password="YOUR_KEY_PASSWORD_HERE"
#ENV ASPNETCORE_Kestrel__Certificates__Default__Path="C:\\app\\YOUR_KEY_HERE.pfx"
ENV ASPNETCORE_ENVIRONMENT=Development
USER ContainerUser

ENTRYPOINT ["dotnet" "AzureEventGridSimulator.dll"]