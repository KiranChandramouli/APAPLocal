*-----------------------------------------------------------------------------
* <Rating>-30</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.AZ.BUILD.DATA(ENQ.DETAILS)
*----------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : GANESH
* PROGRAM NAME : REDO.AZ.BUILD.DATA
*----------------------------------------------------------


* DESCRIPTION : This routine is used to fetch the data from Live and history records
*
*
*------------------------------------------------------------

*    LINKED WITH : TELLER & CREDIT.ACCOUNT.NO AS VALIDATION ROUTINE
*    IN PARAMETER: NONE
*    OUT PARAMETER: NONE

*----------------------------------------------------------------------
* Modification History :
*-----------------------
*DATE             WHO                    REFERENCE         DESCRIPTION
*1.06.2010      R GANESH            ODR-2010-04-0424  INITIAL CREATION
*----------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_ENQUIRY.COMMON
$INSERT I_F.AZ.ACCOUNT
$INSERT I_F.CUSTOMER

  GOSUB OPEN.FILE
  GOSUB PROCESS
  RETURN

OPEN.FILE:

  FN.AZ.ACCOUNT = 'F.AZ.ACCOUNT'
  F.AZ.ACCOUNT = ''
  CALL OPF(FN.AZ.ACCOUNT,F.AZ.ACCOUNT)

  FN.AZ.ACCOUNTHIS = 'F.AZ.ACCOUNT$HIS'
  F.AZ.ACCOUNTHIS = ''
  CALL OPF(FN.AZ.ACCOUNTHIS,F.AZ.ACCOUNTHIS)

  FN.CUSTOMER='F.CUSTOMER'
  F.CUSTOMER = ''
  CALL OPF(FN.CUSTOMER,F.CUSTOMER)

  RETURN

PROCESS:
  LOC.APPLICATION = 'CUSTOMER'
  LOC.FIELD ='L.CU.TEL.TYPE':VM:'L.CU.CIDENT'
  LOC.POS = ''
  CALL MULTI.GET.LOC.REF(LOC.APPLICATION,LOC.FIELD,LOC.POS)
  VAR.CUS.TEL.TYPE = LOC.POS<1,1>
  LOC.CIDENT=LOC.POS<1,2>
  LOCATE 'ACCOUNT.NUMBER' IN D.FIELDS<1> SETTING POS THEN
    VAR.ID=D.RANGE.AND.VALUE<POS>
  END
  CALL F.READ(FN.AZ.ACCOUNT,VAR.ID,R.AZ.ACCOUNT,F.AZ.ACCOUNT,ACCT.ERR)
  IF NOT(R.AZ.ACCOUNT) THEN
    CALL EB.READ.HISTORY.REC(F.AZ.ACCOUNTHIS,VAR.ID,R.AZ.ACCOUNTHIS,ACCT.ERR)
    TOD.DAY=TODAY
    TOD.DAY=ICONV(TOD.DAY,"D2")
    VAR.TODAY=OCONV(TOD.DAY,"D2")
    VAR.CODE = R.AZ.ACCOUNTHIS<AZ.CO.CODE>
    VAR.ACCT.NO = VAR.ID[1,10]
    CUS.ID = R.AZ.ACCOUNTHIS<AZ.CUSTOMER>
    CALL F.READ(FN.CUSTOMER,CUS.ID,R.CUSTOMER,F.CUSTOMER,CUS.ERR)
    CIDENT=R.CUSTOMER<EB.CUS.LOCAL.REF><1,LOC.CIDENT>
    IF CIDENT NE '' THEN
      E.DATA="CEDULA"
    END
    LE.VAL=R.CUSTOMER<EB.CUS.LEGAL.ID>
    IF LE.VAL NE '' THEN
      E.DATA="PASAPORTE"
    END
    IF CIDENT EQ '' AND LE.VAL EQ '' THEN
      E.DATA=''
    END
    VAR.CUS.NAME = R.CUSTOMER<EB.CUS.NAME.1>
    VAR.CUS.PHONE = R.CUSTOMER<EB.CUS.LOCAL.REF><1,VAR.CUS.TEL.TYPE>
    VAR.VAL.DATE=R.AZ.ACCOUNTHIS<AZ.VALUE.DATE>
    VAR.DATE=ICONV(VAR.VAL.DATE,"D2")
    VALUE.DATE=OCONV(VAR.DATE,"D2")
    VAR.PRINCIPAL = R.AZ.ACCOUNTHIS<AZ.PRINCIPAL>
    VAR.CUS.PHONE.1 = R.CUSTOMER<EB.CUS.PHONE.1>
    ENQ.DETAILS<-1> = VAR.TODAY:"*":VAR.CODE:"*":VAR.CUS.NAME:"*":E.DATA:"*":VAR.CUS.PHONE.1:"*":VAR.ACCT.NO:"*":CUS.ID:"*":VAR.CUS.PHONE:"*":VALUE.DATE:"*":VAR.CODE:"*":VAR.PRINCIPAL
  END ELSE
    TOD.DAY=TODAY
    TOD.DAY=ICONV(TOD.DAY,"D2")
    VAR.TODAY=OCONV(TOD.DAY,"D2")
    VAR.CODE = R.AZ.ACCOUNT<AZ.CO.CODE>
    VAR.ACCT.NO = VAR.ID
    CUS.ID = R.AZ.ACCOUNT<AZ.CUSTOMER>
    CALL F.READ(FN.CUSTOMER,CUS.ID,R.CUSTOMER,F.CUSTOMER,CUS.ERR)
    CIDENT=R.CUSTOMER<EB.CUS.LOCAL.REF><1,LOC.CIDENT>
    IF CIDENT NE '' THEN
      E.DATA="CEDULA"
    END
    LE.VAL=R.CUSTOMER<EB.CUS.LEGAL.ID>
    IF LE.VAL NE '' THEN
      E.DATA="PASAPORTE"
    END
    IF CIDENT EQ '' AND LE.VAL EQ '' THEN
      E.DATA=''
    END
    VAR.CUS.NAME = R.CUSTOMER<EB.CUS.NAME.1>
    VAR.CUS.PHONE = R.CUSTOMER<EB.CUS.LOCAL.REF><1,VAR.CUS.TEL.TYPE>
    VAR.CUS.PHONE.1 = R.CUSTOMER<EB.CUS.PHONE.1>
    VAR.VAL.DATE=R.AZ.ACCOUNT<AZ.VALUE.DATE>
    VAR.DATE=ICONV(VAR.VAL.DATE,"D2")
    VALUE.DATE=OCONV(VAR.DATE,"D2")
    VAR.PRINCIPAL = R.AZ.ACCOUNT<AZ.PRINCIPAL>
    ENQ.DETAILS<-1> = VAR.TODAY:"*":VAR.CODE:"*":VAR.CUS.NAME:"*":E.DATA:"*":VAR.CUS.PHONE.1:"*":VAR.ACCT.NO:"*":CUS.ID:"*":VAR.CUS.PHONE:"*":VALUE.DATE:"*":VAR.CODE:"*":VAR.PRINCIPAL
  END
  RETURN
END