/**
* A colllection of methods that are useful when manipulating objects.
*
* Documentation on usage can be found here:
*    https://makepositive.atlassian.net/wiki/spaces/DEV/pages/1208713420/Object+Utils
*
* @date    2019-05-10
* @author  makepositive
*/
public without sharing class ObjectUtils {
    /**
     * Given a List of sObjects, return a Set containing the
     * Ids of those objects.
     *
     * @date    2019-05-10
     * @author  makepositive
     * @param   List<sObject> - The objects to get the Ids for
     * @return  Set<Ids> - The Ids of the objects in a set
     */
    public static Set<Id> buildSetOfIds( List<sObject> objects ) {
        return (new Map<Id, SObject>( objects )).keySet();
    }

    /**
     * Given a List of sObjects and a Set of Ids, will filter
     * the list os sObjects so it only contains the objects with
     * an Id that is in the set of Ids to keep.
     *
     * @date    2019-05-10
     * @author  makepositive
     * @param   List<sObject> - The objects to filter
     * @param   Set<Id> - The Ids of objects to keep
     * @return  List<sObject> - The filtered list of objects
     */
    public static List<sObject> filterObjects( List<sObject> originalList, Set<Id> idsOfObjectsToKeep ) {

        Map<Id, SObject> originalObjectIdToObjectMap  = new Map<Id, SObject>( originalList );

        List<SObject> filteredObjects = new List<SObject>();
        for ( Id thisObjectToKeep : idsOfObjectsToKeep ) {
            if ( originalObjectIdToObjectMap.containsKey( thisObjectToKeep ) ) {
                filteredObjects.add( originalObjectIdToObjectMap.get( thisObjectToKeep ) );
            }
        }

        return filteredObjects;
    }
}
