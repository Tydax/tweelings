/* 
 * Sends an Ajax request.
 * type: type of request (GET or POST)
 * path: the path where to send the request
 * callback: the function to call when the request is done
 * parameters: the parameters written in a json formatted string
 */
function sendRequest(type, path, parameters, callback) {
    // Load file
    var xhr = new XMLHttpRequest();
    xhr.open(type, path, true);
    if (parameters != null) {
        xhr.setRequestHeader("Content-Type", "application/json;charset=UTF-8");
    }

    // When given a response, call the callback function
    xhr.addEventListener("readystatechange", function() {
        if (xhr.readyState === 4 && xhr.status === 200) {
            callback(xhr.responseText);
        }
    }, false);

    xhr.send(JSON.stringify(parameters));
}

function fetchTweets() {
    var form = document.getElementById("search-form");
    var parameters = {
        theme: form.theme.value
    }
    lockForm(true);
    sendRequest("POST", "/fetch_tweets", parameters, function(response) {
        var result = JSON.parse(response);
        if (result.code == 0) {
            console.log("Fetched " + result.result + " tweets!");
            saveTweets();
        } else {
            console.log("Error code: " + result.code);
            displayError(result.code, result.result);
        }
    });
}

function saveTweets() {
    sendRequest("GET", "/save_tweets", null, function(response) {
        var result = JSON.parse(response);
        if (result.code == 0) {
            console.log("Saved " + result.result.length + " tweets!");
            lockForm(false);
            console.log(result);
            console.log(JSON.parse(result.result));
            updateTweetList(result.result);
        }
    });
}

function CSVToArray( strData, strDelimiter ) {
    // Check to see if the delimiter is defined. If not,
    // then default to comma.
    strDelimiter = (strDelimiter || ",");

    var objPattern = new RegExp(
    	(
            // Delimiters.
            "(\\" + strDelimiter + "|\\r?\\n|\\r|^)" +

            // Quoted fields.
            "(?:\"([^\"]*(?:\"\"[^\"]*)*)\"|" +

            // Standard fields.
            "([^\"\\" + strDelimiter + "\\r\\n]*))"
    	),
    	"gi"
    	);

    // Create an array to hold our data. Give the array
    // a default empty first row.
    var arrData = [[]];

    // Create an array to hold our individual pattern
    // matching groups.
    var arrMatches = null;


    // Keep looping over the regular expression matches
    // until we can no longer find a match.
    while (arrMatches = objPattern.exec( strData )){

        // Get the delimiter that was found.
        var strMatchedDelimiter = arrMatches[ 1 ];

        // Check to see if the given delimiter has a length
        // (is not the start of string) and if it matches
        // field delimiter. If id does not, then we know
        // that this delimiter is a row delimiter.
        if (
        	strMatchedDelimiter.length &&
        	strMatchedDelimiter !== strDelimiter
        	){

            // Since we have reached a new row of data,
            // add an empty row to our data array.
            arrData.push( [] );

        }

        var strMatchedValue;

        // Now that we have our delimiter out of the way,
        // let's check to see which kind of value we
        // captured (quoted or unquoted).
        if (arrMatches[ 2 ]){

            // We found a quoted value. When we capture
            // this value, unescape any double quotes.
            strMatchedValue = arrMatches[ 2 ].replace(
            	new RegExp( "\"\"", "g" ),
            	"\""
            	);

        } else {

            // We found a non-quoted value.
            strMatchedValue = arrMatches[ 3 ];

        }


        // Now that we have our value string, let's add
        // it to the data array.
        arrData[ arrData.length - 1 ].push( strMatchedValue );
    }

    // Return the parsed data.
    return( arrData );
}
