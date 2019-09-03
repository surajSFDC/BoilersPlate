@isTest
private class ObjectComparerTest {

	/**
	 * @method getFieldsThatHaveChanged
	 * @case   Passed objects with no fields set and an empty list of fields
	 * @result Returns an empty set
	 */	
	@isTest
	private static void getFieldsThatHaveChanged_whenGivenObjectsWithNoFieldsSetAndAnEmptyListOfFields_willReturnAnEmptySet() {

		Contact     oldRecord     = new Contact();
		Contact     newRecord     = new Contact();
		Set<String> fieldsToCheck = new Set<String>();

		Set<String> expectedFieldsChanged = new Set<String>();

		Test.startTest();
			Set<String> fieldsChanged = ObjectComparer.getFieldsThatHaveChanged( oldRecord, newRecord, fieldsToCheck );
		Test.stopTest();

		System.assert( fieldsChanged.containsAll( expectedFieldsChanged ), 'getFieldsThatHaveChanged, when given objects with not fields set and an empty list of fields to check, will return an empty set (check everything that is in the expected set is in the return) ' );
		System.assert( expectedFieldsChanged.containsAll( fieldsChanged ), 'getFieldsThatHaveChanged, when given objects with not fields set and an empty list of fields to check, will return an empty set (check everything that is in the return set is in the expected) ' );
	}

	/**
	 * @method getFieldsThatHaveChanged
	 * @case   Passed objects that have different fields set, but an empty list of fields to check
	 * @result Returns an empty set
	 */	
	@isTest
	private static void getFieldsThatHaveChanged_whenGivenObjectsWithDifferentFieldsSetButAnEmptyListOfFieldsToCheck_willReturnAnEmptySet() {

		Contact     oldRecord     = new Contact( FirstName = 'first');
		Contact     newRecord     = new Contact( LastName  = 'last' );
		Set<String> fieldsToCheck = new Set<String>();

		Set<String> expectedFieldsChanged = new Set<String>();

		Test.startTest();
			Set<String> fieldsChanged = ObjectComparer.getFieldsThatHaveChanged( oldRecord, newRecord, fieldsToCheck );
		Test.stopTest();

		System.assert( fieldsChanged.containsAll( expectedFieldsChanged ), 'getFieldsThatHaveChanged, when given objects with different fields set, but an empty list of fields to check, will return an empty set (check everything that is in the expected set is in the return) ' );
		System.assert( expectedFieldsChanged.containsAll( fieldsChanged ), 'getFieldsThatHaveChanged, when given objects with different fields set, but an empty list of fields to check, will return an empty set (check everything that is in the return set is in the expected) ' );
	}

	/**
	 * @method getFieldsThatHaveChanged
	 * @case   Passed a new object with fields set, an old with none set and fieldsToCheck set to match the fields
	 * @result Returns the names of fields that have been set on the new
	 */	
	@isTest
	private static void getFieldsThatHaveChanged_whenGivenAnOldRecordWithNothingSetANewWithSomeAndFieldsThatMatch_willReturnAllTheFieldsOnTheNewThatAreSet() {

		Contact     oldRecord     = new Contact();
		Contact     newRecord     = new Contact( FirstName = 'first', LastName = 'last' );
		Set<String> fieldsToCheck = new Set<String>{ 'firstname', 'lastname' };

		Set<String> expectedFieldsChanged = new Set<String>{ 'firstname', 'lastname' };

		Test.startTest();
			Set<String> fieldsChanged = ObjectComparer.getFieldsThatHaveChanged( oldRecord, newRecord, fieldsToCheck );
		Test.stopTest();

		System.assert( fieldsChanged.containsAll( expectedFieldsChanged ), 'getFieldsThatHaveChanged, when given old with none set, new with some set and a field list that matches the new, will return the fields on the new that are set (check everything that is in the expected set is in the return) ' );
		System.assert( expectedFieldsChanged.containsAll( fieldsChanged ), 'getFieldsThatHaveChanged, when given old with none set, new with some set and a field list that matches the new, will return the fields on the new that are set (check everything that is in the return set is in the expected) ' );
	}
	/**
	 * @method getFieldsThatHaveChanged
	 * @case   Passed an old object with fields set, a new with none set and fieldsToCheck set to match the fields
	 * @result Returns the names of fields that have been set on the old
	 */	
	@isTest
	private static void getFieldsThatHaveChanged_whenGivenANewRecordWithNothingSetAnOldWithSomeAndFieldsThatMatch_willReturnAllTheFieldsOnTheOldThatAreSet() {

		Contact     oldRecord     = new Contact( FirstName = 'first', LastName = 'last' );
		Contact     newRecord     = new Contact();
		Set<String> fieldsToCheck = new Set<String>{ 'firstname', 'lastname' };

		Set<String> expectedFieldsChanged = new Set<String>{ 'firstname', 'lastname' };

		Test.startTest();
			Set<String> fieldsChanged = ObjectComparer.getFieldsThatHaveChanged( oldRecord, newRecord, fieldsToCheck );
		Test.stopTest();

		System.assert( fieldsChanged.containsAll( expectedFieldsChanged ), 'getFieldsThatHaveChanged, when given new with none set, old with some set and a field list that matches the new, will return the fields on the old that are set (check everything that is in the expected set is in the return) ' );
		System.assert( expectedFieldsChanged.containsAll( fieldsChanged ), 'getFieldsThatHaveChanged, when given new with none set, old with some set and a field list that matches the new, will return the fields on the old that are set (check everything that is in the return set is in the expected) ' );
	}

