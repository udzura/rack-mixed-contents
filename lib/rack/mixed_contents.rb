require 'json'

module Rack
  class MixedContents
    class Rule < Struct.new(:active, :default_src); end
    class RuleReportOnly < Struct.new(:active, :default_src, :report_uri); end

    def initialize(app, &b)
      @app = app
      @rule = Rule.new
      @rule_report_only = RuleReportOnly.new
      @on_reported = nil

      b.call(self)
    end

    def rule(&b)
      b.call(@rule)
      @rule.active = true
    end

    def report_only_rule(&b)
      b.call(@rule_report_only)
      @rule_report_only.report_uri ||= "/_/csp-reports"
      @rule_report_only.active = true
    end

    def on_reported(&b)
      @on_reported = b
    end

    def call(env)
      if @on_reported and env["PATH_INFO"] == @rule_report_only.report_uri
        json = JSON.parse(Rack::Request.new(env).body)
        begin
          @on_reported.call(json)
          return [200, {"Content-Type" => "text/plain"}, ["Request accepted"]]
        rescue
          return [503, {"Content-Type" => "text/plain"}, ["Request failed"]]
        end
      end

      res = Rack::Response.new(@app.call(env))
      res['Content-Security-Policy'] = "default-src '#{@rule.default_src}'" if @rule.active
      res['Content-Security-Policy-Report-Only'] = "default-src '#{@rule_report_only.default_src}'; report-uri #{@rule_report_only.report_uri}" if @rule_report_only.active
      res.finish
    end
  end
end
