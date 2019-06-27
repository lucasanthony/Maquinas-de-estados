logic[1:0] state;
logic vintecinco;
logic cinquenta;
logic um;
logic resetar;

logic[6:0] total;

always_comb begin
	vintecinco <= SWI[0];
	cinquenta <= SWI[1];
	um <= SWI[2];
	resetar <= SWI[7];
end

parameter inicio = 0, sumState25 = 1, sumState50 = 2, sumState1 = 3;

always_ff @(posedge clk_2) begin
	
	if(resetar) begin
		state <= inicio;
		total <= 0;
	end
	else
		unique case(state)
			inicio: begin
				if (vintecinco && total < 100) begin
					state <= sumState25;
				end
				else if (cinquenta && total < 100) begin
					state <= sumState50;
				end
				else if (um && total < 100) begin
					state <= sumState1;
				end
			end
			
			sumState25: begin
				if (!vintecinco) begin
					state <= inicio;
					total <= total + 25;
				end
			end

			sumState50: begin
				if (!cinquenta) begin
					state <= inicio;
					total <= total + 50;
				end
			end

			sumState1: begin
				if (!um) begin
					state <= inicio;
					total <= total + 100;
				end
			end
		endcase


end

always_comb begin
	LED[6:0] <= total;
	LED[7] <= clk_2;
end
