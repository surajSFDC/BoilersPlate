@isTest
public class AbstractBatchTest {

    @TestSetup
    static void setup(){
        LoggingSettingsDataFactory loggingFactory = new LoggingSettingsDataFactory();
        loggingFactory.create( loggingFactory.build() );
    }

    @isTest
    public static void execute_ifTheBatchProcessThrowsAnException() {

        createContactsToProcess( 10 );

        TestableBatch batch = new TestableBatch();

        Boolean exceptionThrown = false;

        try {
            Test.startTest();
                batch.throwException = true;
                Database.executeBatch( batch );
            Test.stopTest();
        } catch ( Exception e ) {
            exceptionThrown = true;
        }

        System.assertEquals( true, exceptionThrown, 'When a batch process execute method throws an exception, it bubbles to the top' );
    }


    @isTest
    public static void execute_ifTheBatchProcessHasNothingToProcess() {

        TestableBatch batch = new TestableBatch();

        Boolean exceptionThrown = false;

        try {
            Test.startTest();
                batch.throwException = true;
                Database.executeBatch( batch );
            Test.stopTest();
        } catch ( Exception e ) {
            exceptionThrown = true;
        }

        System.assertEquals( false, exceptionThrown, 'When the batch has nothing to process, the batch process does not throw an exception' );

        List<System_Log__c> logs = getLogs();
        System.assertEquals( 1     , logs.size()       , 'When the batch has nothing to process, a log record is generated' );
        System.assertEquals( 'Info', logs[0].Level__c  , 'When the batch has nothing to process, a log record is generated with the level of Info' );
        System.assertEquals( 'Apex', logs[0].Source__c , 'When the batch has nothing to process, a log record is generated with the source of Apex' );

        System.assert( logs[0].Message__c.contains( 'Total Job Items: 0'  ), 'When the batch has nothing to process, a log record is generated with the total number of job items (is ' + logs[0].Message__c + ')' );
        System.assert( logs[0].Message__c.contains( 'Number of Errors: 0' ), 'When the batch has nothing to process, a log record is generated with the number of errors (is ' + logs[0].Message__c + ')' );
        System.assert( logs[0].Message__c.contains( 'Total Records: 0'    ), 'When the batch has nothing to process, a log record is generated with the total number of records (is ' + logs[0].Message__c + ')' );
        System.assert( logs[0].Message__c.contains( 'Success Count: 0'    ), 'When the batch has nothing to process, a log record is generated with the success count (is ' + logs[0].Message__c + ')' );
        System.assert( logs[0].Message__c.contains( 'Error Count: 0'      ), 'When the batch has nothing to process, a log record is generated with the error count (is ' + logs[0].Message__c + ')' );
    }

    @isTest
    public static void execute_ifTheBatchProcessUpdatesRecords() {

        createContactsToProcess( 10 );

        TestableBatch batch = new TestableBatch();

        Boolean exceptionThrown = false;

        try {
            Test.startTest();
                batch.updateRecords = true;
                Database.executeBatch( batch );
            Test.stopTest();
        } catch ( Exception e ) {
            exceptionThrown = true;
        }

        System.assertEquals( false, exceptionThrown, 'When the batch updates records using the standard updateRecords, the batch process does not throw an exception' );

        List<System_Log__c> logs = getLogs();
        System.assertEquals( 1     , logs.size()      , 'When the batch updates records using the standard updateRecords, a log record is generated' );
        System.assertEquals( 'Info', logs[0].Level__c , 'When the batch updates records using the standard updateRecords, a log record is generated with the level of Info' );
        System.assertEquals( 'Apex', logs[0].Source__c, 'When the batch updates records using the standard updateRecords, a log record is generated with the source of Apex' );

        System.assert( logs[0].Message__c.contains( 'Total Job Items: 1'  ), 'When the batch updates records using the standard updateRecords, a log record is generated with the total number of job items (is ' + logs[0].Message__c + ')' );
        System.assert( logs[0].Message__c.contains( 'Number of Errors: 0' ), 'When the batch updates records using the standard updateRecords, a log record is generated with the number of errors (is ' + logs[0].Message__c + ')' );
        System.assert( logs[0].Message__c.contains( 'Total Records: 10'   ), 'When the batch updates records using the standard updateRecords, a log record is generated with the total number of records (is ' + logs[0].Message__c + ')' );
        System.assert( logs[0].Message__c.contains( 'Success Count: 10'   ), 'When the batch updates records using the standard updateRecords, a log record is generated with the success count (is ' + logs[0].Message__c + ')' );
        System.assert( logs[0].Message__c.contains( 'Error Count: 0'      ), 'When the batch updates records using the standard updateRecords, a log record is generated with the error count (is ' + logs[0].Message__c + ')' );
    }
    
