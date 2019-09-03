/**
* A colllection of methods that are useful when using picklists.
*
* Documentation on usage can be found here:
*    https://makepositive.atlassian.net/wiki/spaces/DEV/pages/1208746146/Picklist+Utils
*
* @date    2019-05-10
* @author  makepositive
*/
public without sharing class PicklistUtils {

    /**
     * Return a set of active picklist values for a given field.
     *
     * @date    2019-05-10
     * @author  makepositive
     * @param   Schema.DescribeFieldResult - The picklist field
     * @return  Set<String> - Set of active picklist values
     */
    public static Set<String> getActivePicklistValues( Schema.DescribeFieldResult picklistField ) {
        Set<String> picklistValues = new Set<String>();
        for ( Schema.PicklistEntry picklistValue : picklistField.getPicklistValues() ) {
            if ( picklistValue.isActive() ) {
                picklistValues.add( picklistValue.getValue() );
            }
        }
        return picklistValues;
    }
    
    /**
     * Take the values of a picklist field and check against a set
     * of valid picklist values - only return the valid values.
     * Useful when copying one picklist field to another picklist
     * field that may not have the same picklist values.
     * 
     * e.g. A;B;C, new Set<String> { 'A', 'C' }
     * returns 'A;C'
     *
     * @date    2019-05-10
     * @author  makepositive
     * @param   String - Source picklist value(s)
     * @param   Set<String> - Set of valid picklist values
     * @return  String - Destination picklist value(s)
     */
    public static String getValidPicklistEntries( String sourcePicklistValues, Set<String> validPicklistEntries ) {
        if ( sourcePicklistValues == null ) {
            return null;
        }
        
        Set<String> returnPicklistEntries = new Set<String>();
        
        for ( String sourcePicklistValue : sourcePicklistValues.split(';') ) {
            if ( validPicklistEntries.contains( sourcePicklistValue ) ) {
                returnPicklistEntries.add( sourcePicklistValue );
            }
        }
        
        List<String> entries = new List<String>( returnPicklistEntries );
        entries.sort();
        
        return returnPicklistEntries.size() > 0 ? String.join( entries, ';' ) : null;
    }
}
