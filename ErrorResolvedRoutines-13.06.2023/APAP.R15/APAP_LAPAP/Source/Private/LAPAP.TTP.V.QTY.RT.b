* @ValidationCode : Mjo1OTc0NjQ1MzM6Q3AxMjUyOjE2ODY2NzQyNjYyMDg6SVRTUzotMTotMTowOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 13 Jun 2023 22:07:46
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
SUBROUTINE LAPAP.TTP.V.QTY.RT
***********************************************************************
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: J.Q.
* PROGRAM NAME: REDO.TELLER.AUTORTN
* ODR NO      : CTO-73
*----------------------------------------------------------------------
*DESCRIPTION: This is the  Routine for REDO.TELLER.PROCESS to
* validate Quantity field when SUB.GROUP EQ 'PASO RAPIDO'
* If so, L.TTP.PASO.RAPI field should appear

*IN PARAMETER:  NA
*OUT PARAMETER: NA
*LINKED WITH: REDO.TELLER.PROCESS
*----------------------------------------------------------------------
* Modification History :
*----------------------------------------------------------------------
* DATE              WHO                  REFERENCE                           DESCRIPTION
* Nov 16, 2023     J.Q.                 CTO-73                            INITIAL CREATION
*12/06/2023	     CONVERSION TOOL       AUTO R22 CODE CONVERSION		      $INCLUDE change to $INSERT,T24.BP & TAM.BP is removed in insert file
*12/06/2023      VIGNESHWARI           MANUAL R22 CODE CONVERSION         NOCHANGE
*----------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
    $INSERT I_F.REDO.TELLER.PROCESS
    $INSERT I_F.VERSION

    GOSUB LOAD.LOCREF
    GOSUB INITIAL.VAL
RETURN

INITIAL.VAL:
    Y.SUB.GROUP = R.NEW(TEL.PRO.SUB.GROUP)
    IF Y.SUB.GROUP EQ 'PASO RAPIDO' OR Y.SUB.GROUP EQ 'KIT PASO RAPIDO' OR Y.SUB.GROUP EQ 'KIT PASO RAPIDO PIGGY' THEN
        GOSUB PROCESS
    END ELSE
        T.LOCREF<Y.L.TTP.PASO.RAPI.POS,7> = 'NOINPUT'
        R.NEW(TEL.PRO.LOCAL.REF)<1,Y.L.TTP.PASO.RAPI.POS> = ''
        GOSUB END.OF.PGM
    END
RETURN

PROCESS:
*12 is the actual pos of XX.L.TTP.PASO.RAPI
    T.LOCREF<Y.L.TTP.PASO.RAPI.POS,7> = ''
    Y.INPUT.AMOUNT = R.NEW(TEL.PRO.AMOUNT)
    Y.QTY = COMI
    Y.QTY = Y.QTY * 1;
    Y.REAL.AMT = Y.INPUT.AMOUNT * Y.QTY;
*R.NEW(TEL.PRO.AMOUNT) = Y.REAL.AMT
RETURN

LOAD.LOCREF:
    APPL.NAME.ARR = "REDO.TELLER.PROCESS"
    FLD.NAME.ARR = "L.TTP.PASO.RAPI"
    CALL MULTI.GET.LOC.REF(APPL.NAME.ARR,FLD.NAME.ARR,FLD.POS.ARR)

    Y.L.TTP.PASO.RAPI.POS = FLD.POS.ARR<1,1>

RETURN
END.OF.PGM:

RETURN

END
