SUBROUTINE DR.REG.REGN16.CLAIM.TYP
*-------------------------------------------------------------------------
* Date              Author                    Description
* ==========        ====================      ============
* 31-07-2014        Ashokkumar                PACS00366332- Initial revision
*-------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.U.CRM.CLAIM.TYPE

    YCLAIM.TYPE = COMI


    FN.REDO.U.CRM.CLAIM.TYPE = 'F.REDO.U.CRM.CLAIM.TYPE'
    F.REDO.U.CRM.CLAIM.TYPE = ''
    CALL OPF(FN.REDO.U.CRM.CLAIM.TYPE,F.REDO.U.CRM.CLAIM.TYPE)

    R.REDO.U.CRM = ''; REDO.CRM.ERR = ''
    CALL F.READ(FN.REDO.U.CRM.CLAIM.TYPE,YCLAIM.TYPE,R.REDO.U.CRM,F.REDO.U.CRM.CLAIM.TYPE,REDO.CRM.ERR)
    C.VAL = R.REDO.U.CRM<CLAIM.TYPE.L.CLAIM.TYPE>
    COMI = FMT(C.VAL,"L#4")
RETURN
END
