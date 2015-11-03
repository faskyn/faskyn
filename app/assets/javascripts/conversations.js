var ready = function () {
	var chatbox = $(".chatboxcontent");
	if (chatbox.length){
		chatbox.scrollTop(chatbox[0].scrollHeight);
	};
};

$(document).ready(ready);
$(document).on("page:load", ready);