/**
 * Exists as a mechanism to test AbstractBatch (Abstract classes cannot be tested directly, and inner
 * classes cannot be executed as a batch).
 *
 * Also useful to serve as a simple guide of the methods that are available for overriding and using
 * within any classes derived from AbstractBatch
 *
 * Documentation on using AbstractBatch can be found here:
 *     https://makepositive.atlassian.net/wiki/spaces/DEV/pages/1203961892/Batch
 *
 * @date    2019-05-01
 * @author  makepositive
 */
public with sharing class TestableBatch extends AbstractBatch {

    public Boolean throwException = false;
    public Boolean updateRecords  = false;
    public Boolean deleteRecords  = false;
    public Boolean breakARecord   = false;

    // Stores the hooks that were called during a test execution so it can be examined in the test
    public List<String> hooksCalled = new List<String>();

    public class TestableBatchException extends Exception {}

    public TestableBatch() {
        this.query = 'SELECT Id FROM Contact';
    }

    /**
     * A pre-hook that will be executed at early in the 'start' method, allowing for the
     * configuration of the batch (including the query to be executed) to be set up prior to
     * any processing taking place.
     * 
     * @date    2019-05-01
     * @author  makepositive
     */
    protected override void setBatchSettings() {
        hooksCalled.add( 'setBatchSettings' );
    }

    /**
     * A hook that is executed within the 'start' process.  The parent class takes care of the 
     * more generic interface required for this method, including storing the BatchableContext in
     * a member variable.
     *
     * As with setBatchSettings, this executes prior to the query locator being created, and so can
     * also be used to set the 'query' member variable.
     * 
     * @date    2019-05-01
     * @author  makepositive
     */
    protected override void start() {
        hooksCalled.add( 'start' );
    }

    /**
     * A hook that is executed within the 'finish' process.  The parent class takes care of the 
     * more generic interface required for this method, including putting back any process deactiviation
     * methods, logging results, sending emails and scheduling the next batch process.
     *
     * @date    2019-05-01
     * @author  makepositive
     */
    protected override void finish() {
        hooksCalled.add( 'finish' );
    }

    /**
     * The core execute method that will process this batch.
     *
     * This version exists purely for testing, and changes its behaviour based on the setting of member
     * variables.  However, it can be used to review the capabilities and hooks that are available in
     * the AbstractBatch class.
     * 
     * @date    2019-05-01
     * @author  makepositive
     * @param	List<sObject> - The records that this execution of the batch should 'process'
     * @return	AbstractBatch.BatchResult - The resulting effect of the batch processing
     */
    public override AbstractBatch.BatchResult execute( List<sObject> scope ) {
        
        // Purely a test mechanism - so we can test what happens when an exception is thrown
        if ( throwException ) {
            throw new TestableBatchException( 'The exception you asked for' );
        }

        // Every 'execute' method should return a BatchResult with the end result of the processing
        AbstractBatch.BatchResult batchResult = new AbstractBatch.BatchResult();

        if ( updateRecords ) {

            if ( breakARecord ) {
                ((Contact)(scope[3])).LastName = '';
            }

            // An updateRecords method exists that will perform a NON all-or-nothing update
            // and put the resulting errors and suchlike into the batchResult class, ready to be returned
            batchResult = updateRecords( scope );
        }

        if ( deleteRecords ) {
            // A deleteRecords method exists that will perform a NON all-or-nothing delete
            // and put the resulting errors and suchlike into the batchResult class, ready to be returned
            batchResult = deleteRecords( scope );
        }

        return batchResult;
    }
}
