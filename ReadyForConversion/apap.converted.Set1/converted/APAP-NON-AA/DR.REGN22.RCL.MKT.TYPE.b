*
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
SUBROUTINE DR.REGN22.RCL.MKT.TYPE
    $INSERT I_COMMON
    $INSERT I_EQUATE

    MKT.TYPE = COMI
    BEGIN CASE
        CASE MKT.TYPE EQ 'Primary'
            MKT.TYPE = 'P'
        CASE MKT.TYPE EQ 'Secondary'
            MKT.TYPE = 'S'
    END CASE

    COMI = MKT.TYPE

RETURN
END
