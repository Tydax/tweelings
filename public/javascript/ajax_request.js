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
        var tweets = [];
        if (result.code == 0) {
            for (var i = 0; i < result.result.length; i++) {
                tweets.push(JSON.parse(result.result[i]));
            };
            console.log("Saved " + result.result.length + " tweets!");
            lockForm(false);
            updateTweetList(tweets);
            cleanTweets();
        }
    });
}

function cleanTweets() {
    sendRequest("GET", "/clean_tweets", null, function(response) {
        var result = JSON.parse(response);
        var tweets = [];
        if (result.code == 0) {
            for (var i = 0; i < result.result.length; i++) {
                tweets.push(JSON.parse(result.result[i]));
            };
            console.log("Cleaned " + result.result.length + " tweets!");
            lockForm(false);
            updateTweetList(tweets);
        }
    });
}
