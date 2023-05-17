*-----------------------------------------------------------------------------
* <Rating>-48</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.LETTER.ISSUE.VALIDATE
***********************************************************************
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: H GANESH
* PROGRAM NAME: REDO.LETTER.ISSUE.VALIDATE
* ODR NO      : ODR-2009-10-0838
*----------------------------------------------------------------------
*DESCRIPTION: This is the Validation Routine for REDO.LETTER.ISSUE to
*default the value for the fields



*IN PARAMETER:  NA
*OUT PARAMETER: NA
*LINKED WITH: REDO.LETTER.ISSUE
*----------------------------------------------------------------------
* Modification History :
*-----------------------
*DATE           WHO             REFERENCE                           DESCRIPTION
*18.03.2010  H GANESH        ODR-2009-10-0838                     INITIAL CREATION
*29.07.2011   RIYAS          PACS00072839                         CHANGING RNC FIELD
*05.08.2011  Sudharsanan S   PACS00120765 & PACS00120767          Find the duplicate products and also raised the error msg if more than 4 products selected
*----------------------------------------------------------------------


$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.CUSTOMER
$INSERT I_F.REDO.OFFICERS.LIST
$INSERT I_F.REDO.LETTER.ISSUE
$INSERT I_F.FT.COMMISSION.TYPE
$INSERT I_F.ACCOUNT
$INSERT I_F.EB.CONTRACT.BALANCES ;*Tus (S/E)



  IF V$FUNCTION EQ 'D' THEN
    RETURN
  END

  GOSUB INIT
  GOSUB OPENFILES
  GOSUB LOCAL.REF
  GOSUB PROCESS
  RETURN

*----------------------------------------------------------------------
INIT:
*----------------------------------------------------------------------

  FN.CUSTOMER='F.CUSTOMER'
  F.CUSTOMER=''
  FN.REDO.OFFICERS.LIST='F.REDO.OFFICERS.LIST'
  F.REDO.OFFICERS.LIST=''
  FN.FT.COMMISSION.TYPE='F.FT.COMMISSION.TYPE'
  F.FT.COMMISSION.TYPE=''
  FN.ACCOUNT='F.ACCOUNT'
  F.ACCOUNT=''
  FN.ACCOUNT.HIS = 'F.ACCOUNT$HIS'
  F.ACCOUNT.HIS = ''
  RETURN

*----------------------------------------------------------------------
OPENFILES:
*----------------------------------------------------------------------

  CALL OPF(FN.CUSTOMER,F.CUSTOMER)
  CALL OPF(FN.REDO.OFFICERS.LIST,F.REDO.OFFICERS.LIST)
  CALL OPF(FN.FT.COMMISSION.TYPE,F.FT.COMMISSION.TYPE)
  CALL OPF(FN.ACCOUNT,F.ACCOUNT)
  CALL OPF(FN.ACCOUNT.HIS,F.ACCOUNT.HIS)
  RETURN

*----------------------------------------------------------------------
LOCAL.REF:
*----------------------------------------------------------------------

  LOC.REF.APPLICATION="CUSTOMER"
  LOC.REF.FIELDS='L.CU.TIPO.CL':VM:'L.CU.RNC'
  LOC.REF.POS=''
  CALL MULTI.GET.LOC.REF(LOC.REF.APPLICATION,LOC.REF.FIELDS,LOC.REF.POS)
  RETURN

*----------------------------------------------------------------------
PROCESS:
*----------------------------------------------------------------------

  POS.L.CU.TIPO.CL=LOC.REF.POS<1,1>
  POS.L.CU.RNC=LOC.REF.POS<1,2>
  CHK.VAL = 1
  Y.CUSTOMER.ID=R.NEW(REDO.LET.ISS.CUSTOMER.ID)
  CALL F.READ(FN.CUSTOMER,Y.CUSTOMER.ID,R.CUSTOMER,F.CUSTOMER,CUS.ERR)
  Y.NAME=R.CUSTOMER<EB.CUS.LOCAL.REF,POS.L.CU.TIPO.CL>

  GOSUB DEFAULT.NAME

*   R.NEW(REDO.LET.ISS.CU.IDENTITY)=R.CUSTOMER<EB.CUS.LOCAL.REF,POS.L.CU.RNC>
  Y.ISSUE.OFFICER=R.NEW(REDO.LET.ISS.ISS.OFFICER)
  CALL F.READ(FN.REDO.OFFICERS.LIST,Y.ISSUE.OFFICER,R.REDO.OFFICERS.LIST,F.REDO.OFFICERS.LIST,REDO.OFF.ERR)
  R.NEW(REDO.LET.ISS.DESIGNATION)=R.REDO.OFFICERS.LIST<REDO.OFF.LIS.DESIGNATION>
  R.NEW(REDO.LET.ISS.BRANCH)=R.REDO.OFFICERS.LIST<REDO.OFF.LIS.DEPT.BRANCH>
  R.NEW(REDO.LET.ISS.ISSUE.DATE)=TODAY
  Y.CHARGE.KEY=R.NEW(REDO.LET.ISS.CHARGE.KEY)
  IF Y.CHARGE.KEY EQ 'CARTACONS' THEN
    IF R.NEW(REDO.LET.ISS.CHARGE.CCY) EQ '' THEN
      GOSUB DEFAULT.AMOUNT
    END
  END ELSE
    AF=REDO.LET.ISS.CHARGE.KEY
    ETEXT='EB-FTCOM.LETTER'
    CALL STORE.END.ERROR
  END
