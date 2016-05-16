$(document).on("page:change", function() {

  // Activating Best In Place
  $(".best_in_place").best_in_place();

  //in case of anchor automatically open the replies
  if (window.location.hash.length > 0) {
    showAnchorComments();
  };
});

//on clicking notification that takes to the post the comments/replies get shown
function showAnchorComments() {
  var commentable_id = window.location.hash.substr(1);
  var all_replies = $('#' + commentable_id).find('[data-behavior="comment-replies"]:has([data-behavior="comment-reply"])');
  all_replies.show();
  $('#' + commentable_id).find('[data-behavior="open-all-comments-row"]').hide();
};

//showing edit/delete buttons on hover for comments
$(document).on('mouseenter', '[data-behavior="comment-body"]', function() {
  if ($(this).closest('[data-behavior="comment"]').data('commentauthorid') == $('#body-current-user').data('currentuserid')) {
    $(this).find('[data-behavior="comment-editing-deleting"]').removeClass('hidden');
  };
}).on('mouseleave', '[data-behavior="comment-body"]', function() {
  $(this).find('[data-behavior="comment-editing-deleting"]').addClass('hidden');
});

//showing edit/delete buttons on hover for replies
$(document).on('mouseenter', '[data-behavior="comment-reply-body"]', function() {
  if ($(this).closest('[data-behavior="comment-reply"]').data('replyauthorid') == $('#body-current-user').data('currentuserid')) {
    $(this).find('[data-behavior="comment-reply-editing-deleting"]').removeClass('hidden');
  };
}).on('mouseleave', '[data-behavior="comment-reply-body"]', function() {
  $(this).find('[data-behavior="comment-reply-editing-deleting"]').addClass('hidden');
});

//checking comment text creation
$(document).on('keydown', '[data-behavior="comment-text-area"]', function (event) {
  if (event.keyCode == 13 && event.shiftKey == 0) {
    event.preventDefault();
    var commentable_id = $(this).data('commentableid');
    comment = $(this).val();
    comment = comment.replace(/^\s+|\s+$/g, "");
    if (comment != '') {
      $('#comment-form-' + commentable_id).submit();
      // $(this).closest('[data-behavior="post-comment-form"]').submit();
    };
  };
});

//open hidden comments and replies in post thread
$(document).on('click', '[data-behavior="open-all-comments"]', function (event) {
  var commentable_id = $(this).data('commentableid');
  var all_replies = $('[data-behavior="commentable_' + commentable_id + '"]').find('[data-behavior="comment-replies"]:has([data-behavior="comment-reply"])');
  all_replies.toggle();
  $(this).text(function(i, text){
      return text === "Show all" ? "Hide all" : "Show all";
  });
  //$(this).closest('[data-behavior="open-all-comments-row"]').hide();
});

//open comment replies for a certain comment
$(document).on('click', '[data-behavior="open-comment-reply"]', function (event) {
  var comment_id = $(this).data('cid');
  $('#comment-replies-' + comment_id).toggle();
});

//checking comment text reply creation (submitted via enter)
$(document).on('keydown', '[data-behavior="comment-reply-text-area"]', function (event) {
  if (event.keyCode == 13 && event.shiftKey == 0) {
    event.preventDefault();
    var comment_id = $(this).data('cid');
    reply = $(this).val();
    reply = reply.replace(/^\s+|\s+$/g, "");
    if (reply != '') {
      $('#comment-reply-form-' + comment_id).submit();
    };
  };
});




