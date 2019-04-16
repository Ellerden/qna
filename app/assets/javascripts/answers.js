$(document).on('turbolinks:load', function(){
  $('.answers').on('click', '.edit-answer-link', function(e) {
       e.preventDefault();
       $(this).hide();
       var answerId = $(this).data('answerId');
       $('form#edit-answer-' + answerId).removeClass('hidden');
  })

  $('.answer-vote').on('ajax:success', function(e, xhr) {
    e.preventDefault();
    var score = xhr['score'];
    var answerId = $(this).parent().data('aid');
    $('.answer_' + answerId).find('.score').text(score);
  });

  App.cable.subscriptions.create('AnswersChannel', {
    connected: function() {
      console.log('Answer connected');
      var questionId = gon.question_id;
      //var questionId = $('.question').data('qid');
      this.perform('follow', { id: questionId });
    },
    received: function(data) {
      var answer = $.parseJSON(data);
      console.log(answer);
      // ЕСЛИ ЮЗЕР ЗАЛОГИНЕН И АВТОР - показываем js как было до этого, со всеми edit и delete
      if (gon.signed_in_user && (gon.current_user_id == answer.author_id)) return;
      
      console.log('GOGGG!');
      $('.answers').append(JST["templates/answer"]({ answer: answer })); 
    }
  });
});
