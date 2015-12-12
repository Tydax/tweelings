function appendSubmitEvent() {
    var form = document.getElementById("search-form");
    form.onsubmit = function(e) {
    	if(check()) {
    		hideError();
        	fetchTweets();
    	} else {
    		displayError("The search field is empty.");
    	}
        return false;
    };
    console.log("Appended submit event");
}

function check() {
    var form = document.getElementById("search-form-theme");
    if(form.value) {
    	return true;
    } else {
    	return false;	
    }
}

(function() {
    appendSubmitEvent();
})();