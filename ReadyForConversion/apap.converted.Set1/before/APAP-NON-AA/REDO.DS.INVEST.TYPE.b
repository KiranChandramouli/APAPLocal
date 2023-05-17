*-----------------------------------------------------------------------------
* <Rating>-30</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.DS.INVEST.TYPE(Y.RET)
***********************************************************************
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: Pradeep S
* PROGRAM NAME: REDO.DS.INVEST.TYPE
* ODR NO      : PACS00051213
*----------------------------------------------------------------------
*DESCRIPTION: This routine is attched in DEAL.SLIP.FORMAT 'REDO.BUS.SELL'
* to get the details of the SUB.ASSET.TYPE

*IN PARAMETER:  NA
*OUT PARAMETER: NA
*LINKED WITH:
*----------------------------------------------------------------------
* Modification History :
*-----------------------
*DATE           WHO           REFERENCE         DESCRIPTION
*----------------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.SEC.TRADE
$INSERT I_F.SECURITY.MASTER
$INSERT I_F.SUB.ASSET.TYPE

  GOSUB INIT
  GOSUB OPENFILES
  GOSUB PROCESS
  RETURN

INIT:
*****
  FN.SECURITY.MASTER = 'F.SECURITY.MASTER'
  F.SECURITY.MASTER = ''

  FN.SUB.ASSET.TYPE = 'F.SUB.ASSET.TYPE'
  F.SUB.ASSET.TYPE = ''

  RETURN

OPENFILES:
**********
  CALL OPF(FN.SECURITY.MASTER,F.SECURITY.MASTER)
  CALL OPF(FN.SUB.ASSET.TYPE,F.SUB.ASSET.TYPE)
  RETURN

PROCESS:
********

  SEC.TRADE.ID = Y.RET

  SEC.CODE.ID = R.NEW(SC.SBS.SECURITY.CODE)

  CALL F.READ(FN.SECURITY.MASTER,SEC.CODE.ID,R.SECURITY.MASTER,F.SECURITY.MASTER,SECURITY.MASTER.ERR)
  Y.SUB.ASSET.TYPE = R.SECURITY.MASTER<SC.SCM.SUB.ASSET.TYPE>

  IF Y.SUB.ASSET.TYPE THEN
    R.SAT = '' ; SAT.ERR = ''
    CALL F.READ(FN.SUB.ASSET.TYPE,Y.SUB.ASSET.TYPE,R.SAT,F.SUB.ASSET.TYPE,SAT.ERR)
    Y.INVERST.TYPE = R.SAT<SC.CSG.DESCRIPTION>
    Y.INT.CNT=DCOUNT(Y.INVERST.TYPE,VM)

    IF Y.INT.CNT GT 1 THEN
      Y.INVERST.TYPE = R.SAT<SC.CSG.DESCRIPTION,LNGG>
    END
    IF  Y.INVERST.TYPE EQ '' THEN
      Y.INVERST.TYPE = R.SAT<SC.CSG.DESCRIPTION,2>
    END
  END

  Y.RET = Y.INVERST.TYPE
  RETURN

END
