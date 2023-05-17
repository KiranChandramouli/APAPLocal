*-----------------------------------------------------------------------------
* <Rating>-50</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.APAP.GET.ID.NUMBER
*
*DESCRIPTIONS:
*-------------
* This is an conversion routine used in the REDO.APAP.ENQ.MOD.CLIENT.RPT
* and REDO.APAP.ER.MOD.CLIENT.RPT
*-----------------------------------------------------------------------------
* Input/Output:
*--------------
* IN : -NA-
* OUT : -NA-
*
* Dependencies:
*---------------
* CALLS : -NA-
* CALLED BY : -NA-
*-----------------------------------------------------------------------------
* Modification History :
* Date            Who                 Reference
* 06-SEP-10    Kishore.SP            INITIALVERSION
*-----------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.CUSTOMER
$INSERT I_ENQUIRY.COMMON
*-----------------------------------------------------------------------------
  GOSUB OPEN.FILES
  GOSUB PROCESS
  RETURN
*-----------------------------------------------------------------------------
OPEN.FILES:
*----------
!
  FN.CUSTOMER = 'F.CUSTOMER'
  F.CUSTOMER  = ''
  CALL OPF(FN.CUSTOMER,F.CUSTOMER)
!
  Y.CUS.VALUE = ''
  RETURN
*-----------------------------------------------------------------------------
PROCESS:
*-------
!
  CUSTOMER.ID = O.DATA
!
  R.CUSTOMER = ''
  CALL F.READ(FN.CUSTOMER,CUSTOMER.ID,R.CUSTOMER,F.CUSTOMER,Y.CUS.ERR)
  IF R.CUSTOMER NE '' THEN
    GOSUB FIND.MULTI.LOCAL.REF
    GOSUB GET.CUS.VAUES
    O.DATA = Y.CUS.VALUE
  END ELSE
    O.DATA = ''
  END
!
  RETURN
*-----------------------------------------------------------------------------
FIND.MULTI.LOCAL.REF:
*--------------------
  APPL.ARRAY   = "CUSTOMER"
  FLD.ARRAY    = "L.CU.CIDENT":VM:"L.CU.RNC":VM:"L.CU.NOUNICO":VM:"L.CU.ACTANAC"
  FLD.POS      = ''
  CALL MULTI.GET.LOC.REF(APPL.ARRAY,FLD.ARRAY,FLD.POS)
  LOC.L.CU.CIDENT.POS  = FLD.POS<1,1>
  LOC.L.CU.RNC.POS     = FLD.POS<1,2>
  LOC.L.CU.NOUNICO.POS = FLD.POS<1,3>
  LOC.L.CU.ACTANAC.POS = FLD.POS<1,4>
  RETURN
*-----------------------------------------------------------------------------
GET.CUS.VAUES:
*-------------
!
  IF R.CUSTOMER<EB.CUS.LOCAL.REF,LOC.L.CU.CIDENT.POS> NE '' THEN
    Y.CUS.VALUE<-1> =  R.CUSTOMER<EB.CUS.LOCAL.REF,LOC.L.CU.CIDENT.POS>
  END
!
  IF R.CUSTOMER<EB.CUS.LOCAL.REF,LOC.L.CU.RNC.POS> NE '' THEN
    Y.CUS.VALUE<-1> =  R.CUSTOMER<EB.CUS.LOCAL.REF,LOC.L.CU.RNC.POS>
  END
!
  IF R.CUSTOMER<EB.CUS.LEGAL.ID> NE '' THEN
    Y.CUS.VALUE<-1> =  R.CUSTOMER<EB.CUS.LEGAL.ID>
  END
!
  IF R.CUSTOMER<EB.CUS.LOCAL.REF,LOC.L.CU.NOUNICO.POS> NE '' THEN
    Y.CUS.VALUE<-1> =  R.CUSTOMER<EB.CUS.LOCAL.REF,LOC.L.CU.NOUNICO.POS>
  END
!
  IF R.CUSTOMER<EB.CUS.LOCAL.REF,LOC.L.CU.ACTANAC.POS> NE '' THEN
    Y.CUS.VALUE<-1> =  R.CUSTOMER<EB.CUS.LOCAL.REF,LOC.L.CU.ACTANAC.POS>
  END
!
  CHANGE FM TO VM IN Y.CUS.VALUE
  RETURN
*-----------------------------------------------------------------------------
END
