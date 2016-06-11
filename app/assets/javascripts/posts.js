$(document).on("page:change", function() {

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
    showAnchorComments();
  };

  //showing edit/delete dropdowns to author
  if ($('.post-container').length > 0) {
    collectionPostEditDropdown();  
  };
});

//////////////////////////////////////////////////////////

//POST FORM DISABLING WHEN THERE IS NO TEST

$(document).on('ajax:complete', '[data-behavior="new-post-creation-form"]', function(event, xhr, status) {
  alert("haha");
  $('[data-behavior="new-post-submit"]').attr('disabled',true);
});

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

//POST VALIDATION

//enabling post creation when text area is not empty (shared via button)
$(document).on('keyup', '[data-behavior="post-create-body"]', function() {
  if($(this).val().length !=0){
    $('[data-behavior="new-post-submit"]').attr('disabled', false);            
  }
  else {
    $('[data-behavior="new-post-submit"]').attr('disabled',true);  
  }
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

