

FROM microsoft/dotnet:2.1-sdk AS build

RUN apt-get update -yq && apt-get upgrade -yq && apt-get install -yq curl git nano
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash - && apt-get install -yq nodejs build-essential
RUN npm install -g npm
RUN npm install

WORKDIR /app
COPY *.csproj ./
RUN dotnet restore WeatherApp.csproj
COPY . ./
RUN dotnet publish WeatherApp.csproj -c Release -o out

FROM microsoft/dotnet:2.1-aspnetcore-runtime AS runtime
WORKDIR /app
COPY --from=build /app/out ./
EXPOSE 80/tcp
ENTRYPOINT ["dotnet", "WeatherApp.dll"]`
