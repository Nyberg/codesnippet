class Stats::StatsCommon

  def get_head_to_head(round)
    data = [user: round.user, club: round.user.club.name, par: round.tee.par, score: round.total, results: numbers(round.scores) ]
  end

  def get_hole_avg(id)
    average ||= Hole.tour_part_hole_avg(id)
  end

  def holes(holes)
    numbers = []
    holes.each do |hole|
      numbers << "Hål #{hole.number}"
    end
    numbers
  end

  def player_round(scores)
    numbers = []
    scores.each do |s|
      numbers << s.score
    end
    numbers
  end

  def high_low(holes, id, order)
    result = []
    holes.each do |hole|
      number = Score.where(hole_id: hole.id).where(tour_part_id: id).order("score #{order}").first
      result << number.score
    end
    result
  end

  def competition_high_low(round)
    result = []
    round.each do |r|
      r.scores.each do |s|
        result << s.score
      end
    end
    result
  end

  def tour_part_round_stats(avg)
    sums = []
    avg.each do |data|
      sums << data.avg.to_f
    end
    sums
  end

  def competition_round_stats(id, tee)
    sums = []
    avg = Hole.competition_hole_avg(id)
    avg.each do |data|
      sums << data.avg.to_f
    end
    sums
  end

  def numbers(scores)
    numbers = {ace: {count: 0}, albatross: {count: 0}, eagle: {count: 0}, birdie: {count: 0}, par: {count:0}, bogey: {count: 0}, dblbogey: {count: 0}, trpbogey: {count: 0}, other: {count: 0}}
    scores.each do |s|
      if s.hole.par == 3
        numbers[:ace][:count]     += 1 if s.score == 1
        numbers[:birdie][:count]  += 1 if s.score == 2
        numbers[:par][:count]     += 1 if s.score == 3
        numbers[:bogey][:count]   += 1 if s.score == 4
        numbers[:dblbogey][:count]+= 1 if s.score == 5
        numbers[:trpbogey][:count]+= 1 if s.score == 6
        numbers[:other][:count]   += 1 if s.score > 6
      elsif s.hole.par == 4
        numbers[:ace][:count]     += 1 if s.score == 1
        numbers[:eagle][:count]   += 1 if s.score == 2
        numbers[:birdie][:count]  += 1 if s.score == 3
        numbers[:par][:count]     += 1 if s.score == 4
        numbers[:bogey][:count]   += 1 if s.score == 5
        numbers[:dblbogey][:count]+= 1 if s.score == 6
        numbers[:trpbogey][:count]+= 1 if s.score == 7
        numbers[:other][:count]   += 1 if s.score > 7
      end
    end
    numbers
  end

  def tour_part_line_chart(tour_part, avg, low, high, numbers, player = nil)
    @line_chart = LazyHighCharts::HighChart.new('graph') do |f|
      f.title(:text => "Snittresultat för #{tour_part.name}", :style => {:color => '#616161'})
      f.xAxis(:categories => numbers)
      f.series(:name => "Snittresultat", :yAxis => 0, :data => avg)
      f.series(:name => "Lägsta resultat", :yAxis => 0, :data => low)
      f.series(:name => "Högsta resultat", :yAxis => 0, :data => high)
      f.series(:name => "Din runda", :YAxis => 0, :data => player) unless player.blank?
      f.tooltip(:shared => true)
      f.colors(['#24CCA9', '#616161', '#2B8080', '#9061C2'])
      f.yAxis [{:title => {:text => "Resultat", :margin => 20, :style => {:color => '#24CCA9'}} }]
      f.chart({:defaultSeriesType=>"spline", backgroundColor:'rgba(255, 255, 255, 0.1)'})
    end
  end

  def competition_line_chart(competition, avg, numbers, color, low)
    @line_chart = LazyHighCharts::HighChart.new('graph') do |f|
      f.title(:text => "Snittresultat för #{competition.name} - #{color} tee", :style => {:color => '#616161'})
      f.xAxis(:categories => numbers)
      f.series(:name => "Snittresultat", :yAxis => 0, :data => avg)
      f.series(:name => "Bästa runda", :yAxis => 0, :data => low)
      #f.series(:name => "Högsta resultat", :yAxis => 0, :data => high)
      f.tooltip(:shared => true)
      f.colors(['#24CCA9', '#616161', '#2B8080'])
      f.yAxis [{:title => {:text => "Resultat", :margin => 20, :style => {:color => '#24CCA9'}} }]
      f.chart({:defaultSeriesType=>"spline", backgroundColor:'rgba(255, 255, 255, 0.1)'})
    end
  end

  def tour_part_pie_chart(res, tour_part)
    @pie_chart_part = LazyHighCharts::HighChart.new('pie') do |f|
      f.chart({:defaultSeriesType=>"pie", :margin=> [40, 40, 40, 40], backgroundColor:'rgba(255, 255, 255, 0.1)'} )
      series = {
       :type=> 'pie',
       :name=> 'Antal',
       :data=> [
          ['Ace',         res[:ace][:count]],
          ['Albatross',   res[:albatross][:count]],
          ['Eagle',       res[:eagle][:count]],
          ['Birdie',      res[:birdie][:count]],
          ['Par',         res[:par][:count]],
          ['Bogey',       res[:bogey][:count]],
          ['Dubbelbogey', res[:dblbogey][:count]],
          ['Trippelbogey',res[:trpbogey][:count]],
          ['Others',      res[:other][:count]]
       ]}
      f.series(series)
      f.title(:text => "Resultat för #{tour_part}", :style => {:color => '#616161'})
      f.legend(:layout=> 'vertical',:style=> {:left=> 'auto', :bottom=> 'auto',:right=> '50px',:top=> '0px', :color => '#616161'})
      f.colors(['#FF5500', '#14F732', '#3DF556', '#8FFFA3', '#FFFFD4','#FFADAD', '#F08181', '#F26363', '#F53D3D', '#DB3535'])
      f.plot_options(:pie=>{
        :allowPointSelect=>true,
        :dataLabels=>{
          :enabled=>false,
          :distance => 0
        },
        :center => ['50%', '60%']
      })
    end
  end

  def competition_pie_chart(totals, name)
    @pie_chart_total = LazyHighCharts::HighChart.new('pie') do |f|
      f.chart({:defaultSeriesType=>"pie", :margin=> [40, 40, 40, 40], backgroundColor:'rgba(255, 255, 255, 0.1)'} )
      series = {
       :type=> 'pie',
       :name=> 'Antal',
       :data=> [
          ['Ace',         totals[:ace][:count]],
          ['Albatross',   totals[:albatross][:count]],
          ['Eagle',       totals[:eagle][:count]],
          ['Birdie',      totals[:birdie][:count]],
          ['Par',         totals[:par][:count]],
          ['Bogey',       totals[:bogey][:count]],
          ['Dubbelbogey', totals[:dblbogey][:count]],
          ['Trippelbogey',totals[:trpbogey][:count]],
          ['Others',      totals[:other][:count]]
       ]}
      f.series(series)
      f.title(:text => name, :style => {:color => '#616161'})
      f.legend(:layout=> 'vertical',:style=> {:left=> 'auto', :bottom=> 'auto',:right=> '50px',:top=> '0px' })
      f.colors(['#FF5500', '#14F732', '#3DF556', '#8FFFA3', '#FFFFD4','#FFADAD', '#F08181', '#F26363', '#F53D3D', '#DB3535'])
      f.plot_options(:pie=>{
        :allowPointSelect=>true,
        :dataLabels=>{
          :enabled=>false,
          :distance => 0
        },
        :center => ['50%', '60%']
      })
    end
  end

  def get_tour_part_line_chart(tour_part, scores, holes, all_scores, headtohead, user_id = nil)
    average = get_hole_avg(tour_part.id)
    avg = tour_part_round_stats(average) # gets average score for line graph
    numbers = holes(holes) # gets the hole numbers
    high = high_low(holes, tour_part.id, "DESC") # gets the highest score for the tour_part
    low = high_low(holes, tour_part.id, "ASC") # gets the lowest score for the tour_part
    res = numbers(scores) # gets the results for the tour_part (birdies, pars etc)
    totals = numbers(all_scores) # gets the total results for the competition (birdies, pars etc)

    if headtohead
      scores = Score.where(user_id: user_id, tour_part_id: tour_part.id)
      data = scores.map(&:score).to_a
      return @line_chart = tour_part_line_chart(tour_part, avg, low, high, numbers, data)
    else
      return @line_chart = tour_part_line_chart(tour_part, avg, low, high, numbers)
    end
  end

  def get_tour_part_part_pie(name, scores)
    res = numbers(scores)
    return @pie_chart_part = tour_part_pie_chart(res, name)
  end

  def get_tour_part_total_pie(name, scores)
    totals = numbers(scores)
    @pie_chart_total = competition_pie_chart(totals, name)
  end

end
