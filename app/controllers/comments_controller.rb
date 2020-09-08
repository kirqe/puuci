class CommentsController < ApplicationController

  post '/comments' do
    @issue = Issue.find(params[:comment][:issue_id])
    @comment = @issue.comments.build(user: current_user, message: params[:comment][:message])
    
    if @comment.save
      flash :success, "Your comment has successfully been added"
      redirect to "/issues/#{@issue.id}"
    else
      flash :error, "There's something wrong with your comment, it: #{@comment.errors.values.join(", ")}"
      redirect to "/issues/#{@issue.id}"
    end
  end

  delete '/comments/:id', :auth => ["admin"] do |id|
    comment = Comment.find(params[:id])
    authorize(comment)
    comment.destroy

    flash :success, "You have successfully deleted the comment"
    redirect back
  end
end