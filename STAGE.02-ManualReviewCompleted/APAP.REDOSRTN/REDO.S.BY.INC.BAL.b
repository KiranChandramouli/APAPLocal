* @ValidationCode : Mjo5MDY4NTk0MjM6Q3AxMjUyOjE2ODA3NzQ3MjM4OTg6OTE2Mzg6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 06 Apr 2023 15:22:03
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : 91638
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOSRTN
SUBROUTINE REDO.S.BY.INC.BAL(ACCT.ID,CHK.VAL)
*-------------------------------------------------------------------------------------------
*DESCRIPTION:
*             This routine is an internal call routine called by the batch routine REDO.B.LY.POINT.GEN to get the value
*  based on which the point to be updated in REDO.LY.POINTS is computed for modality type 3
* ------------------------------------------------------------------------------------------
* Input/Output:
*--------------
* IN  :
* ACCT.ID - ACCOUNT no
* OUT :
* CHK.VAL - Value based on which the point to be updated in REDO.LY.POINTS is computed
*
* Dependencies:
*---------------
* CALLS     : -NA-
* CALLED BY : REDO.B.LY.POINT.GEN
*
* Revision History:
*------------------
*   Date               who           Reference            Description
* 03-MAY-2010   N.Satheesh Kumar  ODR-2009-12-0276      Initial Creation
*Modification history
*Date                Who               Reference                  Description
*06-04-2023      conversion tool     R22 Auto code conversion     No changes
*06-04-2023      Mohanraj R          R22 Manual code conversion   No changes

*---------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_REDO.B.LY.POINT.GEN.COMMON
* Tus Start
    $INSERT I_F.EB.CONTRACT.BALANCES
* Tus End

    CHK.VAL = ''
    GOSUB GET.INC.BAL
    CHK.VAL = CURR.BALANCE - PREV.BALANCE
RETURN
*----------------
GET.INC.BAL:
*----------------
*--------------------------------------------------------------
* This section calculates the Increase balance for each day
*--------------------------------------------------------------
    ACCT.ACT.ID = ACCT.ID
    R.ACCT = ''
    CALL F.READ(FN.ACCOUNT,ACCT.ID,R.ACCT,F.ACCOUNT,ACCT.ERR)
*  CURR.BALANCE = R.ACCT<AC.WORKING.BALANCE>
*  PREV.BALANCE = R.ACCT<AC.OPEN.ACTUAL.BAL>
    CALL EB.READ.HVT('EB.CONTRACT.BALANCES',ACCT.ID,R.ECB,ECB.ERR)
    CURR.BALANCE = R.ECB<ECB.WORKING.BALANCE>
    PREV.BALANCE = R.ECB<ECB.OPEN.ACTUAL.BAL>
RETURN
END
