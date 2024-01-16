* @ValidationCode : MjoxNTEwMjcxNzQ1OkNwMTI1MjoxNzAzNjgyNzU3NDMyOnZpZ25lc2h3YXJpOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 27 Dec 2023 18:42:37
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
$PACKAGE APAP.AA ;*Manual R22 conversion
SUBROUTINE REDO.B.AA.POOL.RATE.UPDATE.SELECT
*------------------------------------------------------
*Description: This batch routine is to update the pool rate
*             for back to back loans which has deposit as a collateral.
*------------------------------------------------------
* Modification History:
* DATE              WHO                REFERENCE                 DESCRIPTION
* 29-MAR-2023      Conversion Tool    R22 Auto conversion       No changes
* 29-MAR-2023      Harishvikram C     Manual R22 conversion   No changes
*27-12-2023       VIGNESHWARI S      R22 MANUAL CONVERSTION       call rtn modified
*------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_REDO.B.AA.POOL.RATE.UPDATE.COMMON
$USING EB.Service
    GOSUB PROCESS
RETURN
*------------------------------------------------------
PROCESS:
*------------------------------------------------------

    IF R.REDO.AZ.CONCAT.ROLLOVER EQ '' THEN
        CALL OCOMO("No Deposit has rolled over today")
        RETURN
    END

    SEL.CMD = 'SELECT ':FN.REDO.T.DEP.COLLATERAL
    CALL EB.READLIST(SEL.CMD,Y.ARRANGEMENT.IDS,'',SEL.NOR,SEL.RET)
    IF Y.ARRANGEMENT.IDS THEN
        *CALL BATCH.BUILD.LIST('',Y.ARRANGEMENT.IDS)
       EB.Service.BatchBuildList('',Y.ARRANGEMENT.IDS) ;*R22 MANUAL CONVERSTION-call rtn modified
    END ELSE
        CALL OCOMO("No Loans selected in REDO.T.DEP.COLLATERAL")
    END
RETURN
END
