/**
* Stack Trace Utilities class.
*
* A collection of utility methods for retrieving a stack trace,
* the current class and current method.
*
* Documentation on usage can be found here:
*    https://makepositive.atlassian.net/wiki/spaces/DEV/pages/1195180104/Logging
*
* @date    2018-03-09
* @author  makepositive
*/
public class StackTraceUtils {
    
    /**
     * Get current stack trace minus the two calls within this class.
     * 
     * @date    2018-03-09
     * @author  makepositive
     * @return	String - Stack Trace
     */
	public static String getStackTrace() {
        return getStackTrace(1);
    }
    
    /**
     * Get current stack trace minus the top x many levels (can be used to
     * remove the StackTraceUtils methods/logging methods from the stack
     * trace).
     * 
     * @date    2018-03-09
     * @author  makepositive
     * @param	Integer - Number of levels to remove from the top of the
     * 			stack trace
     * @return	String - Stack trace
     */
	public static String getStackTrace(Integer skipLevels) {
        Integer i = 0;
        String line = new DmlException().getStackTraceString();
        
        while (i <= skipLevels) {
            line = line.substringAfter('\n');
            i++;
        }
        
        return line;
    }
    
    /**
     * Get the current class name (excluding this class).
     * 
     * @date    2018-03-09
     * @author  makepositive
     * @return	String - Current class name
     */
    public static String getClassName() {
        return getClassName(1);
    }
    
    /**
     * Get current class name minus the top x many levels (can be used
     * to remove the StackTraceUtils class/logging classes).
     * 
     * @date    2018-03-09
     * @author  makepositive
     * @param	Integer - Number of levels to remove from the top of
     * 			the stack trace before getting class name
     * @return	String - Current class name
     */
    public static String getClassName(Integer skipLevels) {
        Integer i = 0;
        String line = getStackTrace();
        
        while (i <= skipLevels) {
            line = line.substringAfter('\n');
            i++;
        }
        
        if (line.startsWith('Class.')) {
            line = line.substringAfter('Class.');
        }
        
        return line.substringBefore(':').substringBeforeLast('.');
    }
    
    /**
     * Get the current method name (excluding this method).
     * 
     * @date    2018-03-09
     * @author  makepositive
     * @return	String - Current method name
     */
    public static String getMethod() {
        return getMethod(1);
    }
    
    /**
     * Get current method name minus the top x many levels (can be used
     * to remove the StackTraceUtils methods/logging methods).
     * 
     * @date    2018-03-09
     * @author  makepositive
     * @param	Integer - Number of levels to remove from the top of
     * 			the stack trace before getting method name
     * @return	String - Current method name
     */
	public static String getMethod(Integer skipLevels) {
        Integer i = 0;
        String line = getStackTrace();
        
        while (i <= skipLevels) {
            line = line.substringAfter('\n');
            i++;
        }
        
    	return line.substringBefore(':').substringAfterLast('.');
	}
}