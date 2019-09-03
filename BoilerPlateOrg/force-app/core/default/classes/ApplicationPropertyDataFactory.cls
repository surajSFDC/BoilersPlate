/**
 * Application_Properties__c custom setting test data factory
 * 
 * @date    2018-03-09
 * @author  makepositive
 */
@isTest
public class ApplicationPropertyDataFactory extends DataFactory {

    public ApplicationPropertyDataFactory() {
        super( 'Application_Properties__c' );
    }

    protected override SObject buildDefault() {
        return build();
    }

    /**
     * Build a default Application Property
     * 
     * @date    2018-03-09
     * @author  makepositive
     * @return	sObject - Application_Properties__c - NAME / VALUE
     */
    public Application_Properties__c build() {
        return build('NAME', 'VALUE');
    }
    
    /**
     * Build an Application Property
     * 
     * @date    2018-03-097
     * @author  makepositive
     * @param	String - Name of application property
     * @param	String - Value of application property
     * @return	sObject - Application_Properties__c
     */
	public Application_Properties__c build(final String name, final String value) {
        return new Application_Properties__c(
        	Name = name, 
            Value__c = value
        );
    }
}