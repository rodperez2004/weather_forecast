public class WeatherDisplayHelper {
	
    public static WeatherDetailsWrapper.WeatherDetails weatherService(String location) {
		MeteomaticsInfo__mdt meteomaticsInfo = MeteomaticsInfo__mdt.getAll().values()[0];
        String locationInfo = getLocationInfo(location);
        String url = getUrl(locationInfo,meteomaticsInfo);
        String response = WeatherDisplayService.callWeatherService(url, meteomaticsInfo.Username__c, meteomaticsInfo.Password__c);
        if(response != null) {
        	WeatherDetailsWrapper.WeatherDetails weatherWrapper = getWrapper(response, location);
        	return weatherWrapper;
        } else {
            return null;
        }
    }
    
    public static String getUrl(String locationInfo, MeteomaticsInfo__mdt meteomaticsInfo) {
        Date currentDate = Date.today();
        Date forecastDate = currentDate.addDays(4);
        String validDateTime = getDateFormat(currentDate) + '--' + getDateFormat(forecastDate); 
        
        return meteomaticsInfo.Url__c + validDateTime + ':P1D/t_mean_2m_24h:C/' + locationInfo + '/json'; 
    }
    
    public static String getLocationInfo(String location) {
        LocationInfo__mdt locationMetadata = LocationInfo__mdt.getInstance(location);
        String locationInfo = locationMetadata.Latitude__c + ',' + locationMetadata.Longitude__c;
        return locationInfo;
    }
    
    public static Map<String,String> getLocationMap() {
        Map<String,String> locationMap = new Map<String,String>();
        List<LocationInfo__mdt> locations = LocationInfo__mdt.getAll().values();
        
        for(LocationInfo__mdt location : locations) {
            locationMap.put(location.Label, location.DeveloperName);
        }
        
        return locationMap;
    }
    
    public static WeatherDetailsWrapper.WeatherDetails getwrapper(String response,String location) {
        WeatherDetailsWrapper.WeatherDetails weatherDetails = new WeatherDetailsWrapper.WeatherDetails();
        Map<String,Object> responseMap = (Map<String,Object>) JSON.deserializeUntyped(response);
        
        if(String.valueOf(responseMap.get('status')) == 'OK') {
            Map<String,Object> dataMap = (Map<String,Object>) responseMap.get('data');
       		List<WeatherDetailsWrapper.WeatherForecast> forecast = processForecastInfo(dataMap);
        	weatherDetails.forecast = forecast;
        }
        
       
        return weatherDetails;
    } 
    
    public static List<WeatherDetailsWrapper.WeatherForecast> processForecastInfo(Map<String,Object> dataMap) {
        List<WeatherDetailsWrapper.WeatherForecast> forecastList = new List<WeatherDetailsWrapper.WeatherForecast>();
        Map<String,Object> coordinatesMap = (Map<String,Object>) dataMap.get('coordinates');
        Map<String,Object> datesMap = (Map<String,Object>) dataMap.get('dates');
        
        
        for(String forecastDate : datesMap.keySet()) {
			WeatherDetailsWrapper.WeatherForecast forecast = new WeatherDetailsWrapper.WeatherForecast();
            Map<String,Object> forecastData = (Map<String,Object>) dataMap.get(forecastDate);
            forecast.forecastDate = forecastDate;
            forecastList.add(forecast);
        }
        if(!forecastList.isEmpty()) {
        	return forecastList;    
        } else {
            return null;
        }
    }
    
    public static String getDateFormat(Date dateToFormat) {
        String formattedDate = String.valueOf(dateToFormat.year()) + '-'; 
          	   formattedDate += String.valueOf(dateToFormat.month()) + '-'; 
               formattedDate += String.valueOf(dateToFormat.day());
  		       formattedDate += 'T00:00:00-03:00';
        return formattedDate; 
    }
    
    public static void createLog(String message, String userId) {
        
    }
}