    @isTest
    public static void execute_ifTheBatchProcessUpdatesRecords_andOneFails() {

        createContactsToProcess( 10 );

        TestableBatch batch = new TestableBatch();

        Boolean exceptionThrown = false;

        try {
            Test.startTest();
                batch.updateRecords = true;
                batch.breakARecord  = true;
                Database.executeBatch( batch );
            Test.stopTest();
        } catch ( Exception e ) {
            exceptionThrown = true;
        }

        System.assertEquals( false, exceptionThrown, 'When the batch updates records using the standard updateRecords and one fails, the batch process does not throw an exception' );

        List<System_Log__c> logs = getLogs();
        System.assertEquals( 1     , logs.size()       , 'When the batch updates records using the standard updateRecords and one fails, a log record is generated' );
        System.assertEquals( 'Info', logs[0].Level__c  , 'When the batch updates records using the standard updateRecords and one fails, a log record is generated with the level of Info' );
        System.assertEquals( 'Apex', logs[0].Source__c , 'When the batch updates records using the standard updateRecords and one fails, a log record is generated with the source of Apex' );

        System.assert( logs[0].Message__c.contains( 'Total Job Items: 1'  ), 'When the batch updates records using the standard updateRecords and one fails, a log record is generated with the total number of job items (is ' + logs[0].Message__c + ')' );
        System.assert( logs[0].Message__c.contains( 'Number of Errors: 0' ), 'When the batch updates records using the standard updateRecords and one fails, a log record is generated with the number of errors (the number of batches that failed) (is ' + logs[0].Message__c + ')' );
        System.assert( logs[0].Message__c.contains( 'Total Records: 10'   ), 'When the batch updates records using the standard updateRecords and one fails, a log record is generated with the total number of records (is ' + logs[0].Message__c + ')' );
        System.assert( logs[0].Message__c.contains( 'Success Count: 9'    ), 'When the batch updates records using the standard updateRecords and one fails, a log record is generated with the success count (is ' + logs[0].Message__c + ')' );
        System.assert( logs[0].Message__c.contains( 'Error Count: 1'      ), 'When the batch updates records using the standard updateRecords and one fails, a log record is generated with the error count (is ' + logs[0].Message__c + ')' );
    }

    @isTest
    public static void execute_ifTheBatchProcessDeletesRecords() {

        createContactsToProcess( 10 );

        TestableBatch batch = new TestableBatch();

        Boolean exceptionThrown = false;

        try {
            Test.startTest();
                batch.deleteRecords = true;
                Database.executeBatch( batch );
            Test.stopTest();
        } catch ( Exception e ) {
            exceptionThrown = true;
        }

        System.assertEquals( false, exceptionThrown, 'When a child batch process sucessfully deletes records, the batch process does not throw an exception' );

        List<System_Log__c> logs = getLogs();
        System.assertEquals( 1     , logs.size()       , 'When the batch deletes records using the standard deleteRecords, a log record is generated' );
        System.assertEquals( 'Info', logs[0].Level__c  , 'When the batch deletes records using the standard deleteRecords, a log record is generated with the level of Info' );
        System.assertEquals( 'Apex', logs[0].Source__c , 'When the batch deletes records using the standard deleteRecords, a log record is generated with the source of Apex' );

        System.assert( logs[0].Message__c.contains( 'Total Job Items: 1'  ), 'When the batch deletes records using the standard deleteRecords, a log record is generated with the total number of job items (is ' + logs[0].Message__c + ')' );
        System.assert( logs[0].Message__c.contains( 'Number of Errors: 0' ), 'When the batch deletes records using the standard deleteRecords, a log record is generated with the number of errors (is ' + logs[0].Message__c + ')' );
        System.assert( logs[0].Message__c.contains( 'Total Records: 10'   ), 'When the batch deletes records using the standard deleteRecords, a log record is generated with the total number of records (is ' + logs[0].Message__c + ')' );
        System.assert( logs[0].Message__c.contains( 'Success Count: 10'   ), 'When the batch deletes records using the standard deleteRecords, a log record is generated with the success count (is ' + logs[0].Message__c + ')' );
        System.assert( logs[0].Message__c.contains( 'Error Count: 0'      ), 'When the batch deletes records using the standard deleteRecords, a log record is generated with the error count (is ' + logs[0].Message__c + ')' );
    }    

