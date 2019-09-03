/**
* A colllection of methods that are useful when manipulating Strings.
*
* Documentation on usage can be found here:
*    https://makepositive.atlassian.net/wiki/spaces/DEV/pages/1208680559/String+Utils
*
* @date    2019-05-10
* @author  makepositive
*/
public without sharing class StringUtils {

    /**
     * Return the first x many characters of a string but
     * don't throw an error if the string is not at least
     * that length (default behaviour of substring(0, x)).
     *
     * @date    2019-05-10
     * @author  makepositive
     * @param   String - The string to cut
     * @param	Integer - Maximum length of string
     * @return  String - String cut to a maximum of 'length'
     */
    public static String cutString( String str, Integer length ) {
        if (str == null) {
            return null;
        }
        return str.substring(0, Math.min(length, str.length()));
    }

     /**
     * Given a string, will perform a format on it, ensuring that single
     * quotes are converted before the format so that their 'literal string'
     * functionality is overridden.
     * 
     * Provided as a useful alternative to format when performing replacements
     * on labels, meaning that apostrophes don't accidentally halt the replacements
     *
     * @date    2019-05-10
     * @author  makepositive
     * @param   String - The string to format
     * @param   List<String> - The replacement strings to use in the format call
     * @return  String - The formatted string
     */
    public static String formatLabel( String format, List<String> replacementStrings ) {

        if ( String.isEmpty( format ) ) {
            return '';
        }

        format = format.replace( '\'', '\'\'' );
        return String.format( format, replacementStrings );
    }

    /**
     * Given a string, will return it.
     *
     * If the string is null, will return an empty string.
     * 
     * @date    2019-05-10
     * @author  makepositive
     * @param   String - The string
     * @return  String - The same string, or an empty string
     */
    public static String unNullString( String theString ) {
        return ( theString != null ) ? theString : '';
    }
}
