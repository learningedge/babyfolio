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

	  if ($(this).find('input[type=checkbox]').attr('checked')) {
	      
              $(this).find('input[type=checkbox]').attr('checked',false)
              $(this).removeClass('active');

	  } else {
      
              $(this).find('input[type=checkbox]').attr('checked',true);
              $(this).addClass('active');

	  }

      });

    $('.singleselect .vimeo .video').live("click",function(){

	$('.singleselect .vimeo .video input[type=checkbox]').attr('checked',false);
	$('.singleselect .vimeo .video').removeClass('active');
	 
	$(this).find('input[type=checkbox]').attr('checked', true);
	$(this).addClass('active');

    })

    $('.vimeo .header a.upload-link').live('click',function(){

      $(this).parents('.vimeo').find('.upload').css({height: 0}).show().animate({height: 200});
      $(this).hide();
      $(this).parents('.vimeo').find('.header .close-btn').show();
      return false;

    })

    $('.close-btn').live('click',function(){
        $(this).parents('.vimeo').find('.upload').stop().animate({height: 0}, function(){$(this).hide(); })
        $(this).hide();
        $(this).parents('.vimeo').find('.header .upload-link').show();
        return false;
    })

})