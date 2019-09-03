/**
 * Test class for System Logging Utilities class.
 *
 * @date    2018-03-09
 * @author  makepositive
 */
@isTest
public class LogUtilsTest {
    
    private static final Id EXAMPLE_ID = TestUtils.generateId( 'Contact' );

    /**
	 * @method 	log
	 * @case   	Insert info log entry with logging enabled
	 * @result 	A valid system log entry
	 */
    @isTest static void logUtils_log_params_infoLoggingEnabled() {
        LoggingSettingsDataFactory loggingSettingsFactory = new LoggingSettingsDataFactory();
        
        loggingSettingsFactory.create(
            loggingSettingsFactory.build(false, false, true)
        );
        
        Test.startTest();
            LogUtils.log(LogUtils.Level.Info, 'Test Reference', 'Test String', EXAMPLE_ID );
        Test.stopTest();
        
        verifySystemLog('Info', 'Test Reference', 'Test String', EXAMPLE_ID, 'logUtils_log_params_infoLoggingEnabled');
    }

    /**
	 * @method 	log
	 * @case   	Insert info log entry with logging disabled
	 * @result 	No system log entry
	 */
    @isTest static void logUtils_log_params_infoLoggingDisabled() {
        LoggingSettingsDataFactory loggingSettingsFactory = new LoggingSettingsDataFactory();
        
        loggingSettingsFactory.create(
            loggingSettingsFactory.build(true, true, false)
        );
        
        Test.startTest();
            LogUtils.log(LogUtils.Level.Info, 'Test Reference', 'Test String', EXAMPLE_ID );
        Test.stopTest();
        
        system.assertEquals(0, [SELECT COUNT() FROM System_Log__c], 'Logging disabled, should be no log entry');
    }

    /**
	 * @method 	log
	 * @case   	Insert warning log entry with logging enabled
	 * @result 	A valid system log entry
	 */
    @isTest static void logUtils_log_params_warningLoggingEnabled() {
        LoggingSettingsDataFactory loggingSettingsFactory = new LoggingSettingsDataFactory();
        
        loggingSettingsFactory.create(
            loggingSettingsFactory.build(false, true, false)
        );
        
        Test.startTest();
            LogUtils.log(LogUtils.Level.Warning, 'Test Reference', 'Test String', EXAMPLE_ID );
        Test.stopTest();
        
        verifySystemLog('Warning', 'Test Reference', 'Test String', EXAMPLE_ID, 'logUtils_log_params_warningLoggingEnabled');
    }

    /**
	 * @method 	log
	 * @case   	Insert warning log entry with logging disabled
	 * @result 	No system log entry
	 */
    @isTest static void logUtils_log_params_warningLoggingDisabled() {
        LoggingSettingsDataFactory loggingSettingsFactory = new LoggingSettingsDataFactory();
        
        loggingSettingsFactory.create(
            loggingSettingsFactory.build(true, false, true)
        );
        
        Test.startTest();
            LogUtils.log(LogUtils.Level.Warning, 'Test Reference', 'Test String', EXAMPLE_ID );
        Test.stopTest();
        
        system.assertEquals(0, [SELECT Count() FROM System_Log__c], 'Logging disabled, should be no log entry');
    }
    
    /**
	 * @method 	log
	 * @case   	Insert error log entry with logging enabled
	 * @result 	A valid system log entry
	 */
    @isTest static void logUtils_log_params_errorLoggingEnabled() {
        LoggingSettingsDataFactory loggingSettingsFactory = new LoggingSettingsDataFactory();
        
        loggingSettingsFactory.create(
            loggingSettingsFactory.build(true, false, false)
        );
        
        Test.startTest();
            LogUtils.log(LogUtils.Level.Error, 'Test Reference', 'Test String', EXAMPLE_ID );
        Test.stopTest();
        
        verifySystemLog('Error', 'Test Reference', 'Test String', EXAMPLE_ID, 'logUtils_log_params_errorLoggingEnabled');
    }

    /**
	 * @method 	log
	 * @case   	Insert error log entry with logging disabled
	 * @result 	No system log entry
	 */
    @isTest static void logUtils_log_params_errorLoggingDisabled() {
        LoggingSettingsDataFactory loggingSettingsFactory = new LoggingSettingsDataFactory();
        
        loggingSettingsFactory.create(
            loggingSettingsFactory.build(false, true, true)
        );
        
        Test.startTest();
            LogUtils.log(LogUtils.Level.Error, 'Test Reference', 'Test String', EXAMPLE_ID );
        Test.stopTest();
        
        system.assertEquals(0, [SELECT Count() FROM System_Log__c], 'Logging disabled, should be no log entry');
    }

    /**
	 * @method 	log
	 * @case   	Insert error log entry from an exception with default logging settings
	 * @result 	A valid system log entry
	 */
    @isTest static void logUtils_log_exception_defaultSettings() {
        Test.startTest();
        try {
            throw new TestException('Test Exception');
        } catch (TestException ex) {
            LogUtils.log('Test Reference', ex);
        }
        Test.stopTest();
        
        verifySystemLog('Error', 'Test Reference', 'Test Exception', null, 'logUtils_log_exception_defaultSettings');
    }

    /**
	 * @method 	log
	 * @case   	Insert error log entry from a dml exception with default logging settings
	 * @result 	A valid system log entry
	 */
    @isTest static void logUtils_log_dmlException_defaultSettings() {        
        Test.startTest();
        try {
            insert new Account();
        } catch (DmlException ex) {
            LogUtils.log('Test Reference', ex);
        }
        Test.stopTest();
        
        verifySystemLog('Error', 'Test Reference', 'REQUIRED_FIELD_MISSING', null, 'logUtils_log_dmlException_defaultSettings');
    }

    /**
     * Verify saved system log entry.
     * 
     * @date    2018-03-09
     * @author  makepositive
     * @param	String - Expected log entry level
     * @param	String - Expected log entry reference
     * @param	String - Expected log entry message
     * @param	String - Expected log entry record id
     * @param	String - Expected log entry method name
     */
    static void verifySystemLog(String expectedLevel, String expectedReference, String expectedMessage, String expectedId, String expectedMethod) {
        System_Log__c log = [SELECT Id, Level__c, Reference__c, Message__c, Class__c, Method__c, 
                             	Stack_Trace__c, Related_Record_Id__c, Source__c 
                             FROM System_Log__c
                             LIMIT 1][0];
        
        System.assertEquals(expectedLevel, log.Level__c, 'Level not set correctly');
        System.assertEquals(expectedReference, log.Reference__c, 'Reference not set correctly');
        System.assert(log.Message__c.contains(expectedMessage), 'Message not set correctly');
        System.assertEquals(expectedId, log.Related_Record_Id__c, 'Related Record not set correctly');
        System.assertEquals('LogUtilsTest', log.Class__c, 'Class not set correctly');
        System.assertEquals(expectedMethod, log.Method__c, 'Method not set correctly');
        System.assertEquals('Apex', log.Source__c, 'Source not set correctly');
        System.assert(log.Stack_Trace__c.contains('LogUtilsTest'), 'Stack trace should contain class');
        System.assert(log.Stack_Trace__c.contains(expectedMethod), 'Stack trace should contain method');
    }

    /**
     * Test Exception to check exception logging.
     * 
     * @date    2018-03-09
     * @author  makepositive
     */
    public class TestException extends Exception {}
}