module ApplicationHelper
  def isAdmin?
    if session[:user].admin == 1 || session[:user].id == 1
      return true
    else
      return false
    end
  end

  def isOwner(id)
    if session[:user].id == id
      return true
    else
      return false
    end
  end
end
