class Stats::StatsCommon

  def graph_types
    graphs = [["column", "bar-chart"], ["area", "area-chart"], ["spline", "line-chart"]]
  end

  def result_types
    types = ["ace", "eagle", "birdie", "par", "bogey", "dblbogey", "tplbogey", "other"]
  end

  def get_head_to_head(round)
    data = [user: round.user, club: round.user.club.name, par: round.tee.par, score: round.total, results: numbers(round.scores) ]
  end

  def get_hole_stats(datas)
    results = result_types
    sums = Array.new(results.size, 0)
    datas.each do |data|

      if data.result == "ace"
        sums[0] = data.sum
      elsif data.result == "eagle"
        sums[1] = data.sum
      elsif data.result == "birdie"
        sums[2] = data.sum
      elsif data.result == "par"
        sums[3] = data.sum
      elsif data.result == "bogey"
        sums[4] = data.sum
      elsif data.result == "dblbogey"
        sums[5] = data.sum
      elsif data.result == "trpbogey"
        sums[6] = data.sum
      elsif data.result == "other"
        sums[7] = data.sum
      end
    end
    sums
  end

  def get_hole_avg(id)
    average ||= Hole.tour_part_hole_avg(id)
  end

  def holes(holes)
    numbers = []
    holes.each do |hole|
      numbers << hole.number
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

  def tour_part_avg_score(scores)
    sums = []
    scores.each do |s|
      avg = s.sum.to_f/s.number.to_f
      sums << avg.round(2)
    end
    sums
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

  def tour_part_line_chart(tour_part, numbers, tee, player = nil, chart, avg, all_avg)
    @line_chart = LazyHighCharts::HighChart.new('graph') do |f|
      f.title(:text => "Resultat #{tour_part.name} - #{tour_part.date.strftime("%Y-%m-%d")} - #{tee} tee", :style => {:color => '#616161'})
      f.xAxis(:categories => numbers)
      f.series(:name => "Snittresultat", :yAxis => 0, :data => avg)
      f.series(:name => "Snitt alla deltävlingar", :yAxis => 0, :data => all_avg)
      f.series(:name => "Din runda", :yAxis => 0, :data => player) unless player.blank?
      f.tooltip(:shared => true)
      f.plotOptions({
        :series => {
          fillOpacity: 0.4
      }})
      f.colors(['#24CCA9', '#616161', '#9061C2'])
      f.legend({
        layout: 'horizontal',
        itemDistance: 20,
        itemMarginTop: 15,
        borderWidth: 0
        })
      f.yAxis [{:title => {:text => "Resultat", :margin => 20, :style => {:color => '#24CCA9'}} }]
      f.chart({:defaultSeriesType=>chart, backgroundColor:'rgba(255, 255, 255, 0.1)'})
    end
  end

  def hole_bar_chart(graph, all_holes, tour_part, tee)
    holes = holes(all_holes)
    @bar = LazyHighCharts::HighChart.new('column') do |f|
      f.xAxis(categories: holes)
      types = result_types
      data = []
      types.each do |type|
        data = []
        all_holes.each do |h|
          arr = Score.get_type(h.id, tour_part.id, type)
          data << arr.first.sum
        end
        f.series(:name=>type, :data=> data)
      end
      f.legend({
        layout: 'horizontal',
        itemDistance: 20,
        itemMarginTop: 15,
        borderWidth: 0
        })
      f.title({ :text=>"Resultat för #{tour_part.name} - #{tour_part.date.strftime("%Y-%m-%d")} - #{tee} tee"})
      f.tooltip(shared: true)
      f.colors(['#9061C2', '#3DF556', '#8FFFA3', '#FFFFD4','#FFADAD', '#F08181', '#F26363', '#F53D3D', '#DB3535'])
      f.chart({:defaultSeriesType=>graph, backgroundColor:'rgba(255, 255, 255, 0.1)'})
      f.plot_options({:column=>{:stacking=>"normal", :dataLabels => {:enabled => false}}})
    end
  end
end
