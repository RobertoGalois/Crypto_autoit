; --------------------------------------------------------------------------------------------------------------------------
; ----------------------------- SECTION I - PRESENTATION DU PROGRAMME ------------------------------------------------------
; --------------------------------------------------------------------------------------------------------------------------
; Version autoit:		3.6.2
; Langue:				Francais
; Plateforme: 			Win.10
; Auteur:				VV
; Fonction du prog:		Chiffrement/Dechiffrement de texte ou de fichier, avec une interface graphique pour gérer le tout
; Version 1.0: 			16/08/2016
;						- Premiere version
;
; --------------------------------------------------------------------------------------------------------------------------


; --------------------------------------------------------------------------------------------------------------------------
; ----------------------------- SECTION II - DIRECTIVES DE COMPILATION -----------------------------------------------------
; --------------------------------------------------------------------------------------------------------------------------

; Integration d'une icone de programme (Megaman X)
#AutoIt3Wrapper_icon=icon.ico

; --------------------------------------------------------------------------------------------------------------------------
; ----------------------------- SECTION III - DECLARATION DES INCLUDES -----------------------------------------------------
; --------------------------------------------------------------------------------------------------------------------------

#include <ButtonConstants.au3>
#include <ComboConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <MsgBoxConstants.au3>
#include <Crypt.au3>

; --------------------------------------------------------------------------------------------------------------------------
; ----------------------------- SECTION III' - DECLARATION DES VARIABLES ---------------------------------------------------
; --------------------------------------------------------------------------------------------------------------------------

; Declarer ses variables convenablement (en specifiant systematiquement leur portée)
AutoItSetOption("MustDeclareVars", 1)
; Activation du mode evenementiel
Opt("GUIOnEventMode", 1)

; variable interrupteur pour savoir quel bouton radio file ou text est coché
Dim $Fenetre1_Groupe1_Radio_Checked = 0 ; 0 = pas defini, 1 = file, 2 = text
; chaine contenant le message texte une fois chiffré
Dim $msgChiffre = ""
; chaine contenant le message texte une fois déchiffré
Dim $msgDechiffre = ""
; chaine contenant le chemin du fichier à crypter ou à décrypter
Dim $sFileOpenDialog = ""


; --------------------------------------------------------------------------------------------------------------------------
; ----------------------------- SECTION IV - CONSTRUCTION DE LA GUI --------------------------------------------------------
; --------------------------------------------------------------------------------------------------------------------------

; Fenetre principale
Dim $Fenetre1 = GUICreate("TP chiffrement", 622, 496, 192, 124)
GUISetOnEvent($GUI_EVENT_CLOSE, "FinProg")

;Groupe HG
Dim $Fenetre1_Groupe1 = GUICtrlCreateGroup("Que voulez-vous chiffrer ? ", 32, 16, 153, 113)
Dim $Fenetre1_Groupe1_Radio1File = GUICtrlCreateRadio("Un fichier", 56, 48, 113, 17)
GUICtrlSetOnEvent($Fenetre1_Groupe1_Radio1File, "Fenetre1_Groupe1_Radio1File")
Dim $Fenetre1_Groupe1_Radio2Text = GUICtrlCreateRadio("Un texte", 56, 88, 113, 17)
GUICtrlSetOnEvent($Fenetre1_Groupe1_Radio2Text, "Fenetre1_Groupe1_Radio2Text")

; Groupe C
Dim $Fenetre1_Groupe3 = GUICtrlCreateGroup("Chiffrer un texte", 32, 136, 561, 233)
Dim $Fenetre1_Groupe3_Edit1 = GUICtrlCreateEdit("", 48, 168, 521, 185, BitOR($GUI_SS_DEFAULT_EDIT,$WS_BORDER), 0)

; Groupe B
Dim $Fenetre1_Groupe4 = GUICtrlCreateGroup("Chiffrer un fichier :", 32, 392, 553, 81)
Dim $Fenetre1_Groupe4_Label1 = GUICtrlCreateLabel("Emplacement du fichier à chiffrer :", 56, 424, 164, 17)
Dim $Fenetre1_Groupe4_BoutonParcourir = GUICtrlCreateButton("Parcourir", 240, 408, 107, 41)
GUICtrlSetOnEvent($Fenetre1_Groupe4_BoutonParcourir, "Fenetre1_Groupe4_BoutonParcourir")
Dim $Fenetre1_Groupe4_Edit1 = GUICtrlCreateEdit("", 361, 408, 215, 41, BitOR($ES_AUTOVSCROLL,$ES_AUTOHSCROLL,$ES_WANTRETURN))

