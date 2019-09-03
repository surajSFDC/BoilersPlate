/**
 * Abstract class to extend standard Batachable functionality.
 * 
 * Additional functionality:
 *  - Results tracking
 *  - Emailing of results
 *  - Logging of results
 *  - Deactivation of validation rules / processes
 *  - Environment checks
 *
 * Documentation on using AbstractBatch can be found here:
 *     https://makepositive.atlassian.net/wiki/spaces/DEV/pages/1203961892/Batch
 *
 * @date    2019-02-25
 * @author  makepositive
 */
public abstract class AbstractBatch implements Database.Batchable<sObject>, Database.Stateful {

    /**
     * SOQL query to be used for query locator
     * 
     * @date    2019-02-25
     * @author  makepositive
     * @return	String - SOQL query
     */
    @testVisible
    protected String query;
    
    /**
     * Batchable context variable
     * 
     * @date    2019-02-25
     * @author  makepositive
     * @return	Database.BatchableContext - Batchable context
     */
    protected Database.BatchableContext batchableContext;
    
    /**
     * Job start date and time
     * 
     * @date    2019-02-25
     * @author  makepositive
     * @return	DateTime - Job start date/time
     */
    @testVisible
    private DateTime jobStartTime;
    
    /**
     * Salesforce AsyncApexJob Id
     * 
     * @date    2019-02-25
     * @author  makepositive
     * @return	Id - AsyncApexJob Id
     */
    protected Id jobId {
        get {
            if (jobId == null && this.batchableContext != null) {
                jobId = this.batchableContext.getJobID();
            }
            return jobId;
        }
        set;
    }
    
    /**
     * Disable processing - triggers, workflows, process builders,
     * email alerts and outbound messages by Process Deactivation
     * custom setting?
     * 
     * Default: false
     * 
     * @date    2019-02-25
     * @author  makepositive
     * @return	Boolean - Disable processing by custom setting?
     */
    @testVisible
    protected Boolean disableProcessing {
        get {
            if (disableProcessing == null) {
                disableProcessing = false;
            }
            return disableProcessing;
        }
        set;
    }
    
    /**
     * Disable validation rules by Process Deactivation custom 
     * setting?
     * 
     * Default: false
     * 
     * @date    2019-02-25
     * @author  makepositive
     * @return	Boolean - Disable validation by custom setting?
     */
    @testVisible
    protected Boolean disableValidation {
        get {
            if (disableValidation == null) {
                disableValidation = false;
            }
            return disableValidation;
        }
        set;
    }
    
    /**
     * Allow running of batch job in Production?
     * 
     * Default: true
     * 
     * @date    2019-02-25
     * @author  makepositive
     * @return	Boolean - Allow batch job in Production?
     */
    @testVisible
    protected Boolean allowedInProductionEnvironment {
        get {
            if (allowedInProductionEnvironment == null) {
                allowedInProductionEnvironment = true;
            }
            return allowedInProductionEnvironment;
        }
        set;
    }
    
    /**
     * Allow running of batch job in Sandbox?
     * 
     * Default: true
     * 
     * @date    2019-02-25
     * @author  makepositive
     * @return	Boolean - Allow batch job in Sandbox?
     */
    @testVisible
    protected Boolean allowedInSandboxEnvironment {
        get {
            if (allowedInSandboxEnvironment == null) {
                allowedInSandboxEnvironment = true;
            }
            return allowedInSandboxEnvironment;
        }
        set;
    }
    
    /**
     * Log a summary of batch results to the System Log?
     * 
     * Default: true
     * 
     * @date    2019-02-25
     * @author  makepositive
     * @return	Boolean - Enable results logging?
     */
    public Boolean logResults {
        get {
            if (logResults == null) {
                logResults = true;
            }
            return logResults;
        }
        set;
    }
    
    /**
     * Send a results email on completion of batch processing?
     * 
     * Default: true
     * 
     * @date    2019-02-25
     * @author  makepositive
     * @return	Boolean - Send results email?
     */
    public Boolean sendResultsEmail {
        get {
            if (sendResultsEmail == null) {
                sendResultsEmail = true;
            }
            return (sendResultsEmail && this.emailResultsTo.size() > 0);
        }
        set;
    }
    