	/**
	 * @method getFieldsThatHaveChanged
	 * @case   Passed old and new with the same fields set to the same, and field list that matches
	 * @result Returns an empty list
	 */
	@isTest
	private static void getFieldsThatHaveChanged_whenGivenOldAndNewWithFieldsSetTheSame_willReturn() {

		Contact     oldRecord     = new Contact( FirstName = 'first', LastName = 'last' );
		Contact     newRecord     = new Contact( FirstName = 'first', LastName = 'last' );
		Set<String> fieldsToCheck = new Set<String>{ 'firstname', 'lastname' };

		Set<String> expectedFieldsChanged = new Set<String>();

		Test.startTest();
			Set<String> fieldsChanged = ObjectComparer.getFieldsThatHaveChanged( oldRecord, newRecord, fieldsToCheck );
		Test.stopTest();

		System.assert( fieldsChanged.containsAll( expectedFieldsChanged ), 'getFieldsThatHaveChanged, when given old and new the same and field names that matches, will return an empty set (check everything that is in the expected set is in the return) ' );
		System.assert( expectedFieldsChanged.containsAll( fieldsChanged ), 'getFieldsThatHaveChanged, when given old and new the same and field names that matches, will return an empty set (check everything that is in the return set is in the expected) ' );
	}

	/**
	 * @method getFieldsThatHaveChanged
	 * @case   Passed old and new with nothing set and a field list with some fields
	 * @result Returns an empty set
	 */	
	@isTest
	private static void getFieldsThatHaveChanged_whenGivenOldAndNewWithNothingSetAndAFieldListWithSomeFields_willReturnAnEmptySet() {

		Contact     oldRecord     = new Contact();
		Contact     newRecord     = new Contact();
		Set<String> fieldsToCheck = new Set<String>{ 'firstname', 'lastname' };

		Set<String> expectedFieldsChanged = new Set<String>();

		Test.startTest();
			Set<String> fieldsChanged = ObjectComparer.getFieldsThatHaveChanged( oldRecord, newRecord, fieldsToCheck );
		Test.stopTest();

		System.assert( fieldsChanged.containsAll( expectedFieldsChanged ), 'getFieldsThatHaveChanged, when given old and new with nothing set, and a field list with some set, will return an empty set (check everything that is in the expected set is in the return) ' );
		System.assert( expectedFieldsChanged.containsAll( fieldsChanged ), 'getFieldsThatHaveChanged, when given old and new with nothing set, and a field list with some set, will return an empty set (check everything that is in the return set is in the expected) ' );
	}