; Groupe HD
Dim $Fenetre1_Groupe2 = GUICtrlCreateGroup("Options", 208, 16, 385, 113)
Dim $Fenetre1_Groupe2_Label1 = GUICtrlCreateLabel("Mot de passe :", 224, 48, 74, 17)
Dim $Fenetre1_Groupe2_Label2 = GUICtrlCreateLabel("Algorithme :", 440, 48, 59, 17)
Dim $Fenetre1_Groupe2_Input1 = GUICtrlCreateInput("", 304, 48, 121, 21, BitOR($GUI_SS_DEFAULT_INPUT,$ES_PASSWORD))
Dim $Fenetre1_Groupe2_Combo1 = GUICtrlCreateCombo("", 504, 48, 73, 25, BitOR($CBS_DROPDOWN,$CBS_AUTOHSCROLL))
GUICtrlSetData(-1, "RC4|3DES|AES 128|AES 192|AES 256|DES|RC2", "RC4")
Dim $Fenetre1_Groupe2_Bouton1Chiffrer = GUICtrlCreateButton("Chiffrer", 224, 80, 171, 41)
GUICtrlSetOnEvent($Fenetre1_Groupe2_Bouton1Chiffrer, "Fenetre1_Groupe2_Bouton1Chiffrer")
Dim $Fenetre1_Groupe2_Bouton2Dechiffrer = GUICtrlCreateButton("Déchiffrer", 408, 80, 171, 41)
GUICtrlSetOnEvent($Fenetre1_Groupe2_Bouton2Dechiffrer, "Fenetre1_Groupe2_Bouton2Dechiffrer")

; Definition des conditions initiales: RadioFile checked et Groupe3 disabled
GUICtrlSetState($Fenetre1_Groupe1_Radio1File, $GUI_CHECKED)
Dim $Fenetre1_Groupe1_Radio_Checked = 1
GUICtrlSetState($Fenetre1_Groupe4,$GUI_DISABLE)
GUICtrlSetState($Fenetre1_Groupe3_Edit1,$GUI_DISABLE)

; Affichage de la fenetre
GUISetState(@SW_SHOW)


; --------------------------------------------------------------------------------------------------------------------------
; ----------------------------- SECTION V - BOUCLE D'ATTENTE D'ACTION ------------------------------------------------------
; --------------------------------------------------------------------------------------------------------------------------

While 1
	Sleep(5000)
WEnd

; --------------------------------------------------------------------------------------------------------------------------
; ----------------------------- SECTION VI - DEFINITION DES FONCTIONS ------------------------------------------------------
; --------------------------------------------------------------------------------------------------------------------------

; Si on clique sur la croix de fermeture de la fenetre principale
; ===============================================================
Func FinProg()
	Exit
EndFunc


; Si on cheque le radioFile du groupe HG
; ======================================
Func Fenetre1_Groupe1_Radio1File()
	; 1 = file
	$Fenetre1_Groupe1_Radio_Checked = 1
	; Desactivation du groupe C cad groupe3
	GUICtrlSetState($Fenetre1_Groupe4,$GUI_DISABLE)
	GUICtrlSetState($Fenetre1_Groupe3_Edit1,$GUI_DISABLE)
	; Activation du groupe B cad groupe 4
	GUICtrlSetState($Fenetre1_Groupe3,$GUI_ENABLE)
	GUICtrlSetState($Fenetre1_Groupe4_Label1,$GUI_ENABLE)
	GUICtrlSetState($Fenetre1_Groupe4_BoutonParcourir,$GUI_ENABLE)
	GUICtrlSetState($Fenetre1_Groupe4_Edit1,$GUI_ENABLE)
EndFunc


