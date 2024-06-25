public class WeatherDetailsWrapper {
	
    public class WeatherDetails { 
    	@AuraEnabled public List<WeatherForecast> forecast {get;set;}
   
        public WeatherDetails(){}

    }
    public class WeatherForecast {
        @AuraEnabled public String forecastDate {get;set;}
        @AuraEnabled public String temperature {get;set;}

        public WeatherForecast(){}
    }
}