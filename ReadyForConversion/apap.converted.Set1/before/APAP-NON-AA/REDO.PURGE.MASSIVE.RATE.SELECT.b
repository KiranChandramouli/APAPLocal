*-----------------------------------------------------------------------------
* <Rating>-20</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.PURGE.MASSIVE.RATE.SELECT
*--------------------------------------------------------------
* Description : This routine is to delete the one month backdated log of
* F.REDO.MASSIVE.RATE.CHANGE. This is month end batch job
*--------------------------------------------------------------
**********************************************************************
* Modification History :
*-----------------------
*DATE           WHO           REFERENCE         DESCRIPTION
*14.07.2011  H GANESH      PACS00055012 - B.16 INITIAL CREATION
*----------------------------------------------------------------------



$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_REDO.PURGE.MASSIVE.RATE.COMMON


  GOSUB PROCESS
  RETURN
*--------------------------------------------------------------
PROCESS:
*--------------------------------------------------------------
  Y.DATE = TODAY
  YREGION = ''
  YDAYS.ORIG = '-30C'
  CALL CDT(YREGION,Y.DATE,YDAYS.ORIG)

  SEL.CMD = 'SELECT ':FN.REDO.MASSIVE.RATE.CHANGE:' WITH @ID LT ':Y.DATE:'...'
  CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.REC,PGM.ERR)
  CALL BATCH.BUILD.LIST('',SEL.LIST)

  RETURN
END
