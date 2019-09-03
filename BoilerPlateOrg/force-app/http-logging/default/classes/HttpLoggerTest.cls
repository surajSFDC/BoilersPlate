@isTest
private class HttpLoggerTest {

    /**
	 * @method 	responseHasAnErrorCode
	 * @case   	The passed response object has a status code
	 * @result 	Will return false for unambiguously successful requests, and true for potentially erroneous ones
	 */
    @isTest
    private static void responseHasAnErrorCode_respondsFalseIfTheStatusCodeOnTheResponseRepresentsSuccess() {

        Map<Integer,Boolean> expectedResponses = new Map<Integer,Boolean>();

        // Status code meanings taken from:
        //   https://developer.mozilla.org/en-US/docs/Web/HTTP/Status

        // Information responses
        expectedResponses.put( 100, true  ); // Continue
        expectedResponses.put( 101, true  ); // Switching Protocol
        expectedResponses.put( 102, true  ); // Processing
        expectedResponses.put( 103, true  ); // Early Hints

        // Successful responses
        expectedResponses.put( 200, false ); // OK
        expectedResponses.put( 201, false ); // Created
        expectedResponses.put( 202, false ); // Accepted
        expectedResponses.put( 203, false ); // Non-Authoritative Information
        expectedResponses.put( 204, false ); // No Content
        expectedResponses.put( 205, false ); // Reset Content
        expectedResponses.put( 206, false ); // Partial Content
        expectedResponses.put( 207, false ); // Multi-Status
        expectedResponses.put( 208, false ); // Multi-Status
        expectedResponses.put( 226, false ); // IM Used

        // Redirection messages
        expectedResponses.put( 300, true  ); // Multiple Choice
        expectedResponses.put( 301, true  ); // Moved Permanently
        expectedResponses.put( 302, true  ); // Found
        expectedResponses.put( 303, true  ); // See Other
        expectedResponses.put( 304, true  ); // Not Modified
        expectedResponses.put( 305, true  ); // Use Proxy
        expectedResponses.put( 307, true  ); // Temporary Redirect
        expectedResponses.put( 308, true  ); // Permanent Redirect

        // Client error responses
        expectedResponses.put( 400, true  ); // Bad Request
        expectedResponses.put( 401, true  ); // Unauthorized
        expectedResponses.put( 402, true  ); // Payment Required
        expectedResponses.put( 403, true  ); // Forbidden
        expectedResponses.put( 404, true  ); // Not Found
        expectedResponses.put( 405, true  ); // Method Not Allowed
        expectedResponses.put( 406, true  ); // Not Acceptable
        expectedResponses.put( 407, true  ); // Proxy Authentication Required
        expectedResponses.put( 408, true  ); // Request Timeout
        expectedResponses.put( 409, true  ); // Conflict
        expectedResponses.put( 410, true  ); // Gone
        expectedResponses.put( 411, true  ); // Length Required
        expectedResponses.put( 412, true  ); // Precondition Failed
        expectedResponses.put( 413, true  ); // Payload Too Large
        expectedResponses.put( 414, true  ); // URI Too Long
        expectedResponses.put( 415, true  ); // Unsupported Media Type
        expectedResponses.put( 416, true  ); // Requested Range Not Satisfiable
        expectedResponses.put( 417, true  ); // Expectation Failed
        expectedResponses.put( 418, true  ); // I'm a teapot
        expectedResponses.put( 421, true  ); // Misdirected Request
        expectedResponses.put( 422, true  ); // Unprocessable Entity (WebDAV)
        expectedResponses.put( 423, true  ); // Locked (WebDAV)
        expectedResponses.put( 424, true  ); // Failed Dependency (WebDAV)
        expectedResponses.put( 425, true  ); // Too Early
        expectedResponses.put( 426, true  ); // Upgrade Required
        expectedResponses.put( 428, true  ); // Precondition Required
        expectedResponses.put( 429, true  ); // Too Many Requests
        expectedResponses.put( 431, true  ); // Request Header Fields Too Large
        expectedResponses.put( 451, true  ); // Unavailable For Legal Reasons

        // Server error responses
        expectedResponses.put( 500, true  ); // Internal Server Error
        expectedResponses.put( 501, true  ); // Not Implemented
        expectedResponses.put( 502, true  ); // Bad Gateway
        expectedResponses.put( 503, true  ); // Service Unavailable
        expectedResponses.put( 504, true  ); // Gateway Timeout
        expectedResponses.put( 505, true  ); // HTTP Version Not Supported
        expectedResponses.put( 506, true  ); // Variant Also Negotiates
        expectedResponses.put( 507, true  ); // Insufficient Storage
        expectedResponses.put( 508, true  ); // Loop Detected (WebDAV)
        expectedResponses.put( 510, true  ); // Not Extended
        expectedResponses.put( 511, true  ); // Network Authentication Required

        Test.startTest();
            for( Integer thisStatusCode : expectedResponses.keySet() ) {

                HttpResponse response = new HttpResponse();
                response.setStatusCode( thisStatusCode );

                Boolean actualHasErrorCode   = HttpLogger.responseHasAnErrorCode( response );
                Boolean expectedHasErrorCode = expectedResponses.get( thisStatusCode );

                String assertionMessage = 'responseHasAnErrorCode, when passed a response with a status code of ' + String.valueOf( thisStatusCode ) + ' will respond with ' + (expectedHasErrorCode?'true':'false');

                System.assertEquals( expectedResponses.get( thisStatusCode ), actualHasErrorCode, assertionMessage );
            }
        Test.stopTest();
    }

