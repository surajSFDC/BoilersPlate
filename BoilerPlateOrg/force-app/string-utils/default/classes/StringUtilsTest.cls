@isTest
public class StringUtilsTest {

    /**
	 * @method cutString
	 * @case   Passed a string that is longer than required
	 * @result String will be cut to length
	 */		
	@isTest
    static void cutString_greaterThanLength_returnsCutString() {
		System.assertEquals( 'a', StringUtils.cutString( 'abc', 1 ), 'First letter of string should have been returned' );
	}
    
    /**
	 * @method cutString
	 * @case   Passed a string that is shorter than required
	 * @result String will not be cut but also not error (as it would with "abc".substring(0, 10))
	 */		
	@isTest
    static void cutString_lessThanLength_returnsWholeString() {
		System.assertEquals( 'abc', StringUtils.cutString( 'abc', 10 ), 'Whole string should have been returned without error' );
	}
    
    /**
	 * @method cutString
	 * @case   Passed a string that has no length
	 * @result String will not be cut but also not error
	 */		
	@isTest
    static void cutString_zeroLength_returnsZeroLength() {
		System.assertEquals( '', StringUtils.cutString( '', 1 ), 'Zero length passed into custring should still return zero length' );
	}
    
    /**
	 * @method cutString
	 * @case   Passed null
	 * @result Returns null
	 */		
	@isTest
    static void cutString_whenGivenNull_returnsNull() {
		System.assertEquals( null, StringUtils.cutString( null, 1 ), 'Null passed into custring should still return null' );
	}


	/**
	 * @method formatLabel
	 * @case   Passed a string with replacements, and some replacement string
	 * @result Returns the string with the replacements 
	 */		
	@isTest
    static void formatLabel_whenGivenAStringWithReplacements_willReplaceTheStrings() {

		String startingString = 'The string {0} and {1}';
		List<String> replacements = new List<String>{ 'one', 'two' };

		System.assertEquals( 'The string one and two', StringUtils.formatLabel( startingString, replacements ), 'formatLabel will return the string with the replacements made' );
	}

	/**
	 * @method formatLabel
	 * @case   Passed a string with replacements, and no replacement strings
	 * @result Returns the string with the replacements 
	 */		
	@isTest
    static void formatLabel_whenGivenAStringWithReplacements_butNoReplacements_willNotError() {

		String startingString = 'The string {0} and {1}';
		List<String> replacements = new List<String>{};

		System.assertEquals( 'The string {0} and {1}', StringUtils.formatLabel( startingString, replacements ), 'formatLabel will return the string without the replacements made if no strings are given' );
	}

	/**
	 * @method formatLabel
	 * @case   Passed a string with replacements and apostrophes
	 * @result Returns the string with the replacements, ignoring the apostrophes
	 */		
	@isTest
    static void formatLabel_whenGivenAStringWithReplacementsAndApostrophes_ignoresTheApostrophes() {

		String startingString = 'The string \'{0}\' and it\'s also {1}';
		List<String> replacements = new List<String>{ 'one', 'two' };

		System.assertEquals( 'The string \'one\' and it\'s also two', StringUtils.formatLabel( startingString, replacements ), 'formatLabel will return the string with the replacements made, ignoring the apostrophes' );
	}

	/**
	 * @method formatLabel
	 * @case   Passed a null string
	 * @result Returns an empty string
	 */		
	@isTest
    static void formatLabel_whenGivenANullString_returnsANullString() {

		String startingString = null;
		List<String> replacements = new List<String>{ 'one', 'two' };

		System.assertEquals( '', StringUtils.formatLabel( startingString, replacements ), 'formatLabel will return an empty string if given a null string' );
	}

	/**
	 * @method formatLabel
	 * @case   Passed an empty string
	 * @result Returns an empty string
	 */		
	@isTest
    static void formatLabel_whenGivenAnEmptyString_returnsAnEmptyString() {

		String startingString = '';
		List<String> replacements = new List<String>{ 'one', 'two' };

		System.assertEquals( '', StringUtils.formatLabel( startingString, replacements ), 'formatLabel will return an empty string if given an empty string' );
	}

	/**
	 * @method formatLabel
	 * @case   Passed a string of whitespace
	 * @result Returns the original string
	 */		
	@isTest
    static void formatLabel_whenGivenAStringOfWhitespace_returnsTheOriginalString() {

		String startingString = '   ';
		List<String> replacements = new List<String>{ 'one', 'two' };

		System.assertEquals( '   ', StringUtils.formatLabel( startingString, replacements ), 'formatLabel will return the orignal string if given a string of whitespace' );
	}

	/**
	 * @method unNullString
	 * @case   Passed a string
	 * @result Will return it
	 */		
	@isTest
    static void unNullString_passedAString_returnsIt() {
		System.assertEquals( 'string', StringUtils.unNullString( 'string' ), 'unNullString, when passed a string, returns it' );
	}

	/**
	 * @method unNullString
	 * @case   Passed null
	 * @result Returns an empty string
	 */		
	@isTest 
    static void unNullString_passedNull_returnsAnEmptyString() {
		System.assertEquals( '', StringUtils.unNullString( null ), 'unNullString, when passed null, returns an empty string' );
	}

	/**
	 * @method unNullString
	 * @case   Passed an empty string
	 * @result Returns an empty string
	 */		
	@isTest
    static void unNullString_passedAnEmptyString_returnsIt() {
		System.assertEquals( '', StringUtils.unNullString( '' ), 'unNullString, when passed an empty string, returns it' );
	}

	/**
	 * @method unNullString
	 * @case   Passed a string of whitespace
	 * @result Returns the passed string
	 */		
	@isTest
    static void unNullString_passedAStringOfWhitespace_returnsIt() {
		System.assertEquals( '  ', StringUtils.unNullString( '  ' ), 'unNullString, when passed a string of whitespace, will return it' );
	}
}
