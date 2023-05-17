* <Rating>-40</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.E.BLD.OTHRBANK.FTNAU(ENQ.DATA)
************************************************************
*----------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By : Arundev
* Program Name : REDO.E.BLD.OTHRBANK.FTNAU
*----------------------------------------------------------

* Description   : build routine for the enquiry REDO.PAY.IN.OTHER.BANK.FTNAU

* Linked with   :
* In Parameter  :ENQ.DATA
* Out Parameter : ENQ.DATA
*---------------------------------------------------------------------------------
*MODIFICATION:
*---------------------------------------------------------------------------------
* DATE           ODR                   DEVELOPER               VERSION
*--------       ----------------      -------------           --------------------
* 11-04-2013    Arundev                PACS00263522           0004521: Cadena 4176 (Issues Criticos)
*---------------------------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_ENQUIRY.COMMON
$INSERT I_EB.EXTERNAL.COMMON
$INSERT I_System
$INSERT I_F.REDO.ENQ.VERSION.TXNS

  GOSUB INITIALISE
  GOSUB OPENFIES
  GOSUB PROCESS

  RETURN

*---------------------------------------------------------------------------------
INITIALISE:
*---------------------------------------------------------------------------------

  RETURN

*---------------------------------------------------------------------------------
OPENFIES:
*---------------------------------------------------------------------------------

  FN.REDO.ENQ.VERSION.TXNS = 'F.REDO.ENQ.VERSION.TXNS'
  F.REDO.ENQ.VERSION.TXNS = ''
  CALL OPF(FN.REDO.ENQ.VERSION.TXNS,F.REDO.ENQ.VERSION.TXNS)

  RETURN

*---------------------------------------------------------------------------------
PROCESS:
*---------------------------------------------------------------------------------

  V.ENQ.NAME = ENQ.DATA<1>
  R.REDO.ENQ.VERSION.TXNS = ''
  V.ERR = ''
  CALL F.READ(FN.REDO.ENQ.VERSION.TXNS,V.ENQ.NAME,R.REDO.ENQ.VERSION.TXNS,F.REDO.ENQ.VERSION.TXNS,V.ERR)

  IF R.REDO.ENQ.VERSION.TXNS THEN
    GOSUB ENQ.VERSION.PROCESS
  END

  RETURN

*---------------------------------------------------------------------------------
ENQ.VERSION.PROCESS:
*---------------------------------------------------------------------------------

  VERSION.LIST = R.REDO.ENQ.VERSION.TXNS<REDO.ENQ.VER.VERSION>
  VERSION.LIST = CHANGE(VERSION.LIST,VM,SM)

  ENQ.DATA<2,-1>= 'L.ACTUAL.VERSIO'
  ENQ.DATA<3,-1>= 'EQ'
  ENQ.DATA<4,-1> = VERSION.LIST

  RETURN

END
