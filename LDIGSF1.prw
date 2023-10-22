/* 
 @author JO�O CAMPELO (TOTVS NORDESTE)
 Objetivo: Facilitar a inclus�o da linha digitavel pelo time do financeiro
 Com este fonte,o c�digo de barras do boleto poder� ser preenchida diretamente no documento de entrada
 PS. Precisar� de um leitor de c�digo de barras. 
*/ 

//Bibliotecas
#Include "TOTVS.ch"

/*/{Protheus.doc} User Function MA103BUT
Ponto de entrada que inclui aba na SF1 (cabe�alho do documento de entrada); 
OBS:
Criar campo: F1_XCODBAR na SF1 
/*/

User Function MA103BUT()
	Local aArea := GetArea()
	Local lEdit
	Local nAba
	Local oCampo
	Public __cCamNovo := ""

	//Adiciona uma nova aba no documento de entrada
	oFolder:AddItem("Boleto", .T.)
	nAba := Len(oFolder:aDialogs)

	//Se for inclus�o, ir� criar a vari�vel e ser� edit�vel, sen�o ir� buscar do banco e n�o ser� edit�vel
	If INCLUI
		__cCamNovo := CriaVar("F1_XCODBAR",.F.)
		lEdit := .T.
	Else
		__cCamNovo := SF1->F1_XCODBAR
		lEdit := .F.
	EndIf

	//Criando campo na aba BOLETO
	@ 003, 003 SAY Alltrim(RetTitle("F1_XCODBAR")) OF oFolder:aDialogs[nAba] PIXEL SIZE 050,006
	@ 001, 053 MSGET oCampo VAR __cCamNovo SIZE 400, 006 OF oFolder:aDialogs[nAba] COLORS 0, 16777215  PIXEL
	oCampo:bHelp := {|| ShowHelpCpo( "F1_XCODBAR", {GetHlpSoluc("F1_XCODBAR")[1]}, 5  )}
    
	//Se n�o houver edi��o, desabilita os gets
	If ! lEdit
		oCampo:lActive := .F.
	EndIf

	RestArea(aArea)
Return Nil

/*/{Protheus.doc} User Function SF1100I
Ponto de entrada acionado no momento da inclus�o do documento de entrada;
/*/

User Function SF1100I()
	Local aArea := GetArea()

	//Se a vari�vel p�blica existir
	If Type("__cCamNovo") != "U"

		//Grava o conte�do na SF1
		RecLock("SF1", .F.)
		SF1->F1_XCODBAR := __cCamNovo
		SF1->(MsUnlock())
	EndIf

	RestArea(aArea)
Return

/*/{Protheus.doc} User Function SF1100I
Ponto de entrada acionado para complementar a grava��o na tabela dos t�tulos financeiros a pagar;
/*/
User Function MT100GE2()
	cBarras := StrToKarr(__cCamNovo, ";")

	Local nOpc := PARAMIXB[2]
	// Local aHeadSE2:= PARAMIXB[3]
	Local aN:= PARAMIXB[4]
	// Local aParcelas:= PARAMIXB[5]
	// Local nPos := Ascan(aHeadSE2,{|x| Alltrim(x[2]) == 'E2_CODBAR'})

	qtdCBarra := Len(cBarras) // 1

	If qtdCBarra >= aN
		If nOpc == 1 // Inclusao
			RecLock("SE2",.F.)
			SE2->E2_CODBAR := cBarras[aN]
			SE2->E2_LINDIG := FinCBLD(cBarras[aN]) // FinCBLD � respons�vel por transformar o c�digo de barras em linha digit�vel
		EndIf

	EndIf
	MsUnLock()

Return()
