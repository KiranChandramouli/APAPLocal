*
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
SUBROUTINE DR.REG.RCL.LINKED.ID.CONV.RTN
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.AA.ARRANGEMENT

    $INSERT I_DR.REG.COMM.LOAN.SECTOR.COMMON
    $INSERT I_DR.REG.COMM.LOAN.SECTOR.EXT.COMMON

    R.AA.ARRANGEMENT = RCL$COMM.LOAN(1)   ;* AA.ARRANGEMENT Record
    LINK.POS = ''
    LOCATE 'ACCOUNT' IN R.AA.ARRANGEMENT<AA.ARR.LINKED.APPL,1> SETTING LINK.POS THEN
        COMI = R.AA.ARRANGEMENT<AA.ARR.LINKED.APPL.ID,LINK.POS>
    END

RETURN
END
