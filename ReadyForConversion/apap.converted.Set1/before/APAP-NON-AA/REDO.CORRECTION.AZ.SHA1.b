*-----------------------------------------------------------------------------
* <Rating>-60</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.CORRECTION.AZ.SHA1
*----------------------------------------------------
*Description: This correction routine is to correct the AZ contract which doesnt have
*             Sha1 Code.
*             PACS00461539
*----------------------------------------------------


$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.AZ.ACCOUNT
$INSERT I_F.CUSTOMER
$INSERT I_F.ACCOUNT
$INSERT I_F.REDO.T.SHA1


  EXECUTE "COMO ON REDO.CORRECTION.AZ.SHA1"

  CALL OCOMO("***Correction initiated***")

  GOSUB INIT
  GOSUB PREPROCESS
  EXECUTE "COMO OFF REDO.CORRECTION.AZ.SHA1"

  RETURN
*----------------------------------------------------
INIT:
*----------------------------------------------------

  FN.CUSTOMER='F.CUSTOMER'
  F.CUSTOMER=''
  R.CUSTOMER=''
  CUS.ERR1=''
  FLAG.ID = '' ; CIDENT.VALUE = '' ; LEGALID.VALUE = '' ; ACTANAC.VALUE = '' ;  NOUNICO.VALUE = ''
  param = ""
  ret = ""
  FN.ACCOUNT = 'F.ACCOUNT'
  F.ACCOUNT = ''

  FN.AZ.ACCOUNT = 'F.AZ.ACCOUNT'
  F.AZ.ACCOUNT  = ''
  CALL OPF(FN.AZ.ACCOUNT,F.AZ.ACCOUNT)


  FN.REDO.T.SHA1 = 'F.REDO.T.SHA1'
  F.REDO.T.SHA1 = ''
  CALL OPF(FN.REDO.T.SHA1,F.REDO.T.SHA1)

  FN.SL = "&SAVEDLISTS&"
  F.SL  = ""
  CALL OPF(FN.SL,F.SL)

  CALL OPF(FN.ACCOUNT,F.ACCOUNT)
  CALL OPF(FN.CUSTOMER,F.CUSTOMER)
  LREF.APPL = 'CUSTOMER':FM:'AZ.ACCOUNT'
  LREF.FIELDS = 'L.CU.CIDENT':VM:'L.CU.TIPO.CL':VM:'L.CU.RNC':VM:'L.CU.ACTANAC':VM:'L.CU.NOUNICO':FM:'L.AZ.SHA1.CODE'
  LREF.POS = ''
  CALL MULTI.GET.LOC.REF(LREF.APPL,LREF.FIELDS,LREF.POS)
  CIDENT.POS = LREF.POS<1,1>
  TIPO.CL.POS = LREF.POS<1,2>
  RNC.POS = LREF.POS<1,3>
  ACTANAC.POS = LREF.POS<1,4>
  NOUNICO.POS = LREF.POS<1,5>
  SHA1.POS =LREF.POS<2,1>

  RETURN
*---------------------------------------------------------------------
PREPROCESS:
*---------------------------------------------------------------------

  CALL F.READ(FN.SL,"AZ.SHA1",R.SL,F.SL,SL.ERR)
  Y.CNT = DCOUNT(R.SL,FM)
  Y.VAR1 = 1
  LOOP
  WHILE Y.VAR1 LE Y.CNT

    ACC.ID = R.SL<Y.VAR1>
    CALL OCOMO("Process started for contract - ":ACC.ID)
    GOSUB PROCESS

    Y.VAR1++
  REPEAT
  CALL OCOMO("***Correction completed***")

  RETURN
