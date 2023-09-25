* @ValidationCode : MjoxMjk2NTc1NzIxOlVURi04OjE2ODk3NDk2NTczOTA6SVRTUzotMTotMTo2MzoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 19 Jul 2023 12:24:17
* @ValidationInfo : Encoding          : UTF-8
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 63
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
SUBROUTINE LAPAP.RTE.USER.IN(Y.OUT)
*--------------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :APAP
*Program   Name    :LAPAP.RTE.USER.IN
*---------------------------------------------------------------------------------
*DESCRIPTION       : Obtiene el usuario INPUTTER de la transación RTE
* DATE               AUTHOR              REFERENCE              DESCRIPTION
* 14-07-2023    Conversion Tool        R22 Auto Conversion     BP is removed in insert file,F.READ to CACHE,FV.USER is removed in read file
* 14-07-2023    Narmadha V             R22 Manual Conversion   No Changes
* ----------------------------------------------------------------------------------
    $INSERT I_COMMON ;*R22 Auto Conversion -START
    $INSERT I_EQUATE
    $INSERT I_REDO.DEAL.SLIP.COMMON
    $INSERT I_F.TELLER
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.T24.FUND.SERVICES
    $INSERT I_F.USER ;* R22 Auto Conversion - END
    GOSUB PROCESS
RETURN

OPEN.APLICATION:
    FN.USER = 'F.USER'; FV.USER = ''
    CALL OPF (FN.USER,FV.USER)

RETURN
*********
PROCESS:
*********
    GOSUB OPEN.APLICATION

    BEGIN CASE

        CASE ID.NEW[1,2] EQ 'TT'
            GOSUB GET.USER.TT
        CASE ID.NEW[1,2] EQ 'FT'
            GOSUB GET.USER.FT
        CASE ID.NEW[1,5] EQ 'T24FS'
            GOSUB GET.USER.TFS

    END CASE

    Y.OUT = " ":Y.USER.ID:" ":Y.NAME.USER
RETURN

************
GET.USER.TT:
************
    Y.USUARIO = R.NEW(TT.TE.INPUTTER)
    Y.USUARIO = FIELD(Y.USUARIO, "_",2)
    Y.USER.ID = Y.USUARIO
    GOSUB GET.NAME.USER
RETURN

GET.USER.FT:

    Y.USUARIO = R.NEW(FT.INPUTTER)
    Y.USUARIO = FIELD(Y.USUARIO, "_",2)
    Y.USER.ID = Y.USUARIO
    GOSUB GET.NAME.USER
RETURN

GET.USER.TFS:
    Y.USUARIO = R.NEW(TFS.INPUTTER)
    Y.USUARIO = FIELD(Y.USUARIO, "_",2)
    Y.USER.ID = Y.USUARIO
    GOSUB GET.NAME.USER
RETURN


**************
GET.NAME.USER:
**************
    R.USER = ''; ERROR.USER = ''; Y.NAME.USER = ''
    CALL CACHE.READ(FN.USER, Y.USER.ID, R.USER, ERROR.USER); *R22 Auto Conversion
    Y.NAME.USER = R.USER<EB.USE.USER.NAME>

RETURN


END
