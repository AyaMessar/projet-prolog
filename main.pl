
ligne(2, metro, [
		 [nation, 0],
		 [avron, 1],
		 [alexandre_dumas,2],
		 [philippe_auguste,1],
		 [pere_lachaise,2],
		 [menilmontant,2],
		 [couronnes,1],
		 [belleville,2],
		 [colonel_fabien,1],
		 [jaures,1],
		 [stalingrad,2],
		 [la_chapelle,1],
		 [barbes_rochechouart,3],
		 [anvers,2],
		 [pigalle,1],
		 [blanche,2],
		 [place_clichy,3],
		 [rome,2],
		 [villiers,3],
		 [monceau,2],
		 [courcelles,2],
		 [ternes,3],
		 [charles_de_gaulle_etoile,3],
		 [victor_hugo,2],
		 [porte_dauphine,3]
		 ], [[5,0],2,[1,45]], [[5,15],2,[1,55]]
).

ligne(3, metro, [
		 [pont_levallois_becon,0],
		 [anatole_france,2],
		 [louise_michel,3],
		 [porte_de_champerret,2],
		 [pereire,2],
		 [wagram,2],
		 [malesherbes,3],
		 [villiers,2],
		 [europe,3],
		 [saint_lazare,4],
		 [havre_caumartin,2],
		 [opera,3],
		 [quatre_septembre,3],
		 [bourse,2],
		 [sentier,3],
		 [reaumur_sebastopol,3],
		 [arts_metiers,3],
		 [temple,2],
		 [republique,3],
		 [parmentier,2],
		 [rue_saint_maur,3],
		 [pere_lachaise,4],
		 [gambetta,2],
		 [porte_de_bagnolet,3],
		 [gallieni,3]
		 ], [[5,35],4,[0,20]], [[5,30],4,[0,20]]
).

ligne(bis_3, metro, [
		    [porte_lilas,0],
		    [saint_fargeau,2],
		    [pelleport,1],
		    [gambetta, 2]
		    ], [[6,0],7,[23,45]], [[6,10],7,[23,55]]
).

ligne(5, metro, [
		 [bobigny_pablo_picasso, 0],
		 [bobigny_pantin, 2],
		 [eglise_de_pantin, 3],
		 [hoche,4],
		 [porte_pantin,3],
		 [ourcq,4],
		 [laumiere,3],
		 [jaures,3],
		 [stalingrad,2],
		 [gare_du_nord,3],
		 [gare_de_est,1],
		 [jacques_bonsergent,2],
		 [republique,3],
		 [oberkampf,2],
		 [richard_lenoir,2],
		 [breguet_sabin,2],
		 [bastille,2],
		 [quai_de_la_rapee,3],
		 [gare_austerlitz,2],
		 [saint_marcel,3],
		 [campo_formio,2],
		 [place_italie,3]
		], [[5,24],3,[1,20]], [[5,30],3,[1,0]]
).

ligne(bis_7, metro, [
		    [pre_saint_gervais,0],
		    [place_fetes, 3],
		    [danube, 0],
		    [bolivar, 2],
		    [buttes_chaumont, 2],
		    [botzaris, 2],
		    [jaures, 3],
		    [louis_blanc,2]
		    ], [[5,35],8,[0,0]], [[5,50],8,[23,45]]
).

ligne(11, metro, [
                   [mairie_lilas, 0],
                   [porte_lilas, 3],
                   [telegraphe,1],
                   [place_fetes,1],
                   [jourdain, 1],
                   [pyrenees, 1],
                   [belleville, 2],
                   [goncourt, 2],
                   [republique, 3],
                   [arts_metiers, 2],
                   [rambuteau, 1],
                   [hotel_de_ville, 1],
                   [chatelet, 1]
                   ], [[5,15],5,[1,30]], [[5,0],5,[2,0]]
).
% Adds a certain number of minutes to a given time
addh([Hour, Minute], MinutesToAdd, [NewHour, NewMinute]) :-
    TotalMinutes is Hour * 60 + Minute + MinutesToAdd,
    NewHour is TotalMinutes // 60,
    NewMinute is TotalMinutes mod 60.

% Prints a given time in the format 'HH:MM'
affiche([Hour, Minute]) :-
    format('~|~`0t~d~2+:~|~`0t~d~2+', [Hour, Minute]).
% Predicate to check if a station is between two others and find the time difference
ligtot(Station, Arret2, [[Station, _] | [_, [H, M]]], DepartureTime) :-
    current_time(Hours, Minutes),
    seconds_to_hour_minute(Seconds, Hours, Minutes),
    writeln(Seconds),
    DepartureTime is Seconds,
    Hours >= H,
    Minutes >= M.
% Predicate to check if a station is between two others and if it before a certain time
ligtard(Station, [[Station, _] | [_, [H, M]]], Before) :-
    current_time(Hours, Minutes),
    (Hours > H ; (Hours == H, Minutes >= M)),
    Before >= [H, M],
    seconds_to_hour_minute(Seconds, Hours, Minutes),
    writeln(Seconds).
% Utility predicate to get the current time
current_time(Hour, Minute) :-
    get_time(Stamp),
    stamp_date_time(Stamp, DateTime, local),
    date_time_value(hour, DateTime, Hour),
    date_time_value(minute, DateTime, Minute).
% Predicate to convert seconds to hours and minutes
seconds_to_hour_minute(Seconds, Hours, Minutes) :-
    Seconds is Hours * 3600 + Minutes * 60,
    Hours is Seconds // 3600,
    Minutes is (Seconds mod 3600) // 60.
% Predicate to find an itinerary that departs the earliest (itinTot)
itinTot(Arret1, Arret2, _, Parcours) :-
    findall([ArrivalTime, Path], (
        member(Line, Horaires),
        ligtot(Arret1, Arret2, [[Station, _] | [_, [H, M]]], DepartureTime),
        ligtot(Arret2, Arret1, [[Station, _] | [_, [H, M]]], _),
        seconds_to_hour_minute(DepartureTime, _, _),
        seconds_to_hour_minute(ArrivalTime, _, _),
        ArrivalTime >= DepartureTime,
        Path = [Arret1, DepartureTime, Arret2, ArrivalTime]
    ), Paths),
    sort(Paths, [Parcours | _]).
% Predicate to find an itinerary that arrives the latest (itinTard)
itinTard(Arret1, Arret2, _, Parcours) :-
    findall([DepartureTime, Path], (
        member(Line, Horaires),
        ligtard(Arret1, Arret2, [[Station, _] | [_, [H, M]]], DepartureTime),
        ligtard(Arret2, Arret1, [[Station, _] | [_, [H, M]]], _),
        seconds_to_hour_minute(DepartureTime, _, _),
        seconds_to_hour_minute(ArrivalTime, _, _),
        ArrivalTime >= DepartureTime,
        Path = [Arret1, DepartureTime, Arret2, ArrivalTime]
    ), Paths),
    sort(Paths, [Parcours | _]).
get_choice(Type, Choice) :-
    format('Veuillez entrer votre choix de ~w : ', [Type]),
    read_line_to_string(user_input, InputString),
    atom_string(Choice, InputString),
    format('Vous avez choisi ~w.~n', [Choice]).
get_options(Options) :-
    format('1. Ferroviaire ou Bus (ferroviaire)~n', []),
    format('2. Préférence par rapport à la longueur du trajet (court)~n', []),
    format('3. Nombre de correspondances (aucune)~n', []),
    format('Veuillez entrer vos choix séparés par des espaces : ', []),
    read_line_to_string(user_input, InputString),
    atomic_list_concat(OptionsList, ' ', InputString),
    maplist(atom_number, OptionsList, Options),
    format('Vous avez choisi les options ~w.~n', [Options]).
:- initialization(main).
main :-
    ligne(_, TransportType, Stations, _, _),
    format('Voici les stations desservies par les transports publics : ~w~n', [Stations]),
    get_choice('station de départ', Start),
    get_choice('station d arrivée', End),
    get_options(Options),
    writeln('Debug: Before itinTot'),
    itinTot(Start, End, Horaires, Parcours),
    writeln('Debug: After itinTot'),
    format('Le parcours le plus rapide possible est de ~w minutes.', [Parcours]).
