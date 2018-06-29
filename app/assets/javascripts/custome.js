$(function() {
    $(".form_reset").on('click', function(){
        $(':input',$(this).parents("form")[0])
            .not(':button, :submit, :reset, :hidden')
            .val('')
            .removeAttr('checked')
            .removeAttr('selected');
    });
})