@isTest
public class PicklistUtilsTest {

    /**
	 * @method getValidPicklistEntries
	 * @case   When given a string with a mix of valid and invalid picklist values
	 * @result Returns the valid entries as a delimited string
	 */		
	@isTest
    static void getValidPicklistEntries_whenGivenAStringWithAMixOfValidAndInvalidValues_willReturnTheValidValues() {
        Test.startTest();
            String result = PicklistUtils.getValidPicklistEntries( 'A;B;C', new Set<String>{ 'A', 'C' } );
        Test.stopTest();
        
		System.assertEquals( 'A;C', result, 'When given a string with a mix of valid and invalid picklist values, returns the valid entries as a delimited string' );
	}
    
    /**
	 * @method getValidPicklistEntries
	 * @case   When given a string with only invalid picklist values
	 * @result Returns null
	 */		
	@isTest
    static void getValidPicklistEntries_whenGivenAStringWithoutAnyValidValues_willReturnNull() {
        Test.startTest();
            String result = PicklistUtils.getValidPicklistEntries( 'B;D', new Set<String>{ 'A', 'C' } );
        Test.stopTest();
        
		System.assertEquals( null, result, 'B/D not a valid entries, should have returned null' );
	}
    
    /**
	 * @method getValidPicklistEntries
	 * @case   When given a string with a single valid value
	 * @result Returns that value
	 */		
	@isTest
    static void getValidPicklistEntries_whenGivenAStringWithASingleValidValue_willReturnThatValue() {
        Test.startTest();
            String result = PicklistUtils.getValidPicklistEntries( 'A', new Set<String>{ 'A', 'C' } );
        Test.stopTest();
        
		System.assertEquals( 'A', result, 'When given a string with a single valid value, will return that value' );
	}
    
    /**
	 * @method getValidPicklistEntries
	 * @case   When given a string with a single invalid value
	 * @result Returns null
	 */		
	@isTest
    static void getValidPicklistEntries_whenGivenAStringWithASingleInvalidValue_willReturnNull() {
        Test.startTest();
            String result = PicklistUtils.getValidPicklistEntries( 'B', new Set<String>{ 'A', 'C' } );
        Test.stopTest();
        
		System.assertEquals( null, result, 'When given a string with a single invalid value, will return null' );
	}
    
    /**
	 * @method getValidPicklistEntries
	 * @case   When given a null string
	 * @result Returns null
	 */		
	@isTest
    static void getValidPicklistEntries_whenGivenANullString_willReturnNull() {
        Test.startTest();
            String result = PicklistUtils.getValidPicklistEntries( null, new Set<String>{ 'A', 'C' } );
        Test.stopTest();
        
		System.assertEquals( null, result, 'When given a null string, will return null ' );
	}

	/**
	 * @method getActivePicklistValues
	 * @case   Passed picklist with active and inactive values
	 * @result Returns the active values
	 */		
	@isTest
    static void getActivePicklistValues_whenPassedAPicklistWithActiveAndInactiveValues_returnsTheActiveValues() {
        Test.startTest();
            Set<String> values = PicklistUtils.getActivePicklistValues( Unit_Test__c.Example_Picklist__c.getDescribe() );
        Test.stopTest();
        
		System.assertEquals( 2, values.size(), 'When passed a picklist with active and inactive values, will only return the active ones' );
        System.assert(  values.contains( 'Active 1'  ), 'When passed a picklist with active and inactive values, will only return the active ones (checking an active one is included)' );
        System.assert( !values.contains( 'Inactive 1'), 'When passed a picklist with active and inactive values, will only return the active ones (checking the inactive one is not returned' );
	}    
}
