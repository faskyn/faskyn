$(document).on("page:change", function() {
	
	//making collection select act as if command button always were held down
	$('#product_industry_ids').each(function(){
		var select = $(this), values = {};    
    $('option',select).each(function(i, option){
      values[option.value] = option.selected;        
    }).click(function(event){        
      values[this.value] = !values[this.value];
      $('option',select).each(function(i, option){            
          option.selected = values[option.value];        
      });    
    });
	});

  //infinite scrolling for products based on pagination gem
  if ($('#infinite-product-scrolling').size() > 0) {
    $(window).on('scroll', function() {
      $('#infinite-product-scrolling').hide();
      var more_products_url;
      more_products_url = $('#infinite-product-scrolling .pagination .next_page a').attr('href');
      if (more_products_url && $(window).scrollTop() > $(document).height() - $(window).height() - 60) {
        $('.pagination').html("<i class='fa fa-circle-o-notch fa-2x fa-spin'></i>");
        $('#infinite-product-scrolling').show();
        $.getScript(more_products_url);
      }
    });
  };

  //showing edit/delete button to owner
  if ($('.product-show-container').length > 0) {
    showProductEditDeleteButtons();
  };

  //cocoon gem inserting behavior
  $(".customer-well a.add_fields").data("association-insertion-method", 'prepend').data("association-insertion-node", '.customer-fields');
  $(".lead-well a.add_fields").data("association-insertion-method", 'prepend').data("association-insertion-node", '.lead-fields');

});

function showProductEditDeleteButtons() {
  if ($('.product-show-container').find('[data-behavior="edit-delete-product-buttons"]').data("product-owner-id") == $('#body-current-user').data('currentuserid')) {
    $('.product-show-container').find('[data-behavior="edit-delete-product-buttons"]').removeClass('hidden');
  };
};

//deleting product user via modal
$(document).on('click', '[data-behavior="open-delete-product-user-modal"]', function (event) {
  var productUserDeleteLink = $(this).data("productuserdeletelink");
  $('[data-behavior="delete-product-user-submit"]').attr("href", productUserDeleteLink);
});

//deleting product invitation via modal
$(document).on('click', '[data-behavior="open-delete-product-invitation-modal"]', function (event) {
  var productInvitationDeleteLink = $(this).data("productinvitationdeletelink");
  $('[data-behavior="delete-product-invitation-submit"]').attr("href", productInvitationDeleteLink);
});

//deleting group invitation via modal
$(document).on('click', '[data-behavior="open-delete-group-invitation-modal"]', function (event) {
  var groupInvitationDeleteLink = $(this).data("groupinvitationdeletelink");
  $('[data-behavior="delete-group-invitation-submit"]').attr("href", groupInvitationDeleteLink);
});

//deleting product customer user via modal
$(document).on('click', '[data-behavior="open-delete-product-customer-user-modal"]', function (event) {
  var productCustomerUserDeleteLink = $(this).data("productcustomeruserdeletelink");
  $('[data-behavior="delete-product-customer-user-submit"]').attr("href", productCustomerUserDeleteLink);
});

$(document).on('change', '#product-customer-collection-select', function () {
  var newRouteId = $(this).val();
  var newActionURL = "/product_customers/" + newRouteId + "/group_invitations";
  $(this).closest("form").attr("action", newActionURL);
});

//character counter for product oneliner
$(document).on('keyup', '[data-behavior="oneliner-text-area"]', function (event) {
  var textLength = $(this).val().length;
  var textLengthLimit = 140;
  $('[data-behavior="oneliner-counter"]').html(textLengthLimit - textLength);
  if ((textLengthLimit - textLength) < 0) {
    $('[data-behavior="oneliner-counter').addClass('oneliner-description-count-warning');
  } else {
    $('[data-behavior="oneliner-counter').removeClass('oneliner-description-count-warning');
  };
});

$(document).on('focusout', '[data-behavior="oneliner-text-area"]', function (event) {
  var textLength = $(this).val().length;
  var textLengthLimit = 140;
  if ((textLengthLimit - textLength) >= 0) {
    $('[data-behavior="oneliner-counter"]').html("");
  };
});

//character counter for product description
$(document).on('keyup', '[data-behavior="description-text-area"]', function (event) {
  var textLength = $(this).val().length;
  var textLengthLimit = 500;
  $('[data-behavior="description-counter"]').html(textLengthLimit - textLength);
  if ((textLengthLimit - textLength) < 0) {
    $('[data-behavior="description-counter').addClass('oneliner-description-count-warning');
  } else {
    $('[data-behavior="description-counter').removeClass('oneliner-description-count-warning');
  };
});

$(document).on('focusout', '[data-behavior="description-text-area"]', function (event) {
  var textLength = $(this).val().length;
  var textLengthLimit = 500;
  if ((textLengthLimit - textLength) >= 0) {
    $('[data-behavior="description-counter"]').html("");
  };
});

//showing explanation when field is active
// $(document).on('focus', '.form-group', function (event) {
//   if ($('.product-form').length > 0) {
//     $(this).find('.explanation').show();
//   };
// });

// $(document).on('focusout', '.form-group', function (event) {
//   if ($('.product-form').length > 0) {
//     $(this).find('.explanation').hide();
//   };
// });


