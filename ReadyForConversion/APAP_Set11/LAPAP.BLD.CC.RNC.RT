*-----------------------------------------------------------------------------
* <Rating>-31</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE LAPAP.BLD.CC.RNC.RT(ENQ.DATA)
    $INSERT T24.BP I_COMMON
    $INSERT T24.BP I_EQUATE
    $INSERT T24.BP I_ENQUIRY.COMMON
    $INSERT T24.BP I_F.ENQUIRY

    GOSUB INITIALISE
    GOSUB PROCESS
    GOSUB PGM.END

    RETURN

INITIALISE:
    FN.CUSTOMER.RNC = 'F.CUSTOMER.L.CU.RNC'
    F.CUSTOMER.RNC = ''
    CALL OPF(FN.CUSTOMER.RNC,F.CUSTOMER.RNC)

    RETURN

PROCESS:

    Y.FLD = ENQ.DATA<2,1>
    Y.ID = ENQ.DATA<4,1>
    CALL F.READ(FN.CUSTOMER.RNC,Y.ID,R.CUSTOMER.RNC,F.CUSTOMER.RNC,ERR)

    IF R.CUSTOMER.RNC AND Y.FLD EQ 'L.CU.RNC' ELSE
*Si llego aca es que no existe el registro
        ENQ.ERROR = 'EB-INVALID.RNC'
        CALL STORE.END.ERROR

        RETURN
*----------------------------------------------------------
PGM.END:
*----------------------------------------------------------
    END
