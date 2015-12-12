class ContactsController < ApplicationController
  def new
    @contact = Contact.new
  end

  def create
    @contact = Contact.new(params[:contact])
    @contact.request = request
    if @contact.deliver
      flash[:notice] = 'Thank you for your message. We will contact you soon!'
      redirect_to signup_path
      ContactMailer.welcome_email(@contact).deliver
    else
      flash[:error] = 'Cannot send message.'
      render :new
    end
  end
end
