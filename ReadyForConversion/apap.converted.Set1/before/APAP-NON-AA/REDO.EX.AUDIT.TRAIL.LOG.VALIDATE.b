*-----------------------------------------------------------------------------
* <Rating>-10</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.EX.AUDIT.TRAIL.LOG.VALIDATE
*-----------------------------------------------------------------------------
*Company Name      : APAP Bank
*Developed By      : Shankar Raju
*Program Name      : REDO.EX.AUDIT.TRAIL.LOG.VALIDATE
*Date              : 09/01/2011
*-----------------------------------------------------------------------------
*Description       : This is a Validate routine to validate if the path entered is a valid
*                    one
*-----------------------------------------------------------------------------
*Modification History:
*
*    DATE               ODR REFERENCE                 WHO              DESCRIPTION
* 09.01.2012         SegN4 - ODR-2010-03-0116     Shankar Raju       System Audit Trail
* 10.01.2012             TUT1276148               Shankar Raju       Adding Description
*-----------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.REDO.EX.AUDIT.TRAIL.LOG

  GOSUB VALIDATE

  RETURN
*-----------------------------------------------------------------------------
VALIDATE:
*********
  IF ID.NEW EQ 'SYSTEM' THEN
    Y.ARC.PTH = R.NEW(REDO.EX.TRAIL.INFORMATION)
    IF Y.ARC.PTH EQ '' THEN
      AF = REDO.EX.TRAIL.INFORMATION
      ETEXT = 'EB-INVALID.PATH'
      CALL STORE.END.ERROR
    END ELSE
      OPEN Y.ARC.PTH TO F.FILE.PATH ELSE
        AF = REDO.EX.TRAIL.INFORMATION
        ETEXT = 'EB-INVALID.PATH'
        CALL STORE.END.ERROR
      END
    END
  END
  RETURN
*-----------------------------------------------------------------------------
END
