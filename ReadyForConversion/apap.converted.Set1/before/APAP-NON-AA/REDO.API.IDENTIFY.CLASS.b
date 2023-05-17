*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.API.IDENTIFY.CLASS(Y.APP.OVERRIDES,Y.CR.FLAG,Y.TR.FLAG)
*-----------------------------------------------------------------------------
*------------------------------------------------------------------------------------------
* DESCRIPTION :   This routine will be executed at check Record Routine for TELLER VERSIONS
*------------------------------------------------------------------------------------------
*
* COMPANY NAME : APAP
* DEVELOPED BY : VICTOR NAVA
* PROGRAM NAME : REDO.API.IDENTIFY.CLASS
*
*------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*       DATE             WHO                REFERENCE         DESCRIPTION
*
* -----------------------------------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_GTS.COMMON
$INSERT I_System
$INSERT I_F.FOREX
$INSERT I_F.MM.MONEY.MARKET
$INSERT I_F.SEC.TRADE
$INSERT I_F.REDO.APAP.FX.BRN.COND
$INSERT I_F.OVERRIDE
$INSERT I_REDO.FX.OVR.COMMON



  FN.REDO.APAP.FX.BRN.COND = 'F.REDO.APAP.FX.BRN.COND'
  F.REDO.APAP.FX.BRN.COND  = ''
  CALL OPF(FN.REDO.APAP.FX.BRN.COND,F.REDO.APAP.FX.BRN.COND)

  FN.OVERRIDE = 'F.OVERRIDE'
  F.OVERRIDE  = ''
  CALL OPF(FN.OVERRIDE,F.OVERRIDE)

  Y.CR.FLAG = ''
  Y.TR.FLAG = ''
  Y.SYSTEM = 'SYSTEM'
  Y.APPLICATION = APPLICATION


*  CALL F.READ(FN.REDO.APAP.FX.BRN.COND,Y.SYSTEM,R.REDO.APAP.FX.BRN.COND,F.REDO.APAP.FX.BRN.COND,LIMITS.ERR) ;*Tus Start 
  CALL CACHE.READ(FN.REDO.APAP.FX.BRN.COND,Y.SYSTEM,R.REDO.APAP.FX.BRN.COND,LIMITS.ERR) ; * Tus End
  Y.CREDITOR.CLASS = R.REDO.APAP.FX.BRN.COND<REDO.BRN.COND.CR.USER.CLASS>
  Y.TREASURY.CLASS = R.REDO.APAP.FX.BRN.COND<REDO.BRN.COND.TR.USER.CLASS>
  CHANGE VM TO FM IN Y.CREDITOR.CLASS
  CHANGE VM TO FM IN Y.TREASURY.CLASS


  Y.TOT.OVRDS = DCOUNT(Y.APP.OVERRIDES,VM)
  Y.API.CNT = 1
  LOOP
  WHILE Y.API.CNT LE Y.TOT.OVRDS
    Y.OVRD.NAME  = Y.APP.OVERRIDES<1,Y.API.CNT>
    Y.OVRD.NAME = FIELD(Y.OVRD.NAME,'}',1)
    CALL F.READ(FN.OVERRIDE,Y.OVRD.NAME,R.OVERRIDE,F.OVERRIDE,OVERRIDE.ERR)

    Y.OVRD.APPLICATION  = R.OVERRIDE<EB.OR.APPLICATION>
    Y.OVRD.ALL.CLASS    = R.OVERRIDE<EB.OR.CLASS>
    CHANGE VM TO FM IN Y.OVRD.APPLICATION
    LOCATE Y.APPLICATION IN Y.OVRD.APPLICATION SETTING Y.OVR.POS THEN
      Y.OVRD.CLASS = Y.OVRD.ALL.CLASS<1,Y.OVR.POS>
    END

    IF Y.OVRD.CLASS THEN
      LOCATE Y.OVRD.CLASS IN Y.CREDITOR.CLASS SETTING Y.CR.POS THEN
        Y.CR.FLAG  = 'O1'
      END

      LOCATE Y.OVRD.CLASS IN Y.TREASURY.CLASS SETTING Y.TR.POS THEN
        Y.TR.FLAG  = 'O2'
      END
    END
    Y.API.CNT++
  REPEAT

  RETURN
END
