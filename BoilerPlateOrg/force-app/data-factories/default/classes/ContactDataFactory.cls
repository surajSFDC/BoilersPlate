/**
* An example implementation of a Data Factory
*
* Fully expect this implementation to be superceded in a project, probably with
* multiple overloaded 'build' methods that create Accounts in different shapes.
*
* For more examples in the documentation, see AccountDataFactory
*
* Documentation on writing and using data-factories can be found here:
*    https://makepositive.atlassian.net/wiki/spaces/DEV/pages/1192853635/Data+Factories
* 
* @date    2019-04-07
* @author  makepositive
*/
@isTest
public without sharing class ContactDataFactory extends DataFactory {
	
    private final static String DEFAULT_LAST_NAME = 'DefaultLastName';

	public ContactDataFactory() {
        super( 'Contact' );
    }

    protected override SObject buildDefault() {
        return build();
    }
    
    /**
     * Every data factory should have an implementation of build that takes no parameters and
     * returns an object of the right type that *could* be inserted into the database with no
     * validation errors.
     * 
     * For objects that have "required" relationships to other objects, you should use the 
     * method 'getDefaultInstance' against the related object's factory in order to get a 
     * generic version of that object.
     * This is particularly useful when the related object is entirely incidental to the test.
     * 
     * The build method can be overridden to allow for the capability to set the relationships
     * to specific objects when they are important to the tests. 
     * 
     * @date    2019-04-07
     * @author  makepositive
     */
    public Contact build() {
    	return build( getDefaultAccount() );
    }

    public Contact build( Account acc ) {
    	Contact con = new Contact();
    	con.AccountId = (acc != null) ? acc.Id : null;
        con.LastName  = DEFAULT_LAST_NAME;
    	return con;
    }

    public Contact build( String lastName ) {
    	Contact con = build();
        con.LastName = lastName;
        return con;
    }

    public Contact build( String lastName, Account acc ) {
    	Contact con = build( acc );
    	con.LastName = lastName;
    	return con;
    }

    private Account getDefaultAccount() {
        AccountDataFactory adf = new AccountDataFactory();
    	return (Account)adf.getDefaultInstance();
    }

}