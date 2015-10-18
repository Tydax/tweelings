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

function updateEmpty(empty) {
	var emptyDiv = document.getElementById("empty");
	var statsDiv = document.getElementById("stats");
	if (empty) {
		emptyDiv.style.display = "block";
		statsDiv.style.display = "none";
	}
	else {
		emptyDiv.style.display = "none";
		statsDiv.style.display = "block";
	}
}