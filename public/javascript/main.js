function appendSubmitEvent() {
    var form = document.getElementById("search-form");
    form.onsubmit = function(e) {
    	if(check()) {
    		hideError();
        	fetchTweets();
    	} else {
    		displayError("Hey! You should write something in the search field!");
    	}
        return false;
    };
}

function check() {
    var form = document.getElementById("search-form-theme");
    if (form.value) {
    	return true;
    } else {
    	return false;	
    }
}

(function() {
    appendSubmitEvent();
})();