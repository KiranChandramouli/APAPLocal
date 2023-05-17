*-----------------------------------------------------------------------------
* <Rating>68</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.V.INP.REL.CHECK
***********************************************************************
*----------------------------------------------------------------------
* Company Name : APAP
* Developed By : RAJA SAKTHIVEL K P
* Program Name : REDO.V.INP.REL.CHECK
*----------------------------------------------------------------------
* Description: This subroutine is performed in CU,REDO.VINCULADOS Version as Input routine
* The functionality is to check the relation code of a customer and to call an Override if
* it is in the range of 300 to 399

* Linked with : Version CU,REDO.VINCULADOS as Input routine
* In Parameter : None
* Out Parameter : None

*------------------------------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.CUSTOMER

  GOSUB CHECKING.RELATION.CODE
  RETURN

*----------------------------------------------------------------------------
* Relation code is checked to find whether it is in the range of 300 to 399
*----------------------------------------------------------------------------
CHECKING.RELATION.CODE:

  REL.OLD = R.OLD(EB.CUS.RELATION.CODE)
  REL.NEW = R.NEW(EB.CUS.RELATION.CODE)


  OLD.CUS=R.OLD(EB.CUS.REL.CUSTOMER)
  NEW.CUS=R.NEW(EB.CUS.REL.CUSTOMER)

  NEW.CNT.VAL = DCOUNT(REL.NEW,VM)
  OLD.CNT.VAL = DCOUNT(REL.OLD,VM)

  CONVERT VM TO FM IN REL.OLD
  CONVERT VM TO FM IN REL.NEW

  CONVERT VM TO FM IN OLD.CUS
  CONVERT VM TO FM IN NEW.CUS
  FOR COUNT.REL.OLD=1 TO OLD.CNT.VAL
    POS=''
    IF REL.OLD<COUNT.REL.OLD> GE 300 AND REL.OLD<COUNT.REL.OLD> LE 399 THEN
      LOCATE REL.OLD<COUNT.REL.OLD> IN REL.NEW SETTING POS THEN
        IF OLD.CUS<COUNT.REL.OLD> NE NEW.CUS<POS> THEN
          GOSUB COMPARE
        END
      END
      ELSE

        GOSUB COMPARE
      END
    END
  NEXT COUNT.REL.OLD

  FOR COUNT.REL.NEW=1 TO NEW.CNT.VAL
    POS=''
    IF REL.NEW<COUNT.REL.NEW> GE 300 AND REL.NEW<COUNT.REL.NEW> LE 399 THEN
      LOCATE REL.NEW<COUNT.REL.NEW> IN REL.OLD SETTING POS THEN
        IF NEW.CUS<COUNT.REL.NEW> NE OLD.CUS<POS> THEN
          GOSUB COMPARE
        END
      END
      ELSE

        GOSUB COMPARE
      END
    END
  NEXT COUNT.REL.NEW

  RETURN
*-------------------------------------------------
* The Override is thrown here based on condition
*-------------------------------------------------
COMPARE:
  OVERRIDE.FIELD.VALUE = R.NEW(EB.CUS.OVERRIDE)
  CURR.NO = DCOUNT(OVERRIDE.FIELD.VALUE,'VM') + 1
  TEXT = 'REDO.CU.VINCULACIONES'
  CALL STORE.OVERRIDE(CURR.NO)
  GOSUB ROUTINE.END


ROUTINE.END:
END
