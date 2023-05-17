*-----------------------------------------------------------------------------
* <Rating>-40</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.E.CNV.LEGAL.PROSPECT
*---------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By : RAHAMATHULLAH.B
*---------------------------------------------------------
* Description :ASOCIACOPN POPULAR DE AHORROS Y PRESTAMOS
*              requires a report that shows all prospective clients,
*              which are captured through events, e-mail, etc
*----------------------------------------------------------
* Linked With : Enquiry REDO.APAP.NATURAL.AND.LEGAL.PROSP
* In Parameter : ENQ.DATA
* Out Parameter : ENQ.DATA
*----------------------------------------------------------
* Modification History:
*----------------------------------------------------------
*
*
*-----------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_ENQUIRY.COMMON
$INSERT I_F.CUSTOMER

  GOSUB INIT
  GOSUB OPF
  GOSUB PROCESS
  RETURN


INIT:
******
  FN.CUSTOMER = "F.CUSTOMER"
  F.CUSTOMER = ""
  RETURN

  RETURN

OPF:
*****
  CALL OPF(FN.CUSTOMER,F.CUSTOMER)
  RETURN
PROCESS:
********

  APPL.FIELDS ="L.CU.CIDENT":VM:"L.CU.RNC":VM:"L.CU.TEL.TYPE":VM:"L.CU.TEL.AREA":VM:"L.CU.TEL.NO":VM:"L.CU.TEL.EXT"
  APPL.POS = ""
  CALL MULTI.GET.LOC.REF("CUSTOMER",APPL.FIELDS,APPL.POS)
  CIDENT.POS = APPL.POS<1,1>
  RNC.POS = APPL.POS<1,2>
  TEL.TYPE.POS = APPL.POS<1,3>
  TEL.AREA.POS = APPL.POS<1,4>
  TEL.NO.POS = APPL.POS<1,5>
  TEL.EXT.POS = APPL.POS<1,6>

  CALL F.READ(FN.CUSTOMER,ID,R.CUSTOMER,F.CUSTOMER,CUS.ERR)
  Y.CU.CIDENT = R.CUSTOMER<EB.CUS.LOCAL.REF,CIDENT.POS>
  Y.LEGAL.ID = R.CUSTOMER<EB.CUS.LEGAL.ID>
  Y.CU.RNC = R.CUSTOMER<EB.CUS.LOCAL.REF,RNC.POS>

  IF Y.CU.CIDENT NE "" THEN
    O.DATA = "CEDULA"
    R.RECORD<550> = Y.CU.CIDENT
  END
  IF Y.LEGAL.ID NE "" THEN
    O.DATA = "PASAPORTE"
    R.RECORD<550> = Y.LEGAL.ID
  END
  IF Y.CU.RNC NE "" THEN
    O.DATA = "RNC"
    R.RECORD<550> = Y.CU.RNC
  END

  IF R.CUSTOMER<EB.CUS.LOCAL.REF,TEL.TYPE.POS> EQ 01 THEN
    R.RECORD<600> = R.CUSTOMER<EB.CUS.LOCAL.REF,TEL.AREA.POS>:"-":R.CUSTOMER<EB.CUS.LOCAL.REF,TEL.NO.POS>
  END
  IF R.CUSTOMER<EB.CUS.LOCAL.REF,TEL.TYPE.POS> EQ 06 THEN
    R.RECORD<650> = R.CUSTOMER<EB.CUS.LOCAL.REF,TEL.AREA.POS>:"-":R.CUSTOMER<EB.CUS.LOCAL.REF,TEL.NO.POS>
  END
  IF R.CUSTOMER<EB.CUS.LOCAL.REF,TEL.TYPE.POS> EQ 05 THEN
    R.RECORD<700> = R.CUSTOMER<EB.CUS.LOCAL.REF,TEL.AREA.POS>:"-":R.CUSTOMER<EB.CUS.LOCAL.REF,TEL.NO.POS>:"-":R.CUSTOMER<EB.CUS.LOCAL.REF,TEL.EXT.POS>
  END
  RETURN
END
