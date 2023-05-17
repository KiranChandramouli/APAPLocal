*-----------------------------------------------------------------------------
* <Rating>-74</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.FT.DS.NAME(Y.FIELD.NAME)
*-------------------------------------------------------------
*Description: This routine is call routine from deal slip of TT

*-------------------------------------------------------------
*Input Arg : Y.INP.DEAL
*Out Arg   : Y.INP.DEAL
*Deals With: TT payement
*Modify    :btorresalbornoz
*-------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.COMPANY
$INSERT I_F.TELLER
$INSERT I_F.ACCOUNT
$INSERT I_F.RELATION
$INSERT I_F.CUSTOMER
$INSERT I_F.FUNDS.TRANSFER
  GOSUB INITIALISE
  GOSUB PROCESS
  RETURN
*-------------------------------------------------------------------------
PROCESS:
*-------------------------------------------------------------------------

  BEGIN CASE

  CASE Y.FIELD.NAME EQ 'Y.NAME'
    GOSUB GET.NAME

    RETURN

  CASE Y.FIELD.NAME EQ 'L.TT.TRANS.AMT'

    GOSUB GET.TRANS.AMT
    Y.FIELD.NAME = FMT(Y.TT.TRANS.AMT,"16R,2")
    RETURN



  CASE Y.FIELD.NAME EQ 'L.TT.TAX.AMT'
    GOSUB GET.TAX.AMT.DETAIL
    Y.FIELD.NAME = FMT(Y.TAX.COM1,"10R,2")
    RETURN


  CASE Y.FIELD.NAME EQ 'Y.DATE.TIME'
    GET.DATE.TIME = R.NEW(FT.DATE.TIME)
    GOSUB GET.DATE.TIME.INFO

    RETURN


  CASE Y.FIELD.NAME EQ 'Y.CO.CODE'

    GET.CO.CODE =R.COMPANY(EB.COM.COMPANY.NAME):"-":OPERATOR
    GET.CO.CODE=GET.CO.CODE[1,30]
    Y.FIELD.NAME = FMT(GET.CO.CODE,"30R")

    RETURN

  CASE Y.FIELD.NAME EQ 'L.NCF.TAX.NUM'
    Y.FIELD.NAME = FMT(L.NFC.TAX.NUM,"19R")

    RETURN

  CASE Y.FIELD.NAME EQ 'Y.CONCEPT'
    Y.L.T.CONCEPT =  R.NEW(FT.LOCAL.REF)<1,L.FT.CONCEPT>
    Y.L.T.CONCEPT=Y.L.T.CONCEPT[1,35]
    Y.FIELD.NAME = FMT(Y.L.T.CONCEPT,"35R")

    RETURN







  END CASE
  RETURN


*----------------------------------------------------------------------------------------------------------------------
GET.DATE.TIME.INFO:
*----------------------------------------------------------------------------------------------------------------------

  F1 = GET.DATE.TIME[1,2]
  F2 = GET.DATE.TIME[3,2]
  F3 = GET.DATE.TIME[5,2]
  F4 = GET.DATE.TIME[7,2]
  F5 = GET.DATE.TIME[9,2]

  Y.TIME = F3:'/':F2:'/':F1:'-':F4:':':F5
  Y.FIELD.NAME = FMT(Y.TIME,"15R")

  RETURN



*-------------------------------------------------------------------------
GET.TRANS.AMT:
*-------------------------------------------------------------------------

  Y.TT.TRANS.AMT = R.NEW(FT.LOCAL.REF)<1,L.TT.TRANS.AMT>

  RETURN




*----------------------------------------------------------------------------------------------------------------------
GET.NAME:
*----------------------------------------------------------------------------------------------------------------------



  CALL F.READ(FN.ACCOUNT,GET.ACCT.NO,R.ACCOUNT,F.ACCOUNT,ACC.ERR)
  CUSTOMER.ID = R.ACCOUNT<AC.CUSTOMER>
  CALL F.READ(FN.CUSTOMER,CUSTOMER.ID,R.CUSTOMER,F.CUSTOMER,CUSTOMER.ERR)

  IF R.CUSTOMER<EB.CUS.LOCAL.REF,GET.REF.POS> EQ "PERSONA FISICA" OR R.CUSTOMER<EB.CUS.LOCAL.REF,GET.REF.POS> EQ "CLIENTE MENOR" THEN
    Y.NAME1 = R.CUSTOMER<EB.CUS.GIVEN.NAMES>:" ":R.CUSTOMER<EB.CUS.FAMILY.NAME>
  END ELSE
    IF R.CUSTOMER<EB.CUS.LOCAL.REF,GET.REF.POS> EQ "PERSONA JURIDICA" THEN
      Y.NAME1 = R.CUSTOMER<EB.CUS.NAME.1,1>:" ":R.CUSTOMER<EB.CUS.NAME.2,1>
    END
  END
  GOSUB JOINT.HOLDER.CHECK
  Y.NAME = Y.NAME1:' ':Y.REL.DESC:' ':Y.NAME2
  Y.NAME = Y.NAME[1,36]
  Y.FIELD.NAME = FMT(Y.NAME,"36R")

  RETURN

