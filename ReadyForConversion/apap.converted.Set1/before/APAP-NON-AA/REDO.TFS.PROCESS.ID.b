*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
* <Rating>-20</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.TFS.PROCESS.ID
*-----------------------------------------------------------------------------
*----------------------------------------------------------------------------------------------------
*DESCRIPTION : This routine is used to check the ID value for the table REDO.TFS.PROCESS
*-----------------------------------------------------------------------------------------------------
*-----------------------------------------------------------------------------------------------------
* * Input / Output
* --------------
* IN     : -NA-
* OUT    : -NA-
*-----------------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : SUDHARSANAN S
* PROGRAM NAME : REDO.TFS.PROCESS.ID
*-----------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
* DATE             WHO                REFERENCE         DESCRIPTION
* 10.05.2010      SUDHARSANAN S     ODR-2009-10-0322  INITIAL CREATION
* ----------------------------------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_GTS.COMMON
$INSERT I_F.REDO.TFS.PROCESS
$INSERT I_F.LOCKING
  GOSUB INIT
  GOSUB PROCESS
  RETURN
*-----------------------------------------------------------------------------
INIT:
  FN.LOCKING='F.LOCKING'
  F.LOCKING=''
  CALL OPF(FN.LOCKING,F.LOCKING)
  LOCK.FLUSH=''

  RETURN
*----------------------------------------------------------------------------
PROCESS:
  IF V$FUNCTION EQ 'I' THEN
    R.LOCKING = ''
    LOCK.ERR = ''
    LOCK.ID='FBNK.REDO.TFS.PROCESS'
    CALL F.READU(FN.LOCKING,LOCK.ID,R.LOCKING,F.LOCKING,LOCK.ERR,'')
    Y.CONTENT = R.LOCKING<EB.LOK.CONTENT>
    Y.REMARK =R.LOCKING<EB.LOK.REMARK>
    IF Y.CONTENT EQ '' THEN
      Y.SEQ='001'
      ID.NEW='TFS':TODAY:Y.SEQ
      R.LOCKING<EB.LOK.CONTENT> = ID.NEW
      R.LOCKING<EB.LOK.REMARK> = TODAY
      CALL LOG.WRITE(FN.LOCKING,LOCK.ID,R.LOCKING,LOCK.FLUSH)
    END ELSE
      LOCATE TODAY IN Y.REMARK SETTING POS ELSE
        Y.SEQ='001'
        ID.NEW='TFS':TODAY:Y.SEQ
        R.LOCKING<EB.LOK.CONTENT> = ID.NEW
        R.LOCKING<EB.LOK.REMARK> = TODAY
        CALL LOG.WRITE(FN.LOCKING,LOCK.ID,R.LOCKING,LOCK.FLUSH)
      END
    END
  END
  RETURN
*------------------------------------------------------------------------------
END