; Si on cheque le radioFile du groupe HD
; ======================================
Func Fenetre1_Groupe1_Radio2Text()
	; 2 = text
	$Fenetre1_Groupe1_Radio_Checked = 2
	; Desactivation du groupe B cad groupe4
	GUICtrlSetState($Fenetre1_Groupe3,$GUI_DISABLE)
	GUICtrlSetState($Fenetre1_Groupe4_Label1,$GUI_DISABLE)
	GUICtrlSetState($Fenetre1_Groupe4_BoutonParcourir,$GUI_DISABLE)
	GUICtrlSetState($Fenetre1_Groupe4_Edit1,$GUI_DISABLE)
	; Activation du groupe C cad groupe3
	GUICtrlSetState($Fenetre1_Groupe4,$GUI_ENABLE)
	GUICtrlSetState($Fenetre1_Groupe3_Edit1,$GUI_ENABLE)
EndFunc


; Si on appuie sur le bouton chiffrer
; ====================================
Func Fenetre1_Groupe2_Bouton1Chiffrer()

	; On check s'il s'agit de chiffrer un file ou un text
	Switch($Fenetre1_Groupe1_Radio_Checked)

		; Si indefini
		Case 0
			MsgBox(16, "ERROR - Erreur de manipulation", "Veuillez choisir le truc à chiffrer: Fichier ou Texte")
			$msgChiffre = -1

		; Si file, chiffrement du file
		Case 1
			; On verifie qu'un fichier a bien été selectionné
			If($sFileOpenDialog == "") Then
				MsgBox(16, "ERROR - Erreur de manipulation", "Veuillez selectionner un fichier à chiffrer")
				$msgChiffre = -1
			EndIf
			; On effectue le chiffrement, si ya un probleme, on le dit
			If(_Crypt_EncryptFile($sFileOpenDialog,$sFileOpenDialog&".crypt",GUICtrlRead($Fenetre1_Groupe2_Input1), ConvertAlgo(GUICtrlRead($Fenetre1_Groupe2_Combo1))) <> 1) Then
				$msgChiffre = -1
			EndIf

		; Si text, chiffrement du text
		Case 2
			$msgChiffre = _Crypt_EncryptData(GUICtrlRead($Fenetre1_Groupe3_Edit1), GUICtrlRead($Fenetre1_Groupe2_Input1), ConvertAlgo(GUICtrlRead($Fenetre1_Groupe2_Combo1)))

	EndSwitch

	; si le chiffrement a deconné
	If($msgChiffre ==-1) Then
		MsgBox(48, "INFO - Aie...", "Ya eu un couac dans le chiffrement")
	; S'il a fonctionné
	Else
		Switch($Fenetre1_Groupe1_Radio_Checked)
			; Si indefini
			Case 0

			; Si file, chiffrer le file
			Case 1
				MsgBox(64, "OK - Buen", "Chiffrement du fichier ok." & @CRLF & "Vous le trouverez dans le dossier du fichier d'origine.")
			; Si text, affichage du Texte dans l'Edit
			Case 2
				GUICtrlSetData($Fenetre1_Groupe3_Edit1, BinaryToString($msgChiffre))
		EndSwitch
	EndIf

EndFunc


; Si on appuie sur le bouton déchiffrer
; =====================================
Func Fenetre1_Groupe2_Bouton2Dechiffrer()

	; On check s'il s'agit de chiffrer un file ou un text
	Switch($Fenetre1_Groupe1_Radio_Checked)

		; Si indefini
		Case 0
		MsgBox(16, "ERROR - Erreur de manipulation", "Veuillez choisir le truc à chiffrer: Fichier ou Texte")
		$msgDechiffre = -1

		; Si file, dechiffrement du file
		Case 1
			; On verifie qu'un fichier a bien été selectionné
			If($sFileOpenDialog == "") Then
				MsgBox(16, "ERROR - Erreur de manipulation", "Veuillez selectionner un fichier à chiffrer")
				$msgDechiffre = -1
			EndIf
			; On effectue le dechiffrement, si ya un probleme, on le dit

			If(_Crypt_DecryptFile($sFileOpenDialog,StringLeft($sFileOpenDialog,StringLen($sFileOpenDialog)-6),GUICtrlRead($Fenetre1_Groupe2_Input1),ConvertAlgo(GUICtrlRead($Fenetre1_Groupe2_Combo1))) <> 1) Then
				$msgDechiffre = -1
			EndIf

		; Si text, dechiffremnt du text
		Case 2
		$msgDechiffre = _Crypt_DecryptData (GUICtrlRead($Fenetre1_Groupe3_Edit1), GUICtrlRead($Fenetre1_Groupe2_Input1), ConvertAlgo(GUICtrlRead($Fenetre1_Groupe2_Combo1)))

	EndSwitch

	; si le Dechiffrement a deconné
	If($msgDechiffre==-1) Then
		MsgBox(48, "INFO - Aie...", "Ya eu un couac dans le déchiffrement")
	; S'il a fonctionné
	Else
		; affichage du resultat en fonction de si c'est un file ou un texte
		Switch($Fenetre1_Groupe1_Radio_Checked)
			; Si indefini
			Case 0

			; Si file, faire en fonction mais je ne sais pas encore quoi
			Case 1
				MsgBox(64, "OK - Buen", "Dechiffrement du fichier ok." & @CRLF & "Vous le trouverez dans le dossier du fichier d'origine.")
			; Si text, affichage du Texte dans l'Edit
			Case 2
			GUICtrlSetData($Fenetre1_Groupe3_Edit1, BinaryToString($msgDechiffre))
		EndSwitch
	EndIf
