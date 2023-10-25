* @ValidationCode : MjoxMzk0MTAzMzY2OkNwMTI1MjoxNjk4MjMyNTk3MzY4OnZpZ25lc2h3YXJpOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 25 Oct 2023 16:46:37
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
$PACKAGE APAP.IBS
*-----------------------------------------------------------------------------------------------------------------------------------
*Modification HISTORY:
*DATE                          AUTHOR                   Modification                            DESCRIPTION
*25/10/2023                VIGNESHWARI       MANUAL R23 CODE CONVERSION                VM TO @VM, FM TO @FM
*-----------------------------------------------------------------------------------------------------------------------------------

SUBROUTINE REDO.ITSS.V.VAL.SRC.ACC.LBTR

$INCLUDE I_COMMON
$INCLUDE I_EQUATE
$INCLUDE I_F.ACCOUNT
$INCLUDE I_F.FUNDS.TRANSFER
 
GOSUB INIT
GOSUB PROCESS
RETURN


INIT:
	FN.ACCOUNT = "F.ACCOUNT"
	F.ACCOUNT = ""
	CALL OPF(FN.ACCOUNT,F.ACCOUNT)
	
	LREF.APP = 'ACCOUNT':@FM:'FUNDS.TRANSFER'
	LREF.FIELDS = 'L.AC.AV.BAL':@FM:'L.TT.TAX.AMT':@VM:'L.TT.COMM.AMT'
	
	LREF.POS=""
	CALL MULTI.GET.LOC.REF(LREF.APP,LREF.FIELDS ,LREF.POS)
	POS.L.AV.BAL= LREF.POS<1,1>
	POS.L.TT.TAX.AMT = LREF.POS<2,1>
	POS.L.TT.COM.AMT= LREF.POS<2,2>
	
RETURN
	

PROCESS:

Y.ACCOUNT.ID = R.NEW(FT.DEBIT.ACCT.NO)
Y.DEBIT.AMOUNT = R.NEW(FT.DEBIT.AMOUNT)


CALL F.READ(FN.ACCOUNT,Y.ACCOUNT.ID,R.ACCOUNT,F.ACCOUNT,ERR)

Y.ACCT.BAL= R.ACCOUNT<AC.LOCAL.REF,POS.L.AV.BAL>
Y.WORK.BAL= R.ACCOUNT<AC.WORKING.BALANCE>

Y.TAX.AMT = R.NEW(FT.LOCAL.REF)<1,POS.L.TT.TAX.AMT>
Y.COM.AMT = R.NEW(FT.LOCAL.REF)<1,POS.L.TT.COM.AMT>

Y.CHARGE = Y.TAX.AMT + Y.COM.AMT

IF Y.CHARGE  GT Y.ACCT.BAL   OR Y.ACCT.BAL  LT 0 THEN
ETEXT = 'EB-AMT.NOT.AVAIL'
AF = FT.DEBIT.AMOUNT
CALL STORE.END.ERROR
END

RETURN

END