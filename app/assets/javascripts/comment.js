$(document).on('turbolinks:load', function(){
  App.cable.subscriptions.create('CommentsChannel', {
    connected: function() {
      console.log('Comment connected');
      var questionId = gon.question_id;
      if (questionId) this.perform('follow', { id: questionId }); 
    },

    received: function(data) {
      var comment = $.parseJSON(data['comment'])
      if (gon.signed_in_user && (gon.current_user_id == comment.author_id)) return;

      var resourceDiv = comment.commentable_type == "Question" ? "question" : "answer_" + comment.commentable_id;
      $('.' + resourceDiv + ' .comments').append(JST["templates/comment"]({ comment: comment })); 
    }
  });
});