    /**
	 * @method 	log
	 * @case   	When success logging is switched on, and a success response is provided
	 * @result 	Will create an HTTP Response log entry
	 */
    @isTest
    private static void log_whenSuccessLoggingIsSwitchedOn_andASuccessResponseIsProvided_willLogTheResponseAndRequest() {

        switchOnSuccessLogging();

        HttpResponse response = new HttpResponse();
        response.setStatusCode( 200 );

        HttpRequest request = new HttpRequest();

        Test.startTest();
            Id logId = HttpLogger.log( 'ServiceName', request, response );
        Test.stopTest();

        System.assert( logId != null, 'log, when success logging is on, and a success response is provided, will log the response and request' );
    }


    /**
	 * @method 	log
	 * @case   	When success logging is switched off, and a success response is provided
	 * @result 	Will NOT create an HTTP Response log entry
	 */
    @isTest
    private static void log_whenSuccessLoggingIsSwitchedOff_andASuccessResponseIsProvided_willNotLogTheResponseAndRequest() {

        switchOffLogging();

        HttpResponse response = new HttpResponse();
        response.setStatusCode( 200 );

        HttpRequest request = new HttpRequest();

        Test.startTest();
            Id logId = HttpLogger.log( 'ServiceName', request, response );
        Test.stopTest();

        System.assertEquals( null, logId, 'log, when success logging is off, and a success response is provided, will NOT log the response and request' );
    }

    /**
	 * @method 	log
	 * @case   	When no logging configuration exists, and a success response is provided
	 * @result 	Will NOT create an HTTP Response log entry
	 */
    @isTest
    private static void log_whenNoLoggingConfigurationExists_andASuccessResponseIsProvided_willNotLogTheResponseAndRequest() {

        HttpResponse response = new HttpResponse();
        response.setStatusCode( 200 );

        HttpRequest request = new HttpRequest();

        Test.startTest();
            Id logId = HttpLogger.log( 'ServiceName', request, response );
        Test.stopTest();

        System.assertEquals( null, logId, 'log, when no logging config exists, and a success response is provided, will NOT log the response and request' );
    }

    /**
	 * @method 	log
	 * @case   	When Failure logging is switched on, and a Failure response is provided
	 * @result 	Will create an HTTP Response log entry
	 */
    @isTest
    private static void log_whenFailureLoggingIsSwitchedOn_andAFailureResponseIsProvided_willLogTheResponseAndRequest() {

        switchOnFailureLogging();

        HttpResponse response = new HttpResponse();
        response.setStatusCode( 500 );

        HttpRequest request = new HttpRequest();

        Test.startTest();
            Id logId = HttpLogger.log( 'ServiceName', request, response );
        Test.stopTest();

        System.assert( logId != null, 'log, when Failure logging is on, and a Failure response is provided, will log the response and request' );
    }


    /**
	 * @method 	log
	 * @case   	When Failure logging is switched off, and a Failure response is provided
	 * @result 	Will NOT create an HTTP Response log entry
	 */
    @isTest
    private static void log_whenFailureLoggingIsSwitchedOff_andAFailureResponseIsProvided_willNotLogTheResponseAndRequest() {

        switchOffLogging();

        HttpResponse response = new HttpResponse();
        response.setStatusCode( 500 );

        HttpRequest request = new HttpRequest();

        Test.startTest();
            Id logId = HttpLogger.log( 'ServiceName', request, response );
        Test.stopTest();

        System.assertEquals( null, logId, 'log, when Failure logging is off, and a Failure response is provided, will NOT log the response and request' );
    }

    /**
	 * @method 	log
	 * @case   	When no logging configuration exists, and a Failure response is provided
	 * @result 	Will NOT create an HTTP Response log entry
	 */
    @isTest
    private static void log_whenNoLoggingConfigurationExists_andAFailureResponseIsProvided_willNotLogTheResponseAndRequest() {

        HttpResponse response = new HttpResponse();
        response.setStatusCode( 500 );

        HttpRequest request = new HttpRequest();

        Test.startTest();
            Id logId = HttpLogger.log( 'ServiceName', request, response );
        Test.stopTest();

        System.assertEquals( null, logId, 'log, when no logging configuration exists, and a Failure response is provided, will NOT log the response and request' );
    }

    private static void switchOnSuccessLogging() {
        setupLogging( false, true );
    }

    private static void switchOnFailureLogging() {
        setupLogging( true, false );
    }

    private static void switchOffLogging() {
        setupLogging( false, false );
    }

    private static void setupLogging( Boolean failureLogging, Boolean successLogging ) {

        LoggingSettingsDataFactory factory = new LoggingSettingsDataFactory();
        Logging_Settings__c logSettings = factory.build();
        logSettings.Enable_Http_Request_Failure_Logging__c = failureLogging;
        logSettings.Enable_Http_Request_Success_Logging__c = successLogging;
        insert logSettings;
    }    
}
