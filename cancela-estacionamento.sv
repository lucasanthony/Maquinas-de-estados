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
