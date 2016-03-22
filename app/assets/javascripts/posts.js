$(document).on("page:change", function() {

  // Activating Best In Place
  $(".best_in_place").best_in_place();

	//disabling post form when text field is empty
  $('.btn-create-post').prop('disabled',true);

  //infinite scrolling
  if ($('#infinite-post-scrolling').size() > 0) {
    $(window).on('scroll', function() {
      $('#infinite-post-scrolling').hide();
      var more_posts_url;
      more_posts_url = $('#infinite-post-scrolling .pagination .next_page a').attr('href');
      if (more_posts_url && ($(window).scrollTop() > $(document).height() - $(window).height() - 60)) {
        $('.pagination').html("<i class='fa fa-circle-o-notch fa-2x fa-spin'></i>");
        $('#infinite-post-scrolling').show();
        $.getScript(more_posts_url);
      }
    });
  };

  if (window.location.hash.length > 0) {
    showPostAnchorComments();
  };
});

//////////////////////////////////////////////////////////

$(document).on('keyup', '.post-create-body', function() {
	if($(this).val().length !=0){
    $('.btn-create-post').attr('disabled', false);            
	}
  else {
    $('.btn-create-post').attr('disabled',true);  
  }
});

$(document).on('keydown', '.post-comment-text-area', function (event) {
  var post_id = $(this).data('pid');
  checkPostCommentInputKey(event, $(this), post_id);
});

$(document).on('click', '.open-all-post-comments', function (event) {
  var post_id = $(this).data('pid');
  var all_replies = $('#post_' + post_id).find('.post-comment-replies:has(.post-comment-reply)');
  all_replies.show();
  $(this).closest('.open-all-post-comments-row').hide();
});

$(document).on('click', '.open-post-comment-reply', function (event) {
  var post_comment_id = $(this).data('pcid');
  $('#post-comment-replies-' + post_comment_id).toggle();
});

function checkPostCommentInputKey(event, commenttextarea, post_id) {
  if (event.keyCode == 13 && event.shiftKey == 0) {
    event.preventDefault();
    comment = commenttextarea.val();
    comment = comment.replace(/^\s+|\s+$/g, "");
    if (comment != '') {
      $('#post-comment-form-' + post_id).submit();
    }
  }
};

function editPostHideDanger($container) {
  $container.find('.updatepost').on('hidden.bs.modal', function (e) {
    $('.alert-danger').hide();
  });
};

function showPostAnchorComments() {
  var post_id = window.location.hash.substr(1);
  var all_replies = $('#' + post_id).find('.post-comment-replies:has(.post-comment-reply)');
  all_replies.show();
  $('#' + post_id).find('.open-all-post-comments-row').hide();
};