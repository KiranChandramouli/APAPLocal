* @ValidationCode : MjoyMDY0ODY0MjYwOkNwMTI1MjoxNzAzNTY4MTgxNDU2OmFqaXRoOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 26 Dec 2023 10:53:01
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ajith
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOVER
SUBROUTINE REDO.I.CARD.TYPE
**********************************************************************
* Company Name : ASOCIACISN POPULAR DE AHORROS Y PRISTAMOS
* Developed By : S.DHAMU
* Program Name : REDO.I.CARD.TYPE
************************************************************************
*Description : This routine is to restrict to assign same BIN for
* different CARD.TYPE
**************************************************************************

*MODIFICATION HISTORY:

*-------------------------------------------------------------------------------

* DATE			WHO			 REFERENCE		DESCRIPTION

* 06-04-2023	CONVERSION TOOL		AUTO R22 CODE CONVERSION	 NO CHANGE
* 06-04-2023	MUTHUKUMAR M		MANUAL R22 CODE CONVERSION	 NO CHANGE
* 21-12-2023      AJITHKUMAR      R22 MANUAL CODE CONVERSION
*-------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.CARD.BIN
    $INSERT I_F.CARD.TYPE
    $USING EB.LocalReferences

    GOSUB INIT
    GOSUB PROCESS

RETURN
*-----
INIT:
*-----

    FN.REDO.CARD.BIN = 'F.REDO.CARD.BIN'
    F.REDO.CARD.BIN = ''
    CALL OPF(FN.REDO.CARD.BIN,F.REDO.CARD.BIN)


RETURN



*--------
PROCESS:
*--------

    Y.L.CT.BIN.POS = ''
*CALL GET.LOC.REF('CARD.TYPE','L.CT.BIN',Y.L.CT.BIN.POS)
    EB.LocalReferences.GetLocRef('CARD.TYPE','L.CT.BIN',Y.L.CT.BIN.POS);*R22 MANUAL CODE CONVERSION
    BIN.ID = R.NEW(CARD.TYPE.LOCAL.REF)<1,Y.L.CT.BIN.POS>
    CALL F.READ(FN.REDO.CARD.BIN,BIN.ID,R.REDO.CARD.BIN,F.REDO.CARD.BIN,REDO.BIN.ERR)
    CARD.TYPE.VAL = ''
    CARD.TYPE.VAL = R.REDO.CARD.BIN<REDO.CARD.BIN.CARD.TYPE>
    IF CARD.TYPE.VAL NE '' AND CARD.TYPE.VAL NE ID.NEW THEN
        AF = REDO.CARD.BIN.LOCAL.REF
        AV = Y.L.CT.BIN.POS
        ETEXT = "BIN-ALREADY ASSIGNED"
        CALL STORE.END.ERROR
    END

RETURN
*******************************
END
