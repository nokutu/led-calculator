class HomeController < ApplicationController
  include ApplicationHelper


  def index
    @calculation = Calculation.find_or_create_by(:id => session[:calculation])
    @products = Product.all.order(:name)
  end

  def result
    @calculation = Calculation.find(session[:calculation])
    unless @calculation.finished?
      @calculation.finished = true;
      @calculation.save!
      UserMailer.result_email(@calculation).deliver_now
    end
    @code = encode(@calculation.id)
    respond_to do |format|
      format.html
      format.pdf {render :text => PDFKit.new( render_to_string "user_mailer/result_email.html.erb", layout: false ).to_pdf}
    end
  end



  def again
    calculation = Calculation.find(session[:calculation])
    @calculation = Calculation.new({:email => calculation.email,
                                    :phone_number => calculation.phone_number,
                                    :name => calculation.name,
                                    :post_code => calculation.post_code})
    @calculation.save
    session[:calculation] = @calculation.id
    redirect_to "/"
  end

  def reset
    session[:calculation] = nil
    session[:oldCalculation] = nil
    redirect_to "/"
  end

  def addline
    @id = params[:id]
    respond_to do |format|
      format.js{}
    end
  end

  def deleteline
    @id = params[:id]
    respond_to do |format|
      format.js{}
    end
  end
end
