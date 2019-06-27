enum logic[3:0] {INICIO, Q1, Q2, Q3, UM, TRES, FINAL, ERRO, TRANSICAO} estado;
logic cartao, clk_1, dinheiro, destruicao, control, reset;
logic[6:4] codigo; 
logic[1:0] tentativas;

always_ff @(posedge clk_2) begin
	clk_1 = ~clk_1;
end

always_comb begin
    reset <= SWI[0];
    cartao <= SWI[1];
    codigo <= SWI[6:4];
end

always_ff @(posedge clk_1) begin
    if(reset) begin
	control <= 1;
        estado <= INICIO;
        tentativas <= 0;
    end
    else begin
        unique case(estado)
         	INICIO: if(cartao) begin    
			estado <= Q1;
			end
		Q1: if(tentativas == 3) begin
			estado <= ERRO;
			destruicao <= 1;
			end
		   else if(codigo == 1) begin
			estado <= UM;
			control <= 1;
			end
		    else if (codigo != 1 && codigo != 0) begin
			tentativas <= tentativas + 1;
			estado <= TRANSICAO;
		    end
		   else
			estado <= Q1;

		UM: if(codigo[4]+codigo[5]+codigo[6] == 0) begin
			estado <= Q2;
			control <= 0;
			end
		Q2: if(tentativas == 3) begin
			estado <= ERRO;
			destruicao <= 1;
			end
		    else if(codigo == 3) begin
			estado <= TRES;
			control <= 1;
			end
		    else if (codigo != 3 && codigo != 0) begin
			tentativas <= tentativas + 1;
			estado <= TRANSICAO;
		    end
		TRES: if(codigo[4]+codigo[5]+codigo[6] == 0) begin
			estado <= Q3;
			control <= 0;
			end
		Q3: if(tentativas == 3) begin
			estado <= ERRO;
			destruicao <= 1;
			end
		    else if(codigo == 7) begin
			estado <= FINAL;
			control <= 1;
			end
		    else if (codigo != 7 && codigo != 0) begin
			tentativas <= tentativas + 1;
			estado <= TRANSICAO;
		    end
		TRANSICAO: if(codigo[4]+codigo[5]+codigo[6] == 0) begin
				estado <= Q1;
			end
		FINAL: begin
			control <= 1;
			dinheiro <= 1;
		end
        endcase
    end
end

always_comb begin
    LED[1] <= destruicao;
    LED[0] <= dinheiro; 
    LED[7] <= clk_1;
    SEG[7] <= control;
end
