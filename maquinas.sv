logic[1:0] state;
logic cancela1;
logic cancela2;
logic resetar;

logic[4:0] numCarros;

	// Entradas:
always_comb begin 
	cancela1 <= SWI[0];
	cancela2 <= SWI[7];
	resetar <= SWI[3];
	end


	// Estados 
parameter q0 = 0, q1 = 1, q2 = 2;
	
	// Maquina de estados
always_ff @(posedge clk_2) begin
		// Reset dos estados 
	if(resetar) begin
		state <= q0;
		numCarros <= 0;
	end

	else
		unique case(state) 	// switch case dos estados 
			q0 : begin
				if(cancela1 && numCarros < 10) begin 
					state <= q1;
				end

				else if(cancela2 && numCarros > 0) begin
					state <= q2;
				end	
			end

			q1 : begin
				if(!cancela1) begin 
				numCarros <= numCarros + 1;
				state <= q0;
				end
			end

			q2 : begin
				if(!cancela2) begin
				numCarros <= numCarros - 1;
				state <= q0;
				end
			end
		endcase
	end

always_comb begin
	LED[6:3] <= numCarros;
	LED[7] <= clk_2;
	LED[0] <= cancela1;
	LED[1] <= cancela2;
end

/////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////// MOEDAS //////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////

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
