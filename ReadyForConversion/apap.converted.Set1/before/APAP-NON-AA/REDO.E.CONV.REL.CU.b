* <Rating>-53</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.E.CONV.REL.CU

*----------------------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By : RAJA SAKTHIVEL K P
* Program Name : REDO.E.CONV.REL.CU
*----------------------------------------------------------
* Description : This subroutine is attached as a conversion routine in the Enquiry REPO.CU.VINCULADOS
* to populate the label rel.code, customer  as per the relatione code range 300 - 399

* Linked with : Enquiry REPO.CU.VINCULADOS as build routine
* In Parameter : -N/A-
* Out Parameter :-N/A-
*--------------------------------------------------------------------------------
*MODIFICATION HISTORY:
* DATE            WHO                  REFERENCE                  DESCRIPTION
* 08-04-11       RIYAS                PACS00036104     CHANGE THE RELATION CODE 300 TO 399
* 18-06-11       Marimuthu S          PACS00036104 (reopen)
*----------------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_ENQUIRY.COMMON
$INSERT I_F.RELATION.CUSTOMER
$INSERT I_F.RELATION
$INSERT I_System


  GOSUB INIT
  GOSUB PROCESS
  RETURN

INIT:

  FN.RELATION.CUSTOMER = 'F.RELATION.CUSTOMER'
  F.RELATION.CUSTOMER = ''
  CALL OPF(FN.RELATION.CUSTOMER,F.RELATION.CUSTOMER)

  FN.RELATION = 'F.RELATION'
  F.RELATION = ''
  CALL OPF(FN.RELATION,F.RELATION)

  Y.OF.CUSTOMER = ''
  Y.IS.RELATION = ''
  Y.IS.RELATION.DESC = ''
  RETURN


PROCESS:
  Y.CUSTOMER.VAL = System.getVariable('CURRENT.NO')
  CUS.ID = Y.CUSTOMER.VAL

  IF NOT(CUS.ID) THEN
    OPERAND.VALUE = "EQ"
    SEL.CMD = "SELECT ":FN.RELATION.CUSTOMER:" WITH IS.RELATION GE 300 AND IS.RELATION LE 499"
    CALL EB.READLIST(SEL.CMD,CUS.ID.LIST,'',NO.CUS.ID,'')
    LOOP
      REMOVE CUS.ID FROM CUS.ID.LIST SETTING STMT.POS
    WHILE CUS.ID : STMT.POS
      IF CUS.ID THEN
        GOSUB CHECK.DATA
      END
    REPEAT
  END ELSE
    OPERAND.VALUE= 'EQ'
    GOSUB CHECK.DATA
  END

  RETURN
*-------------------------------------------------------
* Here, the value of the relation code is checked
*-------------------------------------------------------
CHECK.DATA:

  CALL F.READ(FN.RELATION.CUSTOMER,CUS.ID,R.RELATION.CUSTOMER,F.RELATION.CUSTOMER,ERR.RELATION.CUSTOMER)
  IF R.RELATION.CUSTOMER THEN
    Y.REL.CODE = R.RELATION.CUSTOMER<EB.RCU.IS.RELATION>
    Y.REL.CNT = DCOUNT(Y.REL.CODE,VM)
    START.LOOP = 1

    LOOP
    WHILE START.LOOP LE Y.REL.CNT
      GOSUB CHECK.CODE
    REPEAT
  END

  VM.COUNT = DCOUNT(Y.IS.RELATION,VM)
  BEGIN CASE
  CASE O.DATA EQ "R.CODE"
    O.DATA = Y.IS.RELATION<1,VC>
  CASE O.DATA EQ "R.NAME"
    O.DATA = Y.IS.RELATION.DESC<1,VC>
  CASE O.DATA EQ "RCUS.CD"
    O.DATA = Y.OF.CUSTOMER<1,VC>
  CASE O.DATA EQ "RCUS.NAM"
    O.DATA = Y.OF.CUSTOMER<1,VC>
  END CASE

  RETURN
*----------------------------------------------------------------------------
* Here, the customer record which satisfies the condition are filtered out
*----------------------------------------------------------------------------
CHECK.CODE:
  REL.CODE = Y.REL.CODE<1,START.LOOP>
  IF REL.CODE GE 300 AND REL.CODE LE 499 THEN
    IF Y.IS.RELATION EQ '' THEN
      Y.IS.RELATION = REL.CODE
    END ELSE
      Y.IS.RELATION := VM:REL.CODE
    END
    CALL F.READ(FN.RELATION,REL.CODE,R.RELATION,F.RELATION,Y.ERR.REL)

    IF Y.IS.RELATION.DESC EQ '' THEN
      Y.IS.RELATION.DESC =  R.RELATION<EB.REL.DESCRIPTION,1>
    END ELSE
      Y.IS.RELATION.DESC := VM:R.RELATION<EB.REL.DESCRIPTION,1>
    END
    IF Y.OF.CUSTOMER EQ '' THEN
      Y.OF.CUSTOMER = R.RELATION.CUSTOMER<EB.RCU.OF.CUSTOMER,START.LOOP>
    END ELSE
      Y.OF.CUSTOMER := VM:R.RELATION.CUSTOMER<EB.RCU.OF.CUSTOMER,START.LOOP>
    END

  END
  START.LOOP = START.LOOP+1
  RETURN
*------------------------------------------------------------------------------
END
