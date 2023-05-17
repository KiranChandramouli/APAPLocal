*--------------------------------------------------------------------------------------------------------
*-----------------------------------------------------------------------------
* <Rating>-10</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.ACH.PROCESS.ID
*--------------------------------------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.ACH.PROCESS.ID
*--------------------------------------------------------------------------------------------------------
*Description  : This is a ID routine to display ID in yyyymmdd.seconds format
*Linked With  : REDO.ACH.PROCESS
*In Parameter : N/A
*Out Parameter: N/A
*--------------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*    Date            Who                  Reference               Description
*   ------         ------               -------------            -------------
* 1 Sep 2010     Swaminathan.S.R       ODR-2009-12-0290        Initial Creation
*--------------------------------------------------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_GTS.COMMON
$INSERT I_F.OFS.STATUS.FLAG

  FN.REDO.ACH = 'F.REDO.ACH.PROCESS'
  F.REDO.ACH = ''
  CALL OPF(FN.REDO.ACH,F.REDO.ACH)

  FN.REDO.ACH.NAU = 'F.REDO.ACH.PROCESS$NAU'
  F.REDO.ACH.NAU = ''
  CALL OPF(FN.REDO.ACH.NAU,F.REDO.ACH.NAU)

  IF GTSACTIVE THEN
    IF OFS$STATUS<STAT.FLAG.FIRST.TIME> THEN
      GOSUB PROCESS.PARA
      RETURN
    END
  END ELSE
    GOSUB PROCESS.PARA
  END
  RETURN

**************
PROCESS.PARA:
**************

  IF V$FUNCTION EQ 'I' THEN

    CALL F.READ(FN.REDO.ACH,ID.NEW,R.REDO.ACH,F.REDO.ACH,DET.ERR)
    IF DET.ERR THEN

      CALL F.READ(FN.REDO.ACH.NAU,ID.NEW,R.REDO.ACH.NAU,F.REDO.ACH.NAU,DET.NAU.ERR)

      IF DET.NAU.ERR THEN

        ID.NEW = TODAY:".":TIME()
      END

    END
  END
  RETURN
END