*PACS00120765/67 - S
  GOSUB CHK.PRODUCTS
*PACS00120765/67 - E
  GOSUB BALANCE.CHECK
  RETURN

*----------------------------------------------------------------------
DEFAULT.AMOUNT:
*----------------------------------------------------------------------
* Defaults the Charge Amount in from FT.COMMISSION.TYPE

  CALL F.READ(FN.FT.COMMISSION.TYPE,Y.CHARGE.KEY,R.FT.COMMISSION.TYPE,F.FT.COMMISSION.TYPE,COMM.TYPE.ERR)
  Y.DEFAULT.CCY=R.FT.COMMISSION.TYPE<FT4.DEFAULT.CCY>
  IF Y.DEFAULT.CCY NE '' THEN
    R.NEW(REDO.LET.ISS.CHARGE.CCY)=Y.DEFAULT.CCY
    Y.CURRENCY=R.FT.COMMISSION.TYPE<FT4.CURRENCY>
    LOCATE Y.DEFAULT.CCY IN Y.CURRENCY<1,1> SETTING POS1 THEN
      R.NEW(REDO.LET.ISS.CHARGE.AMT)=R.FT.COMMISSION.TYPE<FT4.FLAT.AMT,POS1>
    END
  END ELSE
    R.NEW(REDO.LET.ISS.CHARGE.CCY)=LCCY
    LOCATE LCCY IN Y.CURRENCY<1,1> SETTING POS1 THEN
      R.NEW(REDO.LET.ISS.CHARGE.AMT)=R.FT.COMMISSION.TYPE<FT4.FLAT.AMT,POS1>
    END
  END
  RETURN

*----------------------------------------------------------------------
DEFAULT.NAME:
*----------------------------------------------------------------------
* It defaults the customer name as per the type of Customer

  IF Y.NAME EQ 'PERSONA FISICA' THEN
    R.NEW(REDO.LET.ISS.CU.NAME)=R.CUSTOMER<EB.CUS.GIVEN.NAMES>:" ":R.CUSTOMER<EB.CUS.FAMILY.NAME>
  END
  IF Y.NAME EQ 'PERSONA JURIDICA' THEN
    R.NEW(REDO.LET.ISS.CU.NAME)=R.CUSTOMER<EB.CUS.NAME.1>
  END
  RETURN
*PACS00120765/67 - S
*------------------------------------------------------------------------
CHK.PRODUCTS:
*-------------------------------------------------------------------------
* This para is used to find the duplicate products and also raised the error msg if more than 4 products selected
  VAR.PRODUCTS = R.NEW(REDO.LET.ISS.PRODUCTS)
  VAR.COUNT.PDT  = DCOUNT(VAR.PRODUCTS,VM)

  IF VAR.COUNT.PDT GT 4 THEN
    AF = REDO.LET.ISS.PRODUCTS
    AV = VAR.COUNT.PDT
    ETEXT = 'EB-REDO.CHECK.PRODUCTS'
    CALL STORE.END.ERROR
  END ELSE
    CNT.PDT = 1
    LOOP
    WHILE CNT.PDT LE VAR.COUNT.PDT
      Y.PDT = VAR.PRODUCTS<1,CNT.PDT>
      LOCATE Y.PDT IN VAR.PRODUCTS<1,1> SETTING POS.PDT THEN
        IF POS.PDT NE CNT.PDT THEN
          AF = REDO.LET.ISS.PRODUCTS
          AV = CNT.PDT
          ETEXT = 'EB-REDO.DUP.PRODUCTS'
          CALL STORE.END.ERROR
          CNT.PDT = VAR.COUNT.PDT+1
        END
      END
      CNT.PDT++
    REPEAT
  END
  RETURN
*PACS00120765/67 - S
*----------------------------------------------------------------------
BALANCE.CHECK:
*----------------------------------------------------------------------
* Checks the accounr balance and throws the error
  Y.ACCT.ID=R.NEW(REDO.LET.ISS.CHARGE.LIQ.ACT)
  Y.CHARGE.AMT=R.NEW(REDO.LET.ISS.CHARGE.AMT)
  Y.WAIVE=R.NEW(REDO.LET.ISS.WAIVE.CHARGES)
  IF Y.WAIVE NE 'YES' AND Y.ACCT.ID EQ '' THEN
    AF=REDO.LET.ISS.CHARGE.LIQ.ACT
    ETEXT='EB-LIQUDATION.ACCOUNT.MISSING'
    CALL STORE.END.ERROR
  END
  IF Y.ACCT.ID NE '' THEN
    CALL F.READ(FN.ACCOUNT,Y.ACCT.ID,R.ACCOUNT,F.ACCOUNT,ACC.ERR)
    *TUS START
    *Y.ACCOUNT.BAL=R.ACCOUNT<AC.WORKING.BALANCE>
    CALL EB.READ.HVT('EB.CONTRACT.BALANCES',Y.ACCT.ID,R.ECB,ECB.ERR)
    Y.ACCOUNT.BAL = R.ECB<ECB.WORKING.BALANCE>
    *TUS END

    IF Y.CHARGE.AMT THEN
      IF Y.CHARGE.AMT GT Y.ACCOUNT.BAL THEN
        AF=REDO.LET.ISS.CHARGE.AMT
        ETEXT='EB-INSUFFFICIENT.FUNDS'
        CALL STORE.END.ERROR
      END
    END
  END

  RETURN
*------------------------------------------------------------------------------------------------
END
