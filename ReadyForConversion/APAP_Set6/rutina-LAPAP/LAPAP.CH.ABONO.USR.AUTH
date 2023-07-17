*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE LAPAP.CH.ABONO.USR.AUTH
    $INSERT T24.BP I_COMMON
    $INSERT T24.BP I_EQUATE
    $INSERT T24.BP I_ENQUIRY.COMMON
    $INSERT T24.BP I_F.USER

    Y.USR.AUTH         = O.DATA
    Y.USER.ID         = FIELD(Y.USR.AUTH,'_',2)

    FN.USER = 'F.USER';
    F.USER = '';
    CALL OPF(FN.USER, F.USER)

    R.USER.LIST = ''; USER.LIST.ERR = ''
    CALL F.READ(FN.USER,Y.USER.ID,R.USER.LIST,F.USER,USER.LIST.ERR)
    Y.USER.NAME         = R.USER.LIST<EB.USE.USER.NAME>

    O.DATA                = Y.USER.NAME
    RETURN
END
