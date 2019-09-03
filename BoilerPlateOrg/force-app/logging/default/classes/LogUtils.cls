/**
* System Logging Utilities class.
*
* A collection of utility methods for logging messages to the System Log.
*
* Documentation on usage can be found here:
*    https://makepositive.atlassian.net/wiki/spaces/DEV/pages/1195180104/Logging
* 
* @date    2018-03-09
* @author  makepositive
*/
public inherited sharing class LogUtils {
    
    /**
     * Name of log source for Apex.
     * 
     * @date    2018-03-09
     * @author  makepositive
     * @return	String - System log source - Apex
     */
    public static final String LOG_SOURCE_APEX = 'Apex';
    
    /**
     * Logging levels - must match the Level__c picklist values.
     * 
     * @date    2018-03-09
     * @author  makepositive
     * @return	Level - Info / Warning / Error
     */
    public enum Level { Info, Warning, Error }
    
    /**
     * Get current logging settings - if not present default to logging
     * Errors only.
     * 
     * @date    2018-03-09
     * @author  makepositive
     * @return	Logging_Settings__c - Logging custom setting
     */
    private static Logging_Settings__c loggingSettings {
        get {
            if (loggingSettings == null) {
                loggingSettings = Logging_Settings__c.getInstance();
        		
                if (loggingSettings.Name == null) {
                    loggingSettings = new Logging_Settings__c(
                        Enable_System_Log_Error_Messages__c = true,
                        Enable_System_Log_Warning_Messages__c = false,
                        Enable_System_Log_Info_Messages__c = false
                    );
                }
            }
            return loggingSettings;
        }
        set;
    }
    
    /**
     * Log message to system log
     * 
     * @date    2018-03-09
     * @author  makepositive
     * @param	Level - Logging level (Info, Warning, Error)
     * @param	String - Log reference/identifier
     * @param	String - Full message text
     * @param	Id - Optional Id of related record
     * @return	System_Log__c - Inserted System Log entry
     */
    public static System_Log__c log(Level level, String reference, String message, Id relatedRecordId) {
        return insertLog(level, reference, message, relatedRecordId, true);
    }

    /**
     * Log message to system log
     * 
     * @date    2018-03-09
     * @author  makepositive
     * @param	Level - Logging level (Info, Warning, Error)
     * @param	String - Log reference/identifier
     * @param	String - Full message text
     * @param	Id - Optional Id of related record
     * @return	System_Log__c - Inserted System Log entry
     */
    public static System_Log__c log(Level level, String reference, String message, Id relatedRecordId, Boolean doDML) {
       return insertLog(level, reference, message, relatedRecordId, doDML);
    }

    /**
     * Log message to system log from DmlException
     * 
     * @date    2018-03-09
     * @author  makepositive
     * @param	String - Log reference/identifier
     * @param	DmlException - Source DmlException
     * @return	System_Log__c - Inserted System Log entry
     */
    public static System_Log__c log(String reference, DmlException ex) {
        return insertLog(Level.Error, reference, ex.getMessage(), ex.getDmlId(0), true);
    }

    /**
     * Log message to system log from Exception
     * 
     * @date    2018-03-09
     * @author  makepositive
     * @param	String - Log reference/identifier
     * @param	DmlException - Source Exception
     * @return	System_Log__c - Inserted System Log entry
     */
    public static System_Log__c log(String reference, Exception ex) {
        return insertLog(Level.Error, reference, ex.getMessage(), null, true);
    }

    /**
     * Internal method for logging message to system log
     * 
     * @date    2018-03-09
     * @author  makepositive
     * @param	Level - Logging level (Info, Warning, Error)
     * @param	String - Log reference/identifier
     * @param	String - Full message text
     * @param	Id - Optional Id of related record
     * @return	System_Log__c - Inserted System Log entry
     */
    private static System_Log__c insertLog(Level level, String reference, String message, Id relatedRecordId, Boolean doDML) {        
        System_Log__c log = new System_Log__c(
            Level__c             = level.name(),
			Reference__c         = reference,
            Message__c           = message,
            Class__c             = StackTraceUtils.getClassName(2),
            Method__c            = StackTraceUtils.getMethod(2),
            Stack_Trace__c       = StackTraceUtils.getStackTrace(2),
            Related_Record_Id__c = relatedRecordId,
            Source__c            = LOG_SOURCE_APEX
        );
        
        Boolean enableLogging = 
               (level == LogUtils.Level.Error && loggingSettings.Enable_System_Log_Error_Messages__c)
            || (level == LogUtils.Level.Warning && loggingSettings.Enable_System_Log_Warning_Messages__c)
            || (level == LogUtils.Level.Info && loggingSettings.Enable_System_Log_Info_Messages__c);
        
        if (enableLogging && doDML) {
            insert log;
        }
        
        return log;
    }
}