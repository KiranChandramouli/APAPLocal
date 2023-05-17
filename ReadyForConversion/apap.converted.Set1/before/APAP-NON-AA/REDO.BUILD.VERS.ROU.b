*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.BUILD.VERS.ROU

*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :MARIMUTHU S
*Program   Name    :REDO.BUILD.VERS.ROU
*---------------------------------------------------------------------------------

*DESCRIPTION       : This is conversion routine used in the enquiry REDO.PART.TT.PROCESS.LIST

* ----------------------------------------------------------------------------------
*Modification Details:
*=====================
*   Date               who           Reference            Description
* 10-08-2010        MARIMUTHU S      PACS00094144       Initial Creation

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_ENQUIRY.COMMON
$INSERT I_F.REDO.REPAY.NEXT.VER.PROCESS

  FN.REDO.REPAY.NEXT.VER.PROCESS = 'F.REDO.REPAY.NEXT.VER.PROCESS'
  F.REDO.REPAY.NEXT.VER.PROCESS = ''


  CALL CACHE.READ(FN.REDO.REPAY.NEXT.VER.PROCESS,'SYSTEM',R.REDO.REPAY.NEXT.VER.PROCESS,ERRR)

  Y.VAL = O.DATA

  Y.VERSIONS = R.REDO.REPAY.NEXT.VER.PROCESS<REP.NX.PAYMENT.VERSION>
  Y.PAYMETN.MET = R.REDO.REPAY.NEXT.VER.PROCESS<REP.NX.PAYMENT.METHOD>

  LOCATE Y.VAL IN Y.PAYMETN.MET<1,1> SETTING POS.PR THEN
    O.DATA = Y.VERSIONS<1,POS.PR>
  END

END
