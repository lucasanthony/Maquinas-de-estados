
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

/////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////

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


////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////// PARABRISA /////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////

logic reset;
enum logic[2:0] {LIMPADOR_DESLIGADO,Q1,Q2,Q3,LIPADOR_BAIXO,LIMPADOR_ALTO} estado;
logic[5:0] chuva;
logic[1:0] parabrisa;
logic clk_1;
always_ff @(posedge clk_2) clk_1 = ~clk_1;
always_comb begin
    reset <= SWI[6];
    chuva <= SWI[5:0];
end

always_ff @(posedge clk_1) begin
    if(reset) begin
        estado <= LIMPADOR_DESLIGADO;
        parabrisa <= 0;
    end
    else begin
        unique case(estado)
            LIMPADOR_DESLIGADO : begin 
            if((chuva[0]+chuva[1]+chuva[2]+chuva[3]+chuva[4]+chuva[5]) == 3) begin
                estado <= Q1;

            end
            else if((chuva[0]+chuva[1]+chuva[2]+chuva[3]+chuva[4]+chuva[5]) == 5) begin
                estado <= Q3;
            end
            end
            Q1: begin
                if((chuva[0]+chuva[1]+chuva[2]+chuva[3]+chuva[4]+chuva[5]) == 3) begin
                estado <= Q2;
            end
            else if((chuva[0]+chuva[1]+chuva[2]+chuva[3]+chuva[4]+chuva[5]) == 5) begin
                estado <= Q3;
            end
            end
            Q2: begin
                if((chuva[0]+chuva[1]+chuva[2]+chuva[3]+chuva[4]+chuva[5]) >= 3) begin
                estado <= LIPADOR_BAIXO;
                parabrisa <= 1;
            end
                else if((chuva[0]+chuva[1]+chuva[2]+chuva[3]+chuva[4]+chuva[5]) == 5) begin
                estado <= Q3;
            end
            end
            LIPADOR_BAIXO:
                if((chuva[0]+chuva[1]+chuva[2]+chuva[3]+chuva[4]+chuva[5]) < 2) begin
               		estado <= LIMPADOR_DESLIGADO;
                	parabrisa <= 0;
            	end
		else if ((chuva[0]+chuva[1]+chuva[2]+chuva[3]+chuva[4]+chuva[5]) == 5) begin
			estado <= Q3;
		end
            Q3: begin
                if((chuva[0]+chuva[1]+chuva[2]+chuva[3]+chuva[4]+chuva[5]) == 5) begin
                estado <= LIMPADOR_ALTO;
                parabrisa <= 2;
            end
            end
            LIMPADOR_ALTO: begin
                if((chuva[0]+chuva[1]+chuva[2]+chuva[3]+chuva[4]+chuva[5]) < 4) begin
                estado <= LIPADOR_BAIXO;
                parabrisa <= 1;
            end
            end
        endcase
    end
end

always_comb begin
    SEG[7] <= clk_1;
    LED[1:0] <= parabrisa;
end


