module Adhoq
  class Execution < ActiveRecord::Base
    include Adhoq::TimeBasedOrders

    belongs_to :query
    has_one    :report, dependent: :destroy, inverse_of: :execution

    delegate   :supported_formats, to: Adhoq::Reporter

    def generate_report!
      build_report.generate!
    end

    def name
      [query.name, created_at.strftime('%Y%m%d-%H%M%S'), report_format].join('.')
    end

    def success?
      report.try(:available?)
    end

    # TODO go decorator or view model or so
    def status_label
      success? ? :success : :failure
    end
  end
end
