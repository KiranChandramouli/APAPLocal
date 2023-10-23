* @ValidationCode : MjotODQyMzM0MDc2OkNwMTI1MjoxNjk3NzAwMzk0MjU2OnZpY3RvOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 19 Oct 2023 12:56:34
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : victo
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOAPAP
*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*----------------------------------------------------------------------------
SUBROUTINE REDO.B.L.AC.STATUS1.UPD.SELECT
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------

*-----------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : JAYASURYA H
* PROGRAM NAME : REDO.B.L.AC.STATUS1.UPD
*------------------------------------------------------------------
* Description : This is the single thread to update the L.AC.STATUS  manually.
*------------------------------------------------------------------

*Modification Details:
*=====================
*    14/08/2023    JAYASURYA H      TSR-637123         CORRECTION ROUTINE
*
** 09-10-2023     AJITH KUMAR .S               R22 MANUAL CODE CONVERSION                 VM to  @VM
*------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.DATES
    $INSERT I_F.EB.LOOKUP
    $INSERT I_F.ACCOUNT.PARAMETER
*    $INSERT I_REDO.B.STATUS1.UPD.COMMON
    $INSERT I_F.REDO.PREVALANCE.STATUS
    $INSERT I_F.EB.CONTRACT.BALANCES
    $INSERT I_L.AC.STATUS1.UPD.COMMON

    Y.SYSTEM = 'SYSTEM'
    CALL CACHE.READ(FN.ACCOUNT.PARAMETER,Y.SYSTEM,R.ACCT.PARAMETER,Y.ERR)
    Y.PARA.CATG.STR = R.ACCT.PARAMETER<AC.PAR.ACCT.CATEG.STR>
    Y.PARA.CATG.END = R.ACCT.PARAMETER<AC.PAR.ACCT.CATEG.END>
    Y.FINAL.SEL.FORM = ''
    Y.CNT = 1

    LOOP
    WHILE Y.CNT LE DCOUNT(Y.PARA.CATG.STR,@VM)
        Y.SEL.CMD.FORM = ' WITH ( CATEGORY GE ':Y.PARA.CATG.STR<1,Y.CNT>:' AND WITH CATEGORY LE ':Y.PARA.CATG.END<1,Y.CNT>:' ) '
        IF NOT(Y.FINAL.SEL.FORM) THEN
            Y.FINAL.SEL.FORM = Y.SEL.CMD.FORM
        END ELSE
            Y.FINAL.SEL.FORM := ' OR  ':Y.SEL.CMD.FORM
        END
        Y.CNT = Y.CNT + 1
    REPEAT

    SEL.CMD  = "SELECT ":FN.ACCOUNT:Y.FINAL.SEL.FORM

    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.REC,RET.CODE)

    CALL BATCH.BUILD.LIST('',SEL.LIST)

END
