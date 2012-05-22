$(function(){

      $('.multiselect .youtube .video').live("click",function(){

      if(typeof addSelectedImage == 'function'){

        addSelectedImage($(this));

      } else {

        if ($(this).find('input[type=checkbox]').attr('checked')) {

                  $(this).find('input[type=checkbox]').attr('checked',false)
                  $(this).find('input[type=hidden]').remove();
                  $(this).removeClass('active');

        } else {

                  $(this).find('input[type=checkbox]').attr('checked',true);
                  $(this).append('<input type="hidden" name="media_titles[]" value="'+ $(this).find('.media_title_text').html()+'"/>')
                  $(this).addClass('active');

        }
      }

      

    });

    $('.singleselect .youtube .video').live("click",function(){

      $('.singleselect .youtube .video input[type=checkbox]').attr('checked',false);
      $('.singleselect .youtube .video input[type=hidden]').remove();
      $('.singleselect .youtube .video').removeClass('active');

      $(this).find('input[type=checkbox]').attr('checked', true);
      $(this).append('<input type="hidden" name="media_titles[]" value="'+ $(this).find('.media_title_text').html()+'"/>')
      $(this).addClass('active');

    })

    $('.youtube-container .header a.upload-link').live('click',function(){

      $(this).parents('.youtube-container').find('.upload').css({height: 0}).show().animate({height: 200});
      $(this).hide();
      $(this).parents('.youtube-container').find('.header .close-btn').show();
      return false;

    })

    $('.close-btn').live('click',function(){
        $(this).parents('.youtube-container').find('.upload').stop().animate({height: 0}, function(){$(this).hide(); })
        $(this).hide();
        $(this).parents('.youtube-container').find('.header .upload-link').show();
        return false;
    })

})