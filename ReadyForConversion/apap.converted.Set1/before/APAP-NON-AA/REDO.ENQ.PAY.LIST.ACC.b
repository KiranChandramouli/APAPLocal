*-----------------------------------------------------------------------------
* <Rating>6</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.ENQ.PAY.LIST.ACC(Y.FINAL.ARRAY)
*-----------------------------------------------------------------------------
*  Company   Name    : Asociacion Popular de Ahorros y Prestamos
*  Developed By      : GANESH HARIDAS
*  ODR Number        : PACS00092771 - B.29
*  Program   Name    : REDO.ENQ.PAY.LIST.ACC
*-----------------------------------------------------------------------------
* Incoming/Outgoing Parameters
*-------------------------------
* In  : --N/A--
* Out : Y.FINAL.ARRAY
*-----------------------------------------------------------------------------
* DESCRIPTION       : This is a NOFILE enquiry routine to get the accounts based
*                     on the method of payment selected
*------------------------------------------------------------------------------
* Modification History :
*-----------------------
*  DATE            WHO            REFERENCE            DESCRIPTION
*  -----           ----           ----------           -----------
*  28-JUL-2011   GANESH HARIDAS  PACS00092771 - B.29   INITIAL CREATION
*-------------------------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_ENQUIRY.COMMON
$INSERT I_F.ACCOUNT
$INSERT I_F.AZ.ACCOUNT
$INSERT I_System
$INSERT I_F.MULTI.BRANCH.INTERNAL.ACCOUNT

  GOSUB INITIALIZE
  GOSUB OPENFILES
  GOSUB PROCESS

  RETURN
*-------------------------------------------------------------------------------
INITIALIZE:
*----------

  FN.ACCOUNT = 'F.ACCOUNT'
  F.ACCOUNT  = ''
  CALL OPF(FN.ACCOUNT,F.ACCOUNT)

  FN.CUSTOMER.ACCOUNT = 'F.CUSTOMER.ACCOUNT'
  F.CUSTOMER.ACCOUNT = ''
  CALL OPF(FN.CUSTOMER.ACCOUNT,F.CUSTOMER.ACCOUNT)

  FN.JOINT.CONTRACTS.XREF = 'F.JOINT.CONTRACTS.XREF'
  F.JOINT.CONTRACTS.XREF = ''
  CALL OPF(FN.JOINT.CONTRACTS.XREF,F.JOINT.CONTRACTS.XREF)

  FN.MULTI.BRANCH.INTERNAL.ACCOUNT = 'F.MULTI.BRANCH.INTERNAL.ACCOUNT'
  F.MULTI.BRANCH.INTERNAL.ACCOUNT = ''
  CALL OPF(FN.MULTI.BRANCH.INTERNAL.ACCOUNT,F.MULTI.BRANCH.INTERNAL.ACCOUNT)

  Y.AZ.ID = System.getVariable("CURRENT.AZ.ID.REF")
  
  CALL F.READ(FN.ACCOUNT,Y.AZ.ID,R.CUR.AZ,F.ACCOUNT,ACC.ERR)

  Y.CURRENCY = R.CUR.AZ<AC.CURRENCY>
  Y.CUS.ID   = R.CUR.AZ<AC.CUSTOMER>

  R.ACCOUNT  = ''
  SEL.CMD    = ''
  Y.TOTAL.ACC = ''
  NO.OF.REC = ''
  SEL.ERR.AC = ''

  RETURN
*-------------------------------------------------------------------------------
OPENFILES:
*---------

  LOCATE "MODE.OF.PAY" IN D.FIELDS SETTING Y.CLOS.POS THEN
    Y.MODE.OF.PAY = D.RANGE.AND.VALUE<Y.CLOS.POS>
  END

  RETURN
*-------------------------------------------------------------------------------
PROCESS:
*-------

  BEGIN CASE

  CASE Y.MODE.OF.PAY EQ "FROM.CUST.ACC"
* FOR OTHER ACCOUNTS
    GOSUB GET.CUSTOMER.ACCOUNT
  CASE Y.MODE.OF.PAY EQ "FROM.INT.ACC"
