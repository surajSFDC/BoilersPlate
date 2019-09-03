@isTest
public with sharing class ConfigSettingBasedBatchConfiguratorTest {

    /**
	 * @method 	configure
	 * @case   	when passed a batch processor, and there are no Application Properties set for the defined prefix
	 * @result 	will configure the Batch Processor with reasonable defaults
	 */
    @isTest
    private static void configure_whenPassedABatchProcessor_andNoApplicationPropertiesAreSet_willDefaultThePropertiesToResonableValues() {

        ConfigSettingBasedBatchConfigurator config = new ConfigSettingBasedBatchConfigurator( 'prefix' );

        TestBatch testBatch = new TestBatch();

        Test.startTest();
            config.configure( testBatch );
        Test.stopTest();

        System.assertEquals( true , testBatch.logResults      , 'configure, when called with no Application Properties set, will default the passed processor log results to true' );
        System.assertEquals( false, testBatch.sendResultsEmail, 'configure, when called with no Application Properties set, will default the passed processor send results email to false - as we need the target address set' );
        System.assertEquals( 'noreply@makepositive.com', testBatch.emailReplyTo, 'configure, when called with no Application Properties set, will default the passed processor email reply to address to noreply@makepositive.com' );
        System.assertEquals( new List<String>(), testBatch.emailResultsTo, 'configure, when called with no Application Properties set, will default the passed processor email results to address to null' );
    }

    /**
	 * @method 	configure
	 * @case   	when passed a batch processor, and there *are* Application Properties set for the defined prefix
	 * @result 	will configure the Batch Processor with the values defined in the properties
	 */
    @isTest
    private static void configure_whenPassedABatchProcessor_andReleventApplicationPropertiesAreSet_willSetThePropertiesBasedOnTheProperties() {

        String propertyPrefix = 'test_prefix';

        ApplicationPropertyDataFactory applicationPropertyFactory = new ApplicationPropertyDataFactory();
        applicationPropertyFactory.create(
            new List<Application_Properties__c> {
                applicationPropertyFactory.build( propertyPrefix + '_enableResultsLog'  , 'FALSE' ),
                applicationPropertyFactory.build( propertyPrefix + '_enableResultsEmail', 'TRUE'   ),
                applicationPropertyFactory.build( propertyPrefix + '_replyToEmail'      , 'reply@example.com'   ),
                applicationPropertyFactory.build( propertyPrefix + '_toEmails'          , 'to@example.com'   )
            }
        );

        ConfigSettingBasedBatchConfigurator config = new ConfigSettingBasedBatchConfigurator( propertyPrefix );

        TestBatch testBatch = new TestBatch();

        Test.startTest();
            config.configure( testBatch );
        Test.stopTest();

        System.assertEquals( false, testBatch.logResults                                   , 'configure, when called with Application Properties set with the appropriate prefix, will set the passed processor log results to the defined value' );
        System.assertEquals( true , testBatch.sendResultsEmail                             , 'configure, when called with Application Properties set with the appropriate prefix, will set the passed processor send results email to the defined value' );
        System.assertEquals( 'reply@example.com'                 , testBatch.emailReplyTo  , 'configure, when called with Application Properties set with the appropriate prefix, will set the passed processor email reply to the defined value' );
        System.assertEquals( new List<String>{ 'to@example.com' }, testBatch.emailResultsTo, 'configure, when called with Application Properties set with the appropriate prefix, will set the passed processor email results to the defined value' );
    }

    public class TestBatch extends AbstractBatch {
        public TestBatch() {
        }
        public override AbstractBatch.BatchResult execute( List<sObject> scope ) {
            return new AbstractBatch.BatchResult();
        }
    }
}
