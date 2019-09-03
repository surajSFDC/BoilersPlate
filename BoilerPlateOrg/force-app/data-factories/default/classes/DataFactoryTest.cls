/**
* Test class mainly exists as DataFactory is abstract and therefore cannot be specified as '@isTest'
* Including a test means that the code coverage for the DataFactory class is maintained.
*
* It also serves as useful documentation for the behaviour of the factories.
* Usually you would not include tests for any data factories you create.
* 
* Documentation on usage can be found here:
*    https://makepositive.atlassian.net/wiki/spaces/DEV/pages/1192853635/Data+Factories
* 
* @date    2019-04-07
* @author  makepositive
*/
@isTest
private class DataFactoryTest {
    
    /**
	 * @method 	AccountDataFactory.getDefaultInstance (is representative of any build method on a factory)
	 * @result 	Will return the same Account each time it is called against a single instance of the factory
	 */
    @isTest
    static void accountDataFactory_getDefaultInstance_returnsTheSameObjectEachTimeItIsCalled() {

        AccountDataFactory adf = new AccountDataFactory();

        Test.startTest();
            Account a = (Account) adf.getDefaultInstance();
            Account b = (Account) adf.getDefaultInstance();
        Test.stopTest();

        System.assertEquals( a, b, 'DataFactory.getDefaultInstance returns the same object each time it is called' );
    }

    /**
	 * @method 	AccountDataFactory.getDefaultInstance (is representative of any getDefaultInstance method on a factory)
	 * @result 	Will return the same Account each time it is called against any instance of the factory
     *          This ensures that other factories can use 'getDefaultInstance' and guarantee that only 
     *          one Account (or object of the other type) is ever created.
	 */
    @isTest
    static void accountDataFactories_getDefaultInstance_fromMultipleFactories_returnsTheSameObjectEachTimeItIsCalled() {

        AccountDataFactory adf  = new AccountDataFactory();
        AccountDataFactory adf2 = new AccountDataFactory();

        Test.startTest();
            Account a = (Account) adf.getDefaultInstance();
            Account b = (Account) adf2.getDefaultInstance();
        Test.stopTest();

        System.assertEquals( a, b, 'DataFactory.getDefaultInstance returns the same object each time it is called, even if called from multiple instances of the factory' );
    }

    /**
	 * @method 	multipleDataFactoreis.getDefaultInstance
     * @case    getDefaultInstance on one factory is used from another factory
	 * @result 	Will return the same instance that any other call would return, meaning that you know
     *          you only ever have one of any type of object
	 */
    @isTest
    static void multipleDataFactories_getDefaultInstance_fromMultipleFactories_willAlwaysReturnTheSameDefaultObject() {
        
        AccountDataFactory adf = new AccountDataFactory();
        Account account = (Account) adf.getDefaultInstance();
        
        ContactDataFactory cdf = new ContactDataFactory();

        Test.startTest();
            Contact contact = (Contact) cdf.getDefaultInstance();
        Test.stopTest();
        
        System.assertEquals( account.Id, contact.AccountId, 'getDefaultInstance returns the same object for a given type, regardless of which factory asked for it' );
    }

    /**
	 * @method 	AccountDataFactory.build (should be representative of any parameterless build method on a factory)
     * @case    When given no parameters
	 * @result 	Will build an Account with some default properties, but not create it in the database
	 */    
    @isTest
    static void accountDataFactory_build_returnsAnAccountThatIsNotInTheDatabase() {
        
        AccountDataFactory adf = new AccountDataFactory();

        Test.startTest();
            Account a = adf.build();
        Test.stopTest();

        System.assertEquals( null, a.Id, 'AccountDataFactory.build returns an Account that is not in the database' );
    }

    /**
	 * @method 	AccountDataFactory.build (is an example of the kind of thing a build method should do)
     * @case    When given a name
	 * @result 	Will build an Account with the name set, but not create it in the database
	 */  
    @isTest
    static void accountDataFactory_build_withName_returnsAnAccountWithTheNameSet() {
        
        AccountDataFactory adf = new AccountDataFactory();

        Test.startTest();
            Account a = adf.build( 'Test DF' );
        Test.stopTest();

        System.assertEquals( 'Test DF', a.Name, 'AccountDataFactory.build returns an Account that is not in the database, with the name set to that specified in the call' );
    }

