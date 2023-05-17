*-----------------------------------------------------------------------------
* <Rating>-10</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE AI.REDO.INP.SEL.COMP.DET

*-----------------------------------------------------------------------------
* @author riyasbasha@temenos.com
*-----------------------------------------------------------------------------
* Modification History :
*
*-----------------------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.REDO.THIRDPRTY.PARAMETER
$INSERT I_F.REDO.ADD.THIRDPARTY


  FN.REDO.THIRDPRTY.PARAMETER = 'F.REDO.THIRDPRTY.PARAMETER'
  F.REDO.THIRDPRTY.PARAMETER  = ''
  CALL OPF(FN.REDO.THIRDPRTY.PARAMETER,F.REDO.THIRDPRTY.PARAMETER)
  GOSUB PROCESS

  RETURN
*********
PROCESS:
*********

  Y.COMP.NAME  = R.NEW(ARC.TP.COMP.SERV.NAME)
  SEL.CMD.RCO = "SELECT ":FN.REDO.THIRDPRTY.PARAMETER:" WITH COMP.NAME EQ ":Y.COMP.NAME
  CALL EB.READLIST(SEL.CMD.RCO,SEL.LIST,'',NO.OF.REC,SEL.ERR)
  R.NEW(ARC.TP.TYPE.OF.SERVICE) = SEL.LIST<1>
  RETURN
*-----------------------------------------------------------------------------
END
