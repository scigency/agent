class JournalsController < ApplicationController
  # GET /journals
  # GET /journals.xml
  def index
    @journals = Journal.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @journals }
    end
  end

  # GET /journals/1
  # GET /journals/1.xml
  def show
    @journal = Journal.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @journal }
    end
  end

  # GET /journals/new
  # GET /journals/new.xml
  def new
    @journal = Journal.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @journal }
    end
  end

  # GET /journals/1/edit
  def edit
    @journal = Journal.find(params[:id])
  end

  # POST /journals
  # POST /journals.xml
  def create
    @journal = Journal.new(params[:journal])

    respond_to do |format|
      if @journal.save
        format.html { redirect_to(@journal, :notice => 'Journal was successfully created.') }
        format.xml  { render :xml => @journal, :status => :created, :location => @journal }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @journal.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /journals/1
  # PUT /journals/1.xml
  def update
    @journal = Journal.find(params[:id])

    respond_to do |format|
      if @journal.update_attributes(params[:journal])
        format.html { redirect_to(@journal, :notice => 'Journal was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @journal.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /journals/1
  # DELETE /journals/1.xml
  def destroy
    @journal = Journal.find(params[:id])
    @journal.destroy

    respond_to do |format|
      format.html { redirect_to(journals_url) }
      format.xml  { head :ok }
    end
  end

  def top
    subject_ids = params[:ids].split(/,/).uniq.compact.reject {|id| id.blank?} if params[:ids].present?
    @journals = []
    if subject_ids.present?
      if subject_ids.size == 1
        @journals = JournalSubject.where(:subject_id => subject_ids.first).where(:year => 0).order("articles_count desc").limit(20).includes(:journal).map {|js| js.journal}
      else
        article_ids = ArticleSubject.select("article_id, count(*) subjects").where(:subject_id => subject_ids).group(:article_id).having("subjects=#{subject_ids.size}").map{|as| as.article_id}
        journal_ids = Article.where(:id => article_ids).group(:journal_id).select("journal_id, count(*) articles").order("articles desc").limit(20).map {|a| a.journal_id}
        @journals = Journal.find(journal_ids)
      end
    end
    render :layout => false
  end
end
