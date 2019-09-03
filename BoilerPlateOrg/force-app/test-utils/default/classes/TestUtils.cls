@isTest
/**
* A colllection of methods that are useful when running tests.
*
* Documentation on usage can be found here:
*    https://makepositive.atlassian.net/wiki/spaces/DEV/pages/1208746125/Test+Utils
*
* @date    2019-04-23
* @author  makepositive
*/
public class TestUtils {

	public class TestUtilsException extends Exception {}

	private static Map<String,String> objectPrefixes     = new Map<String,String>();
	private static Integer            highestGeneratedId = 0;

	/**
	 * Generate an Id that is appropriate for the given object type, with
	 * the given last digits.
	 *
	 * Useful if you need an in-memory SObject that has an Id or a reference
	 * to another in-memory SObject.
	 *
	 * Means there should be NO hardcoded Ids in tests.
	 *
     * @date    2019-04-23
     * @author  makepositive
     * @param   String - The name of the object for which the Id should be created (e.g. Contact) 
     * @param   Integer - The last section of the Id.
     *
     */
	public static Id generateId( String objectName, Integer idNumber ) {

		String prefix     = getObjectPrefix( objectName );
		String uniquePart = String.valueOf( idNumber );
		String newId      = prefix.rightPad( 18 - uniquePart.length(), '0' ) + uniquePart;

		if ( idNumber > highestGeneratedId ) {
			highestGeneratedId = idNumber;
		}

		return newId;
	}

	/**
	 * Generate an Id that is appropriate for the given object type that is
	 * 1 digit higher than the previous highest
	 *
	 * Useful if you need an in-memory SObject that has an Id or a reference
	 * to another in-memory SObject.
	 *
	 * Means there should be NO hardcoded Ids in tests.
	 *
     * @date    2019-04-23
     * @author  makepositive
     * @param   String - The name of the object for which the Id should be created (e.g. Contact) 
     *
     */
   	public static Id generateId( String objectName ) {
		return generateId( objectName, highestGeneratedId + 1 );
	}

	/**
	 * Get the 3 character prefix for the given object type, caching the values as it goes
	 *
     * @date    2019-04-23
     * @author  makepositive
     * @param   String - The name of the object type for which you want the prefix
     *
     */
	private static String getObjectPrefix( String objectName )  {

		if ( objectPrefixes.containsKey( objectName ) ) {
			return objectPrefixes.get( objectName );
		}

        SObjectType objectType = Schema.getGlobalDescribe().get( objectName );
        if ( objectType == null ) {
        	throw new TestUtilsException( 'Attempted to generate an Id for an invalid object type (' + objectName + ')' );
        }
        Schema.DescribeSObjectResult sobjectDescription = objectType.getDescribe();
        String prefix = sobjectDescription.getKeyPrefix();

        objectPrefixes.put( objectName, prefix );
        return prefix;
	}
}