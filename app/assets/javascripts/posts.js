$(document).on("page:change", function() {

  // Activating Best In Place
  $(".best_in_place").best_in_place();

	//disabling post form when text field is empty
  $('[data-behavior="new-post-submit"]').prop('disabled',true);

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

  //in case of anchor automatically open the replies
  if (window.location.hash.length > 0) {
    showPostAnchorComments();
  };

  //showing edit/delete dropdowns to author
  if ($('.post-container').length > 0) {
    collectionPostEditDropdown();  
  };
});

//////////////////////////////////////////////////////////

//POST IMAGE MANIPULATING

//showing image preview for create action
$(document).on('change', '[data-behavior="post-image-upload"]', function() {
  $('[data-behavior="img-prev"]').removeClass('hidden');
  $('[data-behavior="remove-post-preview"]').removeClass('hidden');
  readPostURL(this);
});

//showing image preview for update action
$(document).on('change', '[data-behavior="post-image-upload-update"]', function() {
  $('[data-behavior="img-prev-update"]').removeClass('hidden');
  $('[data-behavior="remove-post-preview-update"]').removeClass('hidden');
  readUpdatePostURL(this);
});

//removing preview from create action
$(document).on('click', '[data-behavior="remove-post-preview"]', function() {
  $('[data-behavior="img-prev"]').attr('src', '#');
  $('[data-behavior="img-prev"]').addClass('hidden');
  $('[data-behavior="remove-post-preview"]').addClass('hidden');
  $('[data-behavior="post-image-upload"]').val("");
});

//removing preview from update action
$(document).on('click', '[data-behavior="remove-post-preview-update"]', function() {
  $('[data-behavior="img-prev-update"]').attr('src', '#');
  $('[data-behavior="img-prev-update"]').addClass('hidden');
  $(this).addClass('hidden');
  $('[data-behavior="old-post-image"]').removeClass('hidden');
  $('[data-behavior="post-image-upload-update"]').val("");
});

//POST, COMMENT AND REPLY VALIDATION/CREATION

//showing edit/delete buttons on hover for comments
$(document).on('mouseenter', '[data-behavior="post-comment-body"]', function() {
  if ($(this).closest('[data-behavior="post-comment"]').data('commentauthorid') == $('#body-current-user').data('currentuserid')) {
    $(this).find('[data-behavior="post-comment-editing-deleting"]').removeClass('hidden');
  };
}).on('mouseleave', '[data-behavior="post-comment-body"]', function() {
  $(this).find('[data-behavior="post-comment-editing-deleting"]').addClass('hidden');
});

//showing edit/delete buttons on hover for replies
$(document).on('mouseenter', '[data-behavior="post-comment-reply-body"]', function() {
  if ($(this).closest('[data-behavior="post-comment-reply"]').data('replyauthorid') == $('#body-current-user').data('currentuserid')) {
    $(this).find('[data-behavior="post-comment-reply-editing-deleting"]').removeClass('hidden');
  };
}).on('mouseleave', '[data-behavior="post-comment-reply-body"]', function() {
  $(this).find('[data-behavior="post-comment-reply-editing-deleting"]').addClass('hidden');
});

//enabling post creation when text area is not empty (shared via button)
$(document).on('keyup', '[data-behavior="post-create-body"]', function() {
	if($(this).val().length !=0){
    $('[data-behavior="new-post-submit"]').attr('disabled', false);            
	}
  else {
    $('[data-behavior="new-post-submit"]').attr('disabled',true);  
  }
});

//checking comment text creation
$(document).on('keydown', '[data-behavior="post-comment-text-area"]', function (event) {
  if (event.keyCode == 13 && event.shiftKey == 0) {
    event.preventDefault();
    var post_id = $(this).data('pid');
    comment = $(this).val();
    comment = comment.replace(/^\s+|\s+$/g, "");
    if (comment != '') {
      $('#post-comment-form-' + post_id).submit();
      // $(this).closest('[data-behavior="post-comment-form"]').submit();
    };
  };
});

//checking comment text reply creation (submitted via enter)
$(document).on('keydown', '[data-behavior="post-comment-reply-text-area"]', function (event) {
  if (event.keyCode == 13 && event.shiftKey == 0) {
    event.preventDefault();
    var post_comment_id = $(this).data('pcid');
    reply = $(this).val();
    reply = reply.replace(/^\s+|\s+$/g, "");
    if (reply != '') {
      $('#post-comment-reply-form-' + post_comment_id).submit();
    };
  };
});


