logic[2:0] state;
logic reset;
logic passe1;
logic passe2;
logic carrega1;
logic carrega2;

logic total1;
logic total2;

logic catraca;

always_comb begin
	reset <= SWI[6];
	passe1 <= SWI[0];
	passe2 <= SWI[1];
	carrega1 <= SWI[3];
	carrega2 <= SWI[4];
end

parameter inicio = 0, pass1 = 1, pass2 = 2, load1 = 3, load2 = 4;

always_ff @(posedge clk_2) begin
	if (reset) begin
		state <= inicio;
		total1 <= 0;
		total2 <= 0;
	end
	else
		unique case(state)
			inicio: begin
				if (passe1 && total1 > 0) begin
					catraca <= 1;
					state <= pass1;
				end
				else if (passe2 && total2 > 0) begin
					catraca <= 1;
					state <= pass2;
				end
				else if (carrega1 && total1 < 5) begin
					total1 <= total1 + 1;
					state <= load1;
				end
				else if (carrega2 && total2 < 5) begin
					total2 <= total2 + 1;
					state <= load2;
				end
			end
			pass1: begin
				if (!passe1) begin
					total1 <= total1 - 1;
					catraca <= 0;
					state <= inicio;
				end
			end
			pass2: begin
				if (!passe2) begin
					total2 <= total2 - 1;
					catraca <= 0;
					state <= inicio;
				end
			end
			load1: begin
				if (!load1) begin
					state <= inicio;
				end
			end
			load2: begin
				if (!load2) begin
					state <= inicio;
				end
			
			end
		endcase
end

always_comb begin
	LED[7] <= clk_2;
	LED[0] <= catraca;
	LED[6:5] <= total1;
end
