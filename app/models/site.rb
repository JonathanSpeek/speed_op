class Site < ActiveRecord::Base
  belongs_to :user

  has_many :webstats

  validates_format_of :url, :with => URI::regexp(%w(http https)),
    :message => 'Please include http:// before the domain name.'

  def update_score
    ps_d = Pagespeed.new(self)
    ps_m = Pagespeed.new(self, true)
    self.webstats.create(
      pull_date: Time.zone.now,
      desktop_score: ps_d.speed,
      mobile_score: ps_m.speed,
      mobile_usability: ps_m.usability
    )

  end

  def self.update_scores
    all.each do |site|
      site.update_score
    end
  end

  def self.to_csv(options = {})
    CSV.generate(options) do |csv|
      csv << column_names
      all.each do |site|
        csv << site.attributes.values_at(*column_names)
      end
    end
  end
end
