/**
 * Utility class for retrieving generic configuration properties
 * from the Application Properties custom setting. Settings are
 * stored as key/value pairs. This is useful for configuration
 * flags and values without the need for lots of individual
 * custom settings or new fields on existing custom settings.
 * 
 * Documentation on usage can be found here:
 *    https://makepositive.atlassian.net/wiki/spaces/DEV/pages/1193115688/Application+Properties
 * 
 * @date    2018-03-09
 * @author  makepositive
 */
public class ApplicationPropertyUtils {
    /**
     * Instance of this class (singleton)
     * 
     * @date    2018-03-09
     * @author  makepositive
     * @return	ApplicationPropertyUtils - Instance of this class
     */
	private static ApplicationPropertyUtils instance { get; set; }
    
    /**
     * Cached map of application properties from custom settings
     * 
     * @date    2018-03-09
     * @author  makepositive
     * @return	Map<string, Application_Properties__c>
     * 			[Property Key] -> [Application Property]
     */
    private static Map<string, Application_Properties__c> applicationProperties {
        get {
            if (applicationProperties == null) {
                applicationProperties = Application_Properties__c.getAll();
            }
            return applicationProperties;
        }
        set;
    }
    
    /**
     * Get instance of this class (singleton)
     * 
     * @date    2018-03-09
     * @author  makepositive
     * @return	ApplicationPropertyUtils - Instance of this class
     */
    public static ApplicationPropertyUtils getInstance() {
        if (instance == null) {
            instance = new ApplicationPropertyUtils();
        }
        return instance;
    }
    
    /**
     * Get the value of a Application Property (will return null 
     * if the property doesn't exist)
     * 
     * @date    2018-03-09
     * @author  makepositive
     * @param	String - Application Property Key
     * @return	String - Value of Application Property
     */
    public String getValue(final String key) {
        String value = null;
        if (applicationProperties.containsKey(key)) {
            Application_Properties__c applicationProperty = applicationProperties.get(key);
            if (applicationProperty != null) {
                value = applicationProperty.Value__c;
            }
        }
        return value;
    }
    
    /**
     * Get the value of an Application Property, it it doesn't
     * exist use the second parameter as a default value.
     * 
     * Useful as an alternative to hardcoding values in code,
     * set the hardcoded value as the defaultValue and if
     * necessary it can be overridden by custom setting without
     * modifying the code.
     * 
     * @date    2018-03-09
     * @author  makepositive
     * @param	String - Application Property Key
     * @param	String - Default value
     * @return	String - Value of Application Property
     */
    public String getValue(final String key, final String defaultValue) {
        String value = getValue(key);
        if (value == null) {
            value = defaultValue;
        }
        return value;
    }
    
    /**
     * Get the value of an Application Property, it it doesn't
     * exist use the second parameter as a default value.
     * 
     * All Application Properties are stored as strings, 'true'
     * will be converted to TRUE, all other strings are considered
     * FALSE.
     * 
     * @date    2018-03-09
     * @author  makepositive
     * @param	String - Application Property Key
     * @param	Boolean - Default value
     * @return	Boolean - Value of Application Property
     */
    public boolean getValue(final String key, final Boolean defaultValue) {
        String value = getValue(key);
        if (value == null) {
            return defaultValue;
        }
        return value.toLowerCase() == 'true';
    }
    
    /**
     * Get the value of an Application Property, it it doesn't
     * exist use the second parameter as a default value.
     * 
     * All Application Properties are stored as strings, the string
     * will be converted to an Integer value and returned.
     * 
     * @date    2018-03-09
     * @author  makepositive
     * @param	String - Application Property Key
     * @param	Integer - Default value
     * @return	Integer - Value of Application Property
     */
    public Integer getValue(final String key, final Integer defaultValue) {
        String value = getValue(key);
        if (value == null) {
            return defaultValue;
        }
        return Integer.valueOf(value);
    }
    
    /**
     * 
     * 
     * @date    2018-03-09
     * @author  makepositive
     * @param	String - Application Property Key
     * @param	Set<String> - Default value
     * @return	Set<String> - Values of Application Property
     */
    public Set<String> getValues(final String key, final Set<String> defaultValues) {
        String valueString = getValue(key);
        
        Set<String> values = new Set<String>();
        
        if (valueString == null) {
            values = defaultValues;
        } else {
            for (String value : valueString.split(',')) {
                values.add(value.trim());
            }
        }
        
        return values;
    }
}