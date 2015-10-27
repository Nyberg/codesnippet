class Stats::StatsCommon

  def get_head_to_head(round)
    data = [user: round.user, club: round.user.club.name, par: round.tee.par, score: round.total, results: numbers(round.scores) ]
  end

  def holes(holes)
    numbers = []
    holes.each do |hole|
      numbers << "Hål #{hole.number}"
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

  def tour_part_round_stats(id)
    avg = Score.stats_tour_part(id).includes(:hole)
    sums = []
    avg.each do |data|
      sums << (data.total.round(2) / data.amount.round(2)).round(2)
    end
    sums
  end

  def competition_round_stats(id, tee)
    sums = []
    avg = Score.stats_competition(id, tee).includes(:hole)
    avg.each do |data|
      sums << (data.total.round(2) / data.amount.round(2)).round(2)
    end
    sums.flatten
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

  def tour_part_line_chart(tour_part, avg, low, high, numbers)
    @line_chart = LazyHighCharts::HighChart.new('graph') do |f|
      f.title(:text => "Snittresultat för #{tour_part.name}")
      f.xAxis(:categories => numbers)
      f.series(:name => "Snittresultat", :yAxis => 0, :data => avg)
      f.series(:name => "Lägsta resultat", :yAxis => 0, :data => low)
      f.series(:name => "Högsta resultat", :yAxis => 0, :data => high)
      f.tooltip(:shared => true)
      f.yAxis [{:title => {:text => "Resultat", :margin => 20} }]
      f.chart({:defaultSeriesType=>"spline"})
    end
  end

  def competition_line_chart(competition, avg, numbers, color, low)
    @line_chart = LazyHighCharts::HighChart.new('graph') do |f|
      f.title(:text => "Snittresultat för #{competition.name} - #{color} tee")
      f.xAxis(:categories => numbers)
      f.series(:name => "Snittresultat", :yAxis => 0, :data => avg)
      f.series(:name => "Bästa runda", :yAxis => 0, :data => low)
      #f.series(:name => "Högsta resultat", :yAxis => 0, :data => high)
      f.tooltip(:shared => true)
      f.yAxis [{:title => {:text => "Resultat", :margin => 20} }]
      f.chart({:defaultSeriesType=>"spline"})
    end
  end

  def tour_part_pie_chart(res, tour_part)
    @pie_chart_part = LazyHighCharts::HighChart.new('pie') do |f|
      f.chart({:defaultSeriesType=>"pie" , :margin=> [0]} )
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
      f.options[:title][:text] = "Resultat #{tour_part}"
      f.legend(:layout=> 'vertical',:style=> {:left=> 'auto', :bottom=> 'auto',:right=> '50px',:top=> '100px'})
      f.colors(['#FF5500', '#14F732', '#3DF556', '#8FFFA3', '#FFFFD4','#FFADAD', '#F08181', '#F26363', '#F53D3D', '#DB3535'])
      f.plot_options(:pie=>{
        :allowPointSelect=>true,
        :dataLabels=>{
          :enabled=>false,
          :distance => 0
        },
        :startAngle=> -90,
        :endAngle => 90,
        :center => ['50%', '60%']
      })
    end
  end

  def competition_pie_chart(totals, name)
    @pie_chart_total = LazyHighCharts::HighChart.new('pie') do |f|
      f.chart({:defaultSeriesType=>"pie" , :margin=> [0]} )
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
      f.options[:title][:text] = name
      f.legend(:layout=> 'vertical',:style=> {:left=> 'auto', :bottom=> 'auto',:right=> '50px',:top=> '100px'})
      f.colors(['#FF5500', '#14F732', '#3DF556', '#8FFFA3', '#FFFFD4','#FFADAD', '#F08181', '#F26363', '#F53D3D', '#DB3535'])
      f.plot_options(:pie=>{
        :allowPointSelect=>true,
        :dataLabels=>{
          :enabled=>false,
          :distance => 0
        },
        :startAngle=> -90,
        :endAngle => 90,
        :center => ['50%', '60%']
      })
    end
  end
end
