class WithdrawMailer < BaseMailer

  def withdraw_state(withdraw_id)
    @withdraw = Withdraw.find withdraw_id
    mail :to => @withdraw.member.email
  end

end