    /**
	 * @method 	DataFactory.create
     * @case    When given an object to create
	 * @result 	Will insert the object it is given and then return it with the Id set
	 */  
    @isTest
    static void dataFactory_create_insertsTheObjectIntoTheDatabaseAndReturnsIt() {
        
        AccountDataFactory adf = new AccountDataFactory();

        Account a = adf.build();

        Test.startTest();
            Account b = (Account) adf.create( a );
        Test.stopTest();

        System.assertNotEquals( null, a.Id, 'AccountDataFactory.create inserts the passed object into the database, mutating the passed in object' );
        System.assertEquals( a.Id, b.Id, 'AccountDataFactory.create inserts the passed object into the database, returning it' );
        System.assertEquals( 1, [SELECT Id FROM Account].size(), 'create only inserts the one object passed into it' );
    }

    /**
	 * @method 	DataFactory.create
     * @case    When given an object that cannot be created
	 * @result 	Will raise an Exception
	 */  
    @isTest
    static void dataFactory_create_whenGivenAnObjectThatCannotBeCreated_willRaiseAnException() {
        
        AccountDataFactory adf = new AccountDataFactory();

        Account a = adf.build();
        a.Id = TestUtils.generateId( 'Account' );

        Boolean exceptionThrown = false;

        Test.startTest();
            try {
                Account b = (Account) adf.create( a );
            } catch( Exception e ) {
                exceptionThrown = true;
            }
        Test.stopTest();

        System.assert( exceptionThrown, 'create will thrown an exception when asked to create an object that does not exist' );
    }

    /**
	 * @method 	DataFactory.create
     * @case    When given a list of objects to create
	 * @result 	Will insert the objects it is given and then return them with the Ids set
	 */  
    @isTest
    static void dataFactory_create_whenGivenAListOfObjects_insertsTheObjectsIntoTheDatabaseAndReturnsThem() {
        
        AccountDataFactory adf = new AccountDataFactory();

        Account a = adf.build( 'Account1' );
        Account b = adf.build( 'Account2' );

        List<Account> originalAccounts = new List<Account>{ a,b };

        Test.startTest();
            List<Account> createdAccounts = adf.create( originalAccounts );
        Test.stopTest();

        System.assertNotEquals( null, a.Id, 'AccountDataFactory create inserts the passed list of objects into the database, mutating the passed in objects (1)' );
        System.assertNotEquals( null, b.Id, 'AccountDataFactory create inserts the passed list of objects into the database, mutating the passed in objects (2)' );
        System.assertEquals( originalAccounts[0].Id, createdAccounts[0].Id, 'AccountDataFactory.create inserts the passed objects into the database, returning them (1)' );
        System.assertEquals( originalAccounts[1].Id, createdAccounts[1].Id, 'AccountDataFactory.create inserts the passed objects into the database, returning them (2)' );
        System.assertEquals( 2, [SELECT Id FROM Account].size(), 'create only inserts the objects passed into it' );
    }

    /**
	 * @method 	DataFactory.create
     * @case    When given a list of objects including one that cannot be created
	 * @result 	Will raise an Exception
	 */  
    @isTest
    static void dataFactory_create_whenGivenAListOfObjectsIncludingOneThatCannotBeCreated_willRaiseAnException() {
        
        AccountDataFactory adf = new AccountDataFactory();

        Account a = adf.build( 'Account1' );
        a.Id = TestUtils.generateId( 'Account' );

        Account b = adf.build( 'Account2' );

        List<Account> originalAccounts = new List<Account>{ a,b };

        Boolean exceptionThrown = false;

        Test.startTest();
            try {
                List<Account> createdAccounts = adf.create( originalAccounts );
            } catch( Exception e ) {
                exceptionThrown = true;
            }
        Test.stopTest();

        System.assert( exceptionThrown, 'create will thrown an exception when given a list of objects and asked to create an object that does not exist' );
    }
}