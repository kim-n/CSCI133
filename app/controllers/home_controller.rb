class HomeController < ApplicationController
  def index
    
    session = GoogleDrive.login(ENV["GOOGLE_U"], ENV["GOOGLE_P"])

    @ws = session.spreadsheet_by_key(ENV["GOOGLE_WS"]).worksheets[0]
   
    
    @data = []
    
    @timeoff = 5
    @current_unit = nil
    @name = nil
    
    if params["name"]
      @name = params["name"]["first"].capitalize + " " + params["name"]["last"].capitalize 
      @message = @name + " not found."
      for row in 2..@ws.num_rows
        if @ws[row, 1].downcase == params["name"]["first"].downcase && @ws[row, 2].downcase == params["name"]["last"].downcase 
          @message = nil
          @current_unit = @ws[row, 6].to_i + 1
          for col in 3..@ws.num_cols
            @data << @ws[1,col] if (col-3)% 4 == 0 
            @data << @ws[row,col]
            @timeoff = @timeoff -1 if @ws[row,col] == "A"
            @timeoff = @timeoff -0.5 if @ws[row,col] == "L" || @ws[row,col] == "H"
          end
        end
      end
    end
    
    render :index
  end
  
  def new
    render :new
  end

end
