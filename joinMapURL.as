string mapURL = "";
string errorTxt = "";
bool menu_visibility = false;
bool btnLoadClicked = false;
bool btnEditClicked = false;

void Main(){
    while (true){
        yield();
        if (btnLoadClicked) {
            CTrackMania@ app = cast<CTrackMania>(GetApp());
            app.BackToMainMenu(); // If we're on a map, go back to the main menu else we'll get stuck on the current map
            while(!app.ManiaTitleControlScriptAPI.IsReady) {
                yield(); // Wait until the ManiaTitleControlScriptAPI is ready for loading the next map
            }
            app.ManiaTitleControlScriptAPI.PlayMap(mapURL, "", "");
            btnLoadClicked = false;
        }
        if (btnEditClicked) {
            CTrackMania@ app = cast<CTrackMania>(GetApp());
            app.BackToMainMenu(); // If we're on a map, go back to the main menu else we'll get stuck on the current map
            while(!app.ManiaTitleControlScriptAPI.IsReady) {
                yield(); // Wait until the ManiaTitleControlScriptAPI is ready for loading the next map
            }
            app.ManiaTitleControlScriptAPI.EditMap(mapURL, "", "");
            btnEditClicked = false;
        }
    }
}

void RenderMenu()
{
    if(UI::MenuItem(Icons::Map + " Load Map by URL", "", menu_visibility)) {
#if TMNEXT
        if (Permissions::PlayLocalMap()) menu_visibility = !menu_visibility;
        else UI::ShowNotification("You don't have permission to play local maps");
#else
        menu_visibility = !menu_visibility;
#endif 	
    }
}

void RenderInterface() {
	if (!menu_visibility) {
		return;
	}
	
    auto appMP = cast<CGameManiaPlanet>(GetApp());
    // UI::SetNextWindowSize(440,240, UI::Cond::FirstUseEver);	
    UI::SetNextWindowSize(400,116);	
    CTrackMania@ app = cast<CTrackMania>(GetApp());

	if (UI::Begin(Icons::Map + " Load Map by URL", menu_visibility)) {	
        if (appMP.LoadedManiaTitle is null){
            UI::Text("\\$f00"+Icons::Key+"\\$z Please enter a title pack before trying to connect to a server.");
        } else {
            // UI::Text("\\$f00"+Icons::Info+"\\$z .");
            mapURL = UI::InputText("URL", mapURL, UI::InputTextFlags(UI::InputTextFlags::AutoSelectAll));
            if (UI::Button(Icons::Play + " Play Map")) {
                if(mapURL != "") {
                    btnLoadClicked = true;
                } else {
                    errorTxt = "\\$f00Nothing is typed\\$z";
                }
            }
            UI::SameLine();
            if (UI::Button(Icons::Kenney::Wrench + " Load Map in Editor")) {
                if(mapURL != "") {
                    btnEditClicked = true;
                } else {
                    errorTxt = "\\$f00Nothing is typed\\$z";
                }
            }
            UI::Text(errorTxt);
        }
	}
	UI::End();
}