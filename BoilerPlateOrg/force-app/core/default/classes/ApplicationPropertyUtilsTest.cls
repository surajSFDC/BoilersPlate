/**
 * Test class for ApplicationPropertyUtils
 * 
 * @date    2018-03-09
 * @author  makepositive
 */
@isTest
public class ApplicationPropertyUtilsTest {
    /**
     * Setup Application Property test values
     * 
     * @date    2018-03-09
     * @author  makepositive
     */
    @testSetup
    static void testSetup() {

        ApplicationPropertyDataFactory applicationPropertyFactory = new ApplicationPropertyDataFactory();
        
        applicationPropertyFactory.create(new List<Application_Properties__c> {
            applicationPropertyFactory.build('TEST_STRING'       , 'STRING' ),
            applicationPropertyFactory.build('TEST_BOOLEAN_TRUE' , 'TRUE'   ),
            applicationPropertyFactory.build('TEST_BOOLEAN_FALSE', 'FALSE'  ),
            applicationPropertyFactory.build('TEST_INTEGER'      , '10'     )
        });
    }
    
    /**
	 * @method 	getValue
	 * @case   	Test retrieving custom settings as strings
	 * 			1) Entry doesn't exist, no default
	 * 			2) Entry exists
	 * 			3) Entry doesn't exist, return default value
	 * @result 	1) Returns null
	 * 			2) Returns custom setting value
	 * 			3) Returns default value
	 */
	@isTest
    static void applicationProperties_getValue_string() {

        Test.startTest();
            String testStringDoesntExist = ApplicationPropertyUtils.getInstance().getValue('TEST_STRING_AAA');
            String testStringExists = ApplicationPropertyUtils.getInstance().getValue('TEST_STRING', 'DEFAULT');
            String testStringDefault = ApplicationPropertyUtils.getInstance().getValue('TEST_STRING_AAA', 'DEFAULT');
        Test.stopTest();
        
        System.assertEquals( null    , testStringDoesntExist, 'Application Property does not exist, should return null');
        System.assertEquals('STRING' , testStringExists     , 'Application Property exists, value should be returned');
        System.assertEquals('DEFAULT', testStringDefault    , 'Application Property does not exist, should return default value DEFAULT');
    }
    
    /**
	 * @method 	getValue
	 * @case   	Test retrieving custom settings as boolean
	 * 			1) Entry exists - true
	 * 			2) Entry exists - false
	 * 			3) Entry doesn't exist - default true
	 * 			4) Entry doesn't exist - default false
	 * @result 	1) Returns true from custom setting
	 * 			2) Returns false from custom setting
	 * 			3) Returns default value - true
	 * 			4) Returns default value - false
	 */
    @isTest
    static void applicationProperties_getValue_boolean() {

        Test.startTest();
            Boolean testBooleanTrue         = ApplicationPropertyUtils.getInstance().getValue('TEST_BOOLEAN_TRUE', false);
            Boolean testBooleanFalse        = ApplicationPropertyUtils.getInstance().getValue('TEST_BOOLEAN_FALSE', true);
            Boolean testBooleanDefaultTrue  = ApplicationPropertyUtils.getInstance().getValue('TEST_BOOLEAN_AAA', true);
            Boolean testBooleanDefaultFalse = ApplicationPropertyUtils.getInstance().getValue('TEST_BOOLEAN_AAA', false);
        Test.stopTest();
        
        System.assert( testBooleanTrue         , 'Application Property exists, should return true');
        System.assert( !testBooleanFalse       , 'Application Property exists, should return false');
        System.assert( testBooleanDefaultTrue  , 'Application Property does not exist, should return default value true');
        System.assert( !testBooleanDefaultFalse, 'Application Property does not exist, should return default value false');
    }
    
    /**
	 * @method 	getValue
	 * @case   	Test retrieving custom settings as an integer
	 * 			1) Entry exists
	 * 			2) Entry doesn't exist - default
	 * @result 	1) Returns value from custom setting
	 * 			2) Returns default value
	 */
    @isTest
    static void applicationProperties_getValue_integer() {

        Test.startTest();
            Integer testIntegerExists = ApplicationPropertyUtils.getInstance().getValue('TEST_INTEGER', 20);
            Integer testIntegerDoesntExist = ApplicationPropertyUtils.getInstance().getValue('TEST_INTEGER_AAA', 20);
        Test.stopTest();
        
        System.assertEquals( 10, testIntegerExists     , 'Application Property exists, should return value');
        System.assertEquals( 20, testIntegerDoesntExist, 'Application Property does not exist, should return default value 20' );
    }
}