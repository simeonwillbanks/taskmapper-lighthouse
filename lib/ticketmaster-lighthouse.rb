require 'lighthouse-api'
require File.dirname(__FILE__) + '/api/monkey.rb'
# Monkey Patch - remove when the lighthouse gem gets updated.
# texel's changes got merged, but looks like a new gem didn't get released. ugh!
module Lighthouse
  class Ticket
    protected
      def cleanup_tags(tags)
        tags.tap do |tag|
          tag.collect! do |t|
            unless tag.blank?
              t = Tag.new(t,prefix_options[:project_id])
              t.downcase!
              t.gsub! /(^')|('$)/, ''
              t.gsub! /[^a-z0-9 \-_@\!']/, ''
              t.strip!
              t.prefix_options = prefix_options
              t
            end
          end
          tag.compact!
          tag.uniq!
        end
      end
    
  end
end

%w{ lighthouse ticket project comment }.each do |f|
  require File.dirname(__FILE__) + '/provider/' + f + '.rb';
end

