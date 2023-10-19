* @ValidationCode : Mjo4MDY4ODkxNjQ6Q3AxMjUyOjE2ODY1NzI4OTIzODM6dmljdG86LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 12 Jun 2023 17:58:12
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : victo
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
SUBROUTINE LAPAP.TTP.V.DEF.ACCT1.RT
***********************************************************************
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: J.Q.
* PROGRAM NAME: LAPAP.TTP.V.DEF.ACCT1.RT
* ODR NO      : CTO-73
*----------------------------------------------------------------------
*DESCRIPTION: This is the  Routine for TELLER,SERVICE.CREATE to
* to default ACCOUNT.1 TO DOP1763600010017 instead of the PL ...
* ... when dealing with PASO RAPIDO
*IN PARAMETER:  NA
*OUT PARAMETER: NA
*LINKED WITH: REDO.TELLER.PROCESS
*----------------------------------------------------------------------
* Modification History :
*----------------------------------------------------------------------
* DATE           WHO             REFERENCE          DESCRIPTION
* Nov 17, 2023   J.Q.            CTO-73             INITIAL CREATION
*12-06-2023    CONVERSION TOOL     R22 AUTO CONVERSION     INSERT FILE MODIFIED, VM TO @VM
*12-06-2023    VICTORIA S          R22 MANUAL CONVERSION   NO CHANGE
*----------------------------------------------------------------------
    $INSERT I_COMMON ;*R22 AUTO CONVERSION START
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
    $INSERT I_F.REDO.TELLER.PROCESS
    $INSERT I_F.TELLER ;*R22 AUTO CONVERSION END


    GOSUB LOAD.LOCREF
    GOSUB GET.NARR

    IF Y.TT.NARR EQ 'PASO RAPIDO' OR Y.TT.NARR EQ 'KIT PASO RAPIDO' OR Y.TT.NARR EQ 'KIT PASO RAPIDO PIGGY' THEN
        GOSUB PROCESS
    END


RETURN

LOAD.LOCREF:
    LOC.REF.APPLICATION="TELLER"
    LOC.REF.FIELDS='L.TT.PROCESS':@VM:'L.COMMENTS' ;*R22 AUTO CONVERSION
    LOC.REF.POS=''
    CALL MULTI.GET.LOC.REF(LOC.REF.APPLICATION,LOC.REF.FIELDS,LOC.REF.POS)
    POS.L.TT.PROCESS=LOC.REF.POS<1,1>
    POS.L.COMMENTS = LOC.REF.POS<1,2>
RETURN

PROCESS:

    R.NEW(TT.TE.ACCOUNT.1) = 'DOP1763600010017'

RETURN

GET.NARR:
    Y.TT.NARR = R.NEW(TT.TE.NARRATIVE.1)
RETURN

END
