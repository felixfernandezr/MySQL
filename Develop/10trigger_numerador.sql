ALTER TABLE hora
DROP PRIMARY KEY,
CHANGE hor_log hor_log int primary key;

create table numerador(
    nombre_tabla varchar(50),
    siguiente int
);


create table eliminado(
    nombre_tabla varchar(50),
    siguiente int
);

DELIMITER $$

create trigger numerador_en_hora before insert on hora
for each row
begin

	select max(hor_log) into @max from hora;
	
	if isnull(@max) then
		set @max = 1;
	end if;
	
    set @sig = @max + 1;
	select siguiente into @sig from eliminado where nombre_tabla = 'hora' order by siguiente desc limit 1;

	-- if isnull(@sig) then
		-- set @sig = @max + 1;
	-- end if;
    
    if @max <=> @sig then
		select siguiente into @sig from numerador where nombre_tabla = 'hora' order by siguiente desc limit 1;
		-- if isnull(@sig) then
			-- set @sig = @max + 1;
		-- end if;
    end if;
    
    set new.hor_log = @sig;
    
    insert into eliminado(nombre_tabla, siguiente)
    values('hora', @sig);
    
    set @sig = @sig + 1;
    
    insert into numerador(nombre_tabla, siguiente)
    values('hora', @sig);

end;
 
 drop trigger numerador_en_hora;
 
create trigger delete_en_hora before delete on hora
for each row
begin

	set @sig = old.hor_log;
    
    insert into eliminado(nombre_tabla, siguiente)
    values('hora', @sig);
    
end;

$$