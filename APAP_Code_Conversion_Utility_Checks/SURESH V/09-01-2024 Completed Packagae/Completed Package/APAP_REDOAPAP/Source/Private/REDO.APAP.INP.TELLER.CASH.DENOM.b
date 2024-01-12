* @ValidationCode : MjotMTI0OTI3OTYwOkNwMTI1MjoxNjg0ODM2MDQyNDYwOklUU1M6LTE6LTE6LTMyOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 23 May 2023 15:30:42
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -32
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOAPAP
SUBROUTINE REDO.APAP.INP.TELLER.CASH.DENOM
*********************************************************************************************************
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.APAP.INP.TELLER.CASH.DENOM
*--------------------------------------------------------------------------------------------------------
*Description       : This is an INPUT routine, the routine validates if the amount and the denominations
*                    amount is equal or not and throw an override accordingly
*Linked With       : Versions TELLER,REDO.LCY.CASHIN and TELLER,REDO.CHQ.CLG
*In  Parameter     : N/A
*Out Parameter     : N/A
*Files  Used       : TELLER                              As          I       Mode
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*    Date               Who                  Reference                 Description
*   ------             -----               -------------              -------------
* 19 July 2010     Shiva Prasad Y      ODR-2009-10-0318 B.126        Initial Creation
*---------------------------------------------------------------------------------------
*DATE               WHO                       REFERENCE                 DESCRIPTION
*13-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION   FM to @FM ,VM to @VM
*13-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION NO CHANGE
*----------------------------------------------------------------------------------------
*
*********************************************************************************************************
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.TELLER
*--------------------------------------------------------------------------------------------------------
**********
MAIN.PARA:
**********
* This is the para from where the execution of the code starts
    GOSUB PROCESS.PARA

RETURN
*--------------------------------------------------------------------------------------------------------
*************
PROCESS.PARA:
*************
* This is the main processing para
    GOSUB GET.DENOM.AMT
    GOSUB CHECK.AMT.DIFF

RETURN
*--------------------------------------------------------------------------------------------------------
**************
GET.DENOM.AMT:
**************
    Y.DENOM.COUNT = DCOUNT(R.NEW(TT.TE.DR.DENOM),@VM)
    Y.COUNT = 1

    LOOP
    WHILE Y.COUNT LE Y.DENOM.COUNT
        Y.DR.DENOM = R.NEW(TT.TE.DR.DENOM)<1,Y.COUNT>[4,LEN(R.NEW(TT.TE.DR.DENOM)<1,Y.COUNT>)]
        Y.DR.AMT   = R.NEW(TT.TE.DR.UNIT)<1,Y.COUNT>
        Y.TOT.AMT  = Y.TOT.AMT + (Y.DR.DENOM * Y.DR.AMT)
        Y.COUNT += 1
    REPEAT

RETURN
*--------------------------------------------------------------------------------------------------------
***************
CHECK.AMT.DIFF:
***************
    Y.TXN.AMT = R.NEW(TT.TE.AMOUNT.LOCAL.1)
    Y.DIFF    = Y.TXN.AMT - Y.TOT.AMT

    IF Y.DIFF EQ 0 THEN
        RETURN
    END

    Y.CCY = R.NEW(TT.TE.DR.DENOM)<1,1>[1,3]
    IF Y.DIFF GT 0 THEN
        TEXT = 'TFS.TELLER.CASH.DENOM':@FM:Y.CCY:'.':Y.DIFF
    END ELSE
        Y.DIFF = ABS(Y.DIFF)
        TEXT = 'TFS.TELLER.CASH.DENOM':@FM:'- ':Y.CCY:'.':Y.DIFF
    END
    CURR.NO = DCOUNT(R.NEW(TT.TE.OVERRIDE),@VM) + 1
    CALL STORE.OVERRIDE(CURR.NO)

RETURN
*--------------------------------------------------------------------------------------------------------
END       ;* End of Program
