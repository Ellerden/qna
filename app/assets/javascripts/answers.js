var editAnswer;

editAnswer = function() {
    return $('body').on('click', '.edit-answer-link', function(e) {
        var answer_id;
        e.preventDefault();
        $(this).hide();
        answer_id = $(this).data('answerId');
        return $('form#edit-answer-' + answer_id).show();
    });
};