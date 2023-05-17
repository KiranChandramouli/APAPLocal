*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.COMPARE.KEY
*-----------------------------------------------------------------------------
* <Rating>-39</Rating>
*-----------------------------------------------------------------------------
* <doc>
*
* This table is used to confirm the password
*
* author: prabhun@temenos.com
*
* </doc>
*-----------------------------------------------------------------------------
* Modification History :
*   DATE       REF                WHO       DESC
* 26/06/2011 - PACS00032519       Prabuh N Confirm the password
* 03-10-2011 - PACS00032519       PRABHU N to check 24 CHARACTER
*-----------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.REDO.INTERFACE.PARAM

  Y.KEY1=R.NEW(REDO.INT.PARAM.ENCRIP.KEY)
  Y.KEY2=R.NEW(REDO.INT.PARAM.CON.ENC.KEY)
  Y.COMP=COMPARE(Y.KEY1,Y.KEY2)
  IF Y.COMP THEN
    AF=REDO.INT.PARAM.CON.ENC.KEY
    ETEXT="EB-CHECK.PASS"
    CALL STORE.END.ERROR
  END
  IF LEN(Y.KEY1) NE '24' THEN
    AF=REDO.INT.PARAM.ENCRIP.KEY
    ETEXT="EB-CHECK.24.DIGIT"
    CALL STORE.END.ERROR

  END
  RETURN
END