    @isTest
    public static void start_executesSomeHooksOnTheDerivedClass() {

        TestableBatch batch = new TestableBatch();

        Test.startTest();
            batch.start( null );
        Test.stopTest();

        System.assertEquals( 2, batch.hooksCalled.size(), 'When a batch processes is started, the parent start will call hooks on the derived class' );
        System.assertEquals( 'setBatchSettings', batch.hooksCalled[0], 'When a batch processes is started, the parent start will call the setBatchSettings hook on the derived class first' );
        System.assertEquals( 'start'           , batch.hooksCalled[1], 'When a batch processes is started, the parent start will call the start hook on the derived class second' );
    }

    @isTest
    public static void start_willSetTheJobStartTime() {

        TestableBatch batch = new TestableBatch();

        Test.startTest();
            batch.start( null );
        Test.stopTest();

        System.assertNotEquals( null, batch.jobStartTime, 'When a batch processes is started, the start time is recorded' );
    }

    @isTest
    public static void start_willSwitchOffProcessesIfConfiguredTo() {

        TestableBatch batch = new TestableBatch();

        Test.startTest();
            batch.disableProcessing = true;
            batch.start( null );
        Test.stopTest();

        Process_Deactivation__c deactivationSettings = Process_Deactivation__c.getValues( UserInfo.getUserId() );

        System.assertEquals( true , deactivationSettings.Disable_All_Triggers__c     , 'When a batch processes is started and disable processing is switched on, the triggers are switched off' );
        System.assertEquals( true , deactivationSettings.Disable_Outbound_Messages__c, 'When a batch processes is started and disable processing is switched on, the outbound messages are switched off' );
        System.assertEquals( true , deactivationSettings.Disable_Email_Alerts__c     , 'When a batch processes is started and disable processing is switched on, the email alerts are switched off' );
        System.assertEquals( true , deactivationSettings.Disable_Workflows__c        , 'When a batch processes is started and disable processing is switched on, the workflows are switched off' );
        System.assertEquals( false, deactivationSettings.Disable_Validation_Rules__c , 'When a batch processes is started and disable processing is switched on, the validation rules are NOT switched off' );
    }

    @isTest
    public static void start_willSwitchOffValidationIfConfiguredTo() {

        TestableBatch batch = new TestableBatch();

        Test.startTest();
            batch.disableValidation = true;
            batch.start( null );
        Test.stopTest();

        Process_Deactivation__c deactivationSettings = Process_Deactivation__c.getValues( UserInfo.getUserId() );

        System.assertEquals( false, deactivationSettings.Disable_All_Triggers__c     , 'When a batch processes is started and disable processing is switched on, the triggers are NOT switched off' );
        System.assertEquals( false, deactivationSettings.Disable_Outbound_Messages__c, 'When a batch processes is started and disable processing is switched on, the outbound messages are NOT switched off' );
        System.assertEquals( false, deactivationSettings.Disable_Email_Alerts__c     , 'When a batch processes is started and disable processing is switched on, the email alerts are NOT switched off' );
        System.assertEquals( false, deactivationSettings.Disable_Workflows__c        , 'When a batch processes is started and disable processing is switched on, the workflows are NOT switched off' );
        System.assertEquals( true , deactivationSettings.Disable_Validation_Rules__c , 'When a batch processes is started and disable processing is switched on, the validation rules are switched off' );
    }

    @isTest
    public static void start_returnsADatabaseQueryLocatorWithTheQueryAsSpecifiedOnTheClass() {

        TestableBatch batch = new TestableBatch();

        Test.startTest();
            Database.QueryLocator locator = batch.start( null );
        Test.stopTest();

        System.assertEquals( batch.query, locator.getQuery(), 'When a batch processes is started, it returns a query locator based on the AbstractBatch query member variable - this can be overridden in setBatchProperties' );
    }

    @isTest
    public static void finish_executesHooksOnTheDerivedClass() {

        TestableBatch batch = new TestableBatch();
        batch.logResults = false;

        Test.startTest();
            batch.finish( null );
        Test.stopTest();

        System.assertEquals( 1, batch.hooksCalled.size(), 'When a batch processes is finished, the parent finish will call hooks on the derived class' );
        System.assertEquals( 'finish', batch.hooksCalled[0], 'When a batch processes is finished, the parent finish will call the finish hook on the derived class' );
    }    

