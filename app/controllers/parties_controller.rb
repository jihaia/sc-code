class PartiesController < BaseController
    before_action :set_party, only: [:show, :edit, :update, :destroy]

    # GET /parties
    # GET /parties.json
    def index
        respond_to do |format|
            format.json { render json: process_search(Party, :json) }
            format.html # index.html.erb
        end
    end # def index

    # GET /parties/new
    def new
        @party = Party.new numgsts: 0
    end # def new

    # POST /parties
    # POST /parties.json
    def create
        @party = Party.new(party_params)

        respond_to do |format|
            if @party.save
                format.html { redirect_to parties_url, notice: 'Party was successfully created.' }
                format.json { render :show, status: :created }
            else
                format.html { render :new }
                format.json { render json: @party.errors, status: :unprocessable_entity }
            end
        end
    end # def create

    private

    # Generic handler to fetch the requested instance by identifier
    def set_party
        @party = Party.find(params[:id])
    end # def set_party

    # Never trust parameters from the scary internet, only allow the white list through.
    def party_params
        params.require(:party).permit(:id, :email, :host_name, :host_email, :numgsts, :guest_names,
                                      :venue, :location, :theme, :when, :when_its_over, :descript)
    end # def party_params
end # class PartiesController
