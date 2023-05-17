*-----------------------------------------------------------------------------
* <Rating>-21</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.V.TEL.SUB.GROUP
*----------------------------------------------------------------------------------------------------
*DESCRIPTION : This routine is used to validate the REDO.TELLER.PROCESS table fields
*-----------------------------------------------------------------------------------------------------
*-----------------------------------------------------------------------------------------------------
* * Input / Output
* --------------
* IN     : -NA-
* OUT    : -NA-
*-----------------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : SUDHARSANAN S
* PROGRAM NAME : REDO.V.TEL.SUB.GROUP
*-----------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*DATE             WHO                REFERENCE         DESCRIPTION
*27-05-2011     Sudharsanan S       PACS00062653    Initial Creation
* -----------------------------------------------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.REDO.TELLER.PROCESS
$INSERT I_F.REDO.TT.GROUP.PARAM
$INSERT I_GTS.COMMON

  IF OFS.VAL.ONLY EQ '1' AND MESSAGE EQ '' THEN
    GOSUB INIT
    GOSUB PROCESS
  END
  RETURN
*---
INIT:
*---
  FN.REDO.TT.GROUP.PARAM = 'F.REDO.TT.GROUP.PARAM'
  F.REDO.TT.GROUP.PARAM = ''
  CALL OPF(FN.REDO.TT.GROUP.PARAM,F.REDO.TT.GROUP.PARAM)

  Y.SUB.GROUP = ''
  CALL CACHE.READ(FN.REDO.TT.GROUP.PARAM,'SYSTEM',R.REDO.TT.GROUP.PARAM,GRO.ERR)
  VAR.GROUP = R.REDO.TT.GROUP.PARAM<TEL.GRO.GROUP>

  RETURN
*-------
PROCESS:
*-------
*To validate the fields and updates the value
  Y.GROUP = R.NEW(TEL.PRO.GROUP)
  Y.SUB.GROUP = COMI
  CHANGE VM TO FM IN VAR.GROUP
  LOCATE Y.GROUP IN VAR.GROUP SETTING POS.VM THEN
    VAR.SUB.GROUP = R.REDO.TT.GROUP.PARAM<TEL.GRO.SUB.GROUP,POS.VM>
    CHANGE SM TO FM IN VAR.SUB.GROUP
    LOCATE Y.SUB.GROUP IN VAR.SUB.GROUP SETTING POS.SM THEN
      VAR.DESCRIPTION = R.REDO.TT.GROUP.PARAM<TEL.GRO.DESCRIPTION,POS.VM,POS.SM>
      VAR.CURRENCY = R.REDO.TT.GROUP.PARAM<TEL.GRO.CURRENCY,POS.VM,POS.SM>
      VAR.AMOUNT = R.REDO.TT.GROUP.PARAM<TEL.GRO.CHG.AMOUNT,POS.VM,POS.SM>
      VAR.CATEGORY = R.REDO.TT.GROUP.PARAM<TEL.GRO.CATEGORY,POS.VM,POS.SM>
      R.NEW(TEL.PRO.CONCEPT) = VAR.DESCRIPTION
      R.NEW(TEL.PRO.CURRENCY) = VAR.CURRENCY
      R.NEW(TEL.PRO.AMOUNT) = VAR.AMOUNT
      R.NEW(TEL.PRO.CATEGORY) = VAR.CATEGORY
    END ELSE
      AF = TEL.PRO.SUB.GROUP
      ETEXT = 'EB-MAND.INP'
      CALL STORE.END.ERROR
    END
  END
  RETURN
*---------------------------------------------------------------------------------------
END