//open hidden post comments and replies in post thread
$(document).on('click', '[data-behavior="open-all-post-comments"]', function (event) {
  var post_id = $(this).data('pid');
  var all_replies = $('#post_' + post_id).find('[data-behavior="post-comment-replies"]:has([data-behavior="post-comment-reply"])');
  all_replies.show();
  $(this).closest('[data-behavior="open-all-post-comments-row"]').hide();
});

//open comment replies for a certain comment
$(document).on('click', '[data-behavior="open-post-comment-reply"]', function (event) {
  var post_comment_id = $(this).data('pcid');
  $('#post-comment-replies-' + post_comment_id).toggle();
});

//SHOW EDIT AND DELETE POST VIA AJAX

//showing post image modal via show action
$(document).on('click', '[data-behavior="post-image"]', function (event) {
  $('[data-behavior="post-image-insert"]').html("<div style='text-align:center'><i class='fa fa-circle-o-notch fa-2x fa-spin' style='color:#5E5E5E'></i></div>");
  var href = $(this).data("postlink");
  $.ajax({
    type: "GET",
    url: href,
    dataType: "script"
  });
});


//editing post in modal
$(document).on('click', '[data-behavior="open-edit-post-modal"]', function (event) {
  $('[data-behavior="post-edit-form-insert"]').html("<div style='text-align:center'><i class='fa fa-circle-o-notch fa-2x fa-spin' style='color:#5E5E5E'></i></div>");
  var href = $(this).data("posteditlink");
  $.ajax({
    type: "GET",
    url: href,
    dataType: "script"
  });
});

//deleting post via modal
$(document).on('click', '[data-behavior="open-delete-post-modal"]', function (event) {
  var postDeleteLink = $(this).data("postdeletelink");
  $('[data-behavior="delete-post-submit"]').data("postdestroylink", postDeleteLink);
});

$(document).on('click', '[data-behavior="delete-post-submit"]', function (event) {
  var href = $(this).data("postdestroylink");
  $.ajax({
    type: "DELETE",
    url: href,
    dataType: "script"
  });
});

//FUNCTIONS

//image preview for new post
function readPostURL(input) {
  if (input.files && input.files[0]) {
    var reader = new FileReader();
    reader.onload = function (e) {
      $('[data-behavior="img-prev"]').attr('src', e.target.result);
    }
    reader.readAsDataURL(input.files[0]);
  }
};

//image preview for edited post
function readUpdatePostURL(input) {
  if (input.files && input.files[0]) {
    var reader = new FileReader();
    reader.onload = function (e) {
      $('[data-behavior="img-prev-update"]').attr('src', e.target.result);
      $('[data-behavior="old-post-image"]').addClass('hidden');
    }
    reader.readAsDataURL(input.files[0]);
  }
};

//hiding post errors on closing edit post modal
function editPostHideDanger($container) {
  $container.find('#update-post-modal').on('hidden.bs.modal', function (e) {
    $('.alert-danger').hide();
  });
};

//on clicking notification that takes to the post the comments/replies get shown
function showPostAnchorComments() {
  var post_id = window.location.hash.substr(1);
  var all_replies = $('#' + post_id).find('[data-behavior="post-comment-replies"]:has([data-behavior="post-comment-reply"])');
  all_replies.show();
  $('#' + post_id).find('[data-behavior="open-all-post-comments-row"]').hide();
};

//showing edit/delete dropdown on a certain post to author (important for caching)
function showPostEditDropdown($container) {
  if ($container.find('[data-behavior="edit-post-dropdown-button"]').data('postauthorid') == $('#body-current-user').data('currentuserid')) {
    $container.find('[data-behavior="edit-post-dropdown-button"]').removeClass('hidden');
  };
};

//iterating thru the posts and showing edit/delete dropdown to author (important for caching)
function collectionPostEditDropdown() {
  $('[data-behavior="edit-post-dropdown-button"]').each(function(index) {
    if ($(this).data('postauthorid') == $('#body-current-user').data('currentuserid')) {
      $(this).removeClass('hidden');
    };
  });
};






