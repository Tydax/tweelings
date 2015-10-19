function appendSubmitEvent() {
	console.log("appendSubmitEvent()");
    var form = document.getElementById("search-form");
    //form.action = fetchTweets();
    form.addEventListener("submit", function(e) {
        fetchTweets();
    }, false);
}

appendSubmitEvent();
/*(function() {
    appendSubmitEvent();
});*/