class StaticPagesController < ApplicationController
  def home
    session[:teste] = 'session inicial no home'
  end

  def test
  end

  def about
    session[:teste] = 'mudando o session no about'
  end

  def contact
  end
end
