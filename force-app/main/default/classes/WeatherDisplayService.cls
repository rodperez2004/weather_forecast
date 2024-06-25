public class WeatherDisplayService {
	
    public static String callWeatherService(String url, String username, String password) {
        return callout(url, username, password);
    }
    
    private static String callout(String url, String username, String password) {

    	Http h = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint(url);
        req.setMethod('GET');
        
        Blob headerValue = Blob.valueOf(username + ':' + password);
        String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);
        req.setHeader('Authorization', authorizationHeader);
        
        try {
            HttpResponse res = h.send(req);
            System.debug(res.getStatusCode());
            if(res.getStatusCode() == 200){
            	return res.getBody();    
            }
            else {
            	WeatherDisplayHelper.createLog(res.getStatus(), UserInfo.getUserId());
                return null;
            }
            
        }
       catch(CalloutException e) {
           WeatherDisplayHelper.createLog(e.getMessage(), UserInfo.getUserId());
           return null;
        }
    }
}