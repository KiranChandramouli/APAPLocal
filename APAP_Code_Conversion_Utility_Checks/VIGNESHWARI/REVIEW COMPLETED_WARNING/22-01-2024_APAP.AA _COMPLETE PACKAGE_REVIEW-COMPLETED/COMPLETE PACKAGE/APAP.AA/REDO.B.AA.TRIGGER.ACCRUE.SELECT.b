* @ValidationCode : MjoxNzMzNTgwNDM2OkNwMTI1MjoxNzAzNjgzMTA4OTIwOnZpZ25lc2h3YXJpOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 27 Dec 2023 18:48:28
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : vigneshwari
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.AA
SUBROUTINE REDO.B.AA.TRIGGER.ACCRUE.SELECT
*------------------------------------------------------
*Description: This routine selects the records to be processed
* multi thread routine
*------------------------------------------------------
* Modification History:
* DATE              WHO                REFERENCE                 DESCRIPTION
* 29-MAR-2023      Conversion Tool    R22 Auto conversion       No changes
* 29-MAR-2023      Harishvikram C     Manual R22 conversion     No changes
*27-12-2023       VIGNESHWARI S      R22 MANUAL CONVERSTION       call rtn modified
*-------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.DATES
    $INSERT I_REDO.B.AA.TRIGGER.ACCRUE.COMMON
    $USING EB.Service

    GOSUB PROCESS
RETURN
*------------------------------------------------------
PROCESS:
*------------------------------------------------------

    Y.LAST.WORKING.DATE = R.DATES(EB.DAT.LAST.WORKING.DAY)
    Y.TODAY             = TODAY

    IF Y.LAST.WORKING.DATE[5,2] NE Y.TODAY[5,2] THEN          ;* We need to check if the last working day is previous month and today date is current month
        IF Y.TODAY[7,2] EQ '01' THEN
            CALL OCOMO("Month end COB but today is the first day of the month - ":Y.LAST.WORKING.DATE:' & ':Y.TODAY)
            RETURN
        END  ELSE
            CALL OCOMO("Processing started - ":Y.LAST.WORKING.DATE:' & ':Y.TODAY)
        END
    END ELSE
        CALL OCOMO("Month of last working day and today are same LWM - :":Y.LAST.WORKING.DATE:" & TM - ":Y.TODAY)
        RETURN          ;* No need to process this batch
    END

    SEL.CMD = "SELECT ":FN.AA.ACCOUNT.DETAILS:" WITH ARR.AGE.STATUS NE 'CUR'"     ;* Loans with aging bills

    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.REC,PGM.ERR)
  *  CALL BATCH.BUILD.LIST('',SEL.LIST)
    EB.Service.BatchBuildList('',SEL.LIST) ;*R22 MANUAL CONVERSTION-call rtn modified

RETURN
END
