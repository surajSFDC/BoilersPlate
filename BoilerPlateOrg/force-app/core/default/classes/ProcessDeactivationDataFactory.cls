/**
 * Process_Deactivation__c custom setting test data factory
 * 
 * @date    2018-03-09
 * @author  makepositive
 */
@isTest
public class ProcessDeactivationDataFactory extends DataFactory {
    
    public ProcessDeactivationDataFactory() {
        super( 'Process_Deactivation__c' );
    }

    protected override SObject buildDefault() {
        return build();
    }

    /**
     * Build a default Process Deactivation custom setting with all
     * processes enabled.
     * 
     * @date    2018-03-09
     * @author  makepositive
     * @return	sObject - Process_Deactivation__c - All processes enabled
     */
    public Process_Deactivation__c build() {
        return new Process_Deactivation__c(
            SetupOwnerId = UserInfo.getOrganizationId()
        );
    }

    /**
     * Build a Process Deactivation with all processes disabled and insert it
     * 
     * @date    2018-03-04
     * @author  makepositive
     * @return	Process_Deactivation__c - All processes disabled
     */
    public static Process_Deactivation__c deactivateAll() {

        ProcessDeactivationDataFactory factory = new ProcessDeactivationDataFactory();

        Process_Deactivation__c processDeactivationSetting = factory.build();
        processDeactivationSetting.Disable_Validation_Rules__c     = true;
        processDeactivationSetting.Disable_All_Triggers__c         = true;
        processDeactivationSetting.Disable_Processes__c            = true;
        processDeactivationSetting.Disable_Workflows__c            = true;
        processDeactivationSetting.Disable_Benign_Field_Ignore__c  = true;
        processDeactivationSetting.Disable_Email_Alerts__c         = true;
        processDeactivationSetting.Disable_Outbound_Messages__c    = true;

        insert processDeactivationSetting;

        // TODO: If you bring in the trigger handler, then re-instate the following line
        // TriggerHandler.resetProcessDeactivationSetting();

        return processDeactivationSetting;
    }

    /**
     * Remove the passed in process deactivation record
     * 
     * @date    2018-03-04
     * @author  makepositive
     * @param	Process_Deactivation__c - Process_Deactivation__c
     */
    public static void removeDeactivation( Process_Deactivation__c deactivation ) {
        delete deactivation;
        // TODO: If you bring in the trigger handler, then re-instate the following line
        // TriggerHandler.resetProcessDeactivationSetting();
    }
}