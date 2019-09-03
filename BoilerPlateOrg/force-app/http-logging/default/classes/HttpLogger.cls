/**
* System HTTP Request and Response logging Utilities class.
*
* A collection of utility methods for logging HTTP messages to the HTTP Response Log.
*
* Documentation on usage can be found here:
*    https://makepositive.atlassian.net/wiki/spaces/DEV/pages/1236041904/HTTP+Logging
* 
* @date    2019-06-25
* @author  makepositive
*/
public inherited sharing class HttpLogger {

	public class HttpLoggerException extends Exception {}

	/**
	 * Will examine the HTTP Status code and decide if the code represents an error
	 * 
	 * @date    2019-06-25
	 * @author  makepositive
	 * @param   HttpResonse - The response to examine
	 * @return  Boolean - States true if the response contains an error
	 */
	public static Boolean responseHasAnErrorCode( HttpResponse response ) {
		if ( response.getStatusCode() < 200 ) {
			return true;
		}
		return ( response.getStatusCode() >= 300 );
	}

	/**
	 * Log the provided HttpRequest and Response objects into the HTTP_Response object
	 *
	 * Based on custom settings, will either log in all cases (for debugging purposes)
	 * or only when there's an error.
	 * 
	 * @date    2019-06-25
	 * @author  makepositive
	 * @param   String - A reasonably descriptive term for the service that was being requested
	 * @param   HttpRequest - The HTTP request object that was used to make the request
	 * @param   HttpResponse - The HTTP response object that was generated
	 * @return  Id - The Id of the created HTTP_Response object
	 */
	public static Id log( String serviceName, HttpRequest request, HttpResponse response ) {

		Logging_Settings__c logLevels = Logging_Settings__c.getInstance();

        Boolean shouldLog = responseHasAnErrorCode( response ) ? logLevels.Enable_Http_Request_Failure_Logging__c : logLevels.Enable_Http_Request_Success_Logging__c;

		if ( shouldLog ) {

			try {

				HTTP_Response__c log           = new HTTP_Response__c();

				log.Service_Name__c            = serviceName;
	       
				log.Request_Body__c            = request.getBody().abbreviate( 131072 );
				log.Request_Endpoint__c        = request.getEndpoint();
				log.Request_Method__c          = request.getMethod();

				log.Response_Status_Code__c    = response.getStatusCode();
				log.Response_Status_Message__c = response.getStatus();
				log.Response_Body__c           = response.getBody().abbreviate( 131072 );

				String headers = '';
				for( String thisHeaderKey : response.getHeaderKeys() ) {
					headers = headers + thisHeaderKey + ': ' + response.getHeader( thisHeaderKey ) + '\n';
				}

				log.Response_Headers__c        = headers.abbreviate( 32768 );

				insert log;

				return log.Id;

			} catch ( Exception e ) {
				throw new HttpLoggerException( 'Unable to log the HTTP response.' );
			}
		}

		return null;
	}
}