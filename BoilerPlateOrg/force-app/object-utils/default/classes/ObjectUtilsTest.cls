@isTest
public class ObjectUtilsTest {

    /**
	 * @method buildSetOfIds
	 * @case   passed a list of SObjects where some have NULL Ids
	 * @result Will throw an exception
	 */		
	@isTest
    static void buildSetOfIds_givenAListOfSObjectsWhereSomeHaveNullIds_WillThrowAnException() {

		List<sObject> objects = new List<sObject>();
		objects.add( new Contact( Id = TestUtils.generateId( 'Contact', 1 ) ) );
		objects.add( new Contact() );
		objects.add( new Contact( Id = TestUtils.generateId( 'Contact', 3 ) ) );
		objects.add( new Contact( Id = TestUtils.generateId( 'Contact', 4 ) ) );
		objects.add( new Contact() );

		Boolean exceptionThrown = false;

		try {
			ObjectUtils.buildSetOfIds( objects );
		} catch( Exception e ) {
			exceptionThrown = true;
		}

		System.assert( exceptionThrown, 'buildSetOfIds, when passed a list of SObjects where some have NULL Ids, will throw an exception' );

	}

    /**
	 * @method buildSetOfIds
	 * @case   passed a list of SObjects where some have duplicate Ids
	 * @result Will throw an exception
	 */		
	@isTest
    static void buildSetOfIds_givenAListOfSObjectsWhereSomeHaveDuplicateIds_WillThrowAnException() {

		List<sObject> objects = new List<sObject>();
		objects.add( new Contact( Id = TestUtils.generateId( 'Contact', 1 ) ) );
		objects.add( new Contact( Id = TestUtils.generateId( 'Contact', 1 ) ) );
		objects.add( new Contact( Id = TestUtils.generateId( 'Contact', 3 ) ) );
		objects.add( new Contact( Id = TestUtils.generateId( 'Contact', 4 ) ) );
		objects.add( new Contact( Id = TestUtils.generateId( 'Contact', 4 ) ) );

		Boolean exceptionThrown = false;

		try {
			ObjectUtils.buildSetOfIds( objects );
		} catch( Exception e ) {
			exceptionThrown = true;
		}

		System.assert( exceptionThrown, 'buildSetOfIds, when passed a list of SObjects where some have duplicate Ids, will throw an exception' );

	}

    /**
	 * @method buildSetOfIds
	 * @case   passed a list of SObjects
	 * @result Returns a set of the Ids of the objects
	 */		
	@isTest
    static void buildSetOfIds_givenAnEmptyList_WillReturnAnEmptySet() {

		List<sObject> objects = new List<sObject>();

		Set<Id> expectedSetOfIds = new Set<Id>{};

		System.assertEquals( expectedSetOfIds, ObjectUtils.buildSetOfIds( objects ), 'buildSetOfIds, when given a list of sObjects, returns a set of the unique ids of those objects' );
	}
    
    /**
	 * @method filterObjects
	 * @case   passed a list of sObjects, and a list of Ids
	 * @result Returns a list of the original sObjects whose Ids are in the list of Ids
	 */		
	@isTest
    static void filterObjects_givenAListOfSObjectsAndIdsThatAreIncludedInTheList_returnsAListOfTheObjectsWithTheStatedIds() {

		List<sObject> objects = new List<sObject>();
		objects.add( new Contact( Id = TestUtils.generateId( 'Contact', 1 ) ) );
		objects.add( new Contact( Id = TestUtils.generateId( 'Contact', 2 ) ) );
		objects.add( new Contact( Id = TestUtils.generateId( 'Contact', 3 ) ) );
		objects.add( new Contact( Id = TestUtils.generateId( 'Contact', 4 ) ) );

		Set<Id> filterIds = new Set<Id>{ TestUtils.generateId( 'Contact', 1 )
									   , TestUtils.generateId( 'Contact', 4 )
									   };

		List<sObject> expectedObjects = new List<sObject>{ objects[0], objects[3] };
		List<sObject> actualObjects   = ObjectUtils.filterObjects( objects, filterIds );

		System.assertEquals( expectedObjects, actualObjects, 'filterObjects, given a list of SObjects and Ids that are included in the list, returns a list of the objects with the stated Ids' );
	}