*----------------------------------------------------------------------------------------------------------------------
JOINT.HOLDER.CHECK:
*----------------------------------------------------------------------------------------------------------------------

  Y.RELATION.CODE = R.CUSTOMER<EB.CUS.RELATION.CODE>
  IF Y.RELATION.CODE GE 500 AND Y.RELATION.CODE LE 529 THEN
    CALL F.READ(FN.RELATION,Y.RELATION.CODE,R.RELATION,F.RELATION,REL.ERR)
    Y.REL.DESC = R.RELATION<EB.REL.DESCRIPTION>
    Y.ACC.JOINT.HOLD = R.ACCOUNT<AC.JOINT.HOLDER>
    CALL F.READ(FN.CUSTOMER,Y.ACC.JOINT.HOLD,R.CUSTOMER,F.CUSTOMER,CUSTOMER.ERR)
    Y.NAME = R.CUSTOMER<EB.CUS.LOCAL.REF,GET.REF.POS>
    IF R.CUSTOMER<EB.CUS.LOCAL.REF,GET.REF.POS> EQ "PERSONA FISICA" OR R.CUSTOMER<EB.CUS.LOCAL.REF,GET.REF.POS> EQ "CLIENTE MENOR" THEN
      Y.NAME2 = R.CUSTOMER<EB.CUS.GIVEN.NAMES>:" ":R.CUSTOMER<EB.CUS.FAMILY.NAME>
    END ELSE
      IF R.CUSTOMER<EB.CUS.LOCAL.REF,GET.REF.POS> EQ "PERSONA JURIDICA" THEN
        Y.NAME2 = R.CUSTOMER<EB.CUS.NAME.1,1>:" ":R.CUSTOMER<EB.CUS.NAME.2,1>
      END
    END
  END

  RETURN


*----------------------------------------------------------------------------------------------------------------------
GET.TAX.AMT.DETAIL:
*----------------------------------------------------------------------------------------------------------------------



  Y.WVT1 = 1
  Y.TOTAL = ''



  Y.WVT.COUNT1 = DCOUNT(Y.WV.TAX,VM)

  LOOP
  WHILE Y.WVT1 LE Y.WVT.COUNT1

    IF Y.WV.TAX = 'NO' THEN

      Y.TAX.COM1 = R.NEW(FT.LOCAL.REF)<1,L.TT.TAX.AMT>
      Y.TAX.COM1=CHANGE(Y.TAX.COM1,SM,VM)
      Y.TAX.COM1=CHANGE(Y.TAX.COM1,FM,VM)
      Y.TAX.COM1=Y.TAX.COM1<1,Y.WVT1>

    END


    Y.WVT1++

  REPEAT

*   Y.TAX.AMT = Y.TT.TAX.AMT:VM:Y.TT.COMM.AMT

*   LOOP
*       REMOVE Y.TAX FROM Y.TAX.AMT SETTING TAX.POS
*   WHILE Y.TAX:TAX.POS
*       Y.TOTAL += Y.TAX
*   REPEAT
  RETURN





*----------------------------------------------------------------------------------------------------------------------
INITIALISE:
*------------------------------------------------------------------------------------------------

  FN.CUSTOMER = 'F.CUSTOMER'
  F.CUSTOMER = ''
  CALL OPF(FN.CUSTOMER,F.CUSTOMER)

  Y.APPL = 'CUSTOMER':FM:'TELLER':FM:'FUNDS.TRANSFER'
  Y.FIELD = 'L.CU.TIPO.CL':FM:'L.TT.TAX.AMT':VM:'L.TT.COMM.AMT':VM:'L.TT.WV.COMM':VM:'L.TT.WV.TAX':FM:'L.TT.TRANS.AMT':VM:'L.TT.TAX.AMT':VM:'L.TT.WV.TAX':VM:'L.NCF.TAX.NUM':VM:'L.FT.CONCEPT'
  Y.FLD.POS = ''
  CALL MULTI.GET.LOC.REF(Y.APPL,Y.FIELD,Y.FLD.POS)
  GET.REF.POS = Y.FLD.POS<1,1>
  L.TT.TAX.AMT.POS = Y.FLD.POS<2,1>
  L.TT.COMM.AMT.POS = Y.FLD.POS<2,2>
  L.TT.WV.COMM = Y.FLD.POS<2,3>
  L.TT.TRANS.AMT = Y.FLD.POS<3,1>
  L.TT.TAX.AMT=Y.FLD.POS<3,2>
  L.TT.WV.TAX  = Y.FLD.POS<3,3>
  L.NFC.TAX.NUM.POS=Y.FLD.POS<3,4>
  L.FT.CONCEPT=Y.FLD.POS<3,5>

  Y.WV.TAX =  R.NEW(FT.LOCAL.REF)<1,L.TT.WV.TAX>
  L.NFC.TAX.NUM=R.NEW(FT.LOCAL.REF)<1,L.NFC.TAX.NUM.POS>
  GET.ACCT.NO = R.NEW(FT.DEBIT.ACCT.NO)


  FN.ACCOUNT = 'F.ACCOUNT'
  F.ACCOUNT = ''
  CALL OPF(FN.ACCOUNT,F.ACCOUNT)

  FN.RELATION = 'F.RELATION'
  F.RELATION = ''
  CALL OPF(FN.RELATION,F.RELATION)



  RETURN




END