    /**
     * Results email recipients.
     * 
     * Default: Job creator
     * 
     * @date    2019-02-25
     * @author  makepositive
     * @return	List<String> - List of email addresses
     */
    public List<String> emailResultsTo {
        get {
            if (emailResultsTo == null) {
                emailResultsTo = new List<String>();
                if (this.jobResults.CreatedBy.Email != null) {
                    emailResultsTo.add(this.jobResults.CreatedBy.Email);
                }
            }
            return emailResultsTo;
        }
        set;
    }
    
    /**
     * Reply to email address on results email.
     * 
     * Default: noreply@salesforce.com
     * 
     * @date    2019-02-25
     * @author  makepositive
     * @return	String - Reply to email address
     */
    public String emailReplyTo {
        get {
            if (emailReplyTo == null) {
                emailReplyTo = 'noreply@salesforce.com';
            }
            return emailReplyTo;
        }
        set;
    }
    
    /**
     * Email subject suffix
     * 
     * @date    2019-02-25
     * @author  makepositive
     * @return	String - Email subject suffix
     */
    protected String emailSubjectSuffix {
        get {
            if (emailSubjectSuffix == null) {
                emailSubjectSuffix = '';
            }
            return emailSubjectSuffix;
        }
        set;
    }
    
    /**
     * Swallow any exceptions received on sending results
     * email e.g. if deliverability is disabled in the 
     * environment or email limits have been hit.
     * 
     * Default: true
     * 
     * @date    2019-02-25
     * @author  makepositive
     * @return	Boolean - Ignore email sending exceptions
     */
    @testVisible
    protected Boolean catchResultsEmailException {
        get {
            if (catchResultsEmailException == null) {
                catchResultsEmailException = true;
            }
            return catchResultsEmailException;
        }
        set;
    }
    
    /**
     * Optional parameter for chaining batch jobs - on 
     * completion of job this batch job will be initiated.
     * 
     * @date    2019-02-25
     * @author  makepositive
     * @return	AbstractBatch - Next batch job to run
     */
    protected AbstractBatch nextBatch { get; set; }
    
    /**
     * Current Process Deactivation settings for current logged
     * in user.
     * 
     * @date    2019-02-25
     * @author  makepositive
     * @return	Process_Deactivation__c - Process Deactivation settings
     */
    private Process_Deactivation__c processDeactivation {
        get {
            if (processDeactivation == null) {
                processDeactivation = Process_Deactivation__c.getValues(UserInfo.getUserId());
            }
            return processDeactivation;
        }
        set;
    }
    
    /**
     * A clone of Process Deactivation settings for current
     * logged in user - this enables reverting of settings
     * when the batch job is complete.
     * 
     * @date    2019-02-25
     * @author  makepositive
     * @return	Process_Deactivation__c - Process Deactivation settings
     */
    private Process_Deactivation__c processDeactivationOriginal {
        get {
            if (processDeactivationOriginal == null) {
                processDeactivationOriginal = processDeactivation.clone();
            }
            return processDeactivationOriginal;
        }
        set;
    }
    
    /**
     * Did Process Deactivation settings exist at the beginning
     * of execution? This enables reverting of settings when the
     * batch job is complete.
     * 
     * @date    2019-02-25
     * @author  makepositive
     * @return	Boolean - Process Deactivation settings exist?
     */
    private Boolean processDeactivationExists {
        get {
            if (processDeactivationExists == null) {
                processDeactivationExists = (this.processDeactivation != null && this.processDeactivation.Id != null);
            }
            return processDeactivationExists;
        }
        set;
    }
    
    /**
     * Record level Batch Results tracking - one per batch
     * iteration.
     * 
     * @date    2019-02-25
     * @author  makepositive
     * @return	List<BatchResult> - List of Batch Results
     */
    @testVisible
    private List<BatchResult> batchResults {
        get {
            if (batchResults == null) {
                batchResults = new List<BatchResult>();
            }
            return batchResults;
        }
        set;
    }

