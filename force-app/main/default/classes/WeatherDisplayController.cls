public with sharing class WeatherDisplayController {

    @AuraEnabled
    public static WeatherDetailsWrapper.WeatherDetails getWeather(String location) {       
        return WeatherDisplayHelper.weatherService(location);
    }
    
    @AuraEnabled
    public static Map<String,String> getLocationInfo() {
        return WeatherDisplayHelper.getLocationMap();
    }
}