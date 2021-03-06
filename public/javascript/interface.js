function createTweetElement(tweet, id) {
    var tweetNode = document.createElement("li"),
        pNode = document.createElement("p"),
        notationNode = document.createElement("p"),
        authorNode = document.createElement("strong");

    var textNode = document.createTextNode(tweet.text),
        authorTextNode = document.createTextNode(tweet.author + ": ");

    // Generate option list for the tweet (manual annotation)
    var array = [
        "Positive",
        "Neutral",
        "Negative"
    ];

    var notationList = document.createElement("select");
    for (var i = 0; i < array.length; i++) {
        var option = document.createElement("option");
        option.value = array[i];
        option.text = array[i];
        notationList.appendChild(option);
    }

    switch(tweet.notation) {
        case 0:
            notationList.selectedIndex = "2";
            tweetNode.className = "tweet_bad";
            break;
        case 2:
            notationList.selectedIndex = "1";
            tweetNode.className = "tweet_neutral";
            break;
        case 4:
            notationList.selectedIndex = "0";
            tweetNode.className = "tweet_good";
            break;
    }

    authorNode.appendChild(authorTextNode);
    pNode.appendChild(authorNode);
    pNode.appendChild(textNode);
    notationNode.appendChild(notationList);
    tweetNode.appendChild(pNode);
    tweetNode.appendChild(notationNode);

    notationList.addEventListener('change', function() {
        notationChange(tweetNode, id);
    }, false);

    return tweetNode;
}

function notationChange(tweetNode, id) {
    var notationList = tweetNode.getElementsByTagName("select")[0];
    var notation = notationList.options[notationList.selectedIndex].value

    switch(tweets[id].notation) {
    case 4:
        good--;
        break;
    case 2:
        neutral--;
        break;
    case 0:
        bad--;
        break;
    }

    switch(notation) {
    case "Positive":
        tweetNode.className = "tweet_good";
        tweets[id].notation = 4;
        good++;
        break;
    case "Neutral":
        tweetNode.className = "tweet_neutral";
        tweets[id].notation = 2;
        neutral++;
        break;
    case "Negative":
        tweetNode.className = "tweet_bad";
        tweets[id].notation = 0;
        bad++;
        break;
    }

    updateFeelings(good, neutral, bad);
}

function saveNotification() {
    var notifications = document.getElementById("notifications");
    // Clean node
    while (notifications.lastChild) {
        notifications.removeChild(notifications.lastChild);
    }
    var notification = document.createElement("p");
    var textNode = document.createTextNode("You can now correct all annotations. The verified tweets will be used as a base.");
    var button = document.createElement("button");
    var textButtonNode = document.createTextNode("Save");
    button.id = "button_save";

    button.addEventListener('click', function() {
        //hideNotifications();
        annotateTweetsManually();
        //removeManualAnnotationNodes();
    }, false);

    button.appendChild(textButtonNode);
    notification.appendChild(textNode);
    notification.appendChild(button);
    notifications.appendChild(notification);

    showNode("notifications", true);
}

/*
 * Removes all manual annotation nodes.
 */
function removeManualAnnotationNodes() {
    var tweetListNode = document.getElementById("tweet-list");
    var tweetLiNodes = tweetListNode.getElementsByTagName("li");

    for (var i = 0; i < tweetLiNodes.length; i++) {
        var selectNode = tweetLiNodes[i].getElementsByTagName("select")[0];
        selectNode.parentNode.removeChild(selectNode);
    };
}

function saveConfirmationNotification() {
    var confirmations = document.getElementById("confirmations");

    if(!document.getElementById("confirmation")) {
        var confirmation = document.createElement("p");
        confirmation.id = "confirmation";
        var textNode = document.createTextNode("Tweets Saved.");
        confirmation.appendChild(textNode);
        confirmations.appendChild(confirmation);
    } else {
        var confirmation = document.getElementById("confirmation");
    }

    switch(confirmation.style.borderColor) {
        case "green":
            confirmation.style.borderColor = "blue";
            break;
        case "blue":
            confirmation.style.borderColor = "green";
            break;
        default:
            confirmation.style.borderColor = "green";
            break;
    }

    showNode("confirmations", true);
}

function addNotification(text) {
    var notifications = document.getElementById("notifications");
    // Clean node
    while (notifications.lastChild) {
        notifications.removeChild(notifications.lastChild);
    }
    var notification = document.createElement("p");
    var textNode = document.createTextNode(text);

    notification.appendChild(textNode);
    notifications.appendChild(notification);

    showNode("notifications", true);
}

function hideNotifications() {
    notificationsNode = document.getElementById("notifications");
    notificationsNode.className = "invisible";
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
function displayError(message) {
    var errorNode = document.getElementById("error");
    var pNode = errorNode.getElementsByTagName("p")[0];
    pNode.removeChild(pNode.childNodes[0]);
    var textNode = document.createTextNode(message);
    pNode.appendChild(textNode);
    errorNode.className = "";
}

function hideError() {
    errorNode = document.getElementById("error");
    errorNode.className = "invisible";
}

function showNode(name, invisible) {
    node = document.getElementById(name);
    if(invisible) {
        node.className = "";
    } else {
        node.className = "invisible";
    }
}

function updateFeelings(good, neutral, bad) {
    var statsNode = document.getElementById("stats");
    var feelingsBar = document.getElementById("feelings-bar");
    var goodBar = document.getElementById("good");
    var neutralBar = document.getElementById("neutral");
    var badBar = document.getElementById("bad");
    var smileyImg = document.getElementById("smiley").getElementsByTagName("img")[0];
    var goodScore = document.getElementById("good_score");
    var neutralScore = document.getElementById("neutral_score");
    var badScore = document.getElementById("bad_score");

    var total = (good + neutral + bad);
    var goodRate = good * 100 / total;
    var neutralRate = neutral * 100 / total;
    var badRate = bad * 100 / total;

    goodBar.style.width = goodRate + "%";
    neutralBar.style.width = neutralRate + "%";
    badBar.style.width = badRate + "%";

    updateScoreNode(goodScore, goodRate);
    updateScoreNode(neutralScore, neutralRate);
    updateScoreNode(badScore, badRate);

    var score = goodRate - badRate;
    if(score > 0) {
        smileyImg.src = 'resources/happy.png';
    }
    else if (score < 0) {
        smileyImg.src = 'resources/angry.png';
    } 
    else {
        smileyImg.src = 'resources/neutral.png';
    }

    statsNode.className = "";
}

/*
 * Update the score node by cleaning and writing the new node.
 * node: the score node to update
 * score: the score value
 */
function updateScoreNode(node, rate) {
    // Clean node
    while (node.lastChild) {
        node.removeChild(node.lastChild);
    }

    var textNode = document.createTextNode(Math.round(rate) + "%");
    node.appendChild(textNode);
}

/*
 * Updates the tweet list.
 * tweets: the list of all tweets to display
 */
function updateTweetList(tweets) {
    var emptyNode = document.getElementById("empty");
    emptyNode.className = "invisible";

    var tweetListNode = document.getElementById("tweet-list");
    while (tweetListNode.lastChild) {
        tweetListNode.removeChild(tweetListNode.lastChild);
    }

    for (var i = 0; i < tweets.length; i++) {
        tweetNode = createTweetElement(tweets[i], i);
        tweetListNode.appendChild(tweetNode);
    };
}

function log(text) {
    var console = document.getElementById("console");
    var message = document.createElement("p");
    message.className = "message";
    message.innerHTML = text;
    console.appendChild(message);
    console.scrollTop = console.scrollHeight;
}