    /**
     * Salesforce AsyncApexJob results for use in results logging
     * and email. Purposefully not cached - results always need
     * to be up-to-date.
     * 
     * @date    2019-02-25
     * @author  makepositive
     * @return	AsyncApexJob - Job results
     */
     @testVisible
    private AsyncApexJob jobResults {
        get {
            if (this.jobId != null) {
                jobResults = [SELECT Id, ApexClass.Name, Status, TotalJobItems, 
                              	JobItemsProcessed, NumberOfErrors, CreatedBy.Email
                       		  FROM AsyncApexJob
                       		  WHERE Id = :this.jobId];
            }
            return jobResults;
        }
        set;
    }
    
    /**
     * Batchable interface start implementation - start batch job.
     * 
     *  - Log the start time
     *  - Check batch is allowed in environment
     *  - Set batchable context
     *  - Insert process / validation deactivation settings
     *  - Call start method that can be overwritten in derived class
     * 
     * @date    2019-02-25
     * @author  makepositive
     * @param	Database.BatchableContext - Batchable context
     * @return	Database.QueryLocator - Query locator
     */
	public Database.QueryLocator start(Database.BatchableContext batchableContext) {
        if (this.jobStartTime == null) {
            this.jobStartTime = DateTime.now();
        }
        
        this.batchableContext = batchableContext;
        
        this.setBatchSettings();
        
		this.checkEnvironment();
        
        if (this.disableProcessing || this.disableValidation) {
            this.updateProcessDeactivationSettings();
        }
        
        this.start();
        
		return Database.getQueryLocator(this.query);
	}

    /**
     * Batchable interface execute implementation - execute iteration 
     * of batch job.
     * 
     *  - Delegate processing of scope to abstract execute method
     *  - Log batch failure and rethrow exception (so that Salesforce
     *    counts the batch as a failure)
     * 
     * @date    2019-02-25
     * @author  makepositive
     * @param	Database.BatchableContext - Batchable context
     * @param	List<sObject> - Iteration scope - batch of records
     */
   	public void execute(Database.BatchableContext batchableContext, List<sObject> scope) {
        try {
            this.batchResults.add(this.execute(scope));
        } catch (Exception e) {
            BatchResult result = new BatchResult();
            result.totalRecords = scope.size();
            result.errorCount = scope.size();
            result.errors.add(e.getMessage());
            
            this.batchResults.add(result);
            
            throw e;
        }
	}

    /**
     * Batchable interface finish implementation - finish batch job.
     * 
     *  - Revert any Process Deactivation settings
     *  - Optionally send a results email
     *  - Optionally log results to System Log
     *  - Call finish method that can be overwritten in derived class
     * 
     * @date    2019-02-25
     * @author  makepositive
     * @param	Database.BatchableContext - Batchable context
     */
	public void finish(Database.BatchableContext batchableContext) {

        if (this.disableProcessing || this.disableValidation) {
            this.restoreProcessDeactivationSettings();
        }
        
        if (this.sendResultsEmail) {
            this.sendMail();
        }
        
        if (this.logResults) {
            this.logResults();
        }
        
        this.finish();

        if (this.nextBatch != null) {
            Database.executeBatch(this.nextBatch);
        }

	}
	
    /**
     * Processing of iteration of batch - called from main execute
     * method. Must be implemented by derived class.
     * 
     * @date    2019-02-25
     * @author  makepositive
     * @param	List<sObject> - Iteration scope - batch of records
     * @return	BatchResult - Summary of results and any errors
     */
    public abstract BatchResult execute(List<sObject> scope);

    /**
     * Optional method for hooking into beginning of start method 
     * from derived class for the purpose of setting batchSettings.
     * 
     * @date    2019-02-25
     * @author  makepositive
     */
    protected virtual void setBatchSettings() {}    
    
    /**
     * Optional method for hooking into start method from derived
     * class.
     * 
     * @date    2019-02-25
     * @author  makepositive
     */
    protected virtual void start() {}
    
    /**
     * Optional method for hooking into finish method from derived
     * class.
     * 
     * @date    2019-02-25
     * @author  makepositive
     */
    protected virtual void finish() {}
    
