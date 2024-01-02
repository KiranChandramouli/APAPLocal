* @ValidationCode : MjoxOTY2OTI2OTQ2OkNwMTI1MjoxNjgyNDEyMzM4NDc3OkhhcmlzaHZpa3JhbUM6LTE6LTE6MDoxOmZhbHNlOk4vQTpERVZfMjAyMTA4LjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 25 Apr 2023 14:15:38
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : HarishvikramC
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOVER
SUBROUTINE REDO.V.AUTH.AC.AV.BAL.UPDATE
*********************************************************************************************************
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.V.AUTH.AC.AV.BAL.UPDATE
*--------------------------------------------------------------------------------------------------------
*Description       : REDO.APAP.B.AC.AV.BAL.UPDATE is the main processsing routine, this routine is used to
*                    update the local reference field L.AC.AV.BAL which will be difference between the
*                    amount of WORKING.BALANCE and LOCKED.AMOUNT
*Linked With       : Batch BNK/REDO.B.AC.AV.BAL.UPDATE
*In  Parameter     : ACCOUNT.ID
*Out Parameter     : NA
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*    Date               Who                    Reference                  Description
*   ------             -----                 -------------               -------------
* 05 JUN 2011       Prabhu N                 PACS00328159                Balance updated on auth
* 05 JUN 2015       V.P.Ashokkumar           PACS00462446                Added to remove the ACCOUNT.LIQUADATION for
*                                                                        closed AZ deposit accounts.
*********************************************************************************************************
*Modification History
*DATE                       WHO                         REFERENCE                                   DESCRIPTION
*10-04-2023            Conversion Tool             R22 Auto Code conversion                      FM TO @FM VM TO @VM
*10-04-2023              Samaran T                R22 Manual Code conversion                         No Changes
*-------------------------------------------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.ACCOUNT
$INSERT I_F.AZ.ACCOUNT
$INSERT I_F.EB.CONTRACT.BALANCES   ;* Tus S/E

IF APPLICATION EQ 'ACCOUNT' THEN
GOSUB GET.LOCAL.POS
GOSUB PROCESS
END

IF APPLICATION EQ 'AZ.ACCOUNT' OR APPLICATION EQ 'ACCOUNT.CLOSURE' THEN
GOSUB GET.LOCAL.POS
GOSUB ACCT.LIQ.PROCES
END

RETURN
*-------------
GET.LOCAL.POS:
*-------------
LOC.REF.POS = ''
LOC.REF.APPLICATION = "ACCOUNT":@FM:"AZ.ACCOUNT"
LOC.REF.FIELDS = "L.AC.AV.BAL":@FM:"L.TYPE.INT.PAY"
CALL MULTI.GET.LOC.REF(LOC.REF.APPLICATION,LOC.REF.FIELDS,LOC.REF.POS)
LOC.L.AC.AV.BAL.POS = LOC.REF.POS<1,1>
GET.INT.TYPE = LOC.REF.POS<2,1>
RETURN
*--------------------------------------------------------------------------------------------------------
PROCESS:
*------*
*
GOSUB PROCESS.PARA
*
RETURN
*--------------------------------------------------------------------------------------------------------
*************
PROCESS.PARA:
*************

*  Y.AMT = R.NEW(AC.WORKING.BALANCE)   ;* Tus Start
CALL EB.READ.HVT("EB.CONTRACT.BALANCES",ID.NEW,R.ECB,ECB.ERR)
Y.AMT = R.ECB<ECB.WORKING.BALANCE>   ;* Tus End

GOSUB GET.LOCKED.AMOUNT
Y.AC.AV.BAL = 0
Y.AC.AV.BAL = Y.AMT - Y.LOCK.AMT

IF R.NEW(AC.LOCAL.REF)<1,LOC.L.AC.AV.BAL.POS> EQ Y.AC.AV.BAL THEN
RETURN
END

R.NEW(AC.LOCAL.REF)<1,LOC.L.AC.AV.BAL.POS> = Y.AC.AV.BAL


RETURN
*--------------------------------------------------------------------------------------------------------
******************
GET.LOCKED.AMOUNT:
******************

Y.LOCK.AMT = 0
IF NOT(R.NEW(AC.FROM.DATE)) THEN
Y.LOCK.AMT = 0
RETURN
END

Y.DATE.COUNT = DCOUNT(R.NEW(AC.FROM.DATE),@VM)
Y.DATE.START = 1

LOOP
WHILE Y.DATE.START LE Y.DATE.COUNT
IF R.NEW(AC.FROM.DATE)<1,Y.DATE.START> LE TODAY THEN
Y.LOCK.AMT = R.NEW(AC.LOCKED.AMOUNT)<1,Y.DATE.START>
END
Y.DATE.START += 1
REPEAT

RETURN
*--------------------------------------------------------------------------------------------------------

ACCT.LIQ.PROCES:
****************
FN.ACCOUNT.LIQUIDATION = 'F.ACCOUNT.LIQUIDATION'
F.ACCOUNT.LIQUIDATION = ''
CALL OPF(FN.ACCOUNT.LIQUIDATION,F.ACCOUNT.LIQUIDATION)

YACCT.LIQU = ''
YACCT.LIQU = R.OLD(AZ.INTEREST.LIQU.ACCT)
IF YACCT.LIQU NE R.NEW(AZ.INTEREST.LIQU.ACCT) AND R.NEW(AZ.LOCAL.REF)<1,GET.INT.TYPE> NE 'Reinvested' THEN
ERR.ACCT.LIQU = ''; R.ACCT.LIQU = ''
*CALL F.READ(FN.ACCOUNT.LIQUIDATION,YACCT.LIQU,R.ACCT.LIQU,F.ACCOUNT.LIQUIDATION,ERR.ACCT.LIQU)
CALL F.READU(FN.ACCOUNT.LIQUIDATION,YACCT.LIQU,R.ACCT.LIQU,F.ACCOUNT.LIQUIDATION,ERR.ACCT.LIQU,'');* R22 AUTO CONVERSION
IF R.ACCT.LIQU THEN
CALL F.DELETE(FN.ACCOUNT.LIQUIDATION, YACCT.LIQU)
END
END
RETURN
END
