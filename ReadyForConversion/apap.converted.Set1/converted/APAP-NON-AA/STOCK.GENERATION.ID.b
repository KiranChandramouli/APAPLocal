SUBROUTINE STOCK.GENERATION.ID
*-----------------------------------------------------------------------------
*----------------------------------------------------------------------------------------------------
*DESCRIPTION : This routine is used to check the ID value for the table STOCK.GENERATION
*-----------------------------------------------------------------------------------------------------
*-----------------------------------------------------------------------------------------------------
* * Input / Output
* --------------
* IN     : -NA-
* OUT    : -NA-
*-----------------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : SUDHARSANAN S
* PROGRAM NAME : STOCK.GENERATION.ID
*-----------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
* DATE             WHO                REFERENCE         DESCRIPTION
* 16.03.2010      SUDHARSANAN S     ODR-2009-10-0319  INITIAL CREATION
* ----------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
    $INSERT I_F.STOCK.GENERATION
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
* Check the ID starting with '1' or '2'
    Y.ID = ID.NEW
    Y.ID1 = Y.ID[1,1]
    IF Y.ID1 NE 1 AND Y.ID1 NE 2 THEN
        E = 'TT-ID.VALID.GOVT.NOGOVT'
    END
    GOVT.ID = "GOVT"
    NOGOVT.ID ="NOGOVT"
    LEN.ID=LEN(Y.ID)
    IF V$FUNCTION EQ 'I' AND LEN.ID LT 9 THEN
        BEGIN CASE
            CASE Y.ID1 EQ 1
                R.LOCKING = ''
                LOCK.ERR = ''
                CALL F.READU(FN.LOCKING,GOVT.ID,R.LOCKING,F.LOCKING,LOCK.ERR,'')
                Y.CONTENT = R.LOCKING<EB.LOK.CONTENT>
                IF Y.CONTENT NE '' THEN
                    R.LOCKING<EB.LOK.CONTENT> = Y.CONTENT+1
                    ID.NEW = Y.CONTENT+1
                    CALL LOG.WRITE(FN.LOCKING,GOVT.ID,R.LOCKING,LOCK.FLUSH)
                END ELSE
                    Y.FORMATTED.ID = FMT(Y.ID1,"L%9")
                    ID.NEW=Y.FORMATTED.ID
                    R.LOCKING<EB.LOK.CONTENT> = Y.FORMATTED.ID
                    CALL LOG.WRITE(FN.LOCKING,GOVT.ID,R.LOCKING,LOCK.FLUSH)
                END
            CASE Y.ID1 EQ 2
                R.LOCKING=''
                LOCK.ERR = ''
                CALL F.READU(FN.LOCKING,NOGOVT.ID,R.LOCKING,F.LOCKING,LOCK.ERR,'')
                Y.CONTENT = R.LOCKING<EB.LOK.CONTENT>
                IF Y.CONTENT NE '' THEN
                    R.LOCKING<EB.LOK.CONTENT> = Y.CONTENT+1
                    ID.NEW = Y.CONTENT+1
                    CALL LOG.WRITE(FN.LOCKING,NOGOVT.ID,R.LOCKING,LOCK.FLUSH)
                END ELSE
                    Y.FORMATTED.ID = FMT(Y.ID1,"L%9")
                    ID.NEW=Y.FORMATTED.ID
                    R.LOCKING<EB.LOK.CONTENT> = Y.FORMATTED.ID
                    CALL LOG.WRITE(FN.LOCKING,NOGOVT.ID,R.LOCKING,LOCK.FLUSH)
                END
        END CASE
    END
RETURN
*------------------------------------------------------------------------------
END
