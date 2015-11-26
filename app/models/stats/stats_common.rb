class Stats::StatsCommon < ApplicationController

  def graph_types
    graphs = [["column", "bar-chart"], ["area", "area-chart"], ["spline", "line-chart"]]
  end

  def result_types
    types = ["ace", "eagle", "birdie", "par", "bogey", "dblbogey", "tplbogey", "other"]
  end

  def get_result_types(results)
    data = []
    results.each do |r|
      data << r.name
    end
    data
  end

  def get_head_to_head(round)
    data = [user: round.user, club: round.user.club.name, par: round.tee.par, score: round.total, results: numbers(round.scores) ]
  end

  def get_hole_result_stats(results)
    data = []
    results.each do |result|
      data << [result.name, result.sum]
    end
    data
  end

  def bogeyfree_rounds(rounds)
    bogeyfrees = []
    rounds.each do |round|
      data = round.result_type.split(',')
      if data.include?("5" || "6" || "7" || "8")
      else
        bogeyfrees << round
      end
    end
    bogeyfrees
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
      f.title({text: t(:Results_for_tour_part, name: tour_part.name, date: tour_part.date.strftime("%Y-%m-%d"), color: tee), style: {color: '#616161', "font-size": '12px'}})
      f.xAxis(categories: numbers)
      f.series(name: t(:Avg_result), yAxis: 0, data: avg)
      f.series(name: t(:Tour_part_avg), yAxis: 0, data: all_avg)
      f.series(name: t(:Your_round), yAxis: 0, data: player) unless player.blank?
      f.tooltip(shared: true)
      f.plotOptions({
        series: {
          fillOpacity: 0.4
      }})
      f.colors(['#24CCA9', '#616161', '#9061C2'])
      f.legend({
        layout: 'horizontal',
        itemDistance: 20,
        itemMarginTop: 15,
        borderWidth: 0
        })
      f.yAxis [{title: {text: t(:Result), margin: 15, style: {color: '#24CCA9'}}}]
      f.chart({defaultSeriesType: chart, backgroundColor:'rgba(255, 255, 255, 0.1)'})
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
        f.series(name: type, data: data)
      end
      f.legend({layout: 'horizontal', itemDistance: 20, itemMarginTop: 15, borderWidth: 0})
      f.title({ text: t(:Results_for_tour_part, name: tour_part.name, date: tour_part.date.strftime("%Y-%m-%d"), color: tee), style: {color: '#616161', "font-size": '12px'}})
      f.tooltip(shared: true, valueSuffix: " #{t(:St)}", borderColor: '#24CCA9', borderWidth: 1, useHtml: true, style: { padding: 10 })
      f.yAxis [{title: {text: t(:Quantity), margin: 15, style: {color: '#24CCA9'}}}]
      f.colors(['#9061C2', '#3DF556', '#8FFFA3', '#FFFFD4','#FFADAD', '#F08181', '#F26363', '#F53D3D', '#DB3535'])
      f.chart({defaultSeriesType: graph, backgroundColor:'rgba(255, 255, 255, 0.1)'})
      f.plot_options({column:{stacking: "normal", dataLabels: {enabled: false}}})
    end
  end

  #
  # Statistics functions
  #

  def build_user_stats(graph, types, results)
    @bar = LazyHighCharts::HighChart.new('column') do |f|
      f.series(name: t(:Quantity), data: results)
      f.xAxis(categories: types)
      f.legend({layout: 'horizontal', itemDistance: 20, itemMarginTop: 15, borderWidth: 0})
      f.title({ text: t(:Result), style: {color: '#616161', "font-size": '12px'}})
      f.tooltip(shared: true, valueSuffix: " #{t(:St)}", borderColor: '#24CCA9', borderWidth: 1, useHtml: true, style: { padding: 10 })
      f.colors(['#9061C2'])
      f.chart({defaultSeriesType: graph, backgroundColor:'rgba(255, 255, 255, 0.1)'})
      f.plot_options({column:{stacking: "normal", dataLabels: {enabled: false}}})
      f.options[:yAxis][:title] = {:text=>t(:Quantity)}
    end
  end

  def build_common_stats(graph, rounds, comps, tour_parts, players = nil, types, bogeyfree_rounds, below_par)
    @graph = LazyHighCharts::HighChart.new('column') do |f|
      f.title({ text: t(:Result), style: {color: '#616161', "font-size": '12px'}})
      f.series(name: t(:Players), data: [players]) unless players.nil?
      f.series(name: t(:Tournaments), data: [comps])
      f.series(name: t(:Tour_parts), data: [tour_parts])
      f.series(name: t(:Rounds), data: [rounds])
      f.series(name: t(:Below_par), data: [below_par])
      f.series(name: t(:Bogeyfree_rounds), data: [bogeyfree_rounds])
      f.xAxis(categories: [t(:Quantity)])
      f.colors(['#24CCA9', '#616161', '#9061C2'])
      f.legend({layout: 'horizontal', itemDistance: 20, itemMarginTop: 15, borderWidth: 0})
      f.chart({defaultSeriesType: graph, backgroundColor:'rgba(255, 255, 255, 0.1)'})
      f.tooltip(shared: false, valueSuffix: " #{t(:St)}", borderColor: '#24CCA9', borderWidth: 1, useHtml: true, style: { padding: 10 })
      f.options[:yAxis][:title] = {:text=>t(:Quantity)}
    end
  end

  def build_hole_chart(number, results, graph, result_types)
    @chart = LazyHighCharts::HighChart.new('column') do |f|
      f.series(name: t(:Quantity), data: results)
      f.xAxis(categories: result_types)
      f.legend({layout: 'horizontal', itemDistance: 20, itemMarginTop: 15, borderWidth: 0})
      f.title({ text: t(:Results_for, number: number), style: {color: '#616161', "font-size": '12px'}})
      f.tooltip(shared: true, valueSuffix: t(:St), borderColor: '#24CCA9', borderWidth: 1, useHtml: true, style: { padding: 10 })
      f.colors(['#9061C2'])
      f.chart({defaultSeriesType: graph, backgroundColor:'rgba(255, 255, 255, 0.1)'})
      f.plot_options({column:{stacking: "normal", dataLabels: {enabled: false}}})
    end
  end

  def tee_line_chart(tee, numbers, chart, avg, user = nil, name = nil)
    @chart = LazyHighCharts::HighChart.new('column') do |f|
      f.title({text: "#{tee.color} tee", style: {color: '#616161', "font-size": '12px'}})
      f.xAxis(categories: numbers)
      f.series(name: t(:Avg_result), yAxis: 0, data: avg)
      f.series(name: name, yAxis: 0, data: user) if user
      f.tooltip(shared: true)
      f.plotOptions({
        series: {
          fillOpacity: 0.4
      }})
      f.colors(['#24CCA9', '#9061C2'])
      f.legend({
        layout: 'horizontal',
        itemDistance: 20,
        itemMarginTop: 15,
        borderWidth: 0
        })
      f.yAxis [{title: {text: t(:Result), margin: 15, style: {color: '#24CCA9'}}}]
      f.chart({defaultSeriesType: chart, backgroundColor:'rgba(255, 255, 255, 0.1)'})
    end
  end
end
