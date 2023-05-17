*-----------------------------------------------------------------------------
* <Rating>-15</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.FC.S.INS.POL.AMT
*-----------------------------------------------------------------------------
* Developer    : Luis Fernando Pazmino (lpazminodiaz@temenos.com)
* Date         : 16.06.2011
* Description  : Validation routine with calculates the Total Insurance Amount
*                based on the Monthly Amount and Extra Amount
*                (activated by a hotfield)
*-----------------------------------------------------------------------------
* Modification History:
*
* Version   Date            Who               Reference      Description
* 1.0       15.06.2011      lpazmino          CR.180         Initial version
* 1.1       27.01.2011      jvalarezoulloa    CR.180         amends
* 1.2       29.02.2011      jvalarezoulloa    CR.180         The field INS.TOTAL.PRE.AMT should not be calculated on base other fields
*-----------------------------------------------------------------------------
* Input/Output: N/A
* Dependencies: N/A
*-----------------------------------------------------------------------------

* <region name="INCLUDES">
$INSERT I_COMMON
$INSERT I_EQUATE

$INSERT I_F.REDO.CREATE.ARRANGEMENT
* </region>

  GOSUB PROCESS

  RETURN

* <region name="PROCESS">
PROCESS:
*Y.NUM.INS = DCOUNT(R.NEW(REDO.FC.POLICY.NUMBER),VM)
  Y.NUM.INS = DCOUNT(R.NEW(REDO.FC.INS.POLICY.TYPE),VM)
  FOR I = 1 TO Y.NUM.INS
    Y.NUM.POL.AMT = DCOUNT(R.NEW(REDO.FC.INS.MON.POL.AMT)<1,I>,SM)
    Y.TOT.PREM.AMT = 0
* INS.MON.POL.AMT is mandatory when Management type is eq Incluir en Cuota
    IF R.NEW(REDO.FC.INS.MON.POL.AMT)<1,I> EQ '' AND R.NEW (REDO.FC.INS.MANAGEM.TYPE)<1,I> EQ 'INCLUIR EN CUOTA' THEN
      AF = REDO.FC.INS.MON.POL.AMT
      AV = I
      ETEXT  = 'EB-FC-MANDOTORY.FIELD'
      CALL STORE.END.ERROR
    END
    FOR J = 1 TO Y.NUM.POL.AMT

      Y.INS.EXTRA.AMT = R.NEW(REDO.FC.INS.EXTRA.AMT)<1,I,J>
      IF R.NEW(REDO.FC.INS.MON.POL.AMT)<1,I,J> EQ '' AND R.NEW (REDO.FC.INS.MANAGEM.TYPE)<1,I> EQ 'INCLUIR EN CUOTA' THEN
        AF = REDO.FC.INS.MON.POL.AMT
        AV = I
        AS = J
        ETEXT  = 'EB-FC-MANDOTORY.FIELD'
        CALL STORE.END.ERROR
      END
      Y.INS.MON.POL.AMT = R.NEW(REDO.FC.INS.MON.POL.AMT)<1,I,J>

      R.NEW(REDO.FC.INS.TOT.PREM.AMT)<1,I,J> = Y.INS.MON.POL.AMT + Y.INS.EXTRA.AMT
* JV 29FEB2012     Y.TOT.PREM.AMT += R.NEW(REDO.FC.INS.TOT.PREM.AMT)<1,I,J> JV 29FEB2012
    NEXT J

*  JV 29FEB2012  R.NEW(REDO.FC.INS.TOTAL.PREM.AMT)<1,I> = Y.TOT.PREM.AMT
  NEXT I

  RETURN
* </region>
END
