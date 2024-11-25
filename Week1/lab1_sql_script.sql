select * from player_seasons;

--Creating a data type with the necessary attributes for a payer name
create type season_stats as (
	season INTEGER,
	gp INTEGER,
	pts REAL,
	reb REAL,
	ast REAL
)

create type scoring_class as enum ('star', 'good', 'average', 'bad');

create table players (
	player_name text,
	height text,
	college text,
	country text,
	draft_year text,
	draft_round text,
	draft_number text,
	season_stats season_stats[],
	scoring_class scoring_class,
	years_since_last_season INTEGER,
	current_season INTEGER,
	primary key(player_name, current_season)
);


--select MIN(season) from player_seasons ps ;
--Min is 1996
insert into players 
with yesterday as (
	select * from players
	where current_season = 2000
),
	today as (
		select * from player_seasons
		where season = 2001
	)
select 
	coalesce(t.player_name, y.player_name) as player_name,
	coalesce(t.height, y.height) as height,
	coalesce(t.college, y.college) as college,
	coalesce(t.country, y.country) as country,
	coalesce(t.draft_year, y.draft_year) as draft_year,
	coalesce(t.draft_round, y.draft_round) as draft_round,
	coalesce(t.draft_number, y.draft_number) as draft_number,
	CASE when y.season_stats is null
		then array[row(
			t.season,
			t.gp,
			t.pts,
			t.reb,
			t.ast
		)::season_stats]
	when t.season is not null THEN y.season_stats || array[row(
			t.season,
			t.gp,
			t.pts,
			t.reb,
			t.ast
		)::season_stats]
	else y.season_stats
	END as season_stats,
	case
		when t.season is not null then
		case when t.pts > 20 then 'star'
			when t.pts > 15 then 'good'
			when t.pts > 10 then 'average'
			else 'bad'
		end::scoring_class
		else y.scoring_class
	end as scoring_class,
	
	case when t.season is not null then 0
		else y.years_since_last_season + 1
		end as years_since_last_season,
	coalesce (t.season, y.current_season + 1) as current_season
from today t
full outer join yesterday y on t.player_name = y.player_name;

select * from players 
where current_season = 2001
and player_name = 'Michael Jordan'

--select count(*) from players p ;

--with the new players table it is possible to get back the original player_season tables. kinda like explode
--This cumulative technique will also make sure the shuffling is not happening, resulting in the sorted row as is from the original table.
select player_name, (unnest(season_stats)::season_stats).* as season_stats
from players
where current_season = 2001

select
	player_name,
	season_stats[1] as first_season,
	season_stats[cardinality(season_stats)] as latest_season
from players 
where current_season = 2001

--From the above it can be converted to the following to compare different season results
select
	player_name,
	(season_stats[cardinality(season_stats)]::season_stats).pts as latest_season,
	(season_stats[1]::season_stats).pts as first_season,
from players 
where current_season = 2001

--Furthermore, operations can be performed for example improvement measured in times
select
	player_name,
	(season_stats[cardinality(season_stats)]::season_stats).pts /
	case when (season_stats[1]::season_stats).pts = 0 then 1 else (season_stats[1]::season_stats).pts end as Improvement
from players 
where current_season = 2001
order by Improvement DESC