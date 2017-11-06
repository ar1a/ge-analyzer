class Item < ApplicationRecord
  has_many :price_updates

  searchkick word_start: [:name]

  scope :positive_roi, lambda {
    where('roi > 0') # profits
      .where('buying_rate > 5 AND selling_rate > 5 AND (buying_rate + selling_rate) > 30') # Actually traded
      .where('recommended_buy_price > 1000') # not 20gp herbs or 5gp tinderboxes
      .where('abs(margin) > ? OR roi > ?', 300, 0.03) # Either has a high margin or good ROI
  }

  scope :most_traded, lambda {
    # where('abs(margin) >= 4')
    order('(buying_rate + selling_rate) desc')
      .limit(100)
  }

  scope :top_flips, lambda {
    where('buying_rate > 2')
      .where('selling_rate > 2')
      .order('abs(margin) desc')
      .limit(100)
  }

  scope :barrows_items, lambda {
    where(runescape_id: [
            # Dharok
            12_877, # Set
            4718, # Greataxe
            4716, # Helm
            4720, # Platebody
            4722, # Platelegs
            # Torag
            12_879, # Set
            4747, # Hammers
            4745, # Helm
            4749, # Platebody
            4751, # Platelegs
            # Guthan
            12_873, # Set
            4726, # Warspear
            4724, # Helm
            4728, # Platebody
            4730, # Chainskirt
            # Verac
            12_875, # Set
            4755, # Flail
            4753, # Helm
            4757, # Brassard
            4759, # Plateskirt
            # Karil
            12_883, # Set
            4734, # Crossbow
            4732, # Coif
            4736, # Leathertop
            4738, # Leatherskirt
            # Ahrim
            12_881, # Set
            4710, # Staff
            4708, # Hood
            4712, # Robetop
            4714, # Robeskirt
          ])
  }

  scope :zulrah, lambda {
    where(name: [
            "Zulrah's scales",
            'Tanzanite fang',
            'Magic fang',
            'Serpentine visage',
            'Uncut onyx',
            'Dragon med helm',
            'Dragon halberd',
            'Law rune',
            'Death rune',
            'Chaos rune',
            'Pure essence',
            'Toadflax',
            'Snapdragon',
            'Dwarf weed',
            'Torstol',
            'Flax',
            'Snakeskin',
            'Dragon bolt tips',
            'Yew logs',
            'Mahogany logs',
            'Coal',
            'Runite ore',
            'Calquat tree seed',
            'Palm tree seed',
            'Papaya tree seed',
            'Magic seed',
            'Toadflax seed',
            'Snapdragon seed',
            'Dwarf weed seed',
            'Torstol seed',
            'Crystal seed',
            'Zul-andra teleport',
            'Dragon bones',
            'Coconut',
            'Grapes',
            'Battlestaff',
            'Antidote++(4)',
            'Manta ray',
            'Swamp tar',
            'Crushed nest',
            'Adamantite bar',
            'Jar of swamp'
          ])
  }

  scope :potions, lambda {
    where(name: [
            'Attack potion(4)',
            'Antipoison(4)',
            'Relicym\'s balm(4)',
            'Strength potion(4)',
            'Serum 207(4)',
            'Guthix rest tea(4)',
            'Restore potion(4)',
            'Guthix balance(4)',
            'Blamish oil(4)',
            'Energy potion(4)',
            'Defence potion(4)',
            'Agility potion(4)',
            'Combat potion(4)',
            'Prayer potion(4)',
            'Super attack(4)',
            'Superantipoison(4)',
            'Fishing potion(4)',
            'Super energy potion(4)',
            'Hunter potion(4)',
            'Super strength(4)',
            'Weapon poison(4)',
            'Super restore(4)',
            'Sanfew serum(4)',
            'Super defence potion(4)',
            'Antidote+(4)',
            'Anti-fire potion(4)',
            'Ranging potion(4)',
            'Weapon poison+(4)',
            'Magic potion(4)',
            'Stamina potion(4)',
            'Zamorak brew(4)',
            'Antidote++(4)',
            'Saradomin brew(4)',
            'Weapon poison++(4)',
            'Extended antifire(4)',
            'Anti-venom(4)',
            'Super combat potion(4)',
            'Anti-venom+(4)'
          ])
  }

  scope :ores, lambda {
    where(name: [
            'Clay',
            'Rune essence',
            'Copper ore',
            'Tin ore',
            'Limestone',
            'Blurite ore',
            'Iron ore',
            'Elemental ore',
            'Silver ore',
            'Pure essence',
            'Coal ore',
            'Sandstone',
            'Gold ore',
            'Granite',
            'Mithril ore',
            'Lovakite ore',
            'Adamantite ore',
            'Runite ore',
            'Amethyst'
          ])
  }

  def roi
    if (val = self[:roi]).nil? || val.nan?
      0
    else
      val
    end
  end

  def recommended_buy_price
    if (val = self[:recommended_buy_price]).nil? || val.nan?
      most_recent.buy_average || 0
    else
      val
    end
  end

  def recommended_sell_price
    if (val = self[:recommended_sell_price]).nil? || val.nan?
      most_recent.sell_average || 0
    else
      val
    end
  end

  def most_recent
    price_updates.order('created_at desc').last
  end

  def buying_rate
    if (val = self[:buying_rate]).nil?
      0
    else
      val
    end
  end

  def selling_rate
    if (val = self[:buying_rate]).nil?
      0
    else
      val
    end
  end

  def price
    price_updates.last.overall_average
  rescue NoMethodError
    0
  end

  def buy_price
    price_updates.last.buy_average
  rescue NoMethodError
    0
  end

  def sell_price
    price_updates.last.sell_average
  rescue NoMethodError
    puts 'rescued'
    0
  end

  def icon_link
    "http://cdn.rsbuddy.com/items/#{runescape_id}.png"
  end

  def price_history(day_range = 0)
    if day_range <= 0
      price_updates.pluck(:created_at, :overall_average)
    elsif day_range < 3
      Rails.cache.fetch("#{cache_key}/price_history/daily") do
        get_price_updates(day_range)
      end
    elsif day_range >= 3 && day_range < 7
      Rails.cache.fetch("#{cache_key}/price_history/three") do
        updates = get_price_updates(day_range)
        2.step(updates.size - 1, 3).map { |i| updates[i] }
      end
    elsif day_range == 7
      Rails.cache.fetch("#{cache_key}/price_history/week") do
        updates = get_price_updates(day_range)
        5.step(updates.size - 1, 6).map { |i| updates[i] }
      end
    elsif day_range >= 30
      Rails.cache.fetch("#{cache_key}/price_history/month") do
        a = price_updates.group_by { |x| x.created_at.to_date }
        tmp = []
        a.each do |b|
          tmp << [b[0], (b[1].map(&:overall_average).reduce(:+) / b[1].size.to_f).to_i]
        end
        tmp.reject{ |x| x[1].zero? }
      end
    end
  end

  def get_price_updates(day_range)
    price_updates
      .where(
        created_at: (DateTime.current - day_range.days)..DateTime.current
      )
      .pluck(:created_at, :overall_average).reject { |x| x[1].zero? }
  end

  def update_roi(other)
    roi = margin.abs / recommended_buy_price
    raise 'hit the rescue nigga' if roi.nan? || roi.infinite?
    update(roi: roi)
  rescue
    update(roi: other)
  end

  def update_margin
    margin = recommended_sell_price - recommended_buy_price
    if margin.infinite? || margin.nan?
      update(margin: -1)
      return
    end
    update(margin: recommended_sell_price - recommended_buy_price)
  end

  def update_ema
    buy = price_updates
          .where(created_at: 1.day.ago..DateTime.now)
          .order('created_at asc')
          .pluck(:buy_average)
          .reject { |x| x <= 0 }
    buy.extend Basic::Stats
    p 'buy'
    puts buy.count
    p buy
    if buy.count <= 3
      update(recommended_buy_price: most_recent.buy_average)
    else
      buy.reject_outliers!
      e = Ema.new a: 0.3
      buy.each do |n|
        e.compute current: n
      end
      update(recommended_buy_price: e.last)
    end
    sell = price_updates
           .where(created_at: 1.day.ago..DateTime.now)
           .order('created_at asc')
           .pluck(:sell_average)
           .reject { |x| x <= 0 }
    sell.extend Basic::Stats
    puts 'sell'
    puts sell.count
    p sell
    if sell.count <= 3
      update(recommended_sell_price: most_recent.sell_average)
    else
      sell.reject_outliers!
      e = Ema.new a: 0.3
      sell.each do |n|
        e.compute current: n
      end
      update(recommended_sell_price: e.last)
    end
    # rescue => e
    #   p e
    #   update(recommended_buy_price: most_recent.buy_average,
    #          recommended_sell_price: most_recent.sell_average)
  end

  def get_past_month(force = false, recursion = 0)
    puts "get_past_month on #{name}"
    return if timed_out? && !force
    return if recursion > 15
    puts 1
    time = (DateTime.now - 30).strftime('%Q')
    puts 11
    clnt = HTTPClient.new
    puts 111
    a = clnt.get_content("https://api.rsbuddy.com/grandExchange?a=graph&g=30&start=#{time}&i=#{runescape_id}")
    data = JSON.parse a
    puts 1111
    # TODO: Somehow fix this bug?
    # If the first entry is new-ish, retry the get
    # The rsbuddy api only seems to return it for the past week or so sometimes

    delta = (DateTime.now - DateTime.strptime(data[1]['ts'].to_s, '%Q'))
    puts 11111
    if delta < 25
      puts delta.to_i
      puts "https://api.rsbuddy.com/grandExchange?a=graph&g=30&start=#{time}&i=#{runescape_id}"
      puts 'Get failed! retrying'
      sleep 3
      return get_past_month(force, recursion + 1)
    end
    price_updates.destroy_all
    update(last_update_time: DateTime.now)
    data.each do |entry|
      p = price_updates.build
      p.buy_average = entry['sellingPrice'].to_i
      p.sell_average = entry['buyingPrice'].to_i
      if p.buy_average > p.sell_average
        p.buy_average, p.sell_average = p.sell_average, p.buy_average
      end
      p.overall_average = entry['overallPrice'].to_i
      p.created_at = DateTime.strptime(entry['ts'].to_s, '%Q')
      p.roi = if p.buy_average <= 0
                0
              else
                (p.sell_average.to_f - p.buy_average.to_f) / p.overall_average.to_f
              end
      p.save
    end
    update_ema
    update_roi(price_updates.last.roi)
    update_margin
  rescue => e
    logger.info "get_past_month failed for #{name} (id: #{runescape_id})"
    logger.debug e
    return "RSBuddy api broken, couldn't refresh"
  end

  def timed_out?
    return false if last_update_time.nil?
    (Time.now - last_update_time) < 30.seconds
  end

  def self.update_all
    thing = JSON.parse RestClient.get('https://rsbuddy.com/exchange/summary.json').body
    thing.each do |i|
      i = i[1]
      item = Item.find_or_create_by(runescape_id: i['id'])
      item.update(name: i['name'])
    end
  end
end
