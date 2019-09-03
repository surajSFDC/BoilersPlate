/**
 * 
 * Will check lists of objects and notify the consumer of the full list of fields
 * that have changed between the objects.
 *
 * Documentation on usage can be found here:
 *    https://makepositive.atlassian.net/wiki/spaces/DEV/pages/1230438480/Trigger+Handler+Framework
 *
 * @date    2019-06-21
 * @author  makepositive
 *
 */
public with sharing class ObjectComparer {

	public class ObjectComparerException extends Exception {}

	/**
	 * 
	 * Given a map of old records (indexed by their Id) and a list of new records, will check every pair of
	 * records for any fields that have changed and return a Set that contains the names of all fields 
	 * (in lowercase) that have changed on ANY record in the list.
	 *
	 * @date    2019-06-21
	 * @author  makepositive
	 * @param   Map<Id, sObject> - A map of the original records, indexed by their Id
	 * @param   List<sObject>    - A list of the new records to check against the old ones
	 * @return  Set<String>      - The list of fields that have changed against *any* of the records in the list
	 *
	 */
	public static Set<String> getFieldsThatHaveChanged( Map<Id, sObject> oldRecords, List<sObject> newRecords ) {

		Set<String> fieldNames = new Set<String>();

        if ( newRecords.size() == 0 ) {
            return new Set<String>();
        }

		Map<String, Schema.SObjectField> schemaFieldMap = newRecords[0].getSObjectType().getDescribe().fields.getMap();

		for (String fieldName: schemaFieldMap.keySet()) {
	        fieldNames.add( fieldName ); 
		}

		Set<String> fieldsThatHaveChanged = new Set<String>();

        for( sObject thisNewRecord : newRecords ) {
            fieldsThatHaveChanged.addAll( getFieldsThatHaveChanged( oldRecords.get( thisNewRecord.Id ), thisNewRecord, fieldNames ) );
        }

        return fieldsThatHaveChanged;

	}

	/**
	 * 
	 * Given two records, will check if any of the fields are different between them and return a Set that
	 * contains the names of all fields (in lowercase) that have changed.
	 *
	 * @date    2019-06-21
	 * @author  makepositive
	 * @param   sObject     - The original version of the record
	 * @param   sObject     - The updated version of the record
	 * @return  Set<String> - The list of fields that have changed between the records
	 *
	 */
	@testVisible
	private static Set<String> getFieldsThatHaveChanged( sObject oldRecord, sObject newRecord, Set<String> fieldNames ) {

		if ( oldRecord.getSobjectType() != newRecord.getSobjectType() ) {
			throw new ObjectComparerException( 'Cannot compare objects of different types' );
		}

		if ( oldRecord == null ) {
			throw new ObjectComparerException( 'Old Record cannot be null' );
		}

		Set<String> fieldsThatHaveChanged = new Set<String>();

		for( String thisField : fieldNames ) {
			try {
				if ( oldRecord.get( thisField ) != newRecord.get( thisField ) ) {
					fieldsThatHaveChanged.add( thisField );
				}				
			} catch( Exception e ) {
				// just want to continue on if there's an invalid field in the list
			}
		}

		return fieldsThatHaveChanged;
	}
}