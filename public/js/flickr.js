$(function(){

    jQuery('.flickr .image').live({
        mouseover: function(){
	    
            $(this).find('.thumb').stop().animate({opacity: 1});
            $('.flickr .image .thumb').not($(this).find('.thumb')).stop().animate({opacity: 0.5});
	    
        },
        mouseleave: function(){
 
            $('.flickr .image .thumb').stop().animate({opacity: 1});
	    
        }
    })

    //show preloader

    $('.flickr .flickr-grid .sets .image').live("click",function(){
	$('#flickr-ajax-container .preloader').stop().show().css({opacity: 0}).animate({opacity: 0.8});
    })
    $('.flickr .flickr-grid .photos .header > a').live("click",function(){
	$('#flickr-ajax-container .preloader').stop().show().css({opacity: 0}).animate({opacity: 0.8});
    })

    //multiselect and slingleselect

    $('.multiselect .flickr .flickr-grid .photos .image').live("click",function(){	
	    if(typeof addSelectedImage == 'function'){
        addSelectedImage($(this));
      } else {
        if($('#selected-flickr-photos #'+$(this).attr('id')).length == 0) {
          element = $('<span class="selected-image" id="'+$(this).attr('id')+'"><img src="'+$(this).attr('thumb_url')+'"/><input type="hidden" name="flickr_photos[]" value="'+$(this).attr('url')+'"/><input type="hidden" name="flickr_pids[]" value="'+$(this).attr('id')+'"/><div class="hover">Remove</div></span>')
          element.appendTo('#selected-flickr-photos');
        }
      }

    });

    $('.singleselect .flickr .flickr-grid .photos .image').live("click",function(){
	$('#selected-flickr-photos .selected-image').remove();
	element = $('<span class="selected-image" id="'+$(this).attr('id')+'"><img src="'+$(this).attr('thumb_url')+'"/><input type="hidden" name="flickr_photos[]" value="'+$(this).attr('url')+'"/><input type="hidden" name="flickr_pids[]" value="'+$(this).attr('id')+'"/><input type="hidden" name="media_titles[]" value="'+ $(this).find('.media_title_text').html()+'"/><div class="hover">Remove</div></span>')
	element.appendTo('#selected-flickr-photos');
    })
    

    $('.flickr #selected-flickr-photos .selected-image').live({
        mouseover: function(){
            $(this).find('.hover').show().css({opacity:0.5});
        },
        mouseleave: function(){
            $(this).find('.hover').hide();
        }
    })

    $('.flickr #selected-flickr-photos .selected-image').live('click',function(){
        $(this).remove();
    })
    
})