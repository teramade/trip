class TripsController < ApplicationController
  before_action :authenticate_user! #認証
  

  def index
    @trip = Trip.where(user:current_user).order(created_at: :desc)
  end

  def new

  end

  def create
    @trip = Trip.new
    @trip.title = params[:title]
    if params[:photo]
      @trip.photo.attach params[:photo]
    end
    @trip.tag_list = params[:tag_list]
    @trip.user = current_user

    save_position_info @trip

    if @trip.save
      flash[:notice] = "「#{@trip.title}」を作成しました！"
      redirect_to action: :index
    else
      flash[:alert] = "作成に失敗しましました"
      render action: :new
    end
  end

  def edit
    @trip = Trip.find_by(id: params[:id])
  end

  def update
    @trip = Trip.find_by(id: params[:id])
    @trip.title = params[:title]
    if params[:photo]
      @trip.photo.attach params[:photo]
    end
    # @trip.lat = params[:lat]
    # @trip.lon = params[:lon]
    @trip.tag_list = params[:tag_list]
    # if @trip.save
    #   redirect_to("/trips")
    # else
    #   redirect_to("/trips/#{params[:id]}/edit")
    # end

    # trip = Trip.find params[:id]
    # trip.title = params[:trip][:title]
    # trip.photo.attach params[:trip][:photo]

    # save_position_info @trip

    if @trip.save
      flash[:notice] = "「#{@trip.title}」を保存しました！"
      redirect_to action: :index
    else
      flash[:alert] = "「#{@trip.title}」の保存に失敗しましました"
      # redirect_to action: :edit, id: trip.id
      render action: :edit
    end
  end

  def destroy
    @trip = Trip.find_by(id: params[:id])
    flash[:alert] = "「#{@trip.title}」を削除しました！"
    @trip.destroy
    redirect_to("/trips")
  end

  

  private

  def save_position_info(trip)
    if trip.photo.attached?
      path = ActiveStorage::Blob.service.send(:path_for, trip.photo.key)
      puts "******************"
      puts path

      if path
        exif = Exif::Data.new(File.open(path))

        # 緯度取得
        latitude = nil
        gps = exif.gps_latitude
        if gps
          i = exif.gps_latitude[0].to_i
          j = exif.gps_latitude[1].to_i
          k = exif.gps_latitude[2].to_f
          # puts "北緯#{i}度#{j}分#{k}秒"
          latitude = "#{i}.#{j}#{k.to_s.delete('.')}"
        end

        # 経度取得
        longitude = nil
        gps = exif.gps_longitude
        if gps
          i = exif.gps_longitude[0].to_i
          j = exif.gps_longitude[1].to_i
          k = exif.gps_longitude[2].to_f
          # puts "東経#{i}度#{j}分#{k}秒"
          longitude = "#{i}.#{j}#{k.to_s.delete('.')}"
        end


        # 緯度経度から都道府県、市町村を取得
        response = HTTParty.get(
            "http://geoapi.heartrails.com/api/json?method=searchByGeoLocation&x=#{longitude}&y=#{latitude}"
        )
        result = JSON.parse(response.body)

        locations = result['response']['location']
        if locations
          prefecture = locations[0]['prefecture']
          city = locations[0]['city']
          # tripの都道府県、市町村タグを追加
          trip.tag_list.add(prefecture)
          trip.tag_list.add(city)
        end
      end
    end
  end


end