* FOR INTERNAL ACCOUNT
*SEL.CMD = "SELECT ":FN.ACCOUNT:" WITH CUSTOMER EQ '' AND CO.CODE EQ ":ID.COMPANY:" AND CURRENCY EQ ":Y.CURRENCY
*CALL EB.READLIST(SEL.CMD,Y.TOTAL.ACC,'',NO.OF.REC,SEL.ERR.AC)

    LOCATE 'VERSION' IN D.FIELDS SETTING Y.VER.POS THEN
      Y.VERSION.ID = D.RANGE.AND.VALUE<Y.VER.POS>
      CALL CACHE.READ(FN.MULTI.BRANCH.INTERNAL.ACCOUNT,'SYSTEM',R.MULTI.BRANCH,F.MULTI.BRANCH.INTERNAL.ACCOUNT)
      LOCATE Y.VERSION.ID IN R.MULTI.BRANCH<REDO.BR.ACCT.VERSION,1> SETTING VER.POS THEN
        Y.TOTAL.ACC = R.MULTI.BRANCH<REDO.BR.ACCT.ACCOUNT,VER.POS>
      END
    END


  CASE Y.MODE.OF.PAY EQ "FROM.NOST.ACC"
* FOR NOSTRO ACCOUNT
    SEL.CMD = "SELECT ":FN.ACCOUNT:" WITH CUSTOMER NE '' AND CATEGORY GE 5000 AND CATEGORY LE 5999 AND CURRENCY EQ ":Y.CURRENCY
    CALL EB.READLIST(SEL.CMD,Y.TOTAL.ACC,'',NO.OF.REC,SEL.ERR.AC)

  END CASE

  Y.FINAL.ARRAY = Y.TOTAL.ACC

  RETURN
*-------------------------------------------------------------------------------
GET.CUSTOMER.ACCOUNT:
*-------------------------------------------------------------------------------



  CALL F.READ(FN.CUSTOMER.ACCOUNT,Y.CUS.ID,R.CUS.ACC,F.CUSTOMER.ACCOUNT,CUS.ACC.ERR)
  CALL F.READ(FN.JOINT.CONTRACTS.XREF,Y.CUS.ID,R.JOINT.XREF,F.JOINT.CONTRACTS.XREF,JOINT.ERR)

  Y.OWN.ACC.CNT = DCOUNT(R.CUS.ACC,FM)
  Y.VAR1 = 1
  LOOP
  WHILE Y.VAR1 LE Y.OWN.ACC.CNT
    Y.ACC.ID = R.CUS.ACC<Y.VAR1>
    IF Y.ACC.ID NE Y.AZ.ID THEN
      CALL F.READ(FN.ACCOUNT,Y.ACC.ID,R.ACC,F.ACCOUNT,ACC.ERR)
      Y.CATEG = R.ACC<AC.CATEGORY>
      IF ((Y.CATEG GE 1001 AND Y.CATEG LE 1099) OR (Y.CATEG GE 6001 AND Y.CATEG LE 6010) OR (Y.CATEG GE 6021 AND Y.CATEG LE 6599)) AND (R.ACC<AC.CURRENCY> EQ Y.CURRENCY) THEN
        Y.TOTAL.ACC<-1> = Y.ACC.ID
      END
    END
    Y.VAR1++
  REPEAT

  Y.JOIN.ACC.CNT = DCOUNT(R.JOINT.XREF,FM)
  Y.VAR2 = 1
  LOOP
  WHILE Y.VAR2 LE Y.JOIN.ACC.CNT
    Y.JOIN.ACC.ID = R.JOINT.XREF<Y.VAR2>
    CALL F.READ(FN.ACCOUNT,Y.JOIN.ACC.ID,R.JOIN.ACC,F.ACCOUNT,ACC.ERR)
    Y.CATEG = R.JOIN.ACC<AC.CATEGORY>
    IF ((Y.CATEG GE 1001 AND Y.CATEG LE 1099) OR (Y.CATEG GE 6001 AND Y.CATEG LE 6010) OR (Y.CATEG GE 6021 AND Y.CATEG LE 6599)) AND (R.JOIN.ACC<AC.CURRENCY> EQ Y.CURRENCY) THEN
      LOCATE Y.CUS.ID IN R.JOIN.ACC<AC.JOINT.HOLDER,1> SETTING POS THEN
        IF R.JOIN.ACC<AC.RELATION.CODE,POS> GE 500 AND R.JOIN.ACC<AC.RELATION.CODE,POS> LE 509 THEN
          Y.TOTAL.ACC<-1> = Y.JOIN.ACC.ID
        END
      END
    END
    Y.VAR2++
  REPEAT

  RETURN
*-------------------------------------------------------------------------------
END
