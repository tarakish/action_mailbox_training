class CommentsMailbox < ApplicationMailbox
  before_processing :validate_request

  def process
    board.comments.create!(body: mail.decoded, creator: commenter)
  end

  def validate_request
    return if commenter && board

    bounce_with CommentMailer.invalid_request(
      inbound_email, commenter: commenter, board: board
    )
  end

  def commenter
    return @commenter if defined?(@commenter)
    @commenter
  end

  def board
    return @board if defined?(@board)
    @board = Board.find_by(id: mail.to.split('-')[0])
  end
end
