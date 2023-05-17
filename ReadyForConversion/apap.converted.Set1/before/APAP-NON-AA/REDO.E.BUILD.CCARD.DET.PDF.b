*-----------------------------------------------------------------------------
* <Rating>-31</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.E.BUILD.CCARD.DET.PDF(ENQ.DATA)
************************************************************
*----------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By : PRABHU N
* Program Name : REDO.E.BUILD.CCARD.LIST
*----------------------------------------------------------

* Description   : This subroutine is used to set selection for CREDIT CARD DETAIL

* Linked with   : REDO.CCARD.LIST
* In Parameter  : ENQ.DATA
* Out Parameter : ENQ.DATA
*-----------------------------------------------------------------------------
*--------------------------------------------------------------------------------
*MODIFICATION:
*--------------------------------------------------------------------------------
*DATE           ODR                   DEVELOPER               VERSION
*--------       ----------------      -------------           -------------------
*07.04.2011     PACS00036498           Prabhu N            INITIAL CREATION
*--------------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_ENQUIRY.COMMON
$INSERT I_EB.EXTERNAL.COMMON
$INSERT I_System

  GOSUB INIT
  GOSUB PROCESS
  RETURN
*-----
INIT:
*-----
  Y.CARD.NO= System.getVariable('CURRENT.CARD.ID')
  Y.COMAPNY.CODE= System.getVariable('CURRENT.COMP.CODE')
 
*    Y.CORTE       = System.getVariable('CURRENT.CARD.CORTE')
  FN.REDO.EB.USER.PRINT.VAR='F.REDO.EB.USER.PRINT.VAR'
  F.REDO.EB.USER.PRINT.VAR=''
  CALL OPF(FN.REDO.EB.USER.PRINT.VAR,F.REDO.EB.USER.PRINT.VAR)

  Y.USR.VAR = System.getVariable("EXT.EXTERNAL.USER")

  Y.HTML.VAR = Y.USR.VAR:"-":"CURRENT.CARD.CORTE"
*Read Converted by TUS-Convert
*  READ HTML.HEADER FROM F.REDO.EB.USER.PRINT.VAR,Y.HTML.VAR ELSE ;*Tus Start 
  CALL F.READ(FN.REDO.EB.USER.PRINT.VAR,Y.HTML.VAR,HTML.HEADER,F.REDO.EB.USER.PRINT.VAR,HTML.HEADER.ERR)
  IF HTML.HEADER.ERR THEN  ;* Tus Start
    HTML.HEADER = ''
  END

  Y.CORTE = HTML.HEADER<1,2>
  RETURN
*-------
PROCESS:
*-------
  Y.FIELD.COUNT=DCOUNT(ENQ.DATA<2>,VM)
  ENQ.DATA<2,Y.FIELD.COUNT+1>= 'CARD.NO'
  ENQ.DATA<3,Y.FIELD.COUNT+1>= 'EQ'
  ENQ.DATA<4,Y.FIELD.COUNT+1> = Y.CARD.NO
  ENQ.DATA<2,Y.FIELD.COUNT+2>= 'COMPANY.CODE'
  ENQ.DATA<3,Y.FIELD.COUNT+2>= 'EQ'
  ENQ.DATA<4,Y.FIELD.COUNT+2> = Y.COMAPNY.CODE

  Y.DATE.MONTH=Y.CORTE[5,2]
  Y.DATE.YEAR =Y.CORTE[1,4]

  ENQ.DATA<2,Y.FIELD.COUNT+3>= 'START.DATE'
  ENQ.DATA<3,Y.FIELD.COUNT+3>= 'EQ'
  ENQ.DATA<4,Y.FIELD.COUNT+3>= Y.DATE.MONTH

  ENQ.DATA<2,Y.FIELD.COUNT+4>= 'END.DATE'
  ENQ.DATA<3,Y.FIELD.COUNT+4>= 'EQ'
  ENQ.DATA<4,Y.FIELD.COUNT+4>= Y.DATE.YEAR

  ENQ.DATA<2,Y.FIELD.COUNT+5>= 'CURRENCY'
  ENQ.DATA<3,Y.FIELD.COUNT+5>= 'EQ'
  ENQ.DATA<4,Y.FIELD.COUNT+5>= 'DOP'

  RETURN
END
