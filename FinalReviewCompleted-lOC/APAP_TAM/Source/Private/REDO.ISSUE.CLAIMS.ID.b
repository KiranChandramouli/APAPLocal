$PACKAGE APAP.TAM
SUBROUTINE REDO.ISSUE.CLAIMS.ID
*-----------------------------------------------------------------------------
*----------------------------------------------------------------------------------------------------
*DESCRIPTION : This routine is used to check the ID value for the table REDO.ISSUE.CLAIMS
*-----------------------------------------------------------------------------------------------------
*-----------------------------------------------------------------------------------------------------
* * Input / Output
* --------------
* IN     : -NA-
* OUT    : -NA-
*-----------------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : SUDHARSANAN S
* PROGRAM NAME : REDO.ISSUE.CLAIMS.ID
*-----------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
* DATE             WHO                REFERENCE         DESCRIPTION
* 22.07.2010      SUDHARSANAN S       ODR-2009-12-0283  INITIAL CREATION
* 01-MAR-2010     PRABHU              HD1100464         Lock release added
* 31-MAY-2011     PRADEEP S           PACS00071941      PGM.VERSION set to current variable to access from
*                                                       drop down enquiry
** 12-04-2023 R22 Auto Conversion no changes
** 12-04-2023 Skanda R22 Manual Conversion - No changes
* ----------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
    $INSERT I_F.REDO.ISSUE.CLAIMS
    $INSERT I_F.LOCKING

    GOSUB INIT
    GOSUB PROCESS
RETURN
*------------------------------------------------------------------------------------------------------
INIT:
*------------------------------------------------------------------------------------------------------
    FN.LOCKING='F.LOCKING'
    F.LOCKING=''
    CALL OPF(FN.LOCKING,F.LOCKING)
    LOCK.FLUSH=''

RETURN
*--------------------------------------------------------------------------------------------------------
PROCESS:
*--------------------------------------------------------------------------------------------------------
    BANK.CODE = '0572'
    Y.YEAR = TODAY[1,4]
    Y.MONTH = TODAY[5,2]
    Y.DATE = TODAY[7,2]
    IF V$FUNCTION EQ 'I' AND PGM.VERSION EQ ',OPEN' THEN
        R.LOCKING = ''
        LOCK.ERR = ''
        LOCK.ID='F.REDO.ISSUE.CLAIMS'
        CALL F.READU(FN.LOCKING,LOCK.ID,R.LOCKING,F.LOCKING,LOCK.ERR,'')
        Y.CONTENT = R.LOCKING<EB.LOK.CONTENT>
        Y.REMARK =R.LOCKING<EB.LOK.REMARK>
        IF Y.CONTENT EQ '1' THEN
            Y.SEQ='00001'
            ID.NEW=BANK.CODE:'-':Y.YEAR:'-':Y.MONTH:'-':Y.SEQ
            R.LOCKING<EB.LOK.CONTENT> = ID.NEW
            R.LOCKING<EB.LOK.REMARK> = Y.DATE
            CALL F.WRITE(FN.LOCKING,LOCK.ID,R.LOCKING)
        END ELSE
            IF Y.DATE EQ '01' OR Y.MONTH NE FIELD(Y.CONTENT,'-',3) THEN
                IF Y.REMARK NE '01' THEN
                    Y.SEQ='00001'
                    ID.NEW=BANK.CODE:'-':Y.YEAR:'-':Y.MONTH:'-':Y.SEQ
                    R.LOCKING<EB.LOK.CONTENT> = ID.NEW
                    R.LOCKING<EB.LOK.REMARK> = Y.DATE
                    CALL F.WRITE(FN.LOCKING,LOCK.ID,R.LOCKING)
                END
            END ELSE
                R.LOCKING<EB.LOK.REMARK> = Y.DATE
                CALL F.WRITE(FN.LOCKING,LOCK.ID,R.LOCKING)
            END
        END
        CALL F.RELEASE(FN.LOCKING,LOCK.ID,F.LOCKING)
    END
*PACS00071941 - S
    Y.PGM.VERSION = PGM.VERSION   ; Y.APPLICATION = APPLICATION
    CALL System.setVariable('CURRENT.PGM.VER',Y.PGM.VERSION)
    CALL System.setVariable('CURRENT.APPLICATION',Y.APPLICATION)
*PACS00071941 - E

RETURN
*------------------------------------------------------------------------------------------------------------
END
