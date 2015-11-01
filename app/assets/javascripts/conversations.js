var ready = function () {
	var chatbox = $(".chatboxcontent");
	chatbox.scrollTop(chatbox[0].scrollHeight);
};

$(document).ready(ready);
$(document).on("page:load", ready);