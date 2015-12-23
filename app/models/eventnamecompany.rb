class Eventnamecompany < ActiveRecord::Base

private

  def eventnamecompany_params
    params.require(:eventnamecompany).permit(:term, :popularity)
  end
end