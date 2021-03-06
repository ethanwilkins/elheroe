class GameBoardsController < ApplicationController
  def reset
    @game_board = GameBoard.find(params[:id])
    @game_board.cards.destroy_all
    @game_board.populate
    log_action("game_boards_reset", @game_board.id)
    redirect_to :back
  end
  
  def create
    @code = GameBoard.redeem params[:code]
    @group = Group.find_by_user(current_user)
    @group = @group.is_a?(Array) ? @group.first : @group # not sure why arrays being returned, hack/fix
    @game_board = current_user.game_boards.new(code_id: @code.id, board_number: @code.board_number,
      zip_code: current_user.zip_code, group_id: @group.id) if @code
    
    if @game_board and @game_board.save
      @game_board.populate
      log_action("game_boards_create", @game_board.id)
      redirect_to game_board_path(@game_board)
    elsif @game_board and @game_board.errors.include? :code_already_redeemed
      flash[:error] = translate(@game_board.errors[:code_already_redeemed].first)
      log_action("game_boards_create_fail")
      redirect_to :back
    else
      flash[:error] = translate("The code was not valid.")
      log_action("game_boards_create_fail")
      redirect_to :back
    end
  end
  
  def destroy
    @game_board = GameBoard.find(params[:id])
    @game_board.destroy
    flash[:notice] = translate("The board was successfully deleted.")
    log_action("game_boards_destroy")
    redirect_to boards_path
  end
  
  def show
    @game_board = GameBoard.find(params[:id])
    @cards = @game_board.cards
    @card = Card.new
    log_action("game_boards_show", @game_board.id)
  end
  
  def index
    @game_board = GameBoard.new
    @game_boards = current_user.game_boards.reverse
    @advert = Article.local_advert(current_user)
    log_action("game_boards_index")
  end
end