*---------------------------------------------------------------------
PROCESS:
*---------------------------------------------------------------------

  CALL F.READ(FN.AZ.ACCOUNT,ACC.ID,R.AZ.ACCOUNT,F.AZ.ACCOUNT,AZ.ERR)
  CALL F.READ(FN.ACCOUNT,ACC.ID,R.ACC,F.ACCOUNT,ACC.ERR)
  IF R.ACC THEN
    CUS.ID = R.ACC<AC.CUSTOMER>
  END
  CALL F.READ(FN.CUSTOMER,CUS.ID,R.CUSTOMER,F.CUSTOMER,CUS.ERR1)
  IF R.CUSTOMER THEN
    VAR.TIPO.CL = R.CUSTOMER<EB.CUS.LOCAL.REF,TIPO.CL.POS>

    BEGIN CASE
    CASE VAR.TIPO.CL EQ 'PERSONA FISICA'
      GOSUB FIS.TYPE
    CASE VAR.TIPO.CL EQ 'PERSONA JURIDICA'
      GOSUB JUR.TYPE
    CASE OTHERWISE
      GOSUB OTHER.TYPE
    END CASE
  END

  SHA1.CODE = R.AZ.ACCOUNT<AZ.LOCAL.REF,SHA1.POS>

  IF SHA1.CODE THEN
    RETURN
  END


  INSTRUMENT = ACC.ID
  S = NAME:ID_CARD:INSTRUMENT
  param = S
  CALLJ "Logic.Hash","SHA1", param SETTING ret ON ERROR
    E= 'Unable to call JAVA PGM'
  END
  SHA1.CODE=ret
  R.AZ.ACCOUNT<AZ.LOCAL.REF,SHA1.POS>=SHA1.CODE
  SHA1.ERR = ""
  CALL F.READ(FN.REDO.T.SHA1,SHA1.CODE,R.SHA1.CODE,F.REDO.T.SHA1,SHA1.ERR)
  IF SHA1.ERR THEN
*    R.SHA1.CODE<1> =ACC.ID
* Tus Start
 R.SHA1.CODE<RE.T.SH.AZ.ACCOUNT.NO> =ACC.ID
 * Tus End
  END
  CALL F.WRITE(FN.REDO.T.SHA1,SHA1.CODE,R.SHA1.CODE)

  TEMP.V=V
  V=AZ.AUDIT.DATE.TIME
  CALL F.LIVE.WRITE(FN.AZ.ACCOUNT,ACC.ID,R.AZ.ACCOUNT)
  V=TEMP.V

  CALL JOURNAL.UPDATE("")
  CALL OCOMO("Sha1 updated for contract - ":ACC.ID)
  RETURN

*------------------------------------------------------------------------------------------
FIS.TYPE:
*------------------------------------------------------------------------------------------
  VAR.GIV.NAM  =  R.CUSTOMER<EB.CUS.GIVEN.NAMES>
  VAR.FAM.NAM  =  R.CUSTOMER<EB.CUS.FAMILY.NAME>
  NAME = VAR.GIV.NAM:" ":VAR.FAM.NAM
  CIDENT.VALUE = R.CUSTOMER<EB.CUS.LOCAL.REF,CIDENT.POS>
  IF CIDENT.VALUE THEN
    ID_CARD = CIDENT.VALUE
  END ELSE
    ID_CARD = R.CUSTOMER<EB.CUS.LEGAL.ID,1>
  END
  RETURN
*------------------------------------------------------------------------------------------
JUR.TYPE:
*------------------------------------------------------------------------------------------
  VAR.NAME1=R.CUSTOMER<EB.CUS.NAME.1>
  VAR.NAME2=R.CUSTOMER<EB.CUS.NAME.2>
  NAME = VAR.NAME1:VAR.NAME2
  ID_CARD = R.CUSTOMER<EB.CUS.LOCAL.REF,RNC.POS>
  RETURN
*------------------------------------------------------------------------------------------
OTHER.TYPE:
*------------------------------------------------------------------------------------------
  VAR.GIV.NAM  =  R.CUSTOMER<EB.CUS.GIVEN.NAMES>
  VAR.FAM.NAM = R.CUSTOMER<EB.CUS.FAMILY.NAME>
  NAME = VAR.GIV.NAM:" ":VAR.FAM.NAM
  CIDENT.VALUE  =  R.CUSTOMER<EB.CUS.LOCAL.REF,CIDENT.POS>
  IF CIDENT.VALUE THEN
    ID_CARD = CIDENT.VALUE
    FLAG.ID = 1
  END
  IF NOT(FLAG.ID) THEN
    LEGALID.VALUE = R.CUSTOMER<EB.CUS.LEGAL.ID,1>
    IF LEGALID.VALUE THEN
      ID_CARD = LEGALID.VALUE
      FLAG.ID = 1
    END
  END
  IF NOT(FLAG.ID) THEN
    ACTANAC.VALUE = R.CUSTOMER<EB.CUS.LOCAL.REF,ACTANAC.POS>
    IF ACTANAC.VALUE THEN
      ID_CARD = ACTANAC.VALUE
      FLAG.ID = 1
    END
  END
  IF NOT(FLAG.ID) THEN
    NOUNICO.VALUE = R.CUSTOMER<EB.CUS.LOCAL.REF,NOUNICO.POS>
    IF NOUNICO.VALUE THEN
      ID_CARD = NOUNICO.VALUE
      FLAG.ID = 1
    END
  END
  RETURN

END