    /**
     * Update a list of records and save number of records updated
     * and any errors to a BatchResult.
     * 
     * @date    2019-02-25
     * @author  makepositive
     * @param	List<sObject> - Records to update
     * @return	BatchResult - Summary of results and any errors
     */
    protected BatchResult updateRecords( List<sObject> records ) {
        
		Database.DMLOptions dmlOptions = new Database.DMLOptions();
		dmlOptions.DuplicateRuleHeader.AllowSave = true; 
        dmlOptions.optAllOrNone                  = false;
        
        Database.SaveResult[] results = Database.update(records, dmlOptions);

        BatchResult batchResult = new BatchResult();
        batchResult.totalRecords = records.size();
        for (Integer i = 0; i < results.size(); i++) {
            Database.SaveResult result = results[i];
            if (!result.isSuccess()) {
                String errorMessage = 'Error(s) updating Record Id: ' + records[i].Id + ' ';
                for (Database.Error error : result.getErrors()) {
                    errorMessage += 'Status: ' + error.getStatusCode() + ' Message: ' + error.getMessage() + ' ';
                }
                batchResult.errors.add(errorMessage.trim());
                batchResult.errorCount++;
            } else {
                batchResult.successCount++;
            }
        }
        return batchResult;
    }
    
    /**
     * Update a list of records and save number of records updated
     * and any errors to a BatchResult.
     * 
     * @date    2019-02-25
     * @author  makepositive
     * @param   List<sObject> - Records to delete
     * @return  BatchResult - Summary of results and any errors
     */
    protected BatchResult deleteRecords( List<sObject> records ) {
        
        Database.DMLOptions dmlOptions = new Database.DMLOptions();
        dmlOptions.optAllOrNone = false;
        
        Database.DeleteResult[] results = Database.delete(records);

        BatchResult batchResult = new BatchResult();
        batchResult.totalRecords = records.size();
        for (Integer i = 0; i < results.size(); i++) {
            Database.DeleteResult result = results[i];
            if (!result.isSuccess()) {
                String errorMessage = 'Error(s) deleting Record Id: ' + records[i].Id + ' ';
                for (Database.Error error : result.getErrors()) {
                    errorMessage += 'Status: ' + error.getStatusCode() + ' Message: ' + error.getMessage() + ' ';
                }
                batchResult.errors.add(errorMessage.trim());
                batchResult.errorCount++;
            } else {
                batchResult.successCount++;
            }
        }
        return batchResult;
    }
    
    /**
     * Send a results email with job overview and any messages
     * and/or errors.
     * 
     * @date    2019-02-25
     * @author  makepositive
     */
    private void sendMail() {
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setSubject(UserInfo.getOrganizationName() + ': Batch Job ' + this.jobResults.ApexClass.Name + ' ' + this.jobResults.Status + ' ' + this.emailSubjectSuffix);
        mail.setToAddresses(this.emailResultsTo);
        mail.setReplyTo(this.emailReplyTo);
        mail.setSenderDisplayName(UserInfo.getOrganizationName());
        
        BatchResult totalBatchResult = this.getTotals();
        
        String html = 
            '<table>' +
                '<thead>' + 
                    '<tr>' + 
            			'<th style="text-align:left">Job ID</th>' + 
            			'<th style="text-align:left">Apex Class</th>' + 
            			'<th style="text-align:left">Status</th>' + 
            			'<th style="text-align:left">Total Batches</th>' + 
            			'<th style="text-align:left">Batches Processed</th>' +
            			'<th style="text-align:left">Failures</th>' + 
            			'<th style="text-align:left">Start</th>' + 
            			'<th style="text-align:left">End</th>' + 
            			'<th style="text-align:left">Duration</th>' + 
                        '<th style="text-align:left">Total Records</th>' + 
                        '<th style="text-align:left">Success Count</th>' + 
                        '<th style="text-align:left">Error Count</th>' + 
            		'</tr>' +
                '</thead>' +
                '<tbody>' +
                    '<tr>' + 
            			'<td>' + this.jobResults.Id + '</td>' + 
            			'<td>' + this.jobResults.ApexClass.Name + '</td>' + 
            			'<td>' + this.jobResults.Status + '</td>' + 
            			'<td>' + this.jobResults.TotalJobItems + '</td>' + 
            			'<td>' + this.jobResults.JobItemsProcessed + '</td>' + 
            			'<td>' + this.jobResults.NumberOfErrors + '</td>' + 
            			'<td>' + this.jobStartTime.format() + '</td>' + 
            			'<td>' + DateTime.now().format() + '</td>' + 
            			'<td>' + getElapsedTime(this.jobStartTime, DateTime.now()) + '</td>' + 
                        '<td>' + String.valueOf(totalBatchResult.totalRecords) + '</td>' + 
                        '<td>' + String.valueOf(totalBatchResult.successCount) + '</td>' + 
                        '<td>' + String.valueOf(totalBatchResult.errorCount) + '</td>' + 
            		'</tr>' +
                '</tbody>' + 
            '</table>';
        
        String errorsHtml = '<table><thead><tr><th style="text-align:left">Errors:</th></tr></thead><tbody>';
        String messagesHtml = '<table><thead><tr><th style="text-align:left">Messages:</th></tr></thead><tbody>';
        
        for (BatchResult batchResult : this.batchResults) {            
            for (String error : batchResult.errors) {
                errorsHtml += '<tr><td>' + error + '</td></tr>';
            }
            
            for (String message : batchResult.messages) {
                messagesHtml += '<tr><td>' + message + '</td></tr>';
            }
        }
       	
        errorsHtml += '</tbody></table>';
        messagesHtml += '</tbody></table>';
        
        html += '<hr />' + messagesHtml + '<hr />' + errorsHtml;

        mail.setHtmlBody(html);
        
        try {
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        } catch (Exception ex) {
            LogUtils.log(this.jobResults.ApexClass.Name + ' email sending failed', ex);
            
            if (!this.catchResultsEmailException) {
                throw ex;
            }
        }
    }
    