    @isTest
    public static void construction_defaultsTheConfigurationToReasonableValues() {

        TestableBatch batch = new TestableBatch();

        System.assertEquals( true                    , batch.logResults                    , 'logResults is defaulted to true on construction' );
        System.assertEquals( 0                       , batch.emailResultsTo.size()         , 'emailResultsTo is defaulted to an empty list on construction' );
        System.assertEquals( false                   , batch.sendResultsEmail              , 'sendResultsEmail is defaulted to false if there are no addresses to email results to' );
        System.assertEquals( 'noreply@salesforce.com', batch.emailReplyTo                  , 'emailReplyTo is defaulted to a noreply email address on construction' );

        System.assertEquals( true                    , batch.allowedInProductionEnvironment, 'allowedInProductionEnvironment is defaulted to true on construction' );
        System.assertEquals( true                    , batch.allowedInSandboxEnvironment   , 'allowedInSandboxEnvironment is defaulted to true on construction' );

        System.assertEquals( false                   , batch.disableValidation             , 'disableValidation is defaulted to false on construction' );
        System.assertEquals( false                   , batch.disableProcessing             , 'disableProcessing is defaulted to false on construction' );

        System.assertEquals( true                    , batch.catchResultsEmailException    , 'catchResultsEmailException is defaulted to true on construction' );
    }

    @isTest
    public static void construction_defaultsSendResultsEmailToTrue_ifThereAreEmailAddressesConfigured() {

        TestableBatch batch = new TestableBatch();

        batch.emailResultsTo = new List<String>{ 'email1@example.com', 'email2@example.com' };

        System.assertEquals( 2   , batch.emailResultsTo.size(), 'emailResultsTo can be overridden with a list of email addresses' );
        System.assertEquals( true, batch.sendResultsEmail     , 'sendResultsEmail is defaulted to true if there are ARE addresses to email results to' );
    }

    @isTest
    public static void construction_SendResultsEmailDefaultGetsUpdatedIfEmailResultsToIsPopulated() {

        TestableBatch batch = new TestableBatch();

        Test.startTest();
            Boolean originalSendFlag = batch.sendResultsEmail;
            batch.emailResultsTo     = new List<String>{ 'email1@example.com', 'email2@example.com' };
            Boolean updatedSendFlag  = batch.sendResultsEmail;
        Test.stopTest();
        System.assertEquals( true, updatedSendFlag, 'updating the emailResultsTo property will update the sendResultsEmail default to true' );
    }

    @isTest
    public static void construction_SendResultsEmailWillNotGetUpdatedFromASetValue_whenTheEmailResultsToPropertyIsUpdated() {

        TestableBatch batch = new TestableBatch();

        Test.startTest();
            batch.sendResultsEmail = false;
            batch.emailResultsTo     = new List<String>{ 'email1@example.com', 'email2@example.com' };
            Boolean updatedSendFlag  = batch.sendResultsEmail;
        Test.stopTest();
        System.assertEquals( false, updatedSendFlag, 'updating the emailResultsTo property will NOT update the sendResultsEmail to true if it was manually set to false' );
    }

    @isTest
    public static void getElapsedTime_returnsZeroMsWhenGivenTheSameTime() {

        DateTime now = System.now();

        TestableBatch batch = new TestableBatch();
        Test.startTest();
            System.assertEquals( '0 ms', batch.getElapsedTime( now, now ), 'getElapsedTime, when given two times that are the same, will return 0 ms' );
        Test.stopTest();
    }

    @isTest
    public static void getElapsedTime_returnsTheNumberOfMillisecondsBetweenTheTimesPassedIn_ifTheTimeIsShortEnough() {

        Integer startMilliseconds = 10000000;

        DateTime startTime = DateTime.newInstance( startMilliseconds );
        DateTime endTime   = DateTime.newInstance( startMilliseconds + 250 );

        TestableBatch batch = new TestableBatch();
        Test.startTest();
            System.assertEquals( '250 ms', batch.getElapsedTime( startTime, endTime  ), 'getElapsedTime, when given two times that are less than a second apart, will return the number of milliseconds with ms' );
        Test.stopTest();
    }

    @isTest
    public static void getElapsedTime_returnsANegativeNumberOfMilliseconds_ifTheEndIsBeforeTheStart() {

        Integer startMilliseconds = 10000000;

        DateTime startTime = DateTime.newInstance( startMilliseconds );
        DateTime endTime   = DateTime.newInstance( startMilliseconds - 250 );

        TestableBatch batch = new TestableBatch();
        Test.startTest();
            System.assertEquals( '-250 ms', batch.getElapsedTime( startTime, endTime ), 'getElapsedTime, when given a second time before the first, will return a negative number in milliseconds' );
        Test.stopTest();
    }

