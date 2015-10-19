function appendSubmitEvent() {
    var form = document.getElementById("search-form");
    //form.action = fetchTweets();
    form.onsubmit = function(e) {
        fetchTweets();
        return false;
    };
    console.log("Appended submit event");
}

(function() {
    appendSubmitEvent();
})();