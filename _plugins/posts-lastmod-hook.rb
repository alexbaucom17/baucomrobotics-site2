#!/usr/bin/env ruby
#
# Check for changed posts

Jekyll::Hooks.register :posts, :post_init do |post|
  # Define the cutoff date (ISO format so Ruby Time can parse it)
  cutoff_date = Time.parse("2025-11-09T00:00:00-0700")

  commit_num = `git rev-list --count HEAD "#{ post.path }"`.to_i

  if commit_num > 1
    lastmod_str = `git log -1 --pretty="%ad" --date=iso "#{ post.path }"`.strip
    lastmod_time = Time.parse(lastmod_str) rescue nil

    # Only apply if the lastmod date is AFTER the cutoff
    if lastmod_time && lastmod_time > cutoff_date
      post.data['last_modified_at'] = lastmod_time.iso8601
    end
  end
end
