$(function(){

      jQuery('.vimeo .video').live({
        mouseover: function(){
      
                              $(this).find('.thumb').stop().animate({opacity: 1});
                              $('.vimeo .video .thumb').not($(this).find('.thumb')).stop().animate({opacity: 0.5});

                             },
        mouseleave: function(){
 
                              $('.vimeo .video .thumb').stop().animate({opacity: 1});

                              }
      })

      $('.multiselect .vimeo .video').live("click",function(){

      if(typeof addSelectedImage == 'function'){
        addSelectedImage($(this));
      } else {

        if ($(this).find('input[type=checkbox]').attr('checked')) {

                  $(this).find('input[type=checkbox]').attr('checked',false)
                  $(this).removeClass('active');

        } else {

                  $(this).find('input[type=checkbox]').attr('checked',true);
                  $(this).addClass('active');

        }

      }


      });

    $('.singleselect .vimeo .video').live("click",function(){

	$('.singleselect .vimeo .video input[type=checkbox]').attr('checked',false);
	$('.singleselect .vimeo .video').removeClass('active');
	 
	$(this).find('input[type=checkbox]').attr('checked', true);
	$(this).addClass('active');

    })

    $('.vimeo-container .header a.upload-link').live('click',function(){

      $(this).parents('.vimeo-container').find('.upload').css({height: 0}).show().animate({height: 80});
      $(this).hide();
      $(this).parents('.vimeo-container').find('.header .close-btn').show();
      return false;

    })

    $('.vimeo-container .header .close-btn').live('click',function(){
        $(this).parents('.vimeo-container').find('.upload').stop().animate({height: 0}, function(){$(this).hide(); })
        $(this).hide();
        $(this).parents('.vimeo-container').find('.header .upload-link').show();
        return false;
    })

})