    /**
	 * @method filterObjects
	 * @case   passed a list of sObjects, and a list of Ids with one that does not exist in the original list
	 * @result Returns a list of the original sObjects whose Ids are in the list of Ids
	 */		
	@isTest
    static void filterObjects_givenAListOfObjectsAndAListOfIdsWithAnExtraIdInIt_returnsOnlyTheObjectsThatAreInTheOriginalList() {

		List<sObject> objects = new List<sObject>();
		objects.add( new Contact( Id = TestUtils.generateId( 'Contact', 1 ) ) );
		objects.add( new Contact( Id = TestUtils.generateId( 'Contact', 2 ) ) );
		objects.add( new Contact( Id = TestUtils.generateId( 'Contact', 3 ) ) );
		objects.add( new Contact( Id = TestUtils.generateId( 'Contact', 4 ) ) );

		Set<Id> filterIds = new Set<Id>{ TestUtils.generateId( 'Contact', 1 )
									   , TestUtils.generateId( 'Contact', 4 )
									   , TestUtils.generateId( 'Contact', 5 )
									   };

		List<sObject> expectedObjects = new List<sObject>{ objects[0], objects[3] };
		List<sObject> actualObjects   = ObjectUtils.filterObjects( objects, filterIds );

		System.assertEquals( expectedObjects, actualObjects, 'filterObjects, given a list of Sobjects and Ids, where one Id is not in the original list, returns only those that are in the original list' );
	}

    /**
	 * @method filterObjects
	 * @case   passed a list of sObjects, and an empty list of Ids
	 * @result Returns an empty list of sObjects
	 */		
	@isTest
    static void filterObjects_givenAnEmptyListOfIds_returnsAnEmptyList() {

		List<sObject> objects = new List<sObject>();
		objects.add( new Contact( Id = TestUtils.generateId( 'Contact', 1 ) ) );
		objects.add( new Contact( Id = TestUtils.generateId( 'Contact', 2 ) ) );
		objects.add( new Contact( Id = TestUtils.generateId( 'Contact', 3 ) ) );
		objects.add( new Contact( Id = TestUtils.generateId( 'Contact', 4 ) ) );

		Set<Id> filterIds = new Set<Id>();

		List<sObject> expectedObjects = new List<sObject>();
		List<sObject> actualObjects   = ObjectUtils.filterObjects( objects, filterIds );

		System.assertEquals( expectedObjects, actualObjects, 'filterObjects, when given an empty list of Ids, returns an empty list of objects' );
	}

    /**
	 * @method filterObjects
	 * @case   passed an empty list of sObjects
	 * @result Returns an empty list of sObjects
	 */		
	@isTest
    static void filterObjects_givenAnEmptyListOfObjects_returnsAnEmptyListOfObjects() {

		List<sObject> objects = new List<sObject>();

		Set<Id> filterIds = new Set<Id>();

		List<sObject> expectedObjects = new List<sObject>();
		List<sObject> actualObjects   = ObjectUtils.filterObjects( objects, filterIds );

		System.assertEquals( expectedObjects, actualObjects, 'filterObjects, when given an empty list of objects, returns an empty list of objects' );
	}

    /**
	 * @method filterObjects
	 * @case   passed a list of sObjects, that contains duplicate Ids
	 * @result Throws an exception
	 */		
	@isTest
    static void filterObjects_whenGivenAListOfObjectsWithDuplicateIds_willThrowAnException() {

		List<sObject> objects = new List<sObject>();
		objects.add( new Contact( Id = TestUtils.generateId( 'Contact', 1 ) ) );
		objects.add( new Contact( Id = TestUtils.generateId( 'Contact', 2 ) ) );
		objects.add( new Contact( Id = TestUtils.generateId( 'Contact', 4 ) ) );
		objects.add( new Contact( Id = TestUtils.generateId( 'Contact', 4 ) ) );

		Set<Id> filterIds = new Set<Id>();

		Boolean exceptionThrown = false;
		try {
			List<sObject> actualObjects = ObjectUtils.filterObjects( objects, filterIds );
		} catch( Exception e ) {
			exceptionThrown = true;
		}

		System.assert( exceptionThrown, 'buildSetOfIds, when passed a list of SObjects where some have duplicate Ids, will throw an exception' );
	}

    /**
	 * @method filterObjects
	 * @case   passed a list of sObjects, that contains null Ids
	 * @result Throws an exception
	 */		
	@isTest
    static void filterObjects_whenGivenAListOfObjectsWithNullIds_willThrowAnException() {

		List<sObject> objects = new List<sObject>();
		objects.add( new Contact( Id = TestUtils.generateId( 'Contact', 1 ) ) );
		objects.add( new Contact( Id = TestUtils.generateId( 'Contact', 2 ) ) );
		objects.add( new Contact() );
		objects.add( new Contact( Id = TestUtils.generateId( 'Contact', 4 ) ) );

		Set<Id> filterIds = new Set<Id>();

		Boolean exceptionThrown = false;
		try {
			List<sObject> actualObjects = ObjectUtils.filterObjects( objects, filterIds );
		} catch( Exception e ) {
			exceptionThrown = true;
		}

		System.assert( exceptionThrown, 'buildSetOfIds, when passed a list of SObjects where some have null Ids, will throw an exception' );
	}
}
