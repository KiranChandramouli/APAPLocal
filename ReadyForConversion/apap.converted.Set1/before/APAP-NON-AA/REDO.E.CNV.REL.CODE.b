*-----------------------------------------------------------------------------
* <Rating>-21</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.E.CNV.REL.CODE

*----------------------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By : RAJA SAKTHIVEL K P
* Program Name : REDO.E.CNV.DOC.NO
*----------------------------------------------------------
* Description : This subroutine is attached as a conversion routine in the Enquiry REPO.CU.VINCULADOS
* to populate the label rel.code

* Linked with : Enquiry REPO.CU.VINCULADOS as conversion routine
* In Parameter : None
* Out Parameter : None
*-----------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_ENQUIRY.COMMON
$INSERT I_F.CUSTOMER



  GOSUB INIT
  GOSUB PROCESS
  RETURN

INIT:

  FN.CUSTOMER = 'F.CUSTOMER'
  F.CUSTOMER = ''
  CALL OPF(FN.CUSTOMER,F.CUSTOMER)
  RETURN

PROCESS:
  CALL F.READ(FN.CUSTOMER,ID,R.CUSTOMER,F.CUSTOMER,ERR.CUSTOMER)
  Y.REL.CODE = R.RECORD<EB.CUS.RELATION.CODE>
  CONVERT VM TO FM IN Y.REL.CODE
  FET.REL.CODE = Y.REL.CODE
  Y.REL.CNT = DCOUNT(Y.REL.CODE,FM)
  START.LOOP = 1
  LOOP
  WHILE START.LOOP LE Y.REL.CNT
    FIND.POS = ''
    REL.CODE = Y.REL.CODE<START.LOOP>
*---------------------------------------------------
* Here, the unwanted values are restricted from the record
*---------------------------------------------------
    LOCATE REL.CODE IN FET.REL.CODE SETTING FIND.POS THEN
      IF REL.CODE GE 300 AND REL.CODE LE 399 ELSE
        DEL R.RECORD<EB.CUS.RELATION.CODE,FIND.POS>
        DEL R.RECORD<EB.CUS.REL.CUSTOMER,FIND.POS>
        DEL R.RECORD<EB.CUS.REVERS.REL.CODE,FIND.POS>
        DEL R.RECORD<EB.CUS.REL.DELIV.OPT,FIND.POS>
        DEL R.RECORD<EB.CUS.ROLE,FIND.POS>
        DEL R.RECORD<EB.CUS.ROLE.MORE.INFO,FIND.POS>
        DEL R.RECORD<EB.CUS.ROLE.NOTES,FIND.POS>
        DEL FET.REL.CODE<FIND.POS>
        VM.COUNT=VM.COUNT-1
      END
    END
    START.LOOP = START.LOOP+1
  REPEAT

  RETURN
END
