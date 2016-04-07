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

//POST IMAGE MANIPULATING

//showing image preview for create action
$(document).on('change', '#avatar-upload', function() {
  $('#img-prev').removeClass('hidden');
  $('.remove-post-preview').removeClass('hidden');
  readPostURL(this);
});

//showing image preview for update action
$(document).on('change', '#avatar-upload-update', function() {
  $('#img-prev-update').removeClass('hidden');
  $('.remove-post-preview-update').removeClass('hidden');
  readUpdatePostURL(this);
});

//removing preview from create action
$(document).on('click', '.remove-post-preview', function(){
  $('#img-prev').attr('src', '#');
  $('#img-prev').addClass('hidden');
  $('.remove-post-preview').addClass('hidden');
  $('#avatar-upload').val("");
});

//removing preview from update action
$(document).on('click', '.remove-post-preview-update', function(){
  $('#img-prev-update').attr('src', '#');
  $('#img-prev-update').addClass('hidden');
  $('.remove-post-preview-update').addClass('hidden');
  $('#old-post-image').removeClass('hidden');
  //alert($('.btn-message-file').data['originalimage']);
  //var resetToOriginal = $('.btn-message-file').data['originalimage'];
  $('#avatar-upload-update').val("");
});

//POST, COMMENT AND REPLY VALIDATION/CREATION

//enabling post creation when text area is not empty (shared via button)
$(document).on('keyup', '.post-create-body', function() {
	if($(this).val().length !=0){
    $('.btn-create-post').attr('disabled', false);            
	}
  else {
    $('.btn-create-post').attr('disabled',true);  
  }
});

//checking comment text creation (submitted via enter)
$(document).on('keydown', '.post-comment-text-area', function (event) {
  if (event.keyCode == 13 && event.shiftKey == 0) {
    event.preventDefault();
    var post_id = $(this).data('pid');
    comment = $(this).val();
    comment = comment.replace(/^\s+|\s+$/g, "");
    if (comment != '') {
      $('#post-comment-form-' + post_id).submit();
    };
  };
});

//checking comment text reply creation (submitted via enter)
$(document).on('keydown', '.post-comment-reply-text-area', function (event) {
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
$(document).on('click', '.open-all-post-comments', function (event) {
  var post_id = $(this).data('pid');
  var all_replies = $('#post_' + post_id).find('.post-comment-replies:has(.post-comment-reply)');
  all_replies.show();
  $(this).closest('.open-all-post-comments-row').hide();
});

//open comment replies for a certain comment
$(document).on('click', '.open-post-comment-reply', function (event) {
  var post_comment_id = $(this).data('pcid');
  $('#post-comment-replies-' + post_comment_id).toggle();
});

//SHOW EDIT AND DELETE POST VIA AJAX

//showing post image modal via show action
$(document).on('click', '.post-image', function (event) {
  $('#post-image-insert').html("<div style='text-align:center'><i class='fa fa-circle-o-notch fa-2x fa-spin' style='color:#5E5E5E'></i></div>");
  var href = $(this).data("postlink");
  $.ajax({
    type: "GET",
    url: href,
    dataType: "script"
  });
});


//editing post in modal
$(document).on('click', '.open-edit-post-modal', function (event) {
  $('#post-edit-form-insert').html("<div style='text-align:center'><i class='fa fa-circle-o-notch fa-2x fa-spin' style='color:#5E5E5E'></i></div>");
  var href = $(this).data("posteditlink");
  $.ajax({
    type: "GET",
    url: href,
    dataType: "script"
  });
});

//deleting post via modal
$(document).on('click', '.open-delete-post-modal', function (event) {
  var postDeleteLink = $(this).data("postdeletelink");
  $('#delete-post-link-insert').attr("data-postdestroylink", postDeleteLink);
});
$(document).on('click', '#delete-post-link-insert', function (event) {
  var href = $(this).data("postdestroylink");
  $.ajax({
    type: "DELETE",
    url: href,
    dataType: "script"
  });
});

//FUNCTIONS

function readPostURL(input) {
  if (input.files && input.files[0]) {
    var reader = new FileReader();
    reader.onload = function (e) {
      $('#img-prev').attr('src', e.target.result);
    }
    reader.readAsDataURL(input.files[0]);
  }
};

function readUpdatePostURL(input) {
  if (input.files && input.files[0]) {
    var reader = new FileReader();
    reader.onload = function (e) {
      $('#img-prev-update').attr('src', e.target.result);
      $('#old-post-image').addClass('hidden');
    }
    reader.readAsDataURL(input.files[0]);
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