    /**
     * Log a summary of results to the System Log as an Info
     * entry.
     * 
     * @date    2019-02-25
     * @author  makepositive
     */
    private void logResults() {

        BatchResult totalBatchResult = this.getTotals();
        
        String logMessage = 'Batch Results:\n' +
        					'Id: ' + this.jobResults.Id + '\n' + 
            				'Class: ' + this.jobResults.ApexClass.Name + '\n' + 
            				'Status: ' + this.jobResults.Status + '\n' + 
            				'Total Job Items: ' + this.jobResults.TotalJobItems + '\n' + 
            				'Job Items Processed: ' + this.jobResults.JobItemsProcessed + '\n' + 
            				'Number of Errors: ' + this.jobResults.NumberOfErrors + '\n' + 
            				'Job Start Time: ' + this.jobStartTime.format() + '\n' + 
            				'Job Finish Time: ' + DateTime.now().format() + '\n' + 
            				'Duration: ' + getElapsedTime(this.jobStartTime, DateTime.now()) + '\n' + 
                        	'Total Records: ' + String.valueOf(totalBatchResult.totalRecords) + '\n' + 
                        	'Success Count: ' + String.valueOf(totalBatchResult.successCount) + '\n' + 
                        	'Error Count: ' + String.valueOf(totalBatchResult.errorCount);
        LogUtils.log( LogUtils.Level.Info, this.jobResults.ApexClass.Name + ' Batch Results', logMessage, this.jobResults.Id );
    }

    /**
     * Update Process Deactivation custom setting to disable
     * Triggers, Outbound Messages, Email Alerts, Process
     * Builders, Worklows and/or Validation Rules.
     * 
     * @date    2019-02-25
     * @author  makepositive
     */
    private void updateProcessDeactivationSettings() {
        if (this.processDeactivationExists) {
            this.processDeactivationOriginal = this.processDeactivation.clone();
        } else {
            this.processDeactivation = new Process_Deactivation__c();
            this.processDeactivation.SetupOwnerId = UserInfo.getUserId();
        }
        
        this.processDeactivation.Disable_All_Triggers__c = this.disableProcessing;
        this.processDeactivation.Disable_Outbound_Messages__c = this.disableProcessing;
        this.processDeactivation.Disable_Email_Alerts__c = this.disableProcessing;
        this.processDeactivation.Disable_Workflows__c = this.disableProcessing;
        this.processDeactivation.Disable_Validation_Rules__c = this.disableValidation;
        
        upsert this.processDeactivation;
    }
    
    /**
     * Revert changes to Process Deactivation custom setting.
     * 
     * @date    2019-02-25
     * @author  makepositive
     */
    private void restoreProcessDeactivationSettings() {
        if (!this.processDeactivationExists) {
            delete this.processDeactivation;
        } else {
            Id originalId = this.processDeactivation.Id;
            this.processDeactivation = this.processDeactivationOriginal;
            this.processDeactivation.Id = originalId;
            update this.processDeactivation;
        }
    }
    
