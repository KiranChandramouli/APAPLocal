SUBROUTINE REDO.MERCHANT.CATEG.VALIDATE
*--------------------------------------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.MERCHANT.CATEG.VALIDATE
*--------------------------------------------------------------------------------------------------------
*Description  : This is a  Validate routine to check entered merchant code is correct or not
*Linked With  : REDO.ACCT.IST.RESP.MAP
*In Parameter : N/A
*Out Parameter: N/A
*--------------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*    Date            Who                  Reference               Description
*   ------         ------               -------------            -------------
* 27 Oct 2010     Swaminathan.S.R       ODR-2009-12-0291         Initial Creation
*--------------------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
    $INSERT I_F.OFS.STATUS.FLAG
    $INSERT I_F.REDO.MERCHANT.CATEG
    $INSERT I_F.REDO.MERCHANT.TYPE



    GOSUB PROCESS.PARA

RETURN

**************
PROCESS.PARA:
**************
    IF V$FUNCTION EQ 'I' THEN
        FN.REDO.MERCHANT.CATEG= 'F.REDO.MERCHANT.CATEG'
        F.REDO.MERCHANT.CATEG = ''
        CALL OPF(FN.REDO.MERCHANT.CATEG,F.REDO.MERCHANT.CATEG)

        FN.REDO.MERCHANT.TYPE= 'F.REDO.MERCHANT.TYPE'
        F.REDO.MERCHANT.TYPE = ''
        CALL OPF(FN.REDO.MERCHANT.TYPE,F.REDO.MERCHANT.TYPE)

        GOSUB VALIDATE.PARA
    END
RETURN

***************
VALIDATE.PARA:
***************

    Y.STATUS.COUNT = DCOUNT(R.NEW(REDO.MERCHANT.CATEG.MERCHANT.TYPE),@VM)
    Y.CNT = 1
    LOOP
    WHILE Y.CNT LE Y.STATUS.COUNT
        Y.STAT.CODE = R.NEW(REDO.MERCHANT.CATEG.MERCHANT.TYPE)<1,Y.CNT>
*********MERCHANT CODE CHECK********
*    CALL F.READ(FN.REDO.MERCHANT.TYPE,"SYSTEM",R.REDO.MERCHANT.TYPE,F.REDO.MERCHANT.TYPE,Y.ERR.MER.TYPE) ;*Tus Start
        CALL CACHE.READ(FN.REDO.MERCHANT.TYPE,"SYSTEM",R.REDO.MERCHANT.TYPE,Y.ERR.MER.TYPE) ; * Tus End
        Y.MER.TYPE = R.REDO.MERCHANT.TYPE<REDO.MERCHANT.TYPE.MERCHANT.TYPE>
        LOCATE Y.STAT.CODE IN Y.MER.TYPE<1,1> SETTING MER.POS THEN
        END ELSE
            AF = REDO.MERCHANT.CATEG.MERCHANT.TYPE
            ETEXT = "EB-VALID.MERCHANT.TYPE"
            CALL STORE.END.ERROR
        END
        Y.CNT += 1
    REPEAT
RETURN
END
