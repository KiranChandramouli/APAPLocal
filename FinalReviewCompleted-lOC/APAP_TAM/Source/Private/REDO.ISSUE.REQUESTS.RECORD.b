* @ValidationCode : MjoxNjQxODA0NzQ4OkNwMTI1MjoxNjgzODkyNjUyMDY0OklUU1MxOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 12 May 2023 17:27:32
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS1
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
*Modification History:
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*11/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION           FM TO @FM, VM TO @VM,IF CONDITION ADDED
*11/04/2023         SURESH           MANUAL R22 CODE CONVERSION           NOCHANGE
SUBROUTINE REDO.ISSUE.REQUESTS.RECORD
*-----------------------------------------------------------------------------
* @author tcoleman@temenos.com
*-----------------------------------------------------------------------------
* Modification History :
*
*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes
    $INSERT I_F.REDO.ISSUE.REQUESTS
    $INSERT I_System
    $INSERT I_F.REDO.CLAIM.STATUS.MAP

    FN.REDO.CLAIM.STATUS.MAP = 'F.REDO.CLAIM.STATUS.MAP'
    F.REDO.CLAIM.STATUS.MAP  = ''
    CALL OPF(FN.REDO.CLAIM.STATUS.MAP,F.REDO.CLAIM.STATUS.MAP)
    GOSUB PROCESS

RETURN
*********
PROCESS:
*********

    table = 'CL.CLOSING.STATUS'
    CALL EB.LOOKUP.LIST(table)
    Y.FINAL.TABLE = table<2>
    CHANGE '_' TO @FM IN Y.FINAL.TABLE

    Y.PGM.VERSION = System.getVariable('CURRENT.PGM.VER')
    IF E EQ "EB-UNKNOWN.VARIABLE" THEN ;*AUTO R22 CODE CONVERSION - START
        Y.PGM.VERSION = ""
    END ;*AUTO R22 CODE CONVERSION - END
    Y.APPLICATION = System.getVariable('CURRENT.APPLICATION')
    IF E EQ "EB-UNKNOWN.VARIABLE" THEN ;*AUTO R22 CODE CONVERSION - START
        Y.APPLICATION = ""
    END ;*AUTO R22 CODE CONVERSION - END
    Y.VERSION.ID = Y.APPLICATION:Y.PGM.VERSION
    CALL F.READ(FN.REDO.CLAIM.STATUS.MAP,Y.VERSION.ID,R.REDO.CLAIM.STATUS.MAP,F.REDO.CLAIM.STATUS.MAP,REDO.CLAIM.STATUS.MAP.ERR)
    IF R.REDO.CLAIM.STATUS.MAP THEN
        Y.CLOSED.STATUS = R.REDO.CLAIM.STATUS.MAP<CR.ST.CLOSED.STATUS>

        CHANGE @VM TO @FM IN Y.CLOSED.STATUS
        Y.CNT.TABLE = DCOUNT(Y.FINAL.TABLE,@FM)
        Y.INT = 1
        LOOP
        WHILE Y.INT LE Y.CNT.TABLE
            Y.STATUS = Y.FINAL.TABLE<Y.INT>
            LOCATE Y.STATUS IN Y.CLOSED.STATUS SETTING Y.POS THEN
            END ELSE
                DEL Y.FINAL.TABLE<Y.INT>
                Y.TEMP.ARR = ''
                INS Y.TEMP.ARR BEFORE Y.FINAL.TABLE<Y.INT>
            END

            Y.INT + = 1
        REPEAT
        CHANGE @FM TO '_' IN Y.FINAL.TABLE
        T(ISS.REQ.CLOSING.STATUS)<2> = Y.FINAL.TABLE
    END ELSE
        CHANGE @FM TO '_' IN Y.FINAL.TABLE
        T(ISS.REQ.CLOSING.STATUS)<2> = Y.FINAL.TABLE
    END
RETURN
*-----------------------------------------------------------------------------
END
