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

function appendKNNEvent() {
    var form = document.forms["search-form"];
    var algoNode = form["algorithm"];

    algoNode.addEventListener("change", function(e) {
        form["knn_nb_neighbours"].disabled = !(algoNode.value == "KNN");
    }, false);
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
    appendKNNEvent();
})();