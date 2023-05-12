* @ValidationCode : MjotMjU3NTA0NzgzOkNwMTI1MjoxNjgzODExOTkyNDEyOklUU1M6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjJfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 11 May 2023 19:03:12
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R22_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.REINV.REV.TEMP.IDS
*-------------------------------------------------------

* DESCRIPTION: This routine is to update the REDO.TEMP.VERSION.IDS.


*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
*
*  DATE             WHO         REFERENCE           DESCRIPTION
* 14-Jul-2011     H Ganesh    PACS00072695 - N.11   Initial Draft.
** 13-04-2023 R22 Auto Conversion - FM TO @FM, VM to @VM, SM to @SM
** 13-04-2023 Skanda R22 Manual Conversion - added APAP.TAM, CALL routine format modified

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.REDO.TEMP.VERSION.IDS


    GOSUB INIT
    GOSUB PROCESS
RETURN
*-----------------------------------------------------------------------------
INIT:
*-----------------------------------------------------------------------------


    LOC.REF.APPLICATION="FUNDS.TRANSFER"
    LOC.REF.FIELDS='L.FT.AZ.TXN.REF'
    LOC.REF.POS=''
    CALL MULTI.GET.LOC.REF(LOC.REF.APPLICATION,LOC.REF.FIELDS,LOC.REF.POS) ;*MANUAL R22 CODE CONVERSION
    POS.L.FT.AZ.TXN.REF = LOC.REF.POS<1,1>

    FN.REDO.TEMP.VERSION.IDS = 'F.REDO.TEMP.VERSION.IDS'
    F.REDO.TEMP.VERSION.IDS = ''
    CALL OPF(FN.REDO.TEMP.VERSION.IDS,F.REDO.TEMP.VERSION.IDS)


RETURN
*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------

    Y.TEMP.VERSION.ID = 'FUNDS.TRANSFER,REINV.WDL'
    CALL F.READ(FN.REDO.TEMP.VERSION.IDS,Y.TEMP.VERSION.ID,R.TEMP.VERSION,F.REDO.TEMP.VERSION.IDS,VER.ERR)

    Y.PREV.ID = R.NEW(FT.LOCAL.REF)<1,POS.L.FT.AZ.TXN.REF>
    LOCATE Y.PREV.ID IN R.TEMP.VERSION<REDO.TEM.AUT.TXN.ID,1> SETTING TEM.POS THEN
        DEL R.TEMP.VERSION<REDO.TEM.AUT.TXN.ID,TEM.POS>
        R.TEMP.VERSION<REDO.TEM.REV.TXN.ID,TEM.POS> = Y.PREV.ID
        R.TEMP.VERSION<REDO.TEM.REV.TXN.DATE,TEM.POS> = TODAY
        CALL F.WRITE(FN.REDO.TEMP.VERSION.IDS,Y.TEMP.VERSION.ID,R.TEMP.VERSION)
    END

    Y.ID = APPLICATION:PGM.VERSION
    CALL CACHE.READ(FN.REDO.TEMP.VERSION.IDS,Y.ID,R.REC.TEMP.VERSION,TEMP.ERR)

    IF R.REC.TEMP.VERSION EQ '' THEN
        R.REC.TEMP<REDO.TEM.TXN.ID> = ID.NEW
        R.REC.TEMP<REDO.TEM.PRV.TXN.ID> = Y.PREV.ID

        CALL F.WRITE(FN.REDO.TEMP.VERSION.IDS,Y.ID,R.REC.TEMP)
    END ELSE
        LOCATE ID.NEW IN R.REC.TEMP.VERSION<REDO.TEM.TXN.ID,1> SETTING POS.ID ELSE
            Y.TXN.ID = R.REC.TEMP.VERSION<REDO.TEM.TXN.ID>
            Y.CNT = DCOUNT(Y.TXN.ID,@VM)
            R.REC.TEMP.VERSION<REDO.TEM.TXN.ID,Y.CNT+1> = ID.NEW
            R.REC.TEMP.VERSION<REDO.TEM.PRV.TXN.ID,Y.CNT+1> = Y.PREV.ID
            CALL F.WRITE(FN.REDO.TEMP.VERSION.IDS,Y.ID,R.REC.TEMP.VERSION)
        END
    END

RETURN
END