    @isTest
    public static void getElapsedTime_returnsANegativeNumberOfMilliseconds_ifTheEndIsBeforeTheStart_evenIfTheDifferenceIsHuge() {

        Integer startMilliseconds = 10000000;

        DateTime startTime = DateTime.newInstance( startMilliseconds );
        DateTime endTime   = DateTime.newInstance( startMilliseconds - 250000000 );

        TestableBatch batch = new TestableBatch();
        Test.startTest();
            System.assertEquals( '-250000000 ms', batch.getElapsedTime( startTime, endTime ), 'getElapsedTime, when given a second time a lot earlier than the first, will still return a negative number in milliseconds' );
        Test.stopTest();
    }    

    @isTest
    public static void getElapsedTime_returnsARoundedNumberOfSecondsBetweenTheTimesPassedIn_ifTheTimeIsMeasuredInSeconds() {

        Integer startMilliseconds = 10000000;

        DateTime startTime = DateTime.newInstance( startMilliseconds );
        DateTime endTime   = DateTime.newInstance( startMilliseconds + 2500 );

        TestableBatch batch = new TestableBatch();
        Test.startTest();
            System.assertEquals( '2 s', batch.getElapsedTime( startTime, endTime  ), 'getElapsedTime, when given two times that are in the magnitude of seconds, will return the number of seconds with s' );
        Test.stopTest();
    }

    @isTest
    public static void getElapsedTime_returnsARoundedNumberOfMinutesBetweenTheTimesPassedIn_ifTheTimeIsMeasuredInMinutes() {

        Integer startMilliseconds = 10000000;

        DateTime startTime = DateTime.newInstance( startMilliseconds );
        DateTime endTime   = DateTime.newInstance( startMilliseconds + 60 * 5500 );

        TestableBatch batch = new TestableBatch();
        Test.startTest();
            System.assertEquals( '5 m', batch.getElapsedTime( startTime, endTime  ), 'getElapsedTime, when given two times that are in the magnitude of minutes, will return the number of minutes with m' );
        Test.stopTest();
    }

    @isTest
    public static void getTotals_willAddUpAllTheValuesFromTheBatchResults_andReturnABatchResultWithTheTotals() {

        List<AbstractBatch.BatchResult> results = new List<AbstractBatch.BatchResult>();

        results.add( new AbstractBatch.BatchResult() );
        results[0].totalRecords = 100;
        results[0].successCount =  90;
        results[0].errorCount   =  10;
        results[0].messages.add( 'This will not get added' );
        results[0].errors.add( 'This will not get added' );

        results.add( new AbstractBatch.BatchResult() );
        results[1].totalRecords = 200;
        results[1].successCount = 195;
        results[1].errorCount   =   5;

        results.add( new AbstractBatch.BatchResult() );
        results[2].totalRecords = 150;
        results[2].successCount =  80;
        results[2].errorCount   =  70;

        TestableBatch batch = new TestableBatch();
        batch.batchResults = results;

        AbstractBatch.BatchResult totalResult = batch.getTotals();

        System.assertEquals( 450, totalResult.totalRecords, 'getTotals will sum up the totalRecords on the batchResults and return a new batchResults with that set' );
        System.assertEquals( 365, totalResult.successCount, 'getTotals will sum up the successCount on the batchResults and return a new batchResults with that set' );
        System.assertEquals(  85, totalResult.errorCount  , 'getTotals will sum up the errorCount on the batchResults and return a new batchResults with that set' );

        System.assertEquals(   0, totalResult.messages.size(), 'getTotals will NOT collect up the messages on the batchResults and return a new batchResults with that set' );
        System.assertEquals(   0, totalResult.errors.size()  , 'getTotals will NOT collect up the errors on the batchResults and return a new batchResults with that set' );

    }

    private static List<System_Log__c> getLogs() {
        return [SELECT Level__c, Message__c, Source__c FROM System_Log__c ORDER BY Id DESC LIMIT 2000];
    }

    private static void createContactsToProcess( Integer numberOfContacts ) {

        List<Contact> contactsToCreate = new List<Contact>();

        ContactDataFactory contactFactory = new ContactDataFactory();
        for( Integer i=0; i<numberOfContacts; i++ ) {
            contactsToCreate.add( contactFactory.build( 'Contact-' + i ) );
        }
        contactFactory.create( contactsToCreate );
    }
}
