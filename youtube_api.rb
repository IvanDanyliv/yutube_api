require 'google/apis/youtube_v3'
require 'pry'

youtube = Google::Apis::YoutubeV3::YouTubeService.new
youtube.key = 'YOUTUBE_API_KEY'

search_results = youtube.list_searches('id,snippet', q: ARGV[0], type: 'channel,video', max_results: 10)

search_results.items.each do |search_result|
	channel_id = search_result.snippet.channel_id
  channel = youtube.list_channels('id,snippet,statistics,topicDetails,brandingSettings,contentOwnerDetails', id: channel_id).items.first
	activities = youtube.list_activities('snippet,contentDetails', channel_id: channel_id).items.first
	puts "Назва каналу: #{channel.snippet.title}"
	puts "Кількість підписників: #{channel.statistics.subscriber_count}"
	puts "Кількість відео: #{channel.statistics.video_count}"
	puts "Середня кількість переглядів на відео: #{channel.statistics.view_count.to_i/channel.statistics.video_count.to_i}"
	puts "Опис каналу: #{channel.snippet.description}"
	puts "Email: #{channel.snippet.description.scan(/\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}\b/)}"
	puts "Соціальні мережі: #{activities.content_details.social}" if activities.content_details.social
	puts "_________________________________________________________________________________________________________"
end
