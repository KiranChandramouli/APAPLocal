*-----------------------------------------------------------------------------
* <Rating>20</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE APAP.H.GARNISH.DETAILS.ID
*--------------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :Bharath C
*ODR Number        :ODR-2009-10-0531
*Program   Name    :APAP.H.GARNISH.DETAILS.ID
*---------------------------------------------------------------------------------
*DESCRIPTION       :This routine is the .ID routine for the local template APAP.H.GARNISH.DETAILS
* and is used to set the ID for the Garnish Table
* ----------------------------------------------------------------------------------
*-----------------------------------------------------------------------
*MODIFICATION:
*   DATE             By               Reference
* 16-02-2011        Prabhu.N         PACS00023885     Routine to populate the Local fields in APAP.H.GARNISH.DETAILS
*-------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.LOCKING

  GOSUB OPENFILE
  GOSUB PROCESS

  RETURN
*-----------------
OPENFILE:
  FN.LOCKING='F.LOCKING'
  F.LOCKING=''
  CALL OPF(FN.LOCKING,F.LOCKING)

  RETURN
*----------------------------
PROCESS:

  VAR.ID=ID.NEW
  LEN1=LEN(VAR.ID)

  IF LEN1 LT '12'  THEN
    LOCK.ID='F.APAP.H.GARNISH.DETAILS'
    R.LOCKING = ''
    CALL F.READU(FN.LOCKING,LOCK.ID,R.LOCKING,F.LOCKING,LOCK.ERR,RETRY)
    IF R.LOCKING THEN
      REMARK.VAL=R.LOCKING<EB.LOK.REMARK>
      IF REMARK.VAL EQ '' THEN
        R.LOCKING<EB.LOK.REMARK>= TODAY
        WRITE R.LOCKING TO F.LOCKING,LOCK.ID 

      END ELSE
        IF TODAY GT REMARK.VAL THEN
          GOSUB CHECK.TODAY.DATE
        END
      END
    END ELSE
      GOSUB CHECK.TODAY.DATE
    END
    ID.NEW = TODAY:FMT(VAR.ID,'R%4')
    CALL F.RELEASE(FN.LOCKING,LOCK.ID,F.LOCKING)
  END
  RETURN

*-------------
CHECK.TODAY.DATE:
  R.LOCKING<EB.LOK.REMARK> = TODAY
  R.LOCKING<EB.LOK.CONTENT> = '0001'
  VAR.ID = '0001'
  WRITE R.LOCKING TO F.LOCKING,LOCK.ID 

  RETURN
*--------------
END
