module AdminHelper

  def get_percent_happy(qid, q)
    @count = QuestionaireAnswer.find_by_sql("select avg(" + q.to_s + ") as "\
        "count from questionaire_answers where "\
        "quest_id = \"" + qid.to_s + "\"")    
  end
end
