CREATE TABLE IF NOT EXISTS sports_in_season_tickets (
    sports_type_id integer,
    season_ticket_id integer,
    primary key (sports_type_id, season_ticket_id)
);