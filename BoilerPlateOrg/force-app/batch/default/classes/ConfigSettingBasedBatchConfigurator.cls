/**
 * Is used to configure an instance of AbstractBatch, setting the logging and 
 * email settings based on a set of config settings that can be distinguished
 * using a prefix.
 *
 * Every setting has a default in case the custom setting is not there.
 *
 * Documentation on using ConfigSettingBasedBatchConfigurator with AbstractBatch can be found here:
 *     https://makepositive.atlassian.net/wiki/spaces/DEV/pages/1203961892/Batch
 *
 * @date    2019-04-23
 * @author  makepositive
 */
public without sharing class ConfigSettingBasedBatchConfigurator {

	private String configPrefix;

	public ConfigSettingBasedBatchConfigurator( String configPrefix ) {
		this.configPrefix = configPrefix;
	}

	public void configure( AbstractBatch batchProcessor ) {

        batchProcessor.logResults       = this.logResultsEnabled;
        batchProcessor.sendResultsEmail = this.resultsEmailEnabled;
        batchProcessor.emailResultsTo   = this.resultsEmailTo;
        batchProcessor.emailReplyTo     = this.resultsEmailReplyTo;
	}

   /**
     * Enable logging of results to System Log - on by default
     * but can be configured in Application Properties.
     * 
     * @date    2019-04-23
     * @author  makepositive
     * @return	Boolean - Results logging enabled?
     */
    private Boolean logResultsEnabled {
        get {
            if (logResultsEnabled == null) {
                logResultsEnabled = ApplicationPropertyUtils.getInstance().getValue(
        			configPrefix + '_enableResultsLog',
                    true
    			);
            }
            return logResultsEnabled;
        }
        set;
    }
    
    /**
     * Enable emailing of results - on by default but can be 
     * configured in Application Properties.
     * 
     * @date    2019-04-23
     * @author  makepositive
     * @return	Boolean - Results emailing enabled?
     */
    private Boolean resultsEmailEnabled {
        get {
            if (resultsEmailEnabled == null) {
                resultsEmailEnabled = ApplicationPropertyUtils.getInstance().getValue(
        			configPrefix + '_enableResultsEmail',
                    false
    			);
            }
            return resultsEmailEnabled;
        }
        set;
    }
    
    /**
     * Reply to email address on results email - 
     * noreply@makepositive.com by default but can be configured 
     * in Application Properties.
     * 
     * @date    2019-04-23
     * @author  makepositive
     * @return	Boolean - Results emailing enabled?
     */
    private String resultsEmailReplyTo {
        get {
            if (resultsEmailReplyTo == null) {
                resultsEmailReplyTo = ApplicationPropertyUtils.getInstance().getValue(
        			configPrefix + '_replyToEmail', 
        			'noreply@makepositive.com'
    			);
            }
            return resultsEmailReplyTo;
        }
        set;
    }
    
    /**
     * Results email recipients - null by default but can be 
     * configured in Application Properties.
     * 
     * If null and results emailing is enabled will default to
     * the job submitter.
     * 
     * @date    2019-02-25
     * @author  makepositive
     * @return	List<String> - Results email recipients
     */
    private List<String> resultsEmailTo {
        get {
            if (resultsEmailTo == null) {
                String customSetting = ApplicationPropertyUtils.getInstance().getValue(
        			   configPrefix + '_toEmails'
    			);
                
                if (customSetting != null) {
                    resultsEmailTo = customSetting.split(',');
                }
            }
            return resultsEmailTo;
        }
        set;
    }

}