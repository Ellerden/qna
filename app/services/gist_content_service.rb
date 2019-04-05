class GistContentService
  def initialize(gist, client: default_client)
    @gist = gist
    @client = client
  end

  #GET /gists/:gist_id
  def call
    result = @client.gist(@gist)
    result.files.first[1].content if result.html_url.present?
  end

  private

  def default_client
    Octokit::Client.new(access_token: ENV['GITHUB_TOKEN'])
  end
end
