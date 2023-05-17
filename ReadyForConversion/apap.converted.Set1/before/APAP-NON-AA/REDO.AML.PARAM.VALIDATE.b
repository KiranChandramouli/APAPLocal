*-----------------------------------------------------------------------------
* <Rating>-23</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.AML.PARAM.VALIDATE
*********************************************************************************************************
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.AML.PARAM.VALIDATE
*--------------------------------------------------------------------------------------------------------
*Description       : REDO.AML.PARAM.VALIDATE is a validation routine attached to the TEMPLATE
*Linked With       : Template - REDO.AML.PARAM
*In  Parameter     : NA
*Out Parameter     : NA
*Files  Used       : REDO.AML.PARAM         As              I               Mode
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*    Date               Who                  Reference                  Description
*   ------            ------               -------------               -------------
*  08-04-11             RIYAS            ODR-2009-10-0472          REDO.AML.PARAM Validation Routine
*********************************************************************************************************
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.CURRENCY

$INSERT I_F.REDO.AML.PARAM

  FN.CURRENCY='F.CURRENCY'
  F.CURRENCY=''
  CALL OPF(FN.CURRENCY,F.CURRENCY)

  FN.REDO.AML.PARAM='F.REDO.AML.PARAM'
  F.REDO.AML.PARAM=''
  CALL OPF(FN.REDO.AML.PARAM,F.REDO.AML.PARAM)

  LOC.REF.APPLICATION="CURRENCY"
  LOC.REF.FIELDS='L.CU.AMLBUY.RT'
  LOC.REF.POS=''
  CALL MULTI.GET.LOC.REF(LOC.REF.APPLICATION,LOC.REF.FIELDS,LOC.REF.POS)
  LOC.AMLBUY.RT=LOC.REF.POS<1>
*-------------------------------------------------------------------------------------------------------
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
  Y.CCY = R.NEW(AML.PARAM.AML.CCY)
  Y.LIMIT.FCY = R.NEW(AML.PARAM.AMT.LIMIT.FCY)
  Y.LIMIT.LCY = R.NEW(AML.PARAM.AMT.LIMIT.LCY)
  CALL F.READ(FN.CURRENCY,Y.CCY,R.CURRENCY,F.CURRENCY,CUR.ERR)
  Y.EXC.AMT=R.CURRENCY<EB.CUR.LOCAL.REF,LOC.AMLBUY.RT>
  Y.FIN.AMT=Y.LIMIT.FCY*Y.EXC.AMT
  R.NEW(AML.PARAM.AMT.LIMIT.LCY)=Y.FIN.AMT
  RETURN
*--------------------------------------------------------------------------------------------------------
END       ;* End of Program
