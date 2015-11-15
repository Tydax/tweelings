function createTweetElement(tweet) {
    var tweetNode = document.createElement("li"),
        pNode = document.createElement("p"),
        authorNode = document.createElement("strong");

    var textNode = document.createTextNode(tweet.text),
        authorTextNode = document.createTextNode(tweet.author);

    authorNode.appendChild(authorTextNode);
    pNode.appendChild(authorNode);
    pNode.appendChild(textNode);
    tweetNode.appendChild(pNode);

    return tweetNode;
}

/*
 * Locks or unlocks the search form.
 * locked: "true" locks the form;
 *         "false" unlocks it.
 */
function lockForm(locked) {
    var form = document.getElementById("search-form");
    var theme = document.getElementById("search-form-theme");
    theme.disabled = locked;
}

/*
 * Displays the error block with the specified message.
 *
 * message: the message to display.
 */
function displayError(code, message) {
    var errorNode = document.getElementById("error");
    var pNode = errorNode.getElementsByTagName("p")[0];
    pNode.removeChild(pNode.childNodes[0]);
    var textNode = document.createTextNode(message);
    pNode.appendChild(textNode);
    errorNode.className = "bloc";
}

function hideError() {
    errorNode.className += " invisible";
}

function updateFeelings(good, bad) {
    var feelingsBar = document.getElementById("feelings-bar");
    var goodBar = document.getElementById("good");
    var badBar = document.getElementById("bad");
    var smileyImg = document.getElementById("smiley").getElementsByTagName("img")[0];

    var goodRate = good * 100 / (good + bad);
    var badRate = bad * 100 / (good + bad);

    goodBar.style.width = goodRate + "%";
    goodBar.innerHTML  = Math.round(goodRate) + "%";
    badBar.style.width = badRate + "%";
    badBar.innerHTML  = Math.round(badRate) + "%";

    if(goodRate > 55) {
        smileyImg.src = 'resources/happy.png';
    }
    else if (goodRate < 45) {
        smileyImg.src = 'resources/angry.png';
    } 
    else {
        smileyImg.src = 'resources/neutral.png';
    }
}

function updateVisible(invisible) {
    var emptyNode = document.getElementById("empty");
    var statsNode = document.getElementById("stats");
    if (invisible) {
        emptyNode.className += " invisible";
        statsNode.className += " invisible";
    }
    else {
        emptyNode.className.replace(" invisible", "");
        statsNode.className.replace(" invisible", "");
    }
}

/*
 * Updates the tweet list.
 * tweets: the list of all tweets to display
 */
function updateTweetList(tweets) {
    var tweetListNode = document.getElementById("tweet-list");

    for (var i = 0; i < tweets.length; i++) {
        tweetNode = createTweetElement(tweets[i]);
        tweetListNode.appendChild(tweetNode);
    };
}