EndFunc


; Fonction qui converti le choix de l'algo par l'utilisateur en la variable système à mettre dans la fonction autoit de cryptage/decryptage
; =========================================================================================================================================
Func ConvertAlgo($algoDep) ;Definit la variable selon l'algorithme choisi.
	Local $algoRet

	Switch $algoDep

		Case "3DES"
			$algoRet = $CALG_3DES
		Case "DES"
			$algoRet = $CALG_DES
		Case "RC2"
			$algoRet = $CALG_RC2
		Case "RC4"
			$algoRet = $CALG_RC4

		Case "AES 128"
			If @OSVersion = "WIN_2000" Then
				MsgBox(16, "ERROR - Compatibility OS - Autoit function", "Sorry, this algorithm is not available on this system !")
				$algoRet = $CALG_3DES
			EndIf
			$algoRet = $CALG_AES_128

		Case "AES 192"
			If @OSVersion = "WIN_2000" Then
				MsgBox(16, "ERROR - Compatibility OS - Autoit function", "Sorry, this algorithm is not available on this system !")
				$algoRet = $CALG_3DES
			EndIf
			$algoRet = $CALG_AES_192

		Case "AES 256"
			If @OSVersion = "WIN_2000" Then
				MsgBox(16, "ERROR - Compatibility OS - Autoit function", "Sorry, this algorithm is not available on this system !")
				$algoRet = $CALG_3DES
			EndIf
			$algoRet = $CALG_AES_256

	EndSwitch

	Return $algoRet
EndFunc


; Si on clique sur le bouton parcourir du groupe B
; ================================================
Func Fenetre1_Groupe4_BoutonParcourir()
	$sFileOpenDialog = FileOpenDialog("Selectionner un fichier", @DesktopDir, "Tous les fichiers (*.*)", 7, $Fenetre1)

	; Si ya un couac dans la selection de fichier
	If @error Then
        MsgBox($MB_SYSTEMMODAL, "", "Aucun fichier selectionné. Soucis dans FileOpenDialog...")

        ; Change le répertoire de travail (@WorkingDir) vers l'emplacement du répertoire de script comme FileOpenDialog l'a défini  au dernier dossier consulté.
        FileChangeDir(@ScriptDir)
		GUICtrlSetData($Fenetre1_Groupe4_Edit1, "")
    Else
        ; Change le répertoire de travail (@WorkingDir) vers l'emplacement du répertoire de script comme FileOpenDialog l'a défini au dernier dossier consulté.
        FileChangeDir(@ScriptDir)
        ; Remplace les instances de "|" avec CRLF dans la chaîne renvoyée par FileOpenDialog.
        $sFileOpenDialog = StringReplace($sFileOpenDialog, "|", @CRLF)
        ; Affiche la liste des fichiers sélectionnés.
		GUICtrlSetData($Fenetre1_Groupe4_Edit1, $sFileOpenDialog)
		MsgBox($MB_SYSTEMMODAL, "", "Fichier selectionné: " & @CRLF & $sFileOpenDialog)
    EndIf
EndFunc
