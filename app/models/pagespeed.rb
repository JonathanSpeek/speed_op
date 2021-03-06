require 'google/apis/pagespeedonline_v2'

class Pagespeed
  attr_accessor :site, :mobile
  delegate :url, to: :site
  # belongs_to :site

  def initialize(site, mobile = false)
    @site = site
    @mobile = mobile
  end

  def speed
    results.rule_groups['SPEED'].score
  end

  def usability
    if mobile == false
      return nil
    end
    results.rule_groups['USABILITY'].score
  end

  def rule_result_keys
    @rule_result_keys ||= results.formatted_results.rule_results.keys
  end

  def score(key)
    results.formatted_results.rule_results[key].rule_impact
  end

  def suggestion(key)
    results.formatted_results.rule_results[key].localized_rule_name
  end

  private
  def service
    Google::Apis::PagespeedonlineV2::PagespeedonlineService.new
  end

  def results
    @results ||= service.run_pagespeed(url, strategy: strategy)
  end

  def strategy
    if mobile == true
      'mobile'
    else
      'desktop'
    end
  end
end