	/**
	 * @method getFieldsThatHaveChanged
	 * @case   Passed old and new with the same fields set differently, and a field list that matches
	 * @result Returns the fields that are different
	 */	
	@isTest
	private static void getFieldsThatHaveChanged_whenGivenOldAndNewWithSameFieldsSetDifferentlyAndAFieldListThatMatches_willReturnTheFieldsThatAreDifferent() {

		Contact     oldRecord     = new Contact( FirstName = 'first', LastName = 'last' );
		Contact     newRecord     = new Contact( FirstName = 'other', LastName = 'diff' );
		Set<String> fieldsToCheck = new Set<String>{ 'firstname', 'lastname' };

		Set<String> expectedFieldsChanged = new Set<String>{ 'firstname', 'lastname' };

		Test.startTest();
			Set<String> fieldsChanged = ObjectComparer.getFieldsThatHaveChanged( oldRecord, newRecord, fieldsToCheck );
		Test.stopTest();

		System.assert( fieldsChanged.containsAll( expectedFieldsChanged ), 'getFieldsThatHaveChanged, when given passed old and new with same fields set differently and a field list that matches, will return the fields that have changed (check everything that is in the expected set is in the return) ' );
		System.assert( expectedFieldsChanged.containsAll( fieldsChanged ), 'getFieldsThatHaveChanged, when given passed old and new with same fields set differently and a field list that matches, will return the fields that have changed (check everything that is in the return set is in the expected) ' );
	}

	/**
	 * @method getFieldsThatHaveChanged
	 * @case   Passed old and new that are different and a field list containing only some of the changed fields
	 * @result Returns only the fields that have changed and are in the list of fields to check
	 */	
	@isTest
	private static void getFieldsThatHaveChanged_whenGivenOldAndNewThatDifferAndAFieldSetThatIsASubSet_willReturnOnlyTheFieldsInTheFieldList() {

		Contact     oldRecord     = new Contact( FirstName = 'first', LastName = 'last' );
		Contact     newRecord     = new Contact( FirstName = 'other', LastName = 'diff' );
		Set<String> fieldsToCheck = new Set<String>{ 'firstname', 'ispersonaccount' };

		Set<String> expectedFieldsChanged = new Set<String>{ 'firstname' };

		Test.startTest();
			Set<String> fieldsChanged = ObjectComparer.getFieldsThatHaveChanged( oldRecord, newRecord, fieldsToCheck );
		Test.stopTest();

		System.assert( fieldsChanged.containsAll( expectedFieldsChanged ), 'getFieldsThatHaveChanged, when given old and new that are different and a field list with a sub set, will only return the fields that have changed that are in the list of fields to check (check everything that is in the expected set is in the return) ' );
		System.assert( expectedFieldsChanged.containsAll( fieldsChanged ), 'getFieldsThatHaveChanged, when given old and new that are different and a field list with a sub set, will only return the fields that have changed that are in the list of fields to check (check everything that is in the return set is in the expected) ' );
	}

	/**
	 * @method getFieldsThatHaveChanged
	 * @case   Passed a field in the field list that is not valid
	 * @result Will still return the fields that differ that *are* valid
	 */	
	@isTest
	private static void getFieldsThatHaveChanged_whenGivenAFieldInTheListThatIsInvalid_willReturnTheFieldsThatHaveChangedAsPerNormal() {

		Contact     oldRecord     = new Contact( FirstName = 'first', LastName = 'last' );
		Contact     newRecord     = new Contact( FirstName = 'other', LastName = 'diff' );
		Set<String> fieldsToCheck = new Set<String>{ 'firstname', 'invalidfield' };

		Set<String> expectedFieldsChanged = new Set<String>{ 'firstname' };

		Test.startTest();
			Set<String> fieldsChanged = ObjectComparer.getFieldsThatHaveChanged( oldRecord, newRecord, fieldsToCheck );
		Test.stopTest();

		System.assert( fieldsChanged.containsAll( expectedFieldsChanged ), 'getFieldsThatHaveChanged, when given old and new that are different and a field list with a sub set, will only return the fields that have changed that are in the list of fields to check (check everything that is in the expected set is in the return) ' );
		System.assert( expectedFieldsChanged.containsAll( fieldsChanged ), 'getFieldsThatHaveChanged, when given old and new that are different and a field list with a sub set, will only return the fields that have changed that are in the list of fields to check (check everything that is in the return set is in the expected) ' );
	}

