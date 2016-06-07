$(document).on("page:change", function() {

  if ($('[data-behavior="review-insert"]').length > 0) {
    collectionReviewEditButton();  
    collectionReviewDeleteButton();
  };
});

$(document).on('click', '[data-behavior="review-editing"]', function (event) {
  $('[data-behavior="edit-review-form-insert"]').html("<div style='text-align:center'><i class='fa fa-circle-o-notch fa-2x fa-spin' style='color:#5E5E5E'></i></div>");
  var href = $(this).find('[data-behavior="open-update-review-modal"]').data('revieweditlink');
  $.ajax({
    type: "GET",
    url: href,
    dataType: "script"
  });
});

//deleting review via modal
$(document).on('click', '[data-behavior="open-delete-review-modal"]', function (event) {
  var reviewDeleteLink = $(this).data("reviewdeletelink");
  $('[data-behavior="delete-review-submit"]').data("reviewdestroylink", reviewDeleteLink);
});

$(document).on('click', '[data-behavior="delete-review-submit"]', function (event) {
  var href = $(this).data("reviewdestroylink");
  $.ajax({
    type: "DELETE",
    url: href,
    dataType: "script"
  });
});

function collectionReviewEditButton() {
  $('[data-behavior="review-editing"]').each(function(index) {
    if ($(this).data('reviewauthorid') == $('#body-current-user').data('currentuserid')) {
      $(this).removeClass('hidden');
    };
  });
};

function collectionReviewDeleteButton() {
  $('[data-behavior="review-deleting"]').each(function(index) {
    if ($(this).data('productcustomerownerid') == $('#body-current-user').data('currentuserid')) {
      $(this).removeClass('hidden');
    };
  });
};

//hiding post errors on closing edit post modal
function editReviewHideDanger($container) {
  $container.find('#update-review-modal').on('hidden.bs.modal', function (e) {
    $('.alert-danger').hide();
  });
};

//showing edit/delete sign on a certain post to author (important for caching)
function showReviewEditButton($container) {
  if ($container.find('[data-behavior="review-editing"]').data('reviewauthorid') == $('#body-current-user').data('currentuserid')) {
    $container.find('[data-behavior="review-editing"]').removeClass('hidden');
  };
};
