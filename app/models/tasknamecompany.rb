class Tasknamecompany < ActiveRecord::Base

private

  def tasknamecompany_params
    params.require(:tasknamecompany).permit(:term, :popularity)
  end
end