	/**
	 * @method getFieldsThatHaveChanged
	 * @case   Passed different object types in the old and new
	 * @result Will throw an expcetion
	 */	
	@isTest
	private static void getFieldsThatHaveChanged_whenGivenObjectsOfDifferentTypes_willThrowAnExpception() {

		Contact     oldRecord     = new Contact( FirstName = 'first', LastName = 'last' );
		User        newRecord     = new User( FirstName = 'other', LastName = 'diff' );
		Set<String> fieldsToCheck = new Set<String>{ 'firstname', 'invalidfield' };

		Boolean exceptionThrown = false;
		
		Test.startTest();
			try {
				ObjectComparer.getFieldsThatHaveChanged( oldRecord, newRecord, fieldsToCheck );
			} catch ( Exception e ) {
				exceptionThrown = true;
			}
		Test.stopTest();

		System.assert( exceptionThrown, 'getFieldsThatHaveChanged, when given old and new that are different object types, will throw an exception' );
	}

	/**
	 * @method getFieldsThatHaveChanged (list version)
	 * @case   Passed objects that have differing fields
	 * @result Will return a Set of all the fields that are different between any of the matching old and new records
	 */	
	@isTest
	private static void getFieldsThatHaveChanged_ListVersion_GivenAListOfNewRecordsAndAMapOfOldWhereSomeFieldsDiffer_wilLReturnTheListOfAllFieldsWhereODifferences() {

		List<Contact> 	 newRecords = new List<Contact>{ new Contact( Id = TestUtils.generateId('Contact', 1 ),FirstName = 'first1', LastName = 'last1', Email = 'test1@example.com' )
													   , new Contact( Id = TestUtils.generateId('Contact', 2 ),FirstName = 'first2', LastName = 'last2', Email = 'test2@example.com' )
													   };
		Map<Id, Contact> oldRecords = new  Map<Id, Contact>{ TestUtils.generateId('Contact', 1 ) => new Contact( Id = TestUtils.generateId('Contact', 1 ),FirstName = 'firstxxx', LastName = 'last1', Email = 'test1@example.com' )
													       , TestUtils.generateId('Contact', 2 ) => new Contact( Id = TestUtils.generateId('Contact', 2 ),FirstName = 'first2'  , LastName = 'last2', Email = 'testxxxx@example.com' )
													       };

		Set<String> expectedFieldsChanged = new Set<String>{ 'firstname', 'email' };
		
		Test.startTest();
			Set<String> fieldsChanged = ObjectComparer.getFieldsThatHaveChanged( oldRecords, newRecords );
		Test.stopTest();

		System.assert( fieldsChanged.containsAll( expectedFieldsChanged ), 'getFieldsThatHaveChanged, when given old map and new list that have differing objects, will return the fields that are different between the pairs of objects (check everything that is in the expected set is in the return) ' );
		System.assert( expectedFieldsChanged.containsAll( fieldsChanged ), 'getFieldsThatHaveChanged, when given old map and new list that have differing objects, will return the fields that are different between the pairs of objects (check everything that is in the return set is in the expected) ' );

	}

	/**
	 * @method getFieldsThatHaveChanged (list version)
	 * @case   Passed and empty map of old objects and an empty set of new ones
	 * @result Will return an empty Set
	 */	
	@isTest
	private static void getFieldsThatHaveChanged_ListVersion_GivenEmptySetAndList_WillReturnAnEmptySet() {

		List<Contact> 	 newRecords = new List<Contact>();
		Map<Id, Contact> oldRecords = new Map<Id, Contact>();

		Test.startTest();
			Set<String> fieldsChanged = ObjectComparer.getFieldsThatHaveChanged( oldRecords, newRecords );
		Test.stopTest();

		System.assertEquals( 0, fieldsChanged.size(), 'getFieldsThatHaveChanged, when given an empty map of old and empty list of new, will return an empty set' );

	}
}