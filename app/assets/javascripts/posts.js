$(document).on("page:change", function() {

  // Activating Best In Place
  jQuery(".best_in_place").best_in_place();

	//disabling post form when text field is empty
  $('.btn-create-post').prop('disabled',true);

  //infinite scrolling
  if ($('#infinite-post-scrolling').size() > 0) {
    $(window).on('scroll', function() {
      $('#infinite-post-scrolling').hide();
      var more_posts_url;
      more_posts_url = $('#infinite-post-scrolling .pagination .next_page a').attr('href');
      if (more_posts_url && ($(window).scrollTop() > $(document).height() - $(window).height() - 60)) {
        $('.pagination').html('<img src="/assets/ajax-loader.gif" alt="Loading..." title="Loading..." />');
        $('#infinite-post-scrolling').show();
        $.getScript(more_posts_url);
      }
    });
  };   
});

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

function edit_post_hide_danger($container) {
  $container.find('.updatepost').on('hidden.bs.modal', function (e) {
    $('.alert-danger').hide();
  });
};