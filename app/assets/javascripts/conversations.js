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
  var id = $(this).data('cid');
  checkMessageInputKey(event, $(this), id);
});

function checkMessageInputKey(event, chatboxtextarea, conversation_id) {
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

function chatMessageSender (sender_id, message_rendered) {
  var chatbox = $(".chatboxcontent");
  var receiver_id = $('#bodycurrentuser').data('currentuserid');

  if (event.handled !== true) {
    chatbox.append(message_rendered);
    chatbox.scrollTop(chatbox[0].scrollHeight);
    
    $(".chatboxtextarea").val("");
    $(".chatboxtextarea").focus();
    $(".chatboxtextarea").css('height', '44px');
    var timeField = (message_rendered).find('.timefield');
    var nameField = (message_rendered).find('#chatname');
    var createdAt = timeField.attr('datetime');
    var momentCreatedAt = moment(createdAt).format('hh:mm A');
    timeField.remove();
    $( "<span class='newtime'>" + " • " + momentCreatedAt + "</span>" ).insertAfter(nameField);

    if(sender_id != receiver_id) {
      chatbox.children().last().removeClass("self").addClass("other");
      chatbox.scrollTop(chatbox[0].scrollHeight);
    }
    event.handled = true;
  }
};