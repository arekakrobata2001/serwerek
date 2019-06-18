#include "a_samp"
#include "dfile"
#include "kolory"

native WP_Hash(buffer[], len, const str[]); 

#define NAZWA_SERWERA "Polski Super Serwer"
#define WERSJA_SERWERA "1.0"
#define FOLDER_KONT "/Konta/"
#define DIALOG_REJESTRACJA 0
#define DIALOG_LOGOWANIE 1
#define PUNKTY_NA_START 10
#define KASA_NA_START 10500
main(){}

enum Dgracza
{
	bool:Zalogowany
};
new DaneGracza[MAX_PLAYERS][Dgracza];

public OnPlayerConnect(playerid)
{
	ResetujDaneGracza(playerid);
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	if(DaneGracza[playerid][Zalogowany] == true)
	{
		ZapiszKonto(playerid);
	}
	ResetujDaneGracza(playerid);
	return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	if(dialogid == DIALOG_LOGOWANIE)
	{
		if(response)
		{
			dfile_Open(SciezkaKontaGracza(playerid));
			new haslo[300], hasloex[130];
			haslo = dfile_ReadString("Haslo");
			WP_Hash(hasloex, sizeof hasloex, inputtext);
			dfile_CloseFile();
			if(strcmp(hasloex, haslo, false) == 0)
			{
				WczytajKonto(playerid);
				DaneGracza[playerid][Zalogowany] = true;
				TogglePlayerSpectating(playerid, false);
				WymusWyborPostaci(playerid); 
				SendClientMessage(playerid, COLOR_GREEN,"Haslo sie zgadza! Zostales(as) pomyslnie zalogowany(a)."); 
			}
			else
			{
				OknoLogowania(playerid);
				SendClientMessage(playerid, COLOR_RED, "Haslo sie nie zgadza!");
			}
		}
		else Kick(playerid);
	}
	if(dialogid == DIALOG_REJESTRACJA)
	{
		if(response)
		{
			if(strlen(inputtext) >= 6)
			{
				StworzKonto(playerid, inputtext);
				OknoLogowania(playerid);
				SendClientMessage(playerid, COLOR_GREEN, "Konto zostalo pomyslnie zalozone! Mozesz sie teraz zalogowac.");
			}
			else
			{
				OknoRejestracji(playerid);
				SendClientMessage(playerid, COLOR_RED, "Haslo musi posiadac 6 lub wiecej znakow!");
			}
			

		}
		else Kick(playerid);

	}
	return 0; 
}

public OnGameModeInit() 
{
	for(new idskina=0; idskina < 311; idskina++)
	{
		AddPlayerClass(idskina, 0.0, 0.0, 0.0, 0.0, 0, 0, 0, 0, 0, 0);
	}

	UsePlayerPedAnims();
	/*AddPlayerClass(29, 0.0, 0.0, 0.0, 0.0, 0, 0, 0, 0, 0, 0);
	AddPlayerClass(30, 0.0, 0.0, 0.0, 0.0, 0, 0, 0, 0, 0, 0);
	AddPlayerClass(31, 0.0, 0.0, 0.0, 0.0, 0, 0, 0, 0, 0, 0);
	AddPlayerClass(32, 0.0, 0.0, 0.0, 0.0, 0, 0, 0, 0, 0, 0);
	AddPlayerClass(33, 0.0, 0.0, 0.0, 0.0, 0, 0, 0, 0, 0, 0);
	AddPlayerClass(34, 0.0, 0.0, 0.0, 0.0, 0, 0, 0, 0, 0, 0);*/

	AddStaticVehicle(522,113.4309,-178.4636,1.0768,90.1646,3,8); // p1
	AddStaticVehicle(560,94.2713,-153.2171,2.2815,268.5840,9,39); // p2
	AddStaticVehicle(411,91.9562,-164.8893,2.3208,270.4264,64,1); // p3
	AddStaticVehicle(541,93.8981,-171.9281,2.2078,270.7149,58,8); // p4
	AddStaticVehicle(522,113.4089,-176.9322,1.1088,97.1002,6,25); // p5
	AddStaticVehicle(522,113.4743,-179.9327,1.0672,92.4748,7,79); // p6
	AddStaticVehicle(562,119.9603,-186.5210,1.1953,179.1740,35,1); // p7
	AddStaticVehicle(451,112.2556,-151.0638,1.3268,266.8042,125,125); // p8
	AddStaticVehicle(559,127.7883,-154.4433,1.1579,178.7069,58,8); // p9
	AddStaticVehicle(603,128.1144,-175.9393,1.3393,179.6705,69,1); // p10


	if(!dfile_FileExists(FOLDER_KONT))
	{
		return printf("Folder %s nie istnieje w folderze scriptfiles! Stworz go!", FOLDER_KONT);
	}
	else printf("Folder %s istnieje i jest gotowy do wczytania kont!", FOLDER_KONT);


	printf("\nGamemode %s wersja %s by Banan zostal pomyslnie wlaczony!\n", NAZWA_SERWERA, WERSJA_SERWERA);
	return 1;
}

public OnPlayerSpawn(playerid)
{
	if(DaneGracza[playerid][Zalogowany] == false)
	{
		TogglePlayerSpectating(playerid, true);
		if(!dfile_FileExists(SciezkaKontaGracza(playerid)))
		{
			OknoRejestracji(playerid);
		}
		else
		{
			OknoLogowania(playerid);
		}
	}
	else
	{
		SetPlayerPos(playerid, 117.5482,-165.1391,1.5781);
		SetPlayerFacingAngle(playerid, 274.0992);
		SetCameraBehindPlayer(playerid);
		SetPlayerInterior(playerid, 0);
		SetPlayerVirtualWorld(playerid, 0);
	}
	return 1;
}

public OnPlayerRequestClass(playerid, classid)
{
	if(DaneGracza[playerid][Zalogowany] == false)
	{
		SetTimerEx("SpawnujGracza", 150, false, "i", playerid);
	}
	SetPlayerPos(playerid, 110.1924,-163.7571,1.7069);
	SetPlayerFacingAngle(playerid, 271.0124);
	SetPlayerCameraPos(playerid, 114.4773,-164.2388,1.5781);
	SetPlayerCameraLookAt(playerid, 110.1924,-163.7571,1.7069);
	return 1;
}

stock ResetujDaneGracza(playerid)
{
	DaneGracza[playerid][Zalogowany] = false; 
	return 1; 	
}

stock ZapiszKonto(playerid)
{
	dfile_Create(SciezkaKontaGracza(playerid));
	dfile_Open(SciezkaKontaGracza(playerid));
	dfile_WriteInt("Punkty", GetPlayerScore(playerid));
	dfile_WriteInt("Kasa", GetPlayerMoney(playerid));
	dfile_WriteInt("Level", 1);

	dfile_SaveFile();
	dfile_CloseFile();
	return 1;
}

stock WymusWyborPostaci(playerid)
{
	ForceClassSelection(playerid);
	TogglePlayerSpectating(playerid, true);
	TogglePlayerSpectating(playerid, false);
	return 1;
}

stock WczytajKonto(playerid)
{
	ResetPlayerMoney(playerid);
	dfile_Open(SciezkaKontaGracza(playerid));
	SetPlayerScore(playerid, dfile_ReadInt("Punkty"));
	GivePlayerMoney(playerid, dfile_ReadInt("Kasa"));
	dfile_CloseFile();
	return 1;
}

stock StworzKonto(playerid, haslo[])
{
	new hasloex[130];
	WP_Hash(hasloex, sizeof hasloex, haslo);

	dfile_Create(SciezkaKontaGracza(playerid));
	dfile_Open(SciezkaKontaGracza(playerid));
	dfile_WriteString("Haslo", hasloex);
	dfile_WriteInt("Punkty", PUNKTY_NA_START);
	dfile_WriteInt("Kasa", KASA_NA_START);
	dfile_WriteInt("Level", 1);

	dfile_SaveFile();
	dfile_CloseFile();
	return 1;
}

stock OknoRejestracji(playerid)
{
	ShowPlayerDialog(playerid, DIALOG_REJESTRACJA, DIALOG_STYLE_PASSWORD, "Rejestracja", "Witaj na serwerze!\nNie posiadasz konta. Prosze sie zarejestrowac.", "Zarejestruj", "Wyjdz");
	return 1;
}

stock OknoLogowania(playerid)
{
	ShowPlayerDialog(playerid, DIALOG_LOGOWANIE, DIALOG_STYLE_PASSWORD, "Logowanie", "Witaj na serwerze!\nKonto o takiej nazwie istnieje. Prosze sie zalogowac. ", "Zaloguj", "Wyjdz");
	return 1;
}

stock SciezkaKontaGracza(playerid)
{
	new sciezka[128];
	format(sciezka, sizeof sciezka, FOLDER_KONT"%s.ini", NazwaGracza(playerid));
	return sciezka;
}

stock NazwaGracza(playerid)
{
	new nazwa[MAX_PLAYER_NAME];
	GetPlayerName(playerid, nazwa, sizeof nazwa);
	return nazwa;
}

forward SpawnujGracza(playerid);
public SpawnujGracza(playerid)
{
	SpawnPlayer(playerid);
	return 1;
}
