//submitting chat message
$(document).on("page:change", function() {

  //one page change chat gonna show the last message
  var chatbox = $(".chatboxcontent");
    if (chatbox.length){
      chatbox.scrollTop(chatbox[0].scrollHeight);
    };
});

//chat message sending
$(document).on('keydown', '.chatboxtextarea', function (event) {
  //var cab = document.getElementsByClassName('chatboxtextarea')[0]; 
  //cab.addEventListener("click", checkInputKey, false);
  var id = $(this).data('cid');
  checkInputKey(event, $(this), id);
});

function checkInputKey(event, chatboxtextarea, conversation_id) {
  if (event.keyCode == 13 && event.shiftKey == 0) {

    event.preventDefault();

    //checking if field is empty and submitting the form
    message = chatboxtextarea.val();
    message = message.replace(/^\s+|\s+$/g, "");
    if (message != '') {
      $('#conversation_form_' + conversation_id).submit();
    }
  }

  var adjustedHeight = chatboxtextarea.clientHeight;
  var maxHeight = 94;

  if (maxHeight > adjustedHeight) {
      adjustedHeight = Math.max(chatboxtextarea.scrollHeight, adjustedHeight);
      if (maxHeight)
          adjustedHeight = Math.min(maxHeight, adjustedHeight);
      if (adjustedHeight > chatboxtextarea.clientHeight)
          $(chatboxtextarea).css('height', adjustedHeight + 8 + 'px');
  } else {
      $(chatboxtextarea).css('overflow', 'auto');
  }
};