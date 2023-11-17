* @ValidationCode : MjotMTMzNTk4NjQ0NzpDcDEyNTI6MTY4MjUyODQ3MzMyMzpJVFNTOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 26 Apr 2023 22:31:13
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
$PACKAGE APAP.TAM
SUBROUTINE REDO.REINV.REV.TEMP.IDS.AUTH
*-------------------------------------------------------

* DESCRIPTION: This routine is to update the REDO.TEMP.VERSION.IDS.


*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
*
*  DATE             WHO         REFERENCE           DESCRIPTION
* 14-Jul-2011     H Ganesh    PACS00072695 - N.11   Initial Draft.
*Modification History:
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*13/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION             NOCHANGE
*13/04/2023         SURESH           MANUAL R22 CODE CONVERSION           NOCHANGE

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

    FN.REDO.TEMP.VERSION.IDS = 'F.REDO.TEMP.VERSION.IDS'
    F.REDO.TEMP.VERSION.IDS = ''
    CALL OPF(FN.REDO.TEMP.VERSION.IDS,F.REDO.TEMP.VERSION.IDS)


RETURN
*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------

    Y.ID = APPLICATION:PGM.VERSION
    CALL CACHE.READ(FN.REDO.TEMP.VERSION.IDS,Y.ID,R.REC.TEMP.VERSION,TEMP.ERR)

    IF R.REC.TEMP.VERSION THEN

        LOCATE ID.NEW IN R.REC.TEMP.VERSION<REDO.TEM.TXN.ID,1> SETTING POS.ID THEN
            DEL R.REC.TEMP.VERSION<REDO.TEM.TXN.ID,POS.ID>
            DEL R.REC.TEMP.VERSION<REDO.TEM.PRV.TXN.ID,POS.ID>
            R.REC.TEMP.VERSION<REDO.TEM.AUT.TXN.ID,POS.ID> = ID.NEW
            R.REC.TEMP.VERSION<REDO.TEM.PROCESS.DATE,POS.ID> = TODAY
            CALL F.WRITE(FN.REDO.TEMP.VERSION.IDS,Y.ID,R.REC.TEMP.VERSION)
        END
    END

RETURN
END
