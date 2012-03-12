

$(function() {
    $(".album_link").live("ajax:complete", function(et, e){
	$(this).find('div.preloader').fadeOut();
	$(this).addClass('loaded_album').next('.album').html(e.responseText); // insert content
	$(this).parents('.single_album').css({width : '100%'});
	$(this).removeAttr('data-remote').attr('href', "#");
    });
});

$('.album_link').live('click',function() {
    var album = $(this).parents('.single_album');
    if($(this).is('.loaded_album')) {
	$(this).find('.albums_featured_image').toggle();
	$(this).next('.album').toggle();
	if($(this).find('.albums_featured_image').is(':visible')) { album.css({width: 'auto'}); }
	else  { album.css({width: '100%'}); }
    } else {
	$(this).find('.albums_featured_image').hide();
	$(this).find('.preloader').fadeIn();
    }
});
$('.single_facebook_image').live('click', function() {
    if($(this).is('.is_selected')) {
	move_back($('#selected_images .img_details[parent="' + $(this).attr('parent') + '"]'));
    } else {
	if(!$('.multiselect').length > 0) {
	    $('#selected_images .img_details').each(function() {
		move_back(this);
	    });
	}
	add_image($(this).find('.img_details'));
    }
});

$('.remove_img').live('click', function() {
    move_back($(this).parents('.img_details'));
    return false;
});


function move_back(item){
    $(item).find('input[type="hidden"]').remove();
    $(item).hide();
    $('.album .single_facebook_image[parent="' +  $(item).attr("parent") + '"]').append(item).removeClass('is_selected');
}
function add_image(item) {
    var hidden_input = $('<input>', {type: "hidden", value: $(item).find('a.img_value').attr('href'), name: $(item).attr('id'), id: $(item).attr('id') });
    $(item).append(hidden_input);
    $(item).parents('.single_facebook_image').addClass('is_selected');
    $('#selected_images').append($(item).fadeIn());
}
