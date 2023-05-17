SUBROUTINE REDO.ACCT.IST.RESP.MAP.ID
*--------------------------------------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.ACCT.IST.RESP.MAP.ID
*--------------------------------------------------------------------------------------------------------
*Description  : This is a ID routine to check entered status code is correct or not
*Linked With  : REDO.ACCT.IST.RESP.MAP
*In Parameter : N/A
*Out Parameter: N/A
*--------------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*    Date            Who                  Reference               Description
*   ------         ------               -------------            -------------
* 27 Oct 2010     Swaminathan.S.R                                Initial Creation
*--------------------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
    $INSERT I_F.OFS.STATUS.FLAG
    $INSERT I_F.REDO.ACCT.STATUS.CODE

    IF GTSACTIVE THEN
        IF OFS$STATUS<STAT.FLAG.FIRST.TIME> THEN
            GOSUB PROCESS.PARA
            RETURN
        END
    END ELSE
        GOSUB PROCESS.PARA
    END
RETURN

**************
PROCESS.PARA:
**************
    IF V$FUNCTION EQ 'I' THEN
        FN.REDO.ACCT.STATUS.CODE = 'F.REDO.ACCT.STATUS.CODE'
        F.REDO.ACCT.STATUS.CODE = ''
        CALL OPF(FN.REDO.ACCT.STATUS.CODE,F.REDO.ACCT.STATUS.CODE)
*CALL F.READ(FN.REDO.ACCT.STATUS.CODE,"SYSTEM",R.REDO.ACCT.STATUS.CODE,F.REDO.ACCT.STATUS.CODE,Y.ERR.ACT.STAT.CODE)
        CALL CACHE.READ(FN.REDO.ACCT.STATUS.CODE,"SYSTEM",R.REDO.ACCT.STATUS.CODE,Y.ERR.ACT.STAT.CODE)
        Y.STATUS.CODE = ID.NEW
        Y.ACCT.STATUS.CODE = R.REDO.ACCT.STATUS.CODE<REDO.ACCT.STATUS.STATUS.CODE>
        LOCATE Y.STATUS.CODE IN Y.ACCT.STATUS.CODE<1,1> SETTING STAT.POS THEN
        END ELSE
            E = "EB-VALID.STATUS.CODE"
            CALL STORE.END.ERROR
        END
    END
RETURN
END
