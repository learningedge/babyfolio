$(function(){

    jQuery('.facebook .image').live({
        mouseover: function(){
	    
            $(this).find('.thumb').stop().animate({opacity: 1});
            $('.facebook .image .thumb').not($(this).find('.thumb')).stop().animate({opacity: 0.5});
	    
        },
        mouseleave: function(){
 
            $('.facebook .image .thumb').stop().animate({opacity: 1});
	    
        }
    })

    //show preloader

    $('.facebook .facebook-grid .sets .image').live("click",function(){
	$('#facebook-ajax-container .preloader').stop().show().css({opacity: 0}).animate({opacity: 0.8});
    })
    $('.facebook .facebook-grid .photos .header > a').live("click",function(){
	$('#facebook-ajax-container .preloader').stop().show().css({opacity: 0}).animate({opacity: 0.8});
    })

    //multiselect and slingleselect

    $('.multiselect .facebook .facebook-grid .photos .image').live("click",function(){	

      if(typeof addSelectedImage == 'function'){
        addSelectedImage($(this));
      }else{
	  if($('#selected-facebook-photos #'+$(this).attr('id')).length == 0) {
	    element = $('<span class="selected-image" id="'+$(this).attr('id')+'" style="background-image: url('+ $(this).attr('thumb_url') +')"><input type="hidden" name="facebook_photos[]" value="'+$(this).attr('url')+'"/><input type="hidden" name="facebook_pids[]" value="'+$(this).attr('id')+'"/><input type="hidden" name="media_titles[]" value="'+ $(this).find('.media_title_text').html()+'"/><div class="hover">Remove</div></span>')
	    element.appendTo('#selected-facebook-photos');
	}
      }

    });

    $('.singleselect .facebook .facebook-grid .photos .image').live("click",function(){
	$('#selected-facebook-photos .selected-image').remove();
	element = $('<span class="selected-image" id="'+$(this).attr('id')+'" style="background-image: url('+ $(this).attr('thumb_url') +')"><input type="hidden" name="facebook_photos[]" value="'+$(this).attr('url')+'"/><input type="hidden" name="facebook_pids[]" value="'+$(this).attr('id')+'"/><input type="hidden" name="media_titles[]" value="'+ $(this).find('.media_title_text').html()+'"/><div class="hover">Remove</div></span>')
	element.appendTo('#selected-facebook-photos');
    })
    

    $('.facebook #selected-facebook-photos .selected-image').live({
        mouseover: function(){
            $(this).find('.hover').show().css({opacity:0.5});
        },
        mouseleave: function(){
            $(this).find('.hover').hide();
        }
    })

    $('.facebook #selected-facebook-photos .selected-image').live('click',function(){
        $(this).remove();
    })
    
})


