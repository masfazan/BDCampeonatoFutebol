use BDCampeonatoFutebol
create table Campeonato(
ano date not null,
nomecamp varchar (200) not null,
vencedor varchar (100) 
constraint pk_Campeonato primary key (nomecamp));
create table Time_Futebol(
id_time int identity (1,1) not null,
data_criacao date not null,
apelido varchar(100) not null,
nometime varchar(100) not null,
pontuacao int,
gols_marcados int,
gols_sofridos int,
constraint pk_Time_Futebol primary key (nometime));
create table Partida(
id_partida int identity (1,1) not null,
nomecampeonato varchar (200) not null,
time_mandante varchar(100) not null,
time_visitante varchar(100) not null,
gols_mandante int,
gols_visitante int,
total_gols int,
venc_partida varchar (100) not null
constraint pk_Partida primary key(id_partida)
constraint fk_time_mandante foreign key(time_mandante) references Time_Futebol(nometime),
constraint fk_time_visitante foreign key(time_visitante) references Time_Futebol(nometime),
constraint fk_venc_partida foreign key(venc_partida) references Time_Futebol(nometime),
constraint fk_nome_campeonato foreign key(nomecampeonato) references Campeonato(nomecamp)
);

go
create or alter procedure Inserir_Campeonato
	@nomecamp varchar(200),
	@ano date
as
begin
insert into Campeonato
	([nomecamp],[ano])
values (@nomecamp,@ano);
end;

go
create or alter procedure Inserir_Time
	@id_time int,
	@nometime varchar(100),
	@data_criacao date,
	@apelido varchar(100)
as
if (@id_time <5)
begin
insert into Time_Futebol
	([nometime],[data_criacao],[apelido])
values (@nometime,@data_criacao,@apelido);

end;

go
create or alter procedure Inserir_Partida
	@id_partida int,
	@nomecampeonato varchar(200),
	@time_mandante varchar(100),
	@time_visitante varchar(100)
as
begin
insert into Partida
	([id_partida],[nomecampeonato],[time_mandante],[time_visitante])
values (@id_partida,@nomecampeonato,@time_mandante,@time_visitante);
end;

go
create or alter procedure Inserir_Atualizar_Gol
	@gols_mandante int,
	@gols_visitante int,
	@id_partida int,
	@gols_marcados int,
	@gols_sofridos int,
	@time_mandante varchar(100),
	@time_visitante varchar(100),
	@nometime varchar(100)
as
begin
update Partida
	set
	gols_mandante=@gols_mandante,
	gols_visitante=@gols_visitante
	where id_partida = @id_partida
update Time_Futebol
	set gols_marcados= gols_marcados+@gols_mandante,
		gols_sofridos= gols_sofridos+@gols_visitante
	where nometime=@time_mandante and nometime=@time_visitante
end;

go
create or alter procedure Atualizar_Pontuacao
as 
begin 
declare
	@time_mandante varchar(100),
	@time_visitante varchar(100),
	@gols_mandante int,
	@gols_visitante int,
	@venc_partida varchar (100),
	@pontuacao_mandante int,
	@pontuacao_visitante int,
	@id_partida int
select 
	@pontuacao_mandante=pontuacao
	from Time_Futebol
	where nometime=@time_mandante
select 
	@pontuacao_visitante=pontuacao
	from Time_Futebol
	where nometime=@time_visitante
if(@venc_partida is null)
begin
if(@gols_mandante>@gols_visitante)
begin
	set @pontuacao_mandante=5+@pontuacao_mandante
	set @venc_partida=@time_mandante
	update Time_Futebol set pontuacao=pontuacao+@pontuacao_mandante 
	where nometime=@time_mandante
	update Partida set venc_partida=@venc_partida
	where id_partida=@id_partida
end;
if(@gols_visitante>@gols_mandante)
begin
	set @pontuacao_visitante=3+@pontuacao_visitante
	set @venc_partida=@time_visitante
	update Time_Futebol set pontuacao=pontuacao+@pontuacao_visitante 
	where nometime=@time_visitante
	update Partida set venc_partida = @venc_partida
	where id_partida=@id_partida
end;
if(@gols_visitante=@gols_mandante)
begin
	set @pontuacao_mandante=1+@pontuacao_mandante
	set @pontuacao_visitante=1+@pontuacao_visitante
	set @venc_partida=@time_visitante + @time_mandante 
	update Time_Futebol set pontuacao = pontuacao+@pontuacao_visitante 
	where nometime=@time_visitante
	update Time_Futebol set pontuacao = pontuacao+@pontuacao_mandante 
	where nometime=@time_mandante
	update Partida set venc_partida = @venc_partida
	where id_partida=@id_partida
end;
end;
end;

go

create or alter procedure Obter_Classificacao
	@pontuacao int
	as
	begin
	select top (5) * from Time_Futebol
	order by pontuacao desc;
	end;
go
create or alter procedure Time_Mais_Gols
	@gols_marcados int
	as
	begin
	select top 1 * from Time_Futebol
	order by gols_marcados desc;
end;
go
create or alter procedure Time_Menos_Gols
	@gols_sofridos int
as
begin
	select top 1 * from Time_Futebol
	order by gols_sofridos desc;
end;

go
create or alter procedure Partida_mais_gols
	@id_partida int,
	@gols_mandante int,
	@gols_visitante int,
	@total_gols int
as 
begin
select @total_gols,@gols_mandante,@gols_visitante
set @total_gols=@gols_mandante+@gols_visitante
update Partida set total_gols=@total_gols
where id_partida=@id_partida
select top(1)* from Partida
	order by total_gols desc;
end;

go
create or alter procedure Obter_Campeao
	@vencedor varchar (100)
as
begin
	set @vencedor=(select top(1)*from Time_Futebol order by pontuacao desc)
end;

exec Inserir_Time '','Palmeiras',' ', 'PAL'
exec Inserir_Time '','Corinthians','2024-03-03 ', 'COR'
exec Inserir_Time '','São Paulo','2024-02-02 ', 'SAP'
select* from Time_Futebol
exec Inserir_Campeonato 'Brasileirão','2024-01-01'--erro
select* from Campeonato
exec Inserir_Partida '','Brasileirão','Palmeiras','Corinthians'--erro
select* from Partida
exec Inserir_Atualizar_Gol
exec Atualizar_Pontuacao
--Classificação dos 5 primeiros
exec Obter_Classificacao
--Time com mais gols
exec Time_Mais_Gols
--Time com menos gols
exec Time_Menos_Gols
--Partida com mais gols
exec Partida_mais_gols
--Campeão
exec Obter_Campeao


