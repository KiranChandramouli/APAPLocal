* @ValidationCode : MjotMTkyNzI5MjYzNjpDcDEyNTI6MTcwNDQ0MTUzNTc2NTozMzNzdTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 05 Jan 2024 13:28:55
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : 333su
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.B.STATUS1.UPD.SELECT

*------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : JEEVA T
* PROGRAM NAME : REDO.B.STATUS1.UPD.SELECT
*------------------------------------------------------------------
* Description : This is the update rotuine which will select all the customer
* accounts for processing
**********************************************************************
*08-08-2011                JEEVAT             EB.LOOKUP select has been removed
* DATE              WHO                REFERENCE                 DESCRIPTION
* 04-APR-2023     Conversion tool   R22 Auto conversion      VM to @VM, ++ to +=
* 04-APR-2023      Harishvikram C   Manual R22 conversion      No changes
*------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.EB.LOOKUP
    $INSERT I_F.ACCOUNT.PARAMETER
    $INSERT I_REDO.B.STATUS1.UPD.COMMON
    $USING EB.Service



    GOSUB ACCOUNT.SELECT
RETURN
*-----------------------------------------------------
ACCOUNT.SELECT:
*-----------------------------------------------------

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
        Y.CNT += 1
    REPEAT

*SEL.CMD = "SELECT ":FN.ACCOUNT

    SEL.CMD  = "SELECT ":FN.ACCOUNT:Y.FINAL.SEL.FORM

    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.REC,RET.CODE)

*    CALL BATCH.BUILD.LIST('',SEL.LIST)
    EB.Service.BatchBuildList('',SEL.LIST);* R22 UTILITY AUTO CONVERSION
 
RETURN

END
