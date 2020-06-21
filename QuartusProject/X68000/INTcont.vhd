library IEEE,work;
use IEEE.std_logic_1164.all;
use	IEEE.std_logic_unsigned.all;

entity INTcont is
generic(
	INText	:integer	:=3
);
port(
	int7	:in std_logic	:='0';
	vect7	:in std_logic_vector(7 downto 0)	:=x"1f";
	iack7	:out std_logic;
	e_ln7	:in std_logic	:='1';
	ivack7	:out std_logic_vector(7 downto 0);
	
	int6	:in std_logic	:='0';
	vect6	:in std_logic_vector(7 downto 0)	:=x"1e";
	iack6	:out std_logic;
	e_ln6	:in std_logic	:='1';
	ivack6	:out std_logic_vector(7 downto 0);
	
	int5	:in std_logic	:='0';
	vect5	:in std_logic_vector(7 downto 0)	:=x"1d";
	iack5	:out std_logic;
	e_ln5	:in std_logic	:='1';
	ivack5	:out std_logic_vector(7 downto 0);
	
	int4	:in std_logic	:='0';
	vect4	:in std_logic_vector(7 downto 0)	:=x"1c";
	iack4	:out std_logic;
	e_ln4	:in std_logic	:='1';
	ivack4	:out std_logic_vector(7 downto 0);
	
	int3	:in std_logic	:='0';
	vect3	:in std_logic_vector(7 downto 0)	:=x"1b";
	iack3	:out std_logic;
	e_ln3	:in std_logic	:='1';
	ivack3	:out std_logic_vector(7 downto 0);
	
	int2	:in std_logic	:='0';
	vect2	:in std_logic_vector(7 downto 0)	:=x"1a";
	iack2	:out std_logic;
	e_ln2	:in std_logic	:='1';
	ivack2	:out std_logic_vector(7 downto 0);
	
	int1	:in std_logic	:='0';
	vect1	:in std_logic_vector(7 downto 0)	:=x"19";
	iack1	:out std_logic;
	e_ln1	:in std_logic	:='1';
	ivack1	:out std_logic_vector(7 downto 0);
	
	IPL		:out std_logic_vector(2 downto 0);
	addrin	:in std_logic_vector(23 downto 0);
	addrout	:out std_logic_vector(23 downto 0);
	rw		:in std_logic;
	dtack	:in std_logic;
	
	clk		:in std_logic;
	rstn	:in std_logic
);
end INTcont;
architecture rtl of INTcont is
signal	INTnum	:std_logic_vector(2 downto 0);
signal	vINT	:std_logic_vector(7 downto 1);
signal	sINT	:std_logic_vector(7 downto 1);
signal	lINT	:std_logic_vector(7 downto 1);
signal	ve_ln	:std_logic_vector(7 downto 1);
signal	INTe	:std_logic_vector(7 downto 1);
signal	INTclr	:std_logic_vector(2 downto 0);
signal	lINTclr	:std_logic_vector(2 downto 0);
signal	INTact	:std_logic_vector(2 downto 0);
signal	vect1l	:std_logic_vector(7 downto 0);
signal	vect2l	:std_logic_vector(7 downto 0);
signal	vect3l	:std_logic_vector(7 downto 0);
signal	vect4l	:std_logic_vector(7 downto 0);
signal	vect5l	:std_logic_vector(7 downto 0);
signal	vect6l	:std_logic_vector(7 downto 0);
signal	vect7l	:std_logic_vector(7 downto 0);
signal	ldtack	:std_logic;
signal	ackcount:integer range 0 to INText;
signal	INTen	:std_logic;
begin
			
	vINT<=int7 & int6 & int5 & int4 & int3 & int2 & int1;
	ve_ln<=e_ln7 & e_ln6 & e_ln5 & e_ln4 & e_ln3 & e_ln2 & e_ln1;
	
	INTnum<=
			"000"	when INTe(7)='1' else
			"001"	when INTe(6)='1' else
			"010"	when INTe(5)='1' else
			"011"	when INTe(4)='1' else
			"100"	when INTe(3)='1' else
			"101"	when INTe(2)='1' else
			"110"	when INTe(1)='1' else
			"111";
	
	process(clk,rstn)begin
		if(rstn='0')then
			ldtack<='1';
			ackcount<=0;
		elsif(clk' event and clk='1')then
			ldtack<=dtack;
			if(INTclr/="000")then
				ackcount<=INText;
				INTact<=INTclr;
			elsif(dtack='1' and ldtack='0' and ackcount>0)then
				ackcount<=ackcount-1;
			end if;
		end if;
	end process;
	INTen<='1' when INTclr/="000" or ackcount>0 else '0';
--	INTen<='1';
	addrout<=
			addrin	when rw='0' else	--or INTen='0' 
			"00000000000000" & vect7l & addrin(1 downto 0) when addrin(23 downto 2)="0000000000000000011111"  else
			"00000000000000" & vect6l & addrin(1 downto 0) when addrin(23 downto 2)="0000000000000000011110"  else
			"00000000000000" & vect5l & addrin(1 downto 0) when addrin(23 downto 2)="0000000000000000011101"  else
			"00000000000000" & vect4l & addrin(1 downto 0) when addrin(23 downto 2)="0000000000000000011100"  else
			"00000000000000" & vect3l & addrin(1 downto 0) when addrin(23 downto 2)="0000000000000000011011"  else
			"00000000000000" & vect2l & addrin(1 downto 0) when addrin(23 downto 2)="0000000000000000011010"  else
			"00000000000000" & vect1l & addrin(1 downto 0) when addrin(23 downto 2)="0000000000000000011001"  else
			addrin;
	
	INTclr<=
			"000"	when rw='0' else
			"111"	when INTe(7)='1' and addrin(23 downto 2)="0000000000000000011111"  else
			"110"	when INTe(6)='1' and addrin(23 downto 2)="0000000000000000011110"  else
			"101"	when INTe(5)='1' and addrin(23 downto 2)="0000000000000000011101"  else
			"100"	when INTe(4)='1' and addrin(23 downto 2)="0000000000000000011100"  else
			"011"	when INTe(3)='1' and addrin(23 downto 2)="0000000000000000011011"  else
			"010"	when INTe(2)='1' and addrin(23 downto 2)="0000000000000000011010"  else
			"001"	when INTe(1)='1' and addrin(23 downto 2)="0000000000000000011001"  else
			"000";

	process(clk,rstn)begin
		if(rstn='0')then
			sINT<=(others=>'0');
			lINT<=(others=>'0');
			lINTclr<=(others=>'0');
		elsif(clk' event and clk='1')then
			sINT<=vINT;
			lINT<=sINT;
			lINTclr<=INTclr;
		end if;
	end process;

	process(clk,rstn)
	variable iINTact	:integer range 0 to 7;
	begin
		if(rstn='0')then
			INTe<=(others=>'0');
		elsif(clk' event and clk='1')then
			iINTact:=conv_integer(INTact);
			for i in 1 to 7 loop
				if(ve_ln(i)='1')then
					if(sINT(i)='1' and lINT(i)='0')then
						INTe(i)<='1';
					else
						if(i=iINTact and ackcount=1)then
							INTe(i)<='0';
						end if;
					end if;
				else
					INTe(i)<=sINT(i);
				end if;
			end loop;
		end if;
	end process;
			
--	process(clk,rstn)begin
--		if(rstn='0')then
--			INTe<=(others=>'0');
--		elsif(clk' event and clk='1')then
--			for i in 1 to 7 loop
--				if(sINT(i)='1' and lINT(i)='0')then
--					INTe(i)<='1';
--				elsif(sINT(i)='0')then
--					INTe(i)<='0';
--				end if;
--			end loop;
--			if(INTclr="000")then
--				case lINTclr is
--				when "111"	=>
--					if(e_ln7='1')then
--						INTe(7)<='0';
--					end if;
--				when "110" =>
--					if(e_ln6='1')then
--						INTe(6)<='0';
--					end if;
--				when "101" =>
--					if(e_ln5='1')then
--						INTe(5)<='0';
--					end if;
--				when "100" =>
--					if(e_ln4='1')then
--						INTe(4)<='0';
--					end if;
--				when "011" =>
--					if(e_ln3='1')then
--						INTe(3)<='0';
--					end if;
--				when "010" =>
--					if(e_ln2='1')then
--						INTe(2)<='0';
--					end if;
--				when "001" =>
--					if(e_ln1='1')then
--						INTe(1)<='0';
--					end if;
--				when others =>
--				end case;
--			end if;
--		end if;
--	end process;
	
	process(clk,rstn)begin
		if(rstn='0')then
			iack7<='0';
			iack6<='0';
			iack5<='0';
			iack4<='0';
			iack3<='0';
			iack2<='0';
			iack1<='0';
		elsif(clk' event and clk='1')then
			iack7<='0';
			iack6<='0';
			iack5<='0';
			iack4<='0';
			iack3<='0';
			iack2<='0';
			iack1<='0';
			if(ackcount=1)then
				case INTact is
				when "111" =>
					iack7<='1';
				when "110" =>
					iack6<='1';
				when "101" =>
					iack5<='1';
				when "100" =>
					iack4<='1';
				when "011" =>
					iack3<='1';
				when "010" =>
					iack2<='1';
				when "001" =>
					iack1<='1';
				when others =>
				end case;
			end if;
		end if;
	end process;
				
	
	process(clk,rstn)begin
		if(rstn='0')then
			vect1l<=(others=>'0');
			vect2l<=(others=>'0');
			vect3l<=(others=>'0');
			vect4l<=(others=>'0');
			vect5l<=(others=>'0');
			vect6l<=(others=>'0');
			vect7l<=(others=>'0');
			ivack1<=(others=>'0');
			ivack2<=(others=>'0');
			ivack3<=(others=>'0');
			ivack4<=(others=>'0');
			ivack5<=(others=>'0');
			ivack6<=(others=>'0');
			ivack7<=(others=>'0');
		elsif(clk' event and clk='1')then
			if(INTclr/="001" and INTen='0')then
				vect1l<=vect1;
			elsif(INTclr="001")then
				ivack1<=vect1l;
			end if;
			if(INTclr/="010" and INTen='0')then
				vect2l<=vect2;
			elsif(INTclr="010")then
				ivack2<=vect2l;
			end if;
			if(INTclr/="011" and INTen='0')then
				vect3l<=vect3;
			elsif(INTclr="011")then
				ivack3<=vect3l;
			end if;
			if(INTclr/="100" and INTen='0')then
				vect4l<=vect4;
			elsif(INTclr="100")then
				ivack4<=vect4l;
			end if;
			if(INTclr/="101" and INTen='0')then
				vect5l<=vect5;
			elsif(INTclr="101")then
				ivack5<=vect5l;
			end if;
			if(INTclr/="110" and INTen='0')then
				vect6l<=vect6;
			elsif(INTclr="110")then
				ivack6<=vect6l;
			end if;
			if(INTclr/="111" and INTen='0')then
				vect7l<=vect7;
			elsif(INTclr="111")then
				ivack7<=vect7l;
			end if;
		end if;
	end process;
			
	IPL<=INTnum;
end rtl;

			