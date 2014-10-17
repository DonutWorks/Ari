class NoticeToChecker
  def check(notice)
    responses_go = Response.responsed_to_go(notice)

    if notice.to > responses_go.count
      status = :go
    else
      status = :wait
    end

    return status
  end
end