$PACKAGE APAP.TAM
SUBROUTINE REDO.LY.INPUT.FTUSMOV
*----------------------------------------------------------------------------------------------------
*DESCRIPTION : This routine is used to input FT ID in REDO.LY.POINTS.US local application
*-----------------------------------------------------------------------------------------------------
*-----------------------------------------------------------------------------------------------------
* * Input / Output
* --------------
* IN : -NA-
* OUT : -NA-
*-----------------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : RMONDRAGON
* PROGRAM NAME : REDO.LY.INPUT.FTUSMOV
*-----------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*DATE WHO REFERENCE DESCRIPTION
*16.06.2012 RMONDRAGON ODR-2011-06-0243 FIRST VERSION
*16.07.2012 RMONDRAGON ODR-2011-06-0243 SECOND VERSION
** 12-04-2023 R22 Auto Conversion no changes
** 12-04-2023 Skanda R22 Manual Conversion - No changes
* -----------------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.REDO.LY.POINTS.US
    $INSERT I_GTS.COMMON

    GOSUB INIT
    GOSUB PROCESS

RETURN

*----
INIT:
*----

    CALL GET.LOC.REF('FUNDS.TRANSFER','L.CU.TXN.REF',L.CU.TXN.REF.POS)

RETURN

*-------
PROCESS:
*-------

    Y.ID.USE = R.NEW(FT.LOCAL.REF)<1,L.CU.TXN.REF.POS>

    R.REC.US = ''
    R.REC.US<REDO.PT.US.TXN.REF.MOV.US> = ID.NEW
    R.REC.US<REDO.PT.US.STATUS.US> = 1

    APP.NAME = 'REDO.LY.POINTS.US'
    OFSFUNCTION = 'I'
    PROCESS = 'PROCESS'
    OFS.SOURCE.ID = 'LY.ACCMOV'
    OFSVERSION = 'REDO.LY.POINTS.US,UPD.FT.MOV.REF'
    GTS.MODE = ''
    NO.OF.AUTH = '0'
    TRANSACTION.ID = Y.ID.USE

    CALL OFS.BUILD.RECORD(APP.NAME,OFSFUNCTION,PROCESS,OFSVERSION,GTS.MODE,NO.OF.AUTH,TRANSACTION.ID,R.REC.US,OFSSTRING)

    CALL OFS.POST.MESSAGE(OFSSTRING,OFS.MSG.ID,OFS.SOURCE.ID,OFS.ERR)

RETURN

*----------------------------------------------------------------------------------
END
