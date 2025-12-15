class PasswordResetMailer < ApplicationMailer
    def reset_email(user)
        @user = user
        @url = edit_password_reset_url(token: @user.reset_password_token, id: @user.id)
        mail(to: @user.email, subject: "Password Reset Instructions")
    end
end
