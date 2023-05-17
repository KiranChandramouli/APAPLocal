*-----------------------------------------------------------------------------
* <Rating>20</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.IVR.VALCONTRATO(R.DATA)
*-----------------------------------------------------------------------------
*DESCRIPTION:
*------------
* This is an Nofile routine to be used in enquiry REDO.IVR.VALCONTRATO related
* to C.3 IVR Interface
*
* Input/Output:
*--------------
* IN : CUSTOMER.NO, CONTRACT.NO
* OUT : R.DATA (ALL DATA)
*---------------
*-----------------------------------------------------------------------------
* Modification History :
*   Date            Who                   Reference               Description
* 18-FEB-2011    RMONDRAGON            ODR-2011-02-0099          FIRST VERSION

*-----------------------------------------------------------------------------
* <region name= Inserts>
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_ENQUIRY.COMMON
$INSERT I_F.REDO.ADD.THIRDPARTY
* </region>
*-----------------------------------------------------------------------------

  GOSUB INIT
  GOSUB OPENFILES
  GOSUB PROCESS
  RETURN
*
*****
INIT:
*****

  CUSTOMER.NO.POS = ""
  CONTRACT.NO.POS = ""
  Y.CUSTOMER.NO = ""
  Y.CONTRACT.NO = ""
  Y.SEL.REDO.ADD.THIRDPARTY = ""
  Y.REDO.ADD.THIRDPARTY.LIST = ""
  Y.REDO.ADD.THIRDPARTY.LIST.NO = ""
  REDO.ADD.THIRDPARTY.ERR = ""
  Y.RECORD.TO.CHECK = ""
  Y.REDO.ADD.THIRDPARTY.REC = ""
  Y.CONTRACT.NO.TO.CHECK = ""

  RETURN

**********
OPENFILES:
**********

  FN.REDO.ADD.THIRDPARTY = "F.REDO.ADD.THIRDPARTY"
  F.REDO.ADD.THIRDPARTY = ""
  CALL OPF(FN.REDO.ADD.THIRDPARTY,F.REDO.ADD.THIRDPARTY)

  RETURN

********
PROCESS:
********

  LOCATE "CUSTOMER.NO" IN D.FIELDS<1> SETTING CUSTOMER.NO.POS THEN
    Y.CUSTOMER.NO = D.RANGE.AND.VALUE<CUSTOMER.NO.POS>
  END

  LOCATE "CONTRACT.NO" IN D.FIELDS<1> SETTING CONTRACT.NO.POS THEN
    Y.CONTRACT.NO = D.RANGE.AND.VALUE<CONTRACT.NO.POS>
  END

  Y.SEL.REDO.ADD.THIRDPARTY = "SELECT ":FN.REDO.ADD.THIRDPARTY:" WITH CUSTOMER.ID EQ ":Y.CUSTOMER.NO
  CALL EB.READLIST(Y.SEL.REDO.ADD.THIRDPARTY,Y.REDO.ADD.THIRDPARTY.LIST,'',Y.REDO.ADD.THIRDPARTY.LIST.NO,REDO.ADD.THIRDPARTY.ERR)

  IF Y.REDO.ADD.THIRDPARTY.LIST.NO NE "0" THEN
    FOR Y.IND = 1 TO Y.REDO.ADD.THIRDPARTY.LIST.NO
      Y.RECORD.TO.CHECK = Y.REDO.ADD.THIRDPARTY.LIST<Y.IND>
      CALL F.READ(FN.REDO.ADD.THIRDPARTY,Y.RECORD.TO.CHECK,Y.REDO.ADD.THIRDPARTY.REC,F.REDO.ADD.THIRDPARTY,REDO.ADD.THIRDPARTY.ERR)
      IF Y.REDO.ADD.THIRDPARTY.REC THEN
        Y.CONTRACT.NO.TO.CHECK = Y.REDO.ADD.THIRDPARTY.REC<ARC.TP.CONTRACT.NO>
        IF Y.CONTRACT.NO EQ Y.CONTRACT.NO.TO.CHECK THEN
          R.DATA<-1> = "1"
          RETURN
        END
      END ELSE
        R.DATA<-1> = "2"
        RETURN
      END
    NEXT Y.IND
    R.DATA<-1> = "2"
    RETURN
  END ELSE
    R.DATA<-1> = "2"
  END

  RETURN

END
