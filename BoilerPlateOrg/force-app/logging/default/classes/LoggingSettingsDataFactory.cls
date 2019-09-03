/**
 * Logging_Settings__c custom setting test data factory
 * 
 * @date    2018-03-09
 * @author  makepositive
 */
@isTest
public class LoggingSettingsDataFactory extends DataFactory {
    
    public LoggingSettingsDataFactory() {
        super( 'Logging_Settings__c' );
    }

    protected override SObject buildDefault() {
        return build();
    }

    /**
     * Build a default Logging Settings custom setting with all
     * logging enabled.
     * 
     * @date    2018-03-09
     * @author  makepositive
     * @return	sObject - Logging_Settings__c - All logging enabled
     */
    public Logging_Settings__c build() {
        return build(true, true, true);
    }
    /**
     * Build a Logging Settings custom setting.
     * 
     * @date    2018-03-097
     * @author  makepositive
     * @param	Boolean - Enable error logging?
     * @param	Boolean - Enable warning logging?
     * @param	Boolean - Enable info logging?
     * @return	sObject - Logging_Settings__c
     */
	public Logging_Settings__c build(final Boolean errorLogging, final Boolean warningLogging, final Boolean infoLogging) {
        return new Logging_Settings__c(
            SetupOwnerId = UserInfo.getOrganizationId(),
        	Enable_System_Log_Error_Messages__c = errorLogging, 
            Enable_System_Log_Warning_Messages__c = warningLogging,
            Enable_System_Log_Info_Messages__c = infoLogging
        );
    }
}