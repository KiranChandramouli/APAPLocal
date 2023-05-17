*--------------------------------------------------------------------------------------------------------
* <Rating>-54</Rating>
*--------------------------------------------------------------------------------------------------------
  SUBROUTINE REDO.CARD.REQUEST.ID
*--------------------------------------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.CARD.REQUEST.ID
*--------------------------------------------------------------------------------------------------------
*Description  : This is a ID routine to to fetch next sequence no from F.LOCKING
*Linked With  : REDO.CARD.REQUEST
*In Parameter : N/A
*Out Parameter: N/A
*--------------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*    Date            Who                  Reference               Description
*   ------         ------               -------------            -------------
* 23 Jul 2010    Mohammed Anies K      ODR-2010-03-0400        Initial Creation
* 21-Jan-2010    Kavitha S             ODR-2010-03-0400        Code change as per CR
* 05-4-2011      KAVITHA               PACS00036008            ISSUE FIX
*--------------------------------------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_GTS.COMMON
$INSERT I_F.USER
$INSERT I_F.COMPANY
$INSERT I_F.REDO.CARD.REQUEST
$INSERT I_F.LOCKING
*--------------------------------------------------------------------------------------------------------
**********
MAIN.PARA:
**********

  GOSUB OPEN.PARA
  IF NOT(RUNNING.UNDER.BATCH) THEN
    IF GTSACTIVE THEN
      IF OFS$OPERATION EQ 'BUILD' THEN
        GOSUB PROCESS.PARA
        RETURN
      END
    END ELSE
      GOSUB PROCESS.PARA
    END
  END ELSE
    GOSUB PROCESS.PARA
  END
  RETURN
*--------------------------------------------------------------------------------------------------------
**********
OPEN.PARA:
**********
* In this para of code file variables are initialised and opened

  FN.LOCKING='F.LOCKING'

  FN.REDO.CARD.REQUEST = 'F.REDO.CARD.REQUEST'
  F.REDO.CARD.REQUEST = ''
  CALL OPF(FN.REDO.CARD.REQUEST,F.REDO.CARD.REQUEST)

  FN.REDO.CARD.REQUEST.NAU = 'F.REDO.CARD.REQUEST$NAU'
  F.REDO.CARD.REQUEST.NAU = ''
  CALL OPF(FN.REDO.CARD.REQUEST.NAU,F.REDO.CARD.REQUEST.NAU)

  Y.COMPANY = ID.COMPANY
  Y.COMPANY = Y.COMPANY[6,4]

  RETURN
*--------------------------------------------------------------------------------------------------------
*************
PROCESS.PARA:
*************
* Main processing section
  E = ''

  IF V$FUNCTION NE 'I' THEN
    RETURN
  END

  IF MESSAGE EQ 'VAL' THEN
    RETURN
  END

  Y.REDO.CARD.REQUEST.ID = ID.NEW

  GOSUB CHECK.LIVE

  IF R.REDO.CARD.REQUEST THEN
    RETURN
  END

  Y.REDO.CARD.REQUEST.NAU.ID = ID.NEW

  GOSUB CHECK.NAU

  IF R.REDO.CARD.REQUEST.NAU THEN
    RETURN
  END

  Y.LOCKING.ID = 'F.REDO.CREATE.REQUEST'
  GOSUB READ.LOCKING
  IF R.LOCKING EQ '' THEN
    GOSUB FIRST.NEW.ID
  END ELSE
    GOSUB GET.NEXT.ID
  END

  ID.NEW = Y.NEW.ID


  RETURN
*--------------------------------------------------------------------------------------------------------
**********************
READ.LOCKING:
**********************
*REDO.LOCKING record is read for the given locking id
  R.LOCKING   = ''
  LOCKING.ERR = ''
  F.RLOCKING=F.LOCKING
  CALL F.READU(FN.LOCKING,Y.LOCKING.ID,R.LOCKING,F.RLOCKING,LOCKING.ERR,'P')

  RETURN
*--------------------------------------------------------------------------------------------------------
************
FIRST.NEW.ID:
************
  R.LOCKING<EB.LOK.REMARK> = TODAY
  R.LOCKING<EB.LOK.CONTENT> = '001'

  Y.NEW.ID = 'REQ.':TODAY:'001':'.':Y.COMPANY
  GOSUB WRITE.TO.LOCKING

  RETURN
*--------------------------------------------------------------------------------------------------------
***********
GET.NEXT.ID:
***********
  Y.DATE = R.LOCKING<EB.LOK.REMARK>
  IF Y.DATE EQ TODAY THEN

    Y.SEQUENCE = R.LOCKING<EB.LOK.CONTENT>
    Y.SEQUENCE += 1
    Y.SEQUENCE=FMT(Y.SEQUENCE,'3"0"R')
    R.LOCKING<EB.LOK.CONTENT> = Y.SEQUENCE

    Y.NEW.ID = 'REQ.':TODAY:Y.SEQUENCE:'.':Y.COMPANY

    GOSUB WRITE.TO.LOCKING
  END ELSE
    GOSUB FIRST.NEW.ID
  END

  RETURN
*--------------------------------------------------------------------------------------------------------
****************
WRITE.TO.LOCKING:
****************
*
  WRITE R.LOCKING TO F.RLOCKING,Y.LOCKING.ID
 
*RETURN
*--------------------------------------------------------------------------------------------------------
***********
CHECK.LIVE:
***********
*

  R.REDO.CARD.REQUEST = ''
  REDO.CARD.REQUEST.ERR = ''
  CALL F.READ(FN.REDO.CARD.REQUEST,Y.REDO.CARD.REQUEST.ID,R.REDO.CARD.REQUEST,F.REDO.CARD.REQUEST,REDO.CARD.REQUEST.ERR)
  IF R.REDO.CARD.REQUEST THEN
    REQ.CO.CODE = R.REDO.CARD.REQUEST<REDO.CARD.REQ.CO.CODE>
    GOSUB CHECK.COMP.ERROR
  END



  RETURN
*--------------------------------------------------------------------------------------------------------
*********
CHECK.NAU:
*********
*
  R.REDO.CARD.REQUEST.NAU = ''
  REDO.CARD.REQUEST.NAU.ERR = ''
  CALL F.READ(FN.REDO.CARD.REQUEST.NAU,Y.REDO.CARD.REQUEST.NAU.ID,R.REDO.CARD.REQUEST.NAU,F.REDO.CARD.REQUEST.NAU,REDO.CARD.REQUEST.NAU.ERR)
  IF R.REDO.CARD.REQUEST.NAU THEN
    REQ.CO.CODE = R.REDO.CARD.REQUEST.NAU<REDO.CARD.REQ.CO.CODE>
    GOSUB CHECK.COMP.ERROR
  END


  RETURN
*--------------------------------------------------------------------------------------------------------
CHECK.COMP.ERROR:
*21-Jan-2010 -START

*PACS00036008 -S

  USER.COMP = R.USER<EB.USE.COMPANY.CODE>
  CHANGE VM TO FM IN USER.COMP

  FINAL.COMP = R.COMPANY(EB.COM.FINANCIAL.COM)
*IF ID.COMPANY NE FINAL.COMP  AND ID.COMPANY NE REQ.CO.CODE THEN

  IF ID.COMPANY NE REQ.CO.CODE THEN
    IF ID.COMPANY NE FINAL.COMP THEN
      LOCATE ID.COMPANY IN USER.COMP SETTING POS ELSE
        IF USER.COMP NE 'ALL' THEN
          E = "EB-CANNOT.ACCESS.ANOTHER.COMP"
        END
      END
    END
  END

*PACS00036008 -E
*21-Jan-2010 -END

  RETURN
*-------------------------------------------------------------------------
END
