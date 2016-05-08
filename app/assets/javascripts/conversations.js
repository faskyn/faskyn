//submitting chat message
$(document).on("page:change", function() {

  //one page change chat gonna show the last message
  var chatbox = $('[data-behavior="message-insert"]');
    if (chatbox.length){
      chatbox.scrollTop(chatbox[0].scrollHeight);
    };
});

//chat message sending
$(document).on('keydown', '[data-behavior="new-message-body"]', function (event) {
  //var id = $(this).data('cid');
  checkMessageInputKey(event, $(this));
});

function checkMessageInputKey(event, message_body_text_area) {
  if (event.keyCode == 13 && event.shiftKey == 0) {

    event.preventDefault();

    //checking if field is empty and submitting the form
    message = message_body_text_area.val();
    message = message.replace(/^\s+|\s+$/g, "");
    if (message != '') {
      //$('#conversation_form_' + conversation_id).submit();
      $('[data-behavior="new-message-body-form"]').submit();
    }
  }

  var adjustedHeight = message_body_text_area.clientHeight;
  var maxHeight = 94;

  if (maxHeight > adjustedHeight) {
      adjustedHeight = Math.max(message_body_text_area.scrollHeight, adjustedHeight);
      if (maxHeight)
          adjustedHeight = Math.min(maxHeight, adjustedHeight);
      if (adjustedHeight > message_body_text_area.clientHeight)
          $(message_body_text_area).css('height', adjustedHeight + 8 + 'px');
  } else {
      $(message_body_text_area).css('overflow', 'auto');
  }
};

function chatMessageSender (sender_id, message_rendered) {
  var chatbox = $('[data-behavior="message-insert"]');
  var receiver_id = $('#body-current-user').data('currentuserid');

  if (event.handled !== true) {
    chatbox.append(message_rendered);
    chatbox.scrollTop(chatbox[0].scrollHeight);
    
    $('[data-behavior="new-message-body"]').val("");
    $('[data-behavior="new-message-body"]').focus();
    $('[data-behavior="new-message-body"]').css('height', '44px');
    var timeField = (message_rendered).find('[data-behavior="chat-time"]');
    var nameField = (message_rendered).find('[data-behavior="chat-name"]');
    var createdAt = timeField.data('datetime');
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