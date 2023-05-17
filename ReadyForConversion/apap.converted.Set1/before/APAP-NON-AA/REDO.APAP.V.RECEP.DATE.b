*-----------------------------------------------------------------------------
* <Rating>10</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.APAP.V.RECEP.DATE
*********************************************************************************************************
*Company   Name    : APAP Bank
*Developed By      : Temenos Application Management
*Program   Name    : REDO.APAP.VAL.RECEPTION.DATE
*--------------------------------------------------------------------------------------------------------
*Description       : This routine ia a validation routine. It is used to check if the Security Documents
*                    have been given, if YES then make the field Reception Date mandatory and also check
*                    the reception date is not greater than TODAY
*Linked With       : COLLATERAL,DOC.RECEPTION
*In  Parameter     :
*Out Parameter     :
*Files  Used       : COLLATERAL             As          I Mode
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*    Date            Who                  Reference               Description
*   ------         ------               -------------            -------------
* 20/05/2010    Shiva Prasad Y     ODR-2009-10-0310 B.180C      Initial Creation
* 04/05/2011    Kavitha            PACS00054322 B.180C          Bug Fix
*
*********************************************************************************************************
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.COLLATERAL
*--------------------------------------------------------------------------------------------------------
**********
MAIN.PARA:
**********
  GOSUB FIND.MULTI.LOCAL.REF
  GOSUB PROCESS.PARA

  RETURN
*--------------------------------------------------------------------------------------------------------
*************
PROCESS.PARA:
*************

  RECP.OLD.VALUE = R.OLD(COLL.LOCAL.REF)<1,LOC.L.CO.SRECP>
  RECP.NEW.VALUE = R.NEW(COLL.LOCAL.REF)<1,LOC.L.CO.SRECP>


  LNDATE.OLD.VALUE = R.OLD(COLL.LOCAL.REF)<1,LOC.L.CO.LNDATE>
  LNDATE.NEW.VALUE = R.NEW(COLL.LOCAL.REF)<1,LOC.L.CO.LNDATE>


  DOC.OLD.VALUE = R.OLD(COLL.LOCAL.REF)<1,LOC.L.CO.SEC.DOC>
  DOC.NEW.VALUE = R.NEW(COLL.LOCAL.REF)<1,LOC.L.CO.SEC.DOC>

  DOC.CNTR = DCOUNT(DOC.OLD.VALUE,SM)

  CONVERT SM TO FM IN DOC.OLD.VALUE
  CONVERT SM TO FM IN DOC.NEW.VALUE

  CURR.NO = R.NEW(COLL.CURR.NO)
  IF CURR.NO NE '' THEN

    IF RECP.OLD.VALUE AND RECP.NEW.VALUE THEN
      IF RECP.OLD.VALUE NE RECP.NEW.VALUE THEN
        AF = COLL.LOCAL.REF
        AV = LOC.L.CO.SRECP
        ETEXT = "CO-DOC.REC.NOT.AMEND"
        CALL STORE.END.ERROR
      END

    END

    IF LNDATE.OLD.VALUE AND LNDATE.NEW.VALUE THEN
      IF LNDATE.OLD.VALUE NE LNDATE.NEW.VALUE THEN
        AF = COLL.LOCAL.REF
        AV = LOC.L.CO.LNDATE
        ETEXT = 'CO-DOC.REC.NOT.AMEND'
        CALL STORE.END.ERROR

      END
    END

    LOOP.CNTR = 1
    LOOP
    WHILE LOOP.CNTR LE DOC.CNTR

      FETCH.OLD.VALUE = DOC.OLD.VALUE<LOOP.CNTR>
      FETCH.NEW.VALUE = DOC.NEW.VALUE<LOOP.CNTR>

      IF FETCH.OLD.VALUE AND FETCH.NEW.VALUE THEN
        IF FETCH.OLD.VALUE NE FETCH.NEW.VALUE THEN
          AF = COLL.LOCAL.REF
          AV = LOC.L.CO.SEC.DOC
          AS = LOOP.CNTR
          ETEXT = "CO-DOC.REC.NOT.AMEND"
          CALL STORE.END.ERROR

        END
      END

      LOOP.CNTR += 1

    REPEAT



  END


  RETURN
*--------------------------------------------------------------------------------------------------------
*********************
FIND.MULTI.LOCAL.REF:
*********************
  APPL.ARRAY = 'COLLATERAL'
  FLD.ARRAY  = 'L.CO.SEC.DOC':VM:'L.CO.SRECP.DATE':VM:'L.CO.FILE.DATE'
  FLD.POS    = ''
  CALL MULTI.GET.LOC.REF(APPL.ARRAY,FLD.ARRAY,FLD.POS)
  LOC.L.CO.SEC.DOC  = FLD.POS<1,1>
  LOC.L.CO.SRECP    = FLD.POS<1,2>
  LOC.L.CO.LNDATE    = FLD.POS<1,3>

  RETURN
*---------------------------------------------------------------------------------------------------------------------------
END