    /**
     * Check batch job is allowed in this environment.
     * 
     * Note - always allowed in unit tests.
     * 
     * @date    2019-02-25
     * @author  makepositive
     */
    @testVisible
    private void checkEnvironment() {
        Boolean isSandbox = [SELECT IsSandbox FROM Organization LIMIT 1].IsSandbox;
        
        if (!Test.isRunningTest()) {
            if (!this.allowedInProductionEnvironment && !isSandbox) {
                throw new AbstractBatchException('Not allowed in Production environment!');
            }
            
            if (!this.allowedInSandboxEnvironment && isSandbox) {
                throw new AbstractBatchException('Not allowed in Sandbox environment!');
            }
        }
    }
	
    /**
     * Compare two dates/times and present in milliseconds, seconds
     * or minutes.
     * 
     * @date    2019-02-25
     * @author  makepositive
     * @param	DateTime - Earliest DateTime
     * @param	DateTime - Latest DateTime
     * @return	String - Time difference as string
     */
    @testVisible
    private String getElapsedTime(DateTime start, DateTime finish) {
        Long milliseconds = finish.getTime() - start.getTime();
        if (milliseconds < 1000) {
            return String.valueOf(milliseconds) + ' ms';
        } else if (milliseconds < (1000 * 60)) {
            Decimal seconds = milliseconds / 1000;
        	return String.valueOf(seconds) + ' s';
        } else {
            Decimal minutes = (milliseconds / 1000) / 60;
            return String.valueOf(minutes) + ' m';
        }
    }
    
    /**
     * Combine all batch result totals into grand totals.
     * 
     * @date    2019-02-25
     * @author  makepositive
     * @return	BatchResult - Grand totals of batch results
     */
     @testVisible
    private BatchResult getTotals() {
        BatchResult totalBatchResult = new BatchResult();
        
        for (BatchResult batchResult : this.batchResults) {
            totalBatchResult.totalRecords += batchResult.totalRecords;
            totalBatchResult.successCount += batchResult.successCount;
            totalBatchResult.errorCount   += batchResult.errorCount;
        }
        
        return totalBatchResult;
    }
    
    /**
     * Inner class to track results for a batch iteration.
     * 
     * @date    2019-02-25
     * @author  makepositive
     */
    public class BatchResult {
        
        /**
         * Total number of records in the batch.
         * 
         * @date    2019-02-25
         * @author  makepositive
         * @return	Integer - Total number of records
         */
        public Integer totalRecords {
            get {
                if (totalRecords == null) {
                    totalRecords = 0;
                }
                return totalRecords;
            }
            set;
        }
        
        /**
         * Number of records successfully updated in batch.
         * 
         * @date    2019-02-25
         * @author  makepositive
         * @return	Integer - Number of updated records
         */
        public Integer successCount {
            get {
                if (successCount == null) {
                    successCount = 0;
                }
                return successCount;
            }
            set;
        }
        
        /**
         * Number of records failed to update in batch.
         * 
         * @date    2019-02-25
         * @author  makepositive
         * @return	Integer - Number of failed updates
         */
        public Integer errorCount {
            get {
                if (errorCount == null) {
                    errorCount = 0;
                }
                return errorCount;
            }
            set;
        }
        
        /**
         * List of messages to pass back to results email.
         * 
         * @date    2019-02-25
         * @author  makepositive
         * @return	List<String> - List of messages
         */
        public List<String> messages {
            get {
                if (messages == null) {
                    messages = new List<String>();
                }
                return messages;
            }
            set;
        }
        
        /**
         * List of errors to pass back to results email.
         * 
         * @date    2019-02-25
         * @author  makepositive
         * @return	List<String> - List of errors
         */
        public List<String> errors {
            get {
                if (errors == null) {
                    errors = new List<String>();
                }
                return errors;
            }
            set;
        }
    }
    
    /**
     * General AbstractBatch exception class
     * 
     * @date    2019-02-25
     * @author  makepositive
     */
    public class AbstractBatchException extends Exception {}
}