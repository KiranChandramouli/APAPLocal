* @ValidationCode : MjotMTUwMTU0OTIwODpDcDEyNTI6MTY4MTIwMDMxNTY2NzpzYW1hcjotMTotMTowOjA6ZmFsc2U6Ti9BOkRFVl8yMDIxMDguMDotMTotMQ==
* @ValidationInfo : Timestamp         : 11 Apr 2023 13:35:15
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : samar
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOVER
SUBROUTINE REDO.V.INP.CHECK.AMT
*-------------------------------------------------------------------------------------------
*DESCRIPTION:
*             This Input routine will calculate the sum of all the payments in multi-value field
*L.AZ.AMOUNT and compare it with the PRINCIPAL.If there is any difference then throws the error
*message with the difference
* ------------------------------------------------------------------------------------------
* Input/Output:
*--------------
* IN  : -NA-
* OUT : -NA-
*
* Dependencies:
*---------------
* CALLS : -NA-
* CALLED BY : -NA-
*
* Revision History:
*------------------
*   Date               who           Reference            Description
* 27-JAN-2010       Prabhu.N       ODR-2009-10-0315      Initial Creation
* 08.NOV.2011       Sudharsanan S      CR.18              Modify
*--------------------------------------------------------------------------------------------------

*Modification History
*DATE                       WHO                         REFERENCE                                   DESCRIPTION
*11-04-2023            Conversion Tool             R22 Auto Code conversion                FM TO @FM,VM TO @VM,SM TO @SM,++ TO +=1
*11-04-2023              Samaran T                R22 Manual Code conversion                         No Changes
*-------------------------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.AZ.ACCOUNT
    GOSUB INIT
*********CR.18-S*********
    Y.REPAY.ACCOUNT = R.NEW(AZ.REPAY.ACCOUNT)
    IF NOT(Y.REPAY.ACCOUNT) THEN
        GOSUB CALC.DIFF
    END
*******CR.18-E*************
RETURN
*----
INIT:
*----
    Y.DIFF.AMT=''
    Y.TOT.PAY.AMT=''
    LREF.APP='AZ.ACCOUNT'
    LREF.FIELD='L.AZ.AMOUNT':@VM:'ORIG.LCY.AMT'
    LREF.POS=''
    CALL MULTI.GET.LOC.REF(LREF.APP,LREF.FIELD,LREF.POS)
    POS.L.AZ.AMOUNT = LREF.POS<1,1>
    POS.ORIG.LCY.AMT = LREF.POS<1,2>
RETURN
*--------
CALC.DIFF:
*---------
    Y.AMOUNT.LIST = R.NEW(AZ.LOCAL.REF)<1,POS.L.AZ.AMOUNT>
*******CR.18-S************
    Y.CURRENCY = R.NEW(AZ.CURRENCY)
    IF Y.CURRENCY NE LCCY THEN
        Y.PRIN.AMT = R.NEW(AZ.LOCAL.REF)<1,POS.ORIG.LCY.AMT>
    END ELSE
        Y.PRIN.AMT = R.NEW(AZ.PRINCIPAL)
    END
*********CR.18-E************
    Y.AMOUNT.LIST.SIZE = DCOUNT(Y.AMOUNT.LIST,@SM)
    CHANGE @SM TO @FM IN Y.AMOUNT.LIST
    CNT = 1
    LOOP
    WHILE CNT LE Y.AMOUNT.LIST.SIZE
        Y.TOT.PAY.AMT=Y.TOT.PAY.AMT+Y.AMOUNT.LIST<CNT>
        CNT += 1
    REPEAT
    IF Y.TOT.PAY.AMT GT Y.PRIN.AMT THEN
        Y.DIFF.AMT=Y.TOT.PAY.AMT - Y.PRIN.AMT
        Y.DIF.AMT = FMT(Y.DIFF.AMT, "L2#10")
        AF = AZ.LOCAL.REF
        AV = POS.L.AZ.AMOUNT
        AS = 1
        ETEXT='EB-REDO.AMOUNT.NOT.MATCH':@FM:Y.DIF.AMT
        CALL STORE.END.ERROR
    END
    IF Y.TOT.PAY.AMT LT Y.PRIN.AMT THEN
        Y.DIFF.AMT = Y.PRIN.AMT - Y.TOT.PAY.AMT
        Y.DIF.AMT = FMT(Y.DIFF.AMT, "L2#10")
        AF = AZ.LOCAL.REF
        AV = POS.L.AZ.AMOUNT
        AS = 1
        ETEXT='EB-REDO.AMOUNT.NOT.MATCH':@FM:Y.DIF.AMT
        CALL STORE.END.ERROR
    END
RETURN
END
