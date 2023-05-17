*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
* <Rating>-10</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.V.VAL.ADV.AMT
*--------------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :PRABHU.N
*Program   Name    :REDO.V.VAL.ADV.AMT
*---------------------------------------------------------------------------------

*DESCRIPTION       :It is a validation routine attached to advance payment version of FT and TELLER
*LINKED WITH       :

* ----------------------------------------------------------------------------------
*Modification Details:
*=====================
*   Date               who           Reference            Description
* 3-JUN-2010        Prabhu.N       ODR-2010-01-0081    Initial Creation
*-------------------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.AA.PAYMENT.SCHEDULE
$INSERT I_F.AA.ACCOUNT.DETAILS
$INSERT I_F.TELLER
$INSERT I_F.FUNDS.TRANSFER
$INSERT I_F.ACCOUNT
$INSERT I_F.AA.ARRANGEMENT



  FN.AA.ACCOUNT.DETAILS='F.AA.ACCOUNT.DETAILS'
  F.AA.ACCOUNT.DETAILS=''
  CALL OPF(FN.AA.ACCOUNT.DETAILS,F.AA.ACCOUNT.DETAILS)

  FN.AA.ARRANGEMENT='F.AA.ARRANGEMENT'
  F.AA.ARRANGEMENT=''
  CALL OPF(FN.AA.ARRANGEMENT,F.AA.ARRANGEMENT)

  FN.ACCOUNT='F.ACCOUNT'
  F.ACCOUNT=''
  CALL OPF(FN.ACCOUNT,F.ACCOUNT)

  VAR.NO.OF.INSTALLMENT=COMI


  IF APPLICATION EQ 'FUNDS.TRANSFER' THEN
    VAR.AC.ID=R.NEW(FT.CREDIT.ACCT.NO)
    GOSUB PROCESS

    R.NEW(FT.CREDIT.AMOUNT)=VAR.INSTALL.AMOUNT
  END
  IF APPLICATION EQ 'TELLER' THEN
    VAR.AC.ID=R.NEW(TT.TE.ACCOUNT.2)
    GOSUB PROCESS
    R.NEW(TT.TE.AMOUNT.LOCAL.1)=VAR.INSTALL.AMOUNT
  END
  RETURN
PROCESS:


  CALL F.READ(FN.ACCOUNT,VAR.AC.ID,R.ACCOUNT,F.ACCOUNT,ERR)
  VAR.AA.ID=R.ACCOUNT<AC.ARRANGEMENT.ID>
  CALL F.READ(FN.AA.ARRANGEMENT,VAR.AA.ID,R.AA.ARRANGEMENT,F.AA.ARRANGEMENT,ERR)
  CALL F.READ(FN.AA.ACCOUNT.DETAILS,VAR.AA.ID,R.AA.ACCOUNT.DETAILS ,F.AA.ACCOUNT.DETAILS ,ERR)
  VAR.SET.LIST=R.AA.ACCOUNT.DETAILS<AA.AD.SET.STATUS>
  CHANGE VM TO FM IN  VAR.SET.LIST
  CHANGE SM TO FM IN  VAR.SET.LIST
  LOCATE 'UNPAID' IN  VAR.SET.LIST SETTING POS ELSE
    PROP.CLASS='PAYMENT.SCHEDULE'
    CALL REDO.CRR.GET.CONDITIONS(VAR.AA.ID,EFF.DATE,PROP.CLASS, PROPERTY,R.CONDITION,ERR.MSG)
    VAR.CALC.AMOUNT.LIST=R.CONDITION<AA.PS.CALC.AMOUNT>
    VAR.ACC.LIST   =R.CONDITION<AA.PS.PROPERTY>
    CHANGE VM TO FM IN VAR.CALC.AMOUNT.LIST
    CHANGE VM TO FM IN VAR.ACC.LIST
    CHANGE SM TO FM IN VAR.ACC.LIST
    LOCATE 'ACCOUNT' IN  VAR.ACC.LIST SETTING VAR.ACC.POS THEN
      VAR.CALC.AMOUNT=VAR.CALC.AMOUNT.LIST<VAR.ACC.POS>
    END
    VAR.INSTALL.AMOUNT=VAR.CALC.AMOUNT*VAR.NO.OF.INSTALLMENT
  END
  RETURN
END
