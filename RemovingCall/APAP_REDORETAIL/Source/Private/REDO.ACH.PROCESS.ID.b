* @ValidationCode : MjoxMzI3MTE4NjExOkNwMTI1MjoxNjgxMjgzOTM0MTg1OklUU1M6LTE6LTE6MzkzOjE6ZmFsc2U6Ti9BOkRFVl8yMDIxMDguMDotMTotMQ==
* @ValidationInfo : Timestamp         : 12 Apr 2023 12:48:54
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 393
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDORETAIL
SUBROUTINE REDO.ACH.PROCESS.ID
*--------------------------------------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.ACH.PROCESS.ID
*--------------------------------------------------------------------------------------------------------
*Description  : This is a ID routine to display ID in yyyymmdd.seconds format
*Linked With  : REDO.ACH.PROCESS
*In Parameter : N/A
*Out Parameter: N/A
*--------------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*    Date            Who                  Reference               Description
*   ------         ------               -------------            -------------
* 1 Sep 2010     Swaminathan.S.R       ODR-2009-12-0290        Initial Creation
* Modification History:
* Date                 Who                              Reference                            DESCRIPTION
*10-04-2023           CONVERSION TOOL                AUTO R22 CODE CONVERSION                 NO CHANGES
*10-04-2023          jayasurya H                       MANUAL R22 CODE CONVERSION            NO CHANGES
*--------------------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
    $INSERT I_F.OFS.STATUS.FLAG

    FN.REDO.ACH = 'F.REDO.ACH.PROCESS'
    F.REDO.ACH = ''
    CALL OPF(FN.REDO.ACH,F.REDO.ACH)

    FN.REDO.ACH.NAU = 'F.REDO.ACH.PROCESS$NAU'
    F.REDO.ACH.NAU = ''
    CALL OPF(FN.REDO.ACH.NAU,F.REDO.ACH.NAU)

    IF GTSACTIVE THEN
        IF OFS$STATUS<STAT.FLAG.FIRST.TIME> THEN
            GOSUB PROCESS.PARA
            RETURN
        END
    END ELSE
        GOSUB PROCESS.PARA
    END
RETURN

**************
PROCESS.PARA:
**************

    IF V$FUNCTION EQ 'I' THEN

        CALL F.READ(FN.REDO.ACH,ID.NEW,R.REDO.ACH,F.REDO.ACH,DET.ERR)
        IF DET.ERR THEN

            CALL F.READ(FN.REDO.ACH.NAU,ID.NEW,R.REDO.ACH.NAU,F.REDO.ACH.NAU,DET.NAU.ERR)

            IF DET.NAU.ERR THEN

                ID.NEW = TODAY:".":TIME()
            END

        END
    END
RETURN
END
