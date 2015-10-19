function appendSubmitEvent() {
    var form = document.getElementById("search-form");
    /*form.addEventListener("submit", function(e) {
        fetchTweets();
    }, false);*/
    form.action = fetchTweets();
    alert("added event bitch");
}

(function() {
    appendSubmitEvent